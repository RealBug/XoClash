# 🌐 Web Deployment - XO Clash

Complete guide to deploy XO Clash on the web with Firebase Hosting or other platforms.

---

## 📋 Table of Contents

1. [Prepare Web Application](#1-prepare-web-application)
2. [Firebase Hosting](#2-firebase-hosting)
3. [Other Platforms](#3-other-platforms)
4. [CORS Configuration](#4-cors-configuration)
5. [Web Performance](#5-web-performance)

---

## 1. Prepare Web Application

### 1.1 Web Build

```bash
# Optimized production build
fvm flutter build web --release

# Build with source maps (debug)
fvm flutter build web --web-renderer canvaskit --source-maps

# Build with HTML renderer (lighter but fewer features)
fvm flutter build web --web-renderer html
```

**Generated files:**
```
build/web/
  ├── index.html
  ├── main.dart.js
  ├── flutter_service_worker.js
  ├── assets/
  └── icons/
```

### 1.2 Test Locally

```bash
# Simple HTTP server
cd build/web
python3 -m http.server 8000

# Or with dhttpd (Dart)
dart pub global activate dhttpd
dhttpd --path build/web --port 8000
```

Open: `http://localhost:8000`

---

## 2. Firebase Hosting

### 2.1 Initialize Firebase Hosting

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize in project
firebase init hosting

# Select:
# - Public directory: build/web
# - Configure as SPA: Yes
# - Set up automatic builds: No (for now)
# - Overwrite index.html: No
```

### 2.2 `firebase.json` Configuration

```json
{
  "hosting": {
    "public": "build/web",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ],
    "headers": [
      {
        "source": "**/*.@(js|css|woff2|ttf|otf|eot|woff)",
        "headers": [
          {
            "key": "Cache-Control",
            "value": "max-age=31536000"
          }
        ]
      },
      {
        "source": "**",
        "headers": [
          {
            "key": "X-Content-Type-Options",
            "value": "nosniff"
          },
          {
            "key": "X-Frame-Options",
            "value": "SAMEORIGIN"
          },
          {
            "key": "X-XSS-Protection",
            "value": "1; mode=block"
          }
        ]
      }
    ]
  }
}
```

### 2.3 Deploy

```bash
# Build + Deploy
fvm flutter build web --release
firebase deploy --only hosting

# Preview before deploy
firebase hosting:channel:deploy preview
```

**Production URLs:**
```
https://xo-clash.web.app
https://xo-clash.firebaseapp.com
```

### 2.4 Custom Domain

```bash
# Add custom domain
firebase hosting:sites:create xo-clash

# Configure DNS
# A record: @ → 151.101.1.195, 151.101.65.195
# CNAME: www → xo-clash.web.app
```

---

## 3. Other Platforms

### 3.1 Netlify

**netlify.toml:**
```toml
[build]
  command = "flutter build web --release"
  publish = "build/web"

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200

[[headers]]
  for = "/*"
  [headers.values]
    X-Frame-Options = "SAMEORIGIN"
    X-Content-Type-Options = "nosniff"
```

**Deploy:**
```bash
# CLI
netlify deploy --prod --dir=build/web

# Or via Git (auto-deploy)
# Push to main → automatic deploy
```

### 3.2 Vercel

**vercel.json:**
```json
{
  "buildCommand": "flutter build web --release",
  "outputDirectory": "build/web",
  "routes": [
    { "handle": "filesystem" },
    { "src": "/.*", "dest": "/index.html" }
  ],
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "X-Content-Type-Options",
          "value": "nosniff"
        }
      ]
    }
  ]
}
```

**Deploy:**
```bash
vercel --prod
```

### 3.3 GitHub Pages

**gh-pages.yml** (GitHub Actions):
```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.38.5'
      
      - name: Build Web
        run: flutter build web --release --base-href=/Tictac/
      
      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./build/web
```

---

## 4. CORS Configuration

### 4.1 Firestore CORS

If you use Firestore from the web, no CORS configuration needed! ✅

Firebase SDK automatically handles CORS.

### 4.2 Storage CORS (if used)

**cors.json:**
```json
[
  {
    "origin": [
      "https://xo-clash.web.app",
      "https://xo-clash.firebaseapp.com",
      "http://localhost:*"
    ],
    "method": ["GET", "POST", "DELETE"],
    "maxAgeSeconds": 3600
  }
]
```

**Apply:**
```bash
gsutil cors set cors.json gs://xo-clash.firebasestorage.app
```

### 4.3 External API CORS

If you call a custom API (non-Firebase):

**Backend (Express example):**
```javascript
app.use(cors({
  origin: [
    'https://xo-clash.web.app',
    'http://localhost:8000'
  ],
  credentials: true
}));
```

---

## 5. Web Performance

### 5.1 Build Optimizations

```bash
# CanvasKit renderer (better quality, heavier)
flutter build web --web-renderer canvaskit

# HTML renderer (lighter, fewer features)
flutter build web --web-renderer html

# Auto-detect (recommended)
flutter build web --web-renderer auto

# Tree-shaking
flutter build web --release --tree-shake-icons
```

### 5.2 Service Worker

The `flutter_service_worker.js` file is automatically generated.

**To disable cache (debug):**
```javascript
// In index.html
if ('serviceWorker' in navigator) {
  window.addEventListener('load', function () {
    navigator.serviceWorker.register('/flutter_service_worker.js');
  });
}
```

### 5.3 Lazy Loading

**Defer asset loading:**
```dart
// In pubspec.yaml
flutter:
  assets:
    - assets/images/  # Loaded on demand
  
  deferred-components:
    - name: game
      libraries:
        - package:tictac/features/game
```

### 5.4 Web-specific Optimizations

**main.dart:**
```dart
import 'package:flutter/foundation.dart';

void main() {
  if (kIsWeb) {
    // Disable debug banner on web
    WidgetsFlutterBinding.ensureInitialized();
    
    // Web optimizations
    setUrlStrategy(PathUrlStrategy()); // Clean URLs without #
  }
  
  runApp(const App());
}
```

---

## 6. Firebase Auth Authorized Domains

### 6.1 Add Domains

**Firebase Console → Authentication → Settings → Authorized domains:**

```
✅ localhost (auto-added)
✅ xo-clash.web.app (auto-added)
✅ xo-clash.firebaseapp.com (auto-added)
➕ your-domain.com (add manually)
➕ www.your-domain.com
```

### 6.2 OAuth Redirect URIs

For Google/Apple Sign-In on web:

```
https://xo-clash.firebaseapp.com/__/auth/handler
https://your-domain.com/__/auth/handler
http://localhost:PORT/__/auth/handler
```

---

## 7. Deployment Checklist

### Before Deploy
- [ ] `flutter build web --release` compiles without errors
- [ ] Local tests on `http://localhost:8000`
- [ ] Firebase initialized (`flutterfire configure`)
- [ ] Authorized domains configured
- [ ] OAuth redirect URIs configured

### Firebase Hosting
- [ ] `firebase init hosting` configured
- [ ] `firebase.json` with security headers
- [ ] `firebase deploy --only hosting` successful
- [ ] Verify on `https://xo-clash.web.app`

### Performance
- [ ] Lighthouse score > 80
- [ ] First Contentful Paint < 3s
- [ ] Time to Interactive < 5s
- [ ] Service Worker active

### Security
- [ ] HTTPS enabled
- [ ] Security headers (CSP, X-Frame-Options)
- [ ] Firebase Rules in production mode
- [ ] No secrets in client code

---

## 8. Monitoring

### 8.1 Firebase Performance Monitoring

```dart
import 'package:firebase_performance/firebase_performance.dart';

final performance = FirebasePerformance.instance;

// Custom trace
final trace = performance.newTrace('game_load');
await trace.start();
// ... game loading
await trace.stop();
```

### 8.2 Firebase Analytics

```dart
import 'package:firebase_analytics/firebase_analytics.dart';

final analytics = FirebaseAnalytics.instance;

// Log events
analytics.logEvent(
  name: 'game_completed',
  parameters: {'winner': 'player_x'},
);
```

---

## 📚 Resources

- [FlutterFire Web](https://firebase.flutter.dev/docs/overview#web)
- [Firebase Hosting Docs](https://firebase.google.com/docs/hosting)
- [Flutter Web Deployment](https://docs.flutter.dev/deployment/web)
- [Firebase Auth Web](https://firebase.google.com/docs/auth/web/start)

---

**Web application ready for production!** 🚀
