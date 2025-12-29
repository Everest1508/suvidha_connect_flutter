# Push Notifications Setup Guide

## Current Status
Push notification code is commented out to allow the app to compile without Firebase packages installed.

## Steps to Enable Push Notifications

### 1. Install Firebase Packages
Run the following command in your project root:
```bash
flutter pub get
```

### 2. Uncomment Firebase Code

After running `flutter pub get`, uncomment the following:

#### In `lib/main.dart`:
- Uncomment the Firebase imports at the top
- Uncomment the Firebase initialization code in `_initializeFirebase()`

#### In `lib/services/push_notification_service.dart`:
- Uncomment the Firebase import: `import 'package:firebase_messaging/firebase_messaging.dart';`
- Uncomment all the Firebase-related code in the `initialize()` method
- Uncomment the `firebaseMessagingBackgroundHandler` function at the bottom

#### In `lib/screens/auth/login_screen.dart`:
- Uncomment the import: `import '../../services/push_notification_service.dart';`
- Uncomment the `PushNotificationService.reRegisterToken()` calls

### 3. Firebase Project Setup

1. Create a Firebase project at https://console.firebase.google.com
2. Add Android app:
   - Download `google-services.json`
   - Place it in `android/app/`
3. Add iOS app:
   - Download `GoogleService-Info.plist`
   - Place it in `ios/Runner/`
4. Get FCM Server Key:
   - Go to Project Settings > Cloud Messaging
   - Copy the Server Key

### 4. Backend Configuration

Add the FCM Server Key to `backend/suvidha_connect/settings.py`:
```python
FCM_SERVER_KEY = 'your-fcm-server-key-here'
```

### 5. Run Migrations

```bash
cd backend
python manage.py makemigrations accounts
python manage.py migrate
```

## How It Works

1. When a user books a service, the backend:
   - Creates a database notification (already working)
   - Sends a push notification to the provider's device (if FCM token exists)

2. FCM tokens are automatically:
   - Obtained when the app starts
   - Registered with the backend after login
   - Refreshed when they change

## Testing

After setup, test by:
1. Logging in as a provider
2. Having a customer book a service
3. The provider should receive a push notification

