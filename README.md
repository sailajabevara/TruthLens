# TruthLens

TruthLens is a cross-platform Flutter application for scam detection, fake news analysis, and conversational threat intelligence.

It combines:
- Firebase authentication (email/password + Google sign-in)
- on-device text, URL, news, and document analysis
- OCR and PDF text extraction
- AI chat assistance with scam and job-verification guidance
- scan history, analytics, and profile settings

## App Features

- **Authentication**
  - Firebase email/password login
  - Signup with full name, email, and password
  - Google sign-in
  - password reset and logout flow

- **Dashboard**
  - Personalized greeting and safety score
  - Quick scan tiles for URL, message, document, and news analysis
  - Recent scan snapshot and scam/safe summary
  - Safety tips and quick search input

- **Threat Intelligence Analyzer**
  - text input analysis for message, URL, news, and document scans
  - PDF, TXT, MD, CSV, JSON file upload
  - mobile camera/gallery OCR support for image extraction
  - trust score, risk assessment, and explanation output

- **AI Chat Assistant**
  - interactive chat UI for scam advice
  - Telugu/English prompts support
  - chat history and clear chat action

- **History & Analytics**
  - scan history list with filters for links, messages, documents, and news
  - risk summary cards (high, medium, safe)
  - tap history item to view detailed result

- **Profile & Settings**
  - user profile screen with account stats
  - dark/light theme toggle
  - navigation to personal info, security, notifications, privacy, help, and about screens

## Project Structure

```
lib/
  core/
    state/truthlens_provider.dart
  features/
    auth/
      data/
      presentation/
        screens/
          login_screen.dart
          onboarding_screen.dart
    chat/
      presentation/
        screens/
          ai_chat_assistant_screen.dart
    dashboard/
      presentation/
        screens/
          dashboard_screen.dart
          home_screen.dart
          splash_screen.dart
    history/
      presentation/
        screens/
          history_screen.dart
    settings/
      presentation/
        screens/
          profile_screen.dart
          personal_info_screen.dart
          security_settings_screen.dart
          notification_settings_screen.dart
          privacy_policy_screen.dart
          help_center_screen.dart
          community_guidelines_screen.dart
          about_truthlens_screen.dart
    threat_intelligence/
      domain/
      presentation/
        screens/
          analyzer_screen.dart
          analytics_screen.dart
          result_screen.dart

truthlens-backend/
  package.json
  server.js

android/, ios/, linux/, macos/, windows/, web/

pubspec.yaml
README.md

```

## Dependencies

Key packages used by the Flutter app:

- `provider`
- `firebase_core`, `firebase_auth`
- `google_sign_in`
- `device_preview`
- `file_picker`, `image_picker`
- `google_mlkit_text_recognition`
- `syncfusion_flutter_pdf`
- `read_pdf_text`
- `http`

## Backend Server

The `truthlens-backend` folder contains a small Node.js Express proxy for AI chat.
It sends `/chat` requests to OpenRouter using `google/gemini-2.0-flash-001`.

### Backend run steps

```bash
cd truthlens-backend
npm install
set OPENROUTER_API_KEY=your_api_key
node server.js
```

## Run the App Locally

From the repository root:

```bash
flutter pub get
flutter run
```

If you need a specific platform, run:

```bash
flutter run -d windows
flutter run -d chrome
flutter run -d <device_id>
```

## Run with Docker

This repo is mainly a Flutter app. Local Flutter run is the recommended path.

If you still want to build the container:

```bash
docker build -t truthlens-app .
docker run --rm -it -p 8080:8080 truthlens-app
```

## Git Push

```bash
git status
git add .
git commit -m "Your commit message"
git push origin main
```

For a new branch:

```bash
git push -u origin <branch-name>
```

## Notes

- The app initializes Firebase in `lib/main.dart`.
- The home flow starts at `SplashScreen` and then navigates to `HomeScreen`.
- `TrustShieldProvider` contains app state, analysis methods, chat history, themes, and scan history.
- `AnalyzerScreen` supports both uploaded files and manual input.
- `HistoryScreen` shows saved scan records and risk categories.

---

TruthLens is built to help detect scams, fake jobs, suspicious URLs, and misleading content using a unified Flutter experience.
