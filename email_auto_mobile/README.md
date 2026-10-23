# RecruitMail Automator - Flutter Mobile App

A modern cross-platform Flutter application built to automate job applications and email outreach, featuring direct scraping from **Infopark** and **Technopark**, pre-loaded resume attachments, custom email templates, and hybrid web integration.

---

## 🚀 Features

- **Profile Switching**:
  - **QA Engineer**: Automated testing, manual testing, Playwright keywords + `Sanju Antony QA1.pdf`
  - **Full Stack Developer**: MERN stack portfolio + `Sanju Antony.pdf`
  - **Associate SE**: Software engineer trainee outreach + `Sanju Antony.pdf`
  - **Ola Complaint**: Consumer complaint escalation + `Ola Ticket Details.pdf`
- **Kerala Tech Parks Scraper**:
  - Live HTTP crawler for **Infopark** (`https://infopark.in`) and **Technopark** (`https://technopark.in`)
  - Keyword filtering, senior/lead exclusion, contact extraction
- **Live Terminal Log Console**:
  - Real-time crawling progress, match notifications, and status monitoring
- **Dual Email Dispatch**:
  - **Option 1 (Direct Mobile SMTP)**: Dispatches directly from the device via Gmail App Password with attached resume PDF
  - **Option 2 (Backend Server)**: Relays through the Express / Vercel API backend (`server.js`)
- **Modern Glassmorphic Dark UI**:
  - Custom gradient cards, responsive layout, subtle glowing accents, and smooth transitions
- **Hybrid Web Mode**:
  - In-app WebView to run or preview the responsive web client directly on mobile

---

## 📁 Project Architecture

```
email_auto_mobile/
├── assets/
│   └── resumes/
│       ├── Sanju Antony QA1.pdf
│       ├── Sanju Antony.pdf
│       └── Ola Ticket Details.pdf
├── lib/
│   ├── main.dart                      # App entry point
│   ├── theme/
│   │   └── app_theme.dart             # Curated dark glassmorphism theme
│   ├── models/
│   │   ├── job_profile.dart           # Pre-configured outreach profiles
│   │   ├── job_listing.dart           # Scraped job listing representation
│   │   └── automation_log.dart        # Log entry representation
│   ├── services/
│   │   ├── job_scraper_service.dart   # Pure Dart crawler for Infopark/Technopark
│   │   ├── email_service.dart         # Multi-mode email dispatcher (SMTP + Backend)
│   │   └── preferences_service.dart   # Local persistence with SharedPreferences
│   └── screens/
│       ├── home_screen.dart           # Main dashboard & composer
│       ├── settings_screen.dart       # Configuration & connection test
│       └── hybrid_web_screen.dart     # WebView mode
└── pubspec.yaml                       # Dependencies and asset declarations
```

---

## 🛠️ How to Run Locally

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Run on Device / Emulator
```bash
flutter run
```

### 3. Build Release APK
```bash
flutter build apk --release
```
The output APK will be generated at:
`build/app/outputs/flutter-apk/app-release.apk`

---

## 📦 Ready-to-Install APK

A compiled and signed APK is already provided in the workspace:
- **File**: `RecruitMail-Automator.apk` (Root directory)
- **BlueStacks Shared**: `C:\ProgramData\BlueStacks_nxt\Engine\UserData\SharedFolder\RecruitMail-Automator.apk`
- Ready to install immediately by dragging into BlueStacks or via Android file manager.
