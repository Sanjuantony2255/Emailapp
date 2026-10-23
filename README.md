# RecruitMail Automator - Job Application & Outreach Suite

A modern, high-performance React + Vite web application built to automate job applications and recruiter email outreach. Fully configured to run **100% in the frontend** with **zero backend server required**, and optimized for **instant GitHub Pages deployment**.

---

## 🌟 Key Features

- **100% Client-Side / Serverless**: Runs completely in the browser. No Node.js or Express backend required.
- **1-Click Gmail Web Compose**: Pre-fills recipient, customized subject, and formatted body directly in Gmail web compose.
- **Auto Resume Download**: Automatically downloads the relevant pre-loaded resume (`Sanju Antony QA1.pdf`, `Sanju Antony.pdf`, `Ola Ticket Details.pdf`) so you can attach it immediately.
- **Default Mail App Integration**: One-click trigger for system mail clients via `mailto:`.
- **Kerala Tech Parks Scraper Engine**: Scrapes and indexes active tech listings from **Infopark (Kochi)** and **Technopark (Trivandrum)** with live terminal streaming logs.
- **Copy Utilities**: Instant clipboard copy for Recruiter Email, Message Body, or Complete Outreach with visual toast confirmations.
- **Modern Glassmorphic Dark UI**: Custom gradients, glowing interactive components, and smooth micro-animations.
- **GitHub Pages Ready**: Configured with relative base paths (`./`), custom `404.html` SPA redirect, and automated GitHub Actions workflow.

---

## 🚀 GitHub Pages Deployment (2-Step Setup)

### Method 1: Automatic Deployment via GitHub Actions (Recommended)

1. Push your repository to GitHub:
   ```bash
   git add .
   git commit -m "Build pure frontend for GitHub Pages"
   git push origin main
   ```
2. In your GitHub repository:
   - Go to **Settings** > **Pages**
   - Under **Build and deployment** > **Source**, select **GitHub Actions**
3. That's it! The included `.github/workflows/deploy.yml` workflow will automatically build and publish your site at:
   `https://<your-username>.github.io/<your-repo>/`

---

### Method 2: Manual 1-Command Deployment

You can deploy directly to the `gh-pages` branch using the npm script:

```bash
npm run deploy
```

---

## 💻 Local Development

### 1. Install Dependencies
```bash
npm install
```

### 2. Start Dev Server
```bash
npm run dev
```
Open [http://localhost:5173](http://localhost:5173) in your browser.

### 3. Build Production Bundle
```bash
npm run build
```
The compiled, optimized static bundle is generated in the `dist/` directory, ready to be hosted on GitHub Pages, Vercel, Netlify, or any static web host.

---

## 📁 Project Structure

```
EmailAuto-main/
├── .github/
│   └── workflows/
│       └── deploy.yml        # Automated GitHub Pages CI/CD workflow
├── dist/                     # Production static build output
├── public/
│   ├── 404.html              # GitHub Pages SPA router redirect
│   ├── favicon.svg           # Application favicon
│   ├── Sanju Antony QA1.pdf  # QA Engineer resume
│   ├── Sanju Antony.pdf      # Full Stack & Associate SE resume
│   └── Ola Ticket Details.pdf# Consumer complaint documentation
├── src/
│   ├── App.jsx               # Main React frontend logic (100% client-side)
│   ├── App.css
│   ├── index.css             # Glassmorphic dark design system
│   └── main.jsx
├── index.html                # Entry HTML with relative paths
├── vite.config.js            # Vite configuration with base: './'
├── package.json              # Dependencies and deployment scripts
└── email_auto_mobile/        # Flutter cross-platform mobile companion app
```

---

## ⚙️ Optional Backend Integration

While the app functions 100% client-side by default, you can click the **Settings** icon in the header to specify a custom API endpoint (e.g., Express server or Vercel serverless function) if you wish to relay emails via SMTP in the background.

---

**Designed and Created by Web7TechSolutions of Sanju Antony.**
# Emailapp
