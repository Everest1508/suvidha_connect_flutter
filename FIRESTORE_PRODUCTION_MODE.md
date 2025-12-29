# Firestore Production Mode Setup

Since you started Firestore in **Production Mode**, here's how to configure it:

## Current Situation

- ✅ Firestore is enabled in Production Mode
- ⚠️ Production Mode requires authentication by default
- ⚠️ We're using Django backend (not Firebase Auth)

## Quick Fix (For Development)

### Set Permissive Rules (Temporary)

1. Go to **Firestore Database** → **Rules**
2. Replace the existing rules with:

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

3. Click **Publish**

⚠️ **Warning**: This allows anyone to read/write your database. **Only use for development!**

## Test Chat Now

1. Restart your app
2. Try opening a chat
3. It should work now!

## For Production (Later)

When you're ready for production, you have two options:

### Option 1: Use Firebase Authentication

1. Enable Firebase Auth in Firebase Console
2. Authenticate users in your Flutter app
3. Update security rules to check `request.auth != null`

### Option 2: Use Custom Authentication Tokens

1. Generate custom tokens in your Django backend
2. Sign in with custom tokens in Flutter
3. Update security rules to validate custom claims

### Option 3: Switch to Test Mode (Easier for Development)

If you want to switch back to test mode:

1. Go to Firestore Database
2. Click **Settings** (gear icon)
3. Click **Delete Database** (⚠️ This deletes all data!)
4. Recreate in **Test Mode**

## Current Rules (Development)

For now, use the permissive rules above. Your chat will work immediately!

## Security Rules Structure (For Reference)

When you're ready for production, structure your rules like this:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /chats/{chatRoomId} {
      // Only allow users involved in the booking
      allow read, write: if request.auth != null 
        && (resource.data.customer_id == request.auth.uid 
            || resource.data.provider_id == request.auth.uid);
      
      match /messages/{messageId} {
        allow read, write: if request.auth != null;
      }
    }
  }
}
```

But this requires Firebase Authentication to be set up first.

