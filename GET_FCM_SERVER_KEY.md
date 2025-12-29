# How to Get the Correct FCM Server Key

## Problem
Your current Server Key is only **87 characters** long, but it should be **150+ characters**. This is why you're getting a 404 error.

## Step-by-Step Instructions

### Method 1: Get Server Key from Firebase Console

1. **Go to Firebase Console**
   - Visit: https://console.firebase.google.com/
   - Select your project: **suvidha-2fb5d**

2. **Navigate to Project Settings**
   - Click the gear icon ⚙️ next to "Project Overview"
   - Select **"Project settings"**

3. **Go to Cloud Messaging Tab**
   - Click on the **"Cloud Messaging"** tab (not "General" or "Service accounts")
   - Scroll down to find **"Cloud Messaging API (Legacy)"** section

4. **Find the Server Key**
   - Under "Cloud Messaging API (Legacy)", you should see:
     - **Server key** - This is what you need!
   - It should be a very long string (150+ characters)
   - Format example: `AAAA...` (very long alphanumeric string)

5. **Copy the Server Key**
   - Click the copy icon or select and copy the entire key
   - Make sure you copy the **entire** key (it's very long!)

6. **Update in settings.py**
   - Open: `backend/suvidha_connect/settings.py`
   - Find: `FCM_SERVER_KEY = "..."`
   - Replace with your new Server Key

### Method 2: Enable Cloud Messaging API (Legacy)

If you don't see the Server Key:

1. **Enable the Legacy API**
   - In the Cloud Messaging tab
   - Look for "Cloud Messaging API (Legacy)"
   - If it says "Not enabled", click to enable it
   - You may need to enable it in Google Cloud Console

2. **Check Google Cloud Console**
   - Go to: https://console.cloud.google.com/
   - Select your project
   - Go to **APIs & Services** → **Enabled APIs**
   - Search for "Firebase Cloud Messaging API"
   - Make sure it's enabled

### What the Server Key Should Look Like

- **Length**: 150+ characters (usually 150-200 characters)
- **Format**: Alphanumeric string with possible dashes/underscores
- **Example**: `AAAAxYz123...` (very long string)

### Your Current Key (WRONG)
```
BKFNF_CBjaGzFhBxb9WM5CH7-cWT2cZm6MEY35ZxM4SUwvgKR1Q2lzUFu914AQaA_rDqr76ssrgmuRrDI_-E3uo
```
Length: 87 characters ❌

### What You Need (CORRECT)
```
AAAAxYz123... (150+ characters)
```
Length: 150+ characters ✅

## Alternative: Use FCM HTTP v1 API

If you can't find the Server Key or prefer a more modern approach, we can implement FCM HTTP v1 API which uses:
- Service Account JSON file (the "private key" you mentioned)
- More secure authentication
- Better error handling

Let me know if you want to switch to HTTP v1 API instead!

## After Getting the Correct Key

1. Update `FCM_SERVER_KEY` in `backend/suvidha_connect/settings.py`
2. Restart your Django server
3. Test by creating a booking
4. Check the logs - you should see "✅ Push notification sent successfully!"

