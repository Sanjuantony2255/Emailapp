import express from 'express';
import cors from 'cors';
import nodemailer from 'nodemailer';
import path from 'path';
import fs from 'fs';
import dotenv from 'dotenv';

dotenv.config();


const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());

// Set up Nodemailer transporter
const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.GMAIL_ADDRESS || 'sanjuantony01@gmail.com', 
    pass: process.env.GMAIL_APP_PASSWORD 
  }
});

app.post('/api/send-email', async (req, res) => {
  const { to, subject, text, resumeName } = req.body;
  const formattedTo = to ? to.split(/[\s,]+/).filter(Boolean).join(', ') : '';

  try {
    const filenameToAttach = resumeName || 'Sanju Antony QA1.pdf';
    // We will attach the local PDF that we saved in the public folder
    const pdfPath = path.join(process.cwd(), 'public', filenameToAttach);
    
    // Check if file exists locally
    if (!fs.existsSync(pdfPath)) {
      console.error("PDF not found at path:", pdfPath);
      return res.status(500).json({ error: `Resume PDF file (${filenameToAttach}) not found on server.` });
    }

    const mailOptions = {
      from: process.env.GMAIL_ADDRESS || 'sanjuantony01@gmail.com',
      to: formattedTo,
      subject: subject,
      text: text,
      attachments: [
        {
          filename: filenameToAttach,
          path: pdfPath,
          contentType: 'application/pdf'
        }
      ]
    };

    const info = await transporter.sendMail(mailOptions);
    console.log('Email sent: ' + info.response);
    res.status(200).json({ message: 'Email sent successfully with attachment!' });

  } catch (error) {
    console.error('Error sending email:', error);
    res.status(500).json({ error: 'Failed to send email. Ensure your App Password is correct.', details: error.message });
  }
});

app.post('/api/automate-jobs', async (req, res) => {
  const { keywords, subject, body, resumeName } = req.body;
  
  if (!keywords || !Array.isArray(keywords) || keywords.length === 0) {
    return res.status(400).json({ error: "Missing keywords for automation" });
  }

  const results = [];
  const matchesKeywords = (title) => {
    const lowerTitle = title.toLowerCase();
    
    // Avoid matching Senior, Lead, or Sr. roles
    if (lowerTitle.includes("senior") || lowerTitle.includes("lead") || /\bsr\.?\b/i.test(title)) {
      return false;
    }
    
    return keywords.some(keyword => lowerTitle.includes(keyword));
  };

  try {
    // 1. Scrape Infopark
    console.log(`Scraping Infopark with keywords: ${keywords.join(', ')}...`);
    const infoResponse = await fetch("https://infopark.in/companies/job-search", {
      headers: {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
      }
    });
    const infoHtml = await infoResponse.text();
    const tableBodyMatch = infoHtml.match(/<div[^>]*id="job-list"[\s\S]*?<tbody>([\s\S]*?)<\/tbody>/);
    if (tableBodyMatch) {
      const rows = tableBodyMatch[1].split(/<tr>/);
      for (const row of rows) {
        if (!row.trim()) continue;
        const tds = row.match(/<td[^>]*>([\s\S]*?)<\/td>/g);
        if (tds && tds.length >= 4) {
          const title = tds[1].replace(/<[^>]*>/g, '').trim();
          const company = tds[2].replace(/<[^>]*>/g, '').trim();
          if (matchesKeywords(title)) {
            const linkMatch = row.match(/href="([^"]+)"/);
            const link = linkMatch ? linkMatch[1] : '';
            if (link) {
              console.log(`Found matching Infopark job: ${title} at ${company}. Fetching details...`);
              const detailRes = await fetch(link, {
                headers: { "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)" }
              });
              const detailHtml = await detailRes.text();
              // Extract emails
              let email = '';
              const mailtoMatch = detailHtml.match(/href="mailto:([^"]+)"/i);
              if (mailtoMatch) {
                email = mailtoMatch[1].trim();
              } else {
                const emails = detailHtml.match(/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/g);
                if (emails) {
                  const filtered = emails.filter(e => !e.includes("infopark.in"));
                  if (filtered.length > 0) {
                    email = filtered[0];
                  }
                }
              }
              results.push({
                source: "Infopark",
                title,
                company,
                email,
                status: email ? "Pending" : "No Email Found"
              });
            }
          }
        }
      }
    }

    // 2. Scrape Technopark
    console.log(`Scraping Technopark with keywords: ${keywords.join(', ')}...`);
    const techResponse = await fetch("https://technopark.in/api/paginated-jobs?page=1&search=&type=", {
      headers: {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
        "Accept": "application/json"
      }
    });
    const techData = await techResponse.json();
    const jobList = techData.data || [];
    for (const job of jobList) {
      if (matchesKeywords(job.job_title)) {
        const detailUrl = `https://technopark.in/job-details/${job.id}?job=${encodeURIComponent(job.job_title)}`;
        console.log(`Found matching Technopark job: ${job.job_title} at ${job.company?.company}. Fetching details...`);
        const detailRes = await fetch(detailUrl, {
          headers: { "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)" }
        });
        const detailHtml = await detailRes.text();
        const dataPageMatch = detailHtml.match(/data-page="([^"]+)"/);
        let email = '';
        if (dataPageMatch) {
          try {
            const decodedJson = dataPageMatch[1].replace(/&quot;/g, '"').replace(/&amp;/g, '&');
            const dataObj = JSON.parse(decodedJson);
            email = dataObj.props?.jobListing?.contact_email || '';
          } catch (e) {
            console.error("Error parsing Technopark job details JSON", e);
          }
        }
        results.push({
          source: "Technopark",
          title: job.job_title,
          company: job.company?.company || 'Unknown',
          email,
          status: email ? "Pending" : "No Email Found"
        });
      }
    }

    // 3. Send emails to matched jobs
    const pdfPath = path.join(process.cwd(), 'public', resumeName);
    const resumeExists = fs.existsSync(pdfPath);

    for (let job of results) {
      if (job.status === "Pending" && job.email) {
        if (!resumeExists) {
          job.status = `Failed (${resumeName} not found on server)`;
          continue;
        }

        try {
          console.log(`Sending email to ${job.email} for "${job.title}"...`);
          const mailOptions = {
            from: process.env.GMAIL_ADDRESS || 'sanjuantony01@gmail.com',
            to: job.email,
            subject: `Job Application for ${job.title}`,
            text: body,
            attachments: [
              {
                filename: resumeName,
                path: pdfPath,
                contentType: 'application/pdf'
              }
            ]
          };

          const info = await transporter.sendMail(mailOptions);
          console.log(`Email successfully sent to ${job.email}: ${info.response}`);
          job.status = "Sent 🚀";
        } catch (error) {
          console.error(`Failed to send email to ${job.email}:`, error);
          job.status = `Failed: ${error.message}`;
        }
      }
    }

    res.status(200).json({ success: true, results });

  } catch (error) {
    console.error("Automation error:", error);
    res.status(500).json({ error: "Failed to automate job applications", details: error.message });
  }
});

if (!process.env.VERCEL) {
  app.listen(PORT, () => {
    console.log(`Backend Server running on http://localhost:${PORT}`);
    console.log('Ensure you have set the GMAIL_APP_PASSWORD in the code or via environment variable.');
  });
}

export default app;

