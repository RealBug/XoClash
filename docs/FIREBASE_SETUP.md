# 🔥 Firebase Setup - XO Clash

Complete guide to configure Firebase (Firestore + Authentication) for the XO Clash project.

---

## 📋 Table of Contents

1. [Create Firebase Project](#1-create-firebase-project)
2. [Configure Firestore](#2-configure-firestore)
3. [Configure Firebase Authentication](#3-configure-firebase-authentication)
4. [Flutter Integration](#4-flutter-integration)
5. [Test Configuration](#5-test-configuration)

---

## 1. Create Firebase Project

### 1.1 Firebase Console

1. **Access the console:**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Sign in with a Google account

2. **Create a new project:**
   ```
   Project name: xo-clash (or tictac)
   ✅ Enable Google Analytics (recommended)
   Analytics account: Select or create
   ```

3. **Add applications:**

   **iOS:**
   ```
   Bundle ID: com.yourcompany.tictac
   Download GoogleService-Info.plist
   Place in: ios/Runner/
   ```

   **Android:**
   ```
   Package name: com.yourcompany.tictac
   Download google-services.json
   Place in: android/app/
   ```

   **macOS (if needed):**
   ```
   Bundle ID: com.yourcompany.tictac
   Download GoogleService-Info.plist
   Place in: macos/Runner/
   ```

   **Web:**
   ```
   App nickname: XO Clash Web
   Enable Firebase Hosting (optional)

   Firebase Web Configuration (auto-generated):
   - apiKey: "AIzaSy..."
   - authDomain: "xo-clash.firebaseapp.com"
   - projectId: "xo-clash"
   - storageBucket: "xo-clash.firebasestorage.app"
   - messagingSenderId: "..."
   - appId: "1:...:web:..."

   Note: These values will be added in the code (see section 4.2)
   ```

4. **Initial configuration:**
   - ✅ Enable test mode to start
   - ⚠️ Switch to production with security rules later

---

## 2. Configure Firestore

### 2.1 Create Database

1. **In Firebase console:**
   ```
   Menu: Firestore Database
   → Create database

   Mode: Start in test mode (30 days)
   Region: europe-west1 (Belgium) or closest to you
   ```

2. **Collections structure:**

   ```
   firestore/
   ├── games/
   │   └── {gameId}/
   │       ├── board: Array<Array<String>>
   │       ├── currentPlayer: String ('Player.x' | 'Player.o')
   │       ├── status: String ('GameStatus.playing' | 'GameStatus.xWon' | ...)
   │       ├── gameId: String
   │       ├── playerId: String (owner/creator)
   │       ├── player1Id: String (optional)
   │       ├── player2Id: String (optional)
   │       ├── isOnline: Boolean
   │       ├── createdAt: Timestamp
   │       ├── updatedAt: Timestamp
   │       └── lastMove: Map<String, dynamic>
   │           ├── row: Number
   │           ├── col: Number
   │           └── player: String
   │
   ├── users/ (optional - for profiles)
   │   └── {userId}/
   │       ├── username: String
   │       ├── email: String (optional)
   │       ├── photoUrl: String (optional)
   │       ├── createdAt: Timestamp
   │       └── lastLoginAt: Timestamp
   │
   └── history/ (optional - game history)
       └── {userId}/
           └── games/ (subcollection)
               └── {gameId}/
                   ├── result: String
                   ├── opponent: String
                   ├── timestamp: Timestamp
                   └── score: Number
   ```

### 2.2 Firestore Security Rules

**Development mode (30 days):**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.time < timestamp.date(2025, 2, 1);
    }
  }
}
```

**Production mode (to implement):**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Games collection
    match /games/{gameId} {
      // Everyone can read public games
      allow read: if true;

      // Only authenticated users can create
      allow create: if request.auth != null;

      // Only game players can update
      allow update: if request.auth != null
        && (request.auth.uid == resource.data.player1Id
            || request.auth.uid == resource.data.player2Id
            || request.auth.uid == resource.data.playerId);

      // Only creator can delete
      allow delete: if request.auth != null
        && request.auth.uid == resource.data.playerId;
    }

    // Users collection
    match /users/{userId} {
      // Everyone can read public profiles
      allow read: if true;

      // Only user can modify their profile
      allow create, update: if request.auth != null
        && request.auth.uid == userId;

      allow delete: if request.auth != null
        && request.auth.uid == userId;
    }

    // History collection
    match /history/{userId}/games/{gameId} {
      // Only user can read their history
      allow read: if request.auth != null
        && request.auth.uid == userId;

      // Only user can create/modify their history
      allow create, update: if request.auth != null
        && request.auth.uid == userId;
    }
  }
}
```

### 2.3 Indexes (if needed)

If you have complex queries, create indexes:

```
Collection: games
Fields: status (Ascending), createdAt (Descending)
→ To list active games sorted by date
```

---

## 3. Configure Firebase Authentication

### 3.1 Enable Providers

In **Firebase Console → Authentication → Sign-in method:**

**⚠️ Important for Web:**
- Go to **Settings (⚙️) → Authorized domains**
- Add your authorized domains:
  - `localhost` (dev)
  - `your-domain.com` (production)
  - `xo-clash.web.app` (if Firebase Hosting)

#### 1️⃣ **Anonymous** (Required)
```
✅ Enable anonymous authentication
```

**Use cases:**
- Allow users to play without an account
- Convert to permanent account later

#### 2️⃣ **Google Sign-In** (Recommended)
```
✅ Enable Google Sign-in
Support email: your-email@gmail.com
```

**iOS Configuration:**
1. Open `ios/Runner/Info.plist`
2. Add:
```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>com.googleusercontent.apps.YOUR-CLIENT-ID</string>
    </array>
  </dict>
</array>
```

**Android Configuration:**
- Auto-configured via `google-services.json` ✅

#### 3️⃣ **Apple Sign-In** (For iOS/macOS)
```
✅ Enable Sign in with Apple
```

**iOS/macOS Configuration:**
1. Apple Developer Console:
   - Enable "Sign in with Apple" capability
   - Create a Service ID

2. Xcode:
   - Target → Signing & Capabilities
   - ✅ Add "Sign in with Apple"

3. Firebase Console:
   ```
   Services ID: com.yourcompany.tictac.signin
   Team ID: Your Apple Team ID (10 characters)
   Key ID: Create a key in Apple Developer
   Private Key: Download and upload
   ```

#### 4️⃣ **Email/Password** (Optional)
```
✅ Enable Email/Password
✅ Enable Email link (passwordless)
```

**Configuration:**
```
Authorized domains:
- localhost
- your-domain.com

Email templates:
- Customize verification emails
- Customize reset emails
```

---

## 4. Flutter Integration

### 4.1 Dependencies (already installed)

Check in `pubspec.yaml`:
```yaml
dependencies:
  # Firebase Core
  firebase_core: ^4.3.0

  # Firestore
  cloud_firestore: ^6.1.1

  # Authentication
  google_sign_in: 7.2.0
  sign_in_with_apple: 7.0.1
```

### 4.2 Firebase Initialization

Create `lib/core/firebase/firebase_config.dart`:
```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseConfig {
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: _getFirebaseOptions(),
    );

    if (kDebugMode) {
      print('✅ Firebase initialized successfully');
    }
  }

  static FirebaseOptions _getFirebaseOptions() {
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      return const FirebaseOptions(
        apiKey: 'YOUR_IOS_API_KEY',
        appId: 'YOUR_IOS_APP_ID',
        messagingSenderId: 'YOUR_SENDER_ID',
        projectId: 'xo-clash',
        storageBucket: 'xo-clash.firebasestorage.app',
      );
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return const FirebaseOptions(
        apiKey: 'YOUR_ANDROID_API_KEY',
        appId: 'YOUR_ANDROID_APP_ID',
        messagingSenderId: 'YOUR_SENDER_ID',
        projectId: 'xo-clash',
        storageBucket: 'xo-clash.firebasestorage.app',
      );
    }

    throw UnsupportedError('Platform not supported');
  }
}
```

### 4.3 Initialize in main.dart

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Firebase
  await FirebaseConfig.initialize();

  // 2. Launch app with Riverpod
  runApp(const ProviderScope(child: App()));
}
```

### 4.4 Authentication Service

The project uses `FirebaseAuthBackendService` in `lib/features/auth/data/services/firebase_auth_backend_service.dart`.

It's registered as a Riverpod provider in `lib/core/providers/service_providers.dart`:

```dart
final authBackendServiceProvider = Provider<AuthBackendService>(
  (ref) => FirebaseAuthBackendService(null, null, ref.watch(loggerServiceProvider)),
);
```

---

## 5. Test Configuration

### 5.1 Firestore Test

```dart
// Test write
final docRef = FirebaseFirestore.instance.collection('games').doc('test-123');
await docRef.set({
  'board': [
    ['Player.none', 'Player.none', 'Player.none'],
    ['Player.none', 'Player.none', 'Player.none'],
    ['Player.none', 'Player.none', 'Player.none'],
  ],
  'currentPlayer': 'Player.x',
  'status': 'GameStatus.waiting',
  'createdAt': FieldValue.serverTimestamp(),
});

// Test read
final doc = await docRef.get();
print('✅ Firestore test: ${doc.data()}');
```

### 5.2 Authentication Test

```dart
// Test anonymous
final userCredential = await FirebaseAuth.instance.signInAnonymously();
print('✅ Anonymous: ${userCredential.user?.uid}');

// Test Google (via Riverpod)
final authService = container.read(authBackendServiceProvider);
final googleUser = await authService.signInWithGoogle();
print('✅ Google: ${googleUser.displayName}');
```

### 5.3 Console Verification

1. **Firestore:**
   - Go to Firestore Database
   - Verify that `games` collection exists
   - Verify `test-123` document

2. **Authentication:**
   - Go to Authentication → Users
   - Verify created users
   - Provider methods: Anonymous, Google, Apple

---

## 📝 Final Checklist

### Firebase Console
- [x] Firebase project created
- [x] iOS/Android/macOS apps added
- [x] Config files downloaded and placed
- [x] Firestore Database created
- [x] Security rules configured
- [x] Authentication enabled (4 providers)

### Flutter
- [x] `firebase_core` initialized in `main.dart`
- [x] `FirebaseAuthBackendService` created with Riverpod provider
- [x] `FirebaseGameBackendService` created with Riverpod provider
- [x] Connection tests performed

### Production
- [ ] Firestore security rules in production mode
- [ ] Firestore indexes created if needed
- [ ] OAuth redirect URIs configured
- [ ] Apple Sign-In Service ID configured
- [ ] Analytics configured and tested

---

## 🚀 Next Steps

1. **Implement Auth UI:**
   - Login screen with 4 options
   - User state management
   - Anonymous → permanent account conversion

2. **Advanced Firestore Rules:**
   - Data validation (schema validation)
   - Rate limiting
   - Anti-cheating for games

3. **Monitoring:**
   - Firebase Crashlytics
   - Performance Monitoring
   - Game session analytics

---

## 📚 Resources

- [Firebase Console](https://console.firebase.google.com/)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/get-started)
- [Firebase Auth Flutter](https://firebase.google.com/docs/auth/flutter/start)

---

**Firebase configuration complete!** 🎉
