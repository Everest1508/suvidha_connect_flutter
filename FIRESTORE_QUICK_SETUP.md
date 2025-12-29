# Quick Firestore Setup Guide

## The Error You're Seeing

```
[cloud_firestore/unknown] Unable to establish connection on channel.
```

This means **Firestore is not enabled** in your Firebase project.

## Quick Fix (5 minutes)

### Step 1: Enable Firestore

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **suvidha-2fb5d**
3. In the left menu, click **Firestore Database**
4. Click **Create Database** button
5. Choose **Start in test mode** (for development)
6. Select a location (choose closest to your users, e.g., `asia-south1` for India)
7. Click **Enable**

### Step 2: Set Security Rules

**If you started in TEST MODE:**
Go to **Firestore Database** → **Rules** and paste:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

**If you started in PRODUCTION MODE:**
Go to **Firestore Database** → **Rules** and paste:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

⚠️ **Warning**: These rules allow anyone to read/write. Only use for development/testing!

**For Production Later:**
You'll need to implement Firebase Authentication or custom tokens. For now, use the above rules to get chat working.

Click **Publish**.

### Step 3: Restart Your App

1. Stop the app completely
2. Run `flutter clean` (optional but recommended)
3. Run `flutter pub get`
4. Restart the app

### Step 4: Test Chat

1. Open a booking detail screen
2. Click "Start Chat"
3. The chat should now load without errors!

## Production Security Rules (Later)

Once chat is working, update the rules to:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /chats/{chatRoomId} {
      // Only allow users involved in the booking to access
      allow read, write: if request.auth != null;
      
      match /messages/{messageId} {
        allow read, write: if request.auth != null;
      }
    }
  }
}
```

## Troubleshooting

### Still seeing errors?

1. **Check Firebase project**: Make sure you're using the correct project (`suvidha-2fb5d`)
2. **Check google-services.json**: Make sure it's in `android/app/` and matches your Firebase project
3. **Check internet connection**: Firestore needs internet
4. **Check console logs**: Look for more specific error messages

### Firestore vs Realtime Database

- **Firestore** = What we're using (recommended)
- **Realtime Database** = Older Firebase database (not what we need)

Make sure you enable **Firestore**, not Realtime Database!

## Need Help?

If you're still having issues:
1. Check the Firebase Console → Firestore Database → Data tab - you should see it's enabled
2. Check the Firebase Console → Project Settings → General - verify your project ID is `suvidha-2fb5d`
3. Try creating a test document manually in Firestore to verify it's working

