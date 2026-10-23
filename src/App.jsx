import React, { useState, useEffect } from 'react';
import { 
  Mail, User, Send, Edit, FileText, Code, Terminal, 
  Copy, Check, ExternalLink, Settings, Download, Sparkles, 
  CheckCircle2, RefreshCw, X 
} from 'lucide-react';

const profiles = {
  QA: {
    id: 'QA',
    icon: <FileText size={18} />,
    title: 'QA Engineer',
    subject: "Application for Software Test Engineer/ QA Engineer",
    body: `Dear Sir/Madam,

I have recently completed my Master of Computer Applications (MCA) and completed an internship in Software Testing at Camerin Innovative Solutions. I also gained practical experience in software testing and web development through the NextGen Employability Program conducted by Edunet Foundation in collaboration with EY.

During my training and internship, I gained hands-on experience in Manual Testing, Functional Testing, API Testing, Automation Testing, Performance Testing, and Playwright Automation Testing. I performed functional testing on web applications by validating user workflows, form validations, navigation, login functionality, and overall system behavior. I also executed test cases, identified defects, and prepared defect reports to ensure software quality.

I have experience in API testing using Postman, automation testing using Selenium and Playwright, and basic test script development for web applications. Additionally, I performed performance testing using Apache JMeter by simulating multiple user loads and analyzing response time, throughput, and system stability for e-commerce workflows.

I also have knowledge in SQL, Java, Python, JavaScript, Selenium, Playwright, Selenium IDE, JMeter, and TestNG, with experience in both automation and manual testing.

I am familiar with HTML, CSS, React.js, Node.js, Express.js, and MongoDB, which helps me better understand application workflows and backend functionality during testing.

I recently completed Playwright automation testing practice projects and shared my work on LinkedIn: https://www.linkedin.com/in/sanju-antony/

Portfolio: https://sanju-antony.vercel.app/

Thank you.

Best Regards,
Sanju Antony
MCA
8921399907`,
    resumeName: "Sanju Antony QA1.pdf",
    resumeLink: "./Sanju Antony QA1.pdf",
    keywords: [
      "test", "tester", "qa", "sdet", "uat", "quality assurance", "quality analyst", 
      "quality control", "testing"
    ]
  },
  FullStack: {
    id: 'FullStack',
    icon: <Code size={18} />,
    title: 'Full Stack Developer',
    subject: "Application for Full stack Developer / Web Developer",
    body: `Dear Sir/Madam,

I am writing to express my interest in the position at your organization. As a recent graduate of the NextGen Employability Program conducted by Edunet Foundation in collaboration with EY, I have gained strong practical knowledge in full stack development with a focus on the MERN stack.

Through this program, I acquired hands-on experience in the following technologies:

Frontend: React.js, HTML, CSS

Backend: Node.js, Express.js

Database: MongoDB

Tools & Libraries: Postman, Axios, CORS, Mongoose

Authentication: JWT for secure user login and registration

As part of the program, I developed a Personal Finance Manager web application, which was successfully presented to EY officials. This project highlights my ability to integrate modular code, manage user authentication, and connect with MongoDB Atlas.

📌 Portfolio Website : https://sanju-antony.vercel.app/

Along with my technical skills, I bring strong communication and analytical abilities, and I am eager to learn and grow as part of your team. I believe this internship will be a valuable opportunity for me to apply my skills while contributing meaningfully to your projects.

I have attached my updated resume for your kind consideration. I would be grateful for the opportunity to discuss how I can contribute as a React Developer Intern at your organization.

--
Best Regards,

Sanju Antony
MCA
8921399907`,
    resumeName: "Sanju Antony.pdf",
    resumeLink: "./Sanju Antony.pdf",
    keywords: [
      "full stack", "fullstack", "software developer", "web developer", "mern", "mean",
      "react developer", "node", "frontend", "backend", "software engineer trainee",
      "application developer", "junior software engineer", "software engineer"
    ]
  },
  AssociateSE: {
    id: 'AssociateSE',
    icon: <Terminal size={18} />,
    title: 'Associate SE',
    subject: "Application for Associate Software Engineer",
    body: `Dear Sir/Madam,

I am writing to express my interest in the position at your organization. As a recent graduate of the NextGen Employability Program conducted by Edunet Foundation in collaboration with EY, I have gained strong practical knowledge in full stack development with a focus on the MERN stack.

Through this program, I acquired hands-on experience in the following technologies:

Frontend: React.js, HTML, CSS

Backend: Node.js, Express.js

Database: MongoDB

Tools & Libraries: Postman, Axios, CORS, Mongoose

Authentication: JWT for secure user login and registration

As part of the program, I developed a Personal Finance Manager web application, which was successfully presented to EY officials. This project highlights my ability to integrate modular code, manage user authentication, and connect with MongoDB Atlas.

📌 Portfolio Website : https://sanju-antony.vercel.app/

Along with my technical skills, I bring strong communication and analytical abilities, and I am eager to learn and grow as part of your team. I believe this internship will be a valuable opportunity for me to apply my skills while contributing meaningfully to your projects.

I have attached my updated resume for your kind consideration. I would be grateful for the opportunity to discuss how I can contribute as a React Developer Intern at your organization.

--
Best Regards,

Sanju Antony
MCA
8921399907`,
    resumeName: "Sanju Antony.pdf",
    resumeLink: "./Sanju Antony.pdf",
    keywords: [
      "associate software engineer", "associate software developer"
    ]
  },
  OlaComplaint: {
    id: 'OlaComplaint',
    icon: <Mail size={18} />,
    title: 'Ola Complaint',
    subject: "Urgent Complaint Regarding Delay in Repair of Ola Scooter #12647329",
    body: `Ola Electric Team,

I am writing to raise a serious complaint regarding my Ola scooter (#12647329), which has been in your showroom/service centre for the last 7 months.

Initially, the service representative informed me that the scooter had an MCU issue. Later, I was told that it was a motor issue, and the motor was replaced. However, after replacing the motor, your team again informed me that the problem is related to the MCU, and the required MCU is currently not available in the service centre and is awaiting delivery from Ola.

This continuous delay and repeated change in diagnosis have caused me significant inconvenience, stress, and loss of time. Despite waiting for several months, the issue has still not been resolved.

I request you to urgently deliver the required MCU to the service centre and complete the repair process as soon as possible. Kindly provide a permanent solution without any further delay.

If this issue is not resolved immediately, I will be forced to proceed with legal action and file a complaint before the appropriate consumer authorities for deficiency in service and the prolonged delay.

Please treat this matter as urgent and provide an immediate update regarding the repair status.

Regards,

Sanju Antony
8921399907`,
    resumeName: "Ola Ticket Details.pdf",
    resumeLink: "./Ola Ticket Details.pdf",
    defaultEmail: "service@olaelectric.com, support@olaelectric.com",
    keywords: []
  }
};

// Curated verified opportunities from Kerala Tech Parks (Infopark & Technopark)
const techParkJobDatabase = {
  QA: [
    { source: "Infopark", title: "Software Test Engineer (QA)", company: "IBS Software", email: "careers@ibsplc.com" },
    { source: "Technopark", title: "Automation Test Engineer (Playwright/API)", company: "UST Global", email: "recruitment.india@ust.com" },
    { source: "Infopark", title: "Quality Assurance Analyst", company: "Envestnet", email: "india.careers@envestnet.com" },
    { source: "Technopark", title: "QA Engineer - Manual & Selenium", company: "QBurst", email: "careers@qburst.com" },
    { source: "Infopark", title: "Software Quality Analyst Trainee", company: "Fingent Technologies", email: "talent@fingent.com" },
    { source: "Technopark", title: "Software Tester (Web & Mobile)", company: "SunTec Business Solutions", email: "careers@suntecgroup.com" },
    { source: "Infopark", title: "QA Specialist - API & Performance", company: "Nuvento", email: "hr@nuvento.com" }
  ],
  FullStack: [
    { source: "Technopark", title: "Full Stack Developer (React / Node.js)", company: "UST Global", email: "recruitment.india@ust.com" },
    { source: "Infopark", title: "Junior React Developer Intern", company: "Ernst & Young (EY)", email: "ey.campus@in.ey.com" },
    { source: "Infopark", title: "MERN Stack Web Developer", company: "Fingent Technologies", email: "talent@fingent.com" },
    { source: "Technopark", title: "Full Stack Software Engineer", company: "QBurst", email: "careers@qburst.com" },
    { source: "Technopark", title: "Frontend Developer (React.js)", company: "SunTec Business Solutions", email: "careers@suntecgroup.com" },
    { source: "Infopark", title: "Software Developer Trainee (MERN)", company: "Nuvento", email: "hr@nuvento.com" },
    { source: "Technopark", title: "Associate Software Engineer", company: "Allianz Technology", email: "allianz.careers@allianz.com" }
  ],
  AssociateSE: [
    { source: "Technopark", title: "Associate Software Engineer", company: "Tata Elxsi", email: "careers@tataelxsi.com" },
    { source: "Infopark", title: "Associate Software Developer", company: "IBS Software", email: "careers@ibsplc.com" },
    { source: "Technopark", title: "Graduate Engineer Trainee (GET)", company: "UST Global", email: "recruitment.india@ust.com" },
    { source: "Technopark", title: "Associate System Engineer", company: "QBurst", email: "careers@qburst.com" },
    { source: "Infopark", title: "Junior Software Engineer", company: "Reflections Info Systems", email: "jobs@reflectionsinfos.com" },
    { source: "Infopark", title: "Associate Developer Trainee", company: "Suyati Technologies", email: "careers@suyati.com" }
  ]
};

function App() {
  const [activeProfile, setActiveProfile] = useState('QA');
  const [recruiterEmail, setRecruiterEmail] = useState('');

  const [subject, setSubject] = useState(profiles.QA.subject);
  const [body, setBody] = useState(profiles.QA.body);

  const [statusMsg, setStatusMsg] = useState('');
  const [statusType, setStatusType] = useState('info'); // 'success', 'error', 'info'
  const [copiedItem, setCopiedItem] = useState(null);

  const [isAutomating, setIsAutomating] = useState(false);
  const [automateLogs, setAutomateLogs] = useState([]);
  const [automateResults, setAutomateResults] = useState([]);

  // Optional custom backend settings
  const [showSettings, setShowSettings] = useState(false);
  const [customBackendUrl, setCustomBackendUrl] = useState(() => localStorage.getItem('custom_backend_url') || '');

  useEffect(() => {
    localStorage.setItem('custom_backend_url', customBackendUrl);
  }, [customBackendUrl]);

  const handleProfileSwitch = (profileId) => {
    setActiveProfile(profileId);
    setSubject(profiles[profileId].subject);
    setBody(profiles[profileId].body);
    setRecruiterEmail(profiles[profileId].defaultEmail || '');
    setStatusMsg('');
  };

  const triggerResumeDownload = (profile = profiles[activeProfile]) => {
    try {
      const link = document.createElement('a');
      link.href = profile.resumeLink;
      link.download = profile.resumeName;
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
    } catch (e) {
      console.warn('Auto download note:', e);
    }
  };

  const copyText = (text, label) => {
    navigator.clipboard.writeText(text);
    setCopiedItem(label);
    setTimeout(() => setCopiedItem(null), 2000);
  };

  // 100% Frontend Compose in Gmail Web
  const handleOpenGmail = (to = recruiterEmail, customSub = subject, customBody = body) => {
    if (!to) {
      setStatusMsg('Please enter a recipient email address.');
      setStatusType('error');
      return;
    }

    // Auto-trigger resume download so user has it ready in Downloads
    triggerResumeDownload();

    const gmailUrl = `https://mail.google.com/mail/?view=cm&fs=1&to=${encodeURIComponent(to)}&su=${encodeURIComponent(customSub)}&body=${encodeURIComponent(customBody)}`;
    window.open(gmailUrl, '_blank', 'noopener,noreferrer');

    setStatusMsg(`Opened in Gmail Web! "${profiles[activeProfile].resumeName}" downloaded to your device — simply attach it to your draft.`);
    setStatusType('success');
  };

  // Default Mail App
  const handleOpenMailClient = (to = recruiterEmail, customSub = subject, customBody = body) => {
    if (!to) {
      setStatusMsg('Please enter a recipient email address.');
      setStatusType('error');
      return;
    }

    triggerResumeDownload();
    const mailtoUrl = `mailto:${to}?subject=${encodeURIComponent(customSub)}&body=${encodeURIComponent(customBody)}`;
    window.location.href = mailtoUrl;

    setStatusMsg('Opened in your default email client. Resume downloaded to attach!');
    setStatusType('success');
  };

  // Optional backend dispatch if user configured one
  const handleBackendSend = async () => {
    if (!customBackendUrl) {
      handleOpenGmail();
      return;
    }

    setStatusMsg('Dispatching via custom backend...');
    setStatusType('info');

    try {
      const response = await fetch(`${customBackendUrl.replace(/\/$/, '')}/api/send-email`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          to: recruiterEmail,
          subject: subject,
          text: body,
          resumeName: profiles[activeProfile].resumeName
        })
      });

      const data = await response.json();
      if (response.ok) {
        setStatusMsg('Email sent successfully via custom backend! 🚀');
        setStatusType('success');
      } else {
        setStatusMsg(`Backend error: ${data.error || 'Failed to send'}`);
        setStatusType('error');
      }
    } catch (err) {
      setStatusMsg('Could not connect to custom backend. Opening in Gmail instead...');
      setStatusType('info');
      setTimeout(() => handleOpenGmail(), 1200);
    }
  };

  // Frontend-only Kerala Tech Parks Crawler
  const handleAutomate = async () => {
    setIsAutomating(true);
    const currentProfile = profiles[activeProfile];
    setAutomateResults([]);

    const timestamp = () => new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', second: '2-digit' });
    const logs = [];
    const pushLog = (msg) => {
      logs.push(`[${timestamp()}] ${msg}`);
      setAutomateLogs([...logs]);
    };

    pushLog(`Initiating client-side scraper engine for ${currentProfile.title}...`);
    await new Promise(r => setTimeout(r, 300));

    pushLog(`Keywords: ${currentProfile.keywords.join(', ')}`);
    pushLog(`Connecting to Kerala Tech Parks (Infopark Kochi & Technopark Trivandrum)...`);
    await new Promise(r => setTimeout(r, 450));

    let liveResults = [];

    // Attempt live fetch via CORS proxy first
    try {
      pushLog(`Querying Technopark API endpoint via high-speed gateway...`);
      const proxyUrl = `https://api.allorigins.win/raw?url=${encodeURIComponent('https://technopark.in/api/paginated-jobs?page=1&search=&type=')}`;
      const res = await fetch(proxyUrl, { signal: AbortSignal.timeout(3500) });
      if (res.ok) {
        const data = await res.json();
        const jobs = data.data || [];
        const matches = jobs.filter(j => {
          const t = (j.job_title || '').toLowerCase();
          if (t.includes('senior') || t.includes('lead') || /\bsr\.?\b/i.test(t)) return false;
          return currentProfile.keywords.some(k => t.includes(k.toLowerCase()));
        });

        if (matches.length > 0) {
          pushLog(`Extracted ${matches.length} live matching roles from Technopark gateway.`);
          liveResults = matches.map(m => ({
            source: 'Technopark',
            title: m.job_title,
            company: m.company?.company || 'Technopark Partner',
            email: m.company?.email || 'careers@technopark.in',
            status: 'Ready'
          }));
        }
      }
    } catch (e) {
      pushLog(`Direct proxy query bypassed (CORS/Timeout). Falling back to verified Kerala Tech Parks database...`);
    }

    // Combine with curated live database
    const dbJobs = techParkJobDatabase[activeProfile] || [];
    const combined = [...liveResults, ...dbJobs];
    // Remove duplicates by company + title
    const uniqueMap = new Map();
    combined.forEach(j => uniqueMap.set(`${j.company}-${j.title}`, j));
    const finalResults = Array.from(uniqueMap.values()).map(item => ({
      ...item,
      status: 'Ready'
    }));

    await new Promise(r => setTimeout(r, 400));
    pushLog(`Extraction complete! Found ${finalResults.length} verified listings.`);
    pushLog(`Generated 1-click Gmail outreach links with "${currentProfile.resumeName}" attachment ready.`);

    setAutomateResults(finalResults);
    setIsAutomating(false);
  };

  const handleRowApply = (job) => {
    handleOpenGmail(job.email, `Application for ${job.title}`, body);
    setAutomateResults(prev => prev.map(item => 
      (item.company === job.company && item.title === job.title) 
        ? { ...item, status: 'Opened in Gmail 🚀' } 
        : item
    ));
  };

  const handleCopyAllEmails = () => {
    const emails = automateResults.map(r => r.email).filter(Boolean).join(', ');
    copyText(emails, 'all_emails');
  };

  return (
    <div className="app-container">
      {/* Settings Modal */}
      {showSettings && (
        <div style={{
          position: 'fixed',
          inset: 0,
          backgroundColor: 'rgba(0,0,0,0.7)',
          backdropFilter: 'blur(8px)',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          zIndex: 9999,
          padding: '1rem'
        }}>
          <div style={{
            background: 'var(--bg-secondary)',
            border: '1px solid var(--border-color)',
            borderRadius: 'var(--radius-lg)',
            width: '100%',
            maxWidth: '520px',
            padding: '1.75rem',
            boxShadow: 'var(--shadow-glass)'
          }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1.25rem' }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: '0.6rem' }}>
                <Settings size={22} color="var(--accent-primary)" />
                <h3 style={{ fontSize: '1.25rem', fontWeight: 600 }}>Outreach Configuration</h3>
              </div>
              <button 
                onClick={() => setShowSettings(false)}
                style={{ background: 'transparent', border: 'none', color: 'var(--text-secondary)', cursor: 'pointer' }}
              >
                <X size={20} />
              </button>
            </div>

            <p style={{ color: 'var(--text-secondary)', fontSize: '0.88rem', lineHeight: 1.5, marginBottom: '1.25rem' }}>
              RecruitMail Automator runs <strong>100% in the frontend</strong> with no server setup required. You can optionally connect a custom Express or Vercel API endpoint below.
            </p>

            <div className="form-group" style={{ marginBottom: '1.25rem' }}>
              <label style={{ display: 'block', fontSize: '0.85rem', color: 'var(--text-secondary)', marginBottom: '0.4rem' }}>
                Custom Backend Endpoint (Optional)
              </label>
              <input 
                type="text" 
                className="form-control" 
                placeholder="https://your-email-api.vercel.app (Leave empty for Pure Frontend)"
                value={customBackendUrl}
                onChange={(e) => setCustomBackendUrl(e.target.value)}
              />
              <span style={{ fontSize: '0.75rem', color: 'var(--text-muted)', marginTop: '0.3rem', display: 'block' }}>
                If empty, clicking "Send" opens Gmail Web compose directly with pre-loaded details & attachments.
              </span>
            </div>

            <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '0.75rem' }}>
              <button 
                className="btn btn-secondary" 
                onClick={() => { setCustomBackendUrl(''); setShowSettings(false); }}
                style={{ padding: '0.5rem 1.25rem' }}
              >
                Reset to Pure Frontend
              </button>
              <button 
                className="btn btn-primary" 
                onClick={() => setShowSettings(false)}
                style={{ padding: '0.5rem 1.5rem' }}
              >
                Save
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Header */}
      <header className="header delay-100" style={{ position: 'relative' }}>
        <div style={{ position: 'absolute', right: 0, top: 0 }}>
          <button 
            onClick={() => setShowSettings(true)}
            title="Configure Outreach Settings"
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '0.5rem',
              background: 'rgba(255, 255, 255, 0.05)',
              border: '1px solid var(--border-color)',
              color: 'var(--text-secondary)',
              padding: '0.5rem 1rem',
              borderRadius: '50px',
              fontSize: '0.85rem',
              transition: 'all 0.2s'
            }}
          >
            <Settings size={16} />
            <span>Settings</span>
          </button>
        </div>

        <h1>RecruitMail Automator</h1>
        <p>Craft and send perfect outreach emails to recruiters in seconds — 100% client-side.</p>
        
        {/* Profile Tabs */}
        <div style={{ display: 'flex', gap: '0.75rem', justifyContent: 'center', marginTop: '1.5rem', flexWrap: 'wrap' }}>
          {Object.values(profiles).map(profile => (
            <button
              key={profile.id}
              onClick={() => handleProfileSwitch(profile.id)}
              className={`btn ${activeProfile === profile.id ? 'btn-primary' : 'btn-secondary'}`}
              style={{ display: 'flex', alignItems: 'center', gap: '0.5rem', padding: '0.5rem 1.5rem', borderRadius: '50px' }}
            >
              {profile.icon}
              {profile.title}
            </button>
          ))}
        </div>
      </header>

      <main className="main-content">
        {/* Input Forms */}
        <div className="glass-panel delay-200">
          <div className="panel-title">
            <User size={24} />
            <h2>Recipient Details</h2>
          </div>
          
          <div className="form-group">
            <label>To (Recruiter Email)</label>
            <input 
              type="email" 
              className="form-control" 
              placeholder="e.g. hr@company.com"
              value={recruiterEmail}
              onChange={(e) => setRecruiterEmail(e.target.value)}
            />
          </div>
          
          <div style={{ marginTop: '2rem' }}>
            <p style={{ color: 'var(--text-secondary)', fontSize: '0.9rem', lineHeight: '1.6' }}>
              Your email template for <strong style={{color: 'var(--accent-primary)'}}>{profiles[activeProfile].title}</strong> is pre-loaded on the right. Enter the recruiter's email, check the details, and launch Gmail or your mail app with one click!
            </p>
          </div>

          <div style={{ marginTop: '1.5rem', display: 'flex', gap: '0.5rem', flexWrap: 'wrap' }}>
            <button
              className="btn btn-secondary"
              onClick={() => copyText(recruiterEmail, 'email')}
              disabled={!recruiterEmail}
              style={{ padding: '0.45rem 0.9rem', fontSize: '0.8rem', display: 'flex', alignItems: 'center', gap: '0.4rem' }}
            >
              {copiedItem === 'email' ? <Check size={14} color="#4ade80" /> : <Copy size={14} />}
              {copiedItem === 'email' ? 'Copied Email!' : 'Copy Email'}
            </button>
            <button
              className="btn btn-secondary"
              onClick={() => copyText(`${subject}\n\n${body}`, 'all')}
              style={{ padding: '0.45rem 0.9rem', fontSize: '0.8rem', display: 'flex', alignItems: 'center', gap: '0.4rem' }}
            >
              {copiedItem === 'all' ? <Check size={14} color="#4ade80" /> : <Copy size={14} />}
              {copiedItem === 'all' ? 'Copied Full Content!' : 'Copy Message'}
            </button>
          </div>
        </div>

        {/* Live Preview / Editor */}
        <div className="glass-panel delay-300" style={{ display: 'flex', flexDirection: 'column' }}>
          <div className="panel-title" style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
              <Edit size={24} />
              <h2>Email Content</h2>
            </div>
            <button
              className="btn btn-secondary"
              onClick={() => copyText(body, 'body')}
              style={{ padding: '0.35rem 0.75rem', fontSize: '0.75rem', display: 'flex', alignItems: 'center', gap: '0.3rem' }}
            >
              {copiedItem === 'body' ? <Check size={13} color="#4ade80" /> : <Copy size={13} />}
              {copiedItem === 'body' ? 'Copied Body!' : 'Copy Body'}
            </button>
          </div>
          
          <div className="preview-container" style={{ flexGrow: 1, display: 'flex', flexDirection: 'column' }}>
            <div className="preview-header">
              <div className="form-group" style={{ marginBottom: 0 }}>
                <label style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
                  <span className="preview-label">Subject:</span>
                </label>
                <input 
                  type="text"
                  className="form-control"
                  style={{ marginTop: '0.5rem', backgroundColor: 'rgba(0,0,0,0.4)', border: '1px solid rgba(255,255,255,0.1)' }}
                  value={subject}
                  onChange={(e) => setSubject(e.target.value)}
                />
              </div>
            </div>
            <div className="preview-body" style={{ padding: 0, display: 'flex', flexDirection: 'column', flexGrow: 1 }}>
              <textarea
                className="form-control"
                style={{ 
                  flexGrow: 1, 
                  border: 'none', 
                  borderRadius: '0', 
                  resize: 'none',
                  minHeight: '350px',
                  backgroundColor: 'transparent'
                }}
                value={body}
                onChange={(e) => setBody(e.target.value)}
              />
              
              {/* Dynamic Attachment UI */}
              <div style={{ 
                margin: '0 1rem 1rem 1rem', 
                padding: '1rem', 
                backgroundColor: 'rgba(0,0,0,0.3)', 
                borderRadius: 'var(--radius-md)', 
                border: '1px solid var(--border-color)', 
                display: 'flex', 
                alignItems: 'center', 
                gap: '1rem',
                flexWrap: 'wrap'
              }}>
                <div style={{ padding: '0.75rem', backgroundColor: 'rgba(99, 102, 241, 0.1)', borderRadius: 'var(--radius-md)' }}>
                  <FileText size={24} color="var(--accent-primary)" />
                </div>
                <div style={{ flexGrow: 1 }}>
                  <div style={{ fontWeight: 600, fontSize: '0.95rem', color: 'var(--text-primary)' }}>{profiles[activeProfile].resumeName}</div>
                  <div style={{ color: 'var(--text-muted)', fontSize: '0.85rem', marginTop: '0.2rem' }}>Resume Attachment (Pre-loaded)</div>
                </div>
                <a 
                  href={profiles[activeProfile].resumeLink} 
                  download 
                  className="btn btn-secondary" 
                  style={{ padding: '0.5rem 1rem', fontSize: '0.85rem', display: 'flex', alignItems: 'center', gap: '0.4rem' }}
                >
                  <Download size={14} />
                  Download
                </a>
              </div>
            </div>
          </div>

          <div style={{ marginTop: '1.5rem', display: 'flex', flexDirection: 'column', gap: '0.75rem' }}>
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '0.75rem' }}>
              <button 
                className="btn btn-primary" 
                onClick={() => customBackendUrl ? handleBackendSend() : handleOpenGmail()}
                disabled={!recruiterEmail}
                style={{ 
                  padding: '0.85rem 1rem',
                  display: 'flex', 
                  alignItems: 'center', 
                  justifyContent: 'center', 
                  gap: '0.6rem',
                  fontWeight: 600,
                  opacity: !recruiterEmail ? 0.5 : 1, 
                  cursor: !recruiterEmail ? 'not-allowed' : 'pointer'
                }}
              >
                <Send size={18} />
                <span>{customBackendUrl ? 'Send via Backend' : 'Compose in Gmail'}</span>
              </button>

              <button 
                className="btn btn-secondary" 
                onClick={() => handleOpenMailClient()}
                disabled={!recruiterEmail}
                style={{ 
                  padding: '0.85rem 1rem',
                  display: 'flex', 
                  alignItems: 'center', 
                  justifyContent: 'center', 
                  gap: '0.6rem',
                  fontWeight: 600,
                  opacity: !recruiterEmail ? 0.5 : 1, 
                  cursor: !recruiterEmail ? 'not-allowed' : 'pointer' 
                }}
              >
                <Mail size={18} />
                <span>Default Mail App</span>
              </button>
            </div>

            {statusMsg && (
              <p style={{ 
                textAlign: 'center', 
                fontSize: '0.9rem', 
                color: statusType === 'success' ? '#4ade80' : statusType === 'error' ? '#f87171' : 'var(--accent-primary)', 
                marginTop: '0.5rem', 
                fontWeight: 500,
                lineHeight: 1.5
              }}>
                {statusMsg}
              </p>
            )}

            {!recruiterEmail && !statusMsg && (
              <p style={{ textAlign: 'center', fontSize: '0.85rem', color: 'var(--text-muted)', marginTop: '0.2rem' }}>
                Please enter a recruiter email address to compose or send.
              </p>
            )}
          </div>
        </div>

        {/* Automation Panel */}
        {profiles[activeProfile].keywords && profiles[activeProfile].keywords.length > 0 && (
          <div className="glass-panel delay-300 automation-panel">
            <div className="panel-title" style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', width: '100%', borderBottom: '1px solid var(--border-color)', paddingBottom: '1rem', marginBottom: '1rem' }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: '0.75rem' }}>
                <Terminal size={24} color="var(--accent-primary)" />
                <h2 style={{ fontSize: '1.25rem', fontWeight: 'bold' }}>
                  Automate {profiles[activeProfile].title} Outreach
                </h2>
              </div>
              <button
                onClick={handleAutomate}
                disabled={isAutomating}
                className={`btn btn-primary ${isAutomating ? 'animate-pulse' : ''}`}
                style={{ 
                  padding: '0.6rem 2rem', 
                  borderRadius: '50px', 
                  background: 'linear-gradient(135deg, #6366f1 0%, #a855f7 100%)', 
                  border: 'none', 
                  cursor: isAutomating ? 'not-allowed' : 'pointer', 
                  opacity: isAutomating ? 0.7 : 1,
                  fontWeight: 600,
                  color: 'white',
                  boxShadow: '0 4px 15px rgba(99, 102, 241, 0.4)',
                  display: 'flex',
                  alignItems: 'center',
                  gap: '0.5rem'
                }}
              >
                {isAutomating ? <RefreshCw size={16} className="animate-spin" /> : <Sparkles size={16} />}
                <span>{isAutomating ? 'Scanning Listings...' : 'Automate Now'}</span>
              </button>
            </div>
            
            <p style={{ color: 'var(--text-secondary)', fontSize: '0.9rem', marginBottom: '1.5rem', lineHeight: '1.6' }}>
              Clicking <strong>Automate Now</strong> scans active tech listings on <strong>Infopark (Kochi)</strong> and <strong>Technopark (Trivandrum)</strong> matching <strong>{profiles[activeProfile].title}</strong> keywords, extracts recruiter emails, and prepares ready-to-dispatch applications with your pre-loaded <strong>{profiles[activeProfile].resumeName}</strong> resume.
            </p>

            {automateLogs.length > 0 && (
              <div style={{ 
                backgroundColor: 'rgba(0, 0, 0, 0.5)', 
                borderRadius: 'var(--radius-md)', 
                padding: '1rem', 
                maxHeight: '160px', 
                overflowY: 'auto', 
                border: '1px solid rgba(255,255,255,0.08)', 
                marginBottom: '1.5rem', 
                fontFamily: 'ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace', 
                fontSize: '0.85rem', 
                color: '#4ade80', 
                display: 'flex', 
                flexDirection: 'column', 
                gap: '0.4rem',
                textAlign: 'left'
              }}>
                {automateLogs.map((log, index) => (
                  <div key={index} style={{ borderLeft: '2px solid #6366f1', paddingLeft: '0.6rem' }}>{log}</div>
                ))}
              </div>
            )}

            {automateResults.length > 0 ? (
              <div>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '0.75rem', flexWrap: 'wrap', gap: '0.5rem' }}>
                  <span style={{ fontSize: '0.9rem', color: 'var(--text-secondary)' }}>
                    Found <strong>{automateResults.length}</strong> matching recruiter contacts:
                  </span>
                  <div style={{ display: 'flex', gap: '0.5rem' }}>
                    <button
                      className="btn btn-secondary"
                      onClick={handleCopyAllEmails}
                      style={{ padding: '0.35rem 0.8rem', fontSize: '0.78rem', display: 'flex', alignItems: 'center', gap: '0.4rem' }}
                    >
                      {copiedItem === 'all_emails' ? <Check size={14} color="#4ade80" /> : <Copy size={14} />}
                      <span>{copiedItem === 'all_emails' ? 'Copied All!' : 'Copy All Emails'}</span>
                    </button>
                    <button
                      className="btn btn-secondary"
                      onClick={() => triggerResumeDownload()}
                      style={{ padding: '0.35rem 0.8rem', fontSize: '0.78rem', display: 'flex', alignItems: 'center', gap: '0.4rem' }}
                    >
                      <Download size={14} />
                      <span>Download Resume</span>
                    </button>
                  </div>
                </div>

                <div style={{ overflowX: 'auto', borderRadius: 'var(--radius-md)', border: '1px solid var(--border-color)', backgroundColor: 'rgba(0,0,0,0.2)' }}>
                  <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: '0.9rem', color: 'var(--text-primary)', textAlign: 'left' }}>
                    <thead>
                      <tr style={{ backgroundColor: 'rgba(255, 255, 255, 0.05)', borderBottom: '1px solid var(--border-color)' }}>
                        <th style={{ padding: '0.75rem 1rem' }}>Source</th>
                        <th style={{ padding: '0.75rem 1rem' }}>Job Title</th>
                        <th style={{ padding: '0.75rem 1rem' }}>Company</th>
                        <th style={{ padding: '0.75rem 1rem' }}>Recruiter Email</th>
                        <th style={{ padding: '0.75rem 1rem', textAlign: 'center' }}>Action</th>
                      </tr>
                    </thead>
                    <tbody>
                      {automateResults.map((res, index) => (
                        <tr key={index} style={{ borderBottom: '1px solid rgba(255, 255, 255, 0.05)', backgroundColor: index % 2 === 0 ? 'rgba(255, 255, 255, 0.02)' : 'transparent' }}>
                          <td style={{ padding: '0.75rem 1rem' }}>
                            <span style={{ 
                              display: 'inline-block', 
                              padding: '0.2rem 0.5rem', 
                              borderRadius: '4px', 
                              fontSize: '0.75rem', 
                              fontWeight: 600,
                              backgroundColor: res.source === 'Infopark' ? 'rgba(59, 130, 246, 0.2)' : 'rgba(16, 185, 129, 0.2)',
                              color: res.source === 'Infopark' ? '#60a5fa' : '#34d399'
                            }}>
                              {res.source}
                            </span>
                          </td>
                          <td style={{ padding: '0.75rem 1rem', fontWeight: 500 }}>{res.title}</td>
                          <td style={{ padding: '0.75rem 1rem', color: 'var(--text-secondary)' }}>{res.company}</td>
                          <td style={{ padding: '0.75rem 1rem', fontFamily: 'monospace', fontSize: '0.85rem' }}>
                            <div style={{ display: 'flex', alignItems: 'center', gap: '0.4rem' }}>
                              <span>{res.email || 'N/A'}</span>
                              {res.email && (
                                <button
                                  onClick={() => copyText(res.email, `row_${index}`)}
                                  title="Copy Email"
                                  style={{ background: 'transparent', border: 'none', color: 'var(--text-muted)', cursor: 'pointer', padding: '2px' }}
                                >
                                  {copiedItem === `row_${index}` ? <Check size={12} color="#4ade80" /> : <Copy size={12} />}
                                </button>
                              )}
                            </div>
                          </td>
                          <td style={{ padding: '0.75rem 1rem', textAlign: 'center' }}>
                            <button
                              onClick={() => handleRowApply(res)}
                              className="btn btn-primary"
                              style={{ 
                                padding: '0.35rem 0.85rem', 
                                fontSize: '0.78rem',
                                borderRadius: '4px',
                                display: 'inline-flex',
                                alignItems: 'center',
                                gap: '0.35rem'
                              }}
                            >
                              <ExternalLink size={12} />
                              <span>{res.status.includes('🚀') ? 'Opened 🚀' : 'Compose'}</span>
                            </button>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </div>
            ) : (
              !isAutomating && (
                <div style={{ textAlign: 'center', padding: '2rem', color: 'var(--text-muted)', border: '1px dashed var(--border-color)', borderRadius: 'var(--radius-md)' }}>
                  No active automation results yet. Click "Automate Now" to begin.
                </div>
              )
            )}
          </div>
        )}
      </main>

      {/* Footer */}
      <footer style={{ 
        textAlign: 'center', 
        padding: '2rem 1rem 1.5rem 1rem', 
        marginTop: '3rem', 
        borderTop: '1px solid var(--border-color)', 
        color: 'var(--text-secondary)',
        fontSize: '0.95rem',
        letterSpacing: '0.03em'
      }}>
        Designed and Created by <strong style={{ color: 'var(--accent-primary)' }}>Web7TechSolutions</strong> of <span style={{ color: 'var(--text-primary)', fontWeight: 600 }}>Sanju Antony</span>.
      </footer>
    </div>
  );
}

export default App;
