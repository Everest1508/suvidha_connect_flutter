# Firebase Chat Setup Guide

## Overview
The chat functionality uses Firebase Firestore for real-time messaging. This provides instant message delivery without needing a custom backend.

## Firebase Firestore Structure

### Chat Rooms Collection
```
chats/
  └── booking_{bookingId}/
      ├── booking_id: "123"
      ├── customer_id: 1
      ├── provider_id: 2
      ├── last_message: "Hello!"
      ├── last_message_time: timestamp
      ├── updated_at: timestamp
      └── messages/ (subcollection)
          └── {messageId}/
              ├── message: "Hello!"
              ├── sender_id: 1
              ├── receiver_id: 2
              ├── timestamp: timestamp
              └── booking_id: "123"
```

## Setup Steps

### 1. Enable Firestore in Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **suvidha-2fb5d**
3. Go to **Firestore Database** in the left menu
4. Click **Create Database**
5. Choose **Start in test mode** (for development) or **Start in production mode** (for production)
6. Select a location (choose closest to your users)

### 2. Set Firestore Security Rules

Go to **Firestore Database** → **Rules** and add:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow users to read/write their own chat messages
    match /chats/{chatRoomId} {
      allow read, write: if request.auth != null;
      
      match /messages/{messageId} {
        allow read, write: if request.auth != null;
      }
    }
  }
}
```

**For production**, use more restrictive rules:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /chats/{chatRoomId} {
      // Only allow users involved in the booking to access the chat
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

### 3. Install Cloud Firestore Package

The package is already added to `pubspec.yaml`:
```yaml
cloud_firestore: ^5.4.4
```

Run:
```bash
flutter pub get
```

### 4. Firebase Authentication (Optional but Recommended)

For better security, you can use Firebase Authentication. However, the current implementation uses your Django backend user IDs, which works fine.

If you want to use Firebase Auth:
1. Enable **Authentication** in Firebase Console
2. Enable **Email/Password** sign-in method
3. Update the chat screen to use Firebase Auth UIDs

## How It Works

1. **Chat Room Creation**:
   - Each booking gets a unique chat room: `booking_{bookingId}`
   - Created automatically when first message is sent

2. **Real-time Messages**:
   - Uses Firestore `snapshots()` listener
   - Messages appear instantly for both users
   - No polling needed

3. **Message Structure**:
   - Each message stored in `chats/{chatRoomId}/messages/{messageId}`
   - Contains: message text, sender_id, receiver_id, timestamp

4. **Chat Room Metadata**:
   - Stored in `chats/{chatRoomId}`
   - Tracks last message and update time
   - Useful for showing chat previews

## Features

✅ Real-time messaging (instant delivery)
✅ Message history (persisted in Firestore)
✅ Timestamps on messages
✅ Read receipts (can be added)
✅ Typing indicators (can be added)
✅ File attachments (can be added)

## Testing

1. Accept a booking (as provider)
2. Click "Start Chat" button
3. Send a message
4. Open the chat on the other user's device
5. Messages should appear in real-time!

## Troubleshooting

### Messages not appearing
- Check Firestore rules allow read/write
- Verify Firebase is initialized in `main.dart`
- Check console for errors

### Permission denied errors
- Update Firestore security rules
- Make sure user is authenticated (if using Firebase Auth)

### Messages not sending
- Check internet connection
- Verify Firestore is enabled in Firebase Console
- Check console for error messages

