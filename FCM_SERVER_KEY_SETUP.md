# FCM Server Key Setup Guide

## Issue: 404 Error When Sending Push Notifications

If you're getting a 404 error, it usually means:
1. The Server Key is invalid or incorrect
2. The Server Key format is wrong
3. The legacy FCM API endpoint might have issues

## How to Get the Correct FCM Server Key

### Option 1: Legacy Server Key (Current Implementation)

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Click the gear icon ⚙️ next to "Project Overview"
4. Select **Project Settings**
5. Go to the **Cloud Messaging** tab
6. Under **Cloud Messaging API (Legacy)**, you should see:
   - **Server key** - This is what you need
   - It should be a long string (usually 150+ characters)
   - Format: `AAAA...` or similar

**Important Notes:**
- The Server Key should be a very long string
- If you see "Cloud Messaging API (Legacy)" is disabled, you need to enable it
- The key you're using might be from a different location

### Option 2: Verify Your Current Key

Your current Server Key format looks like:
```
BKFNF_CBjaGzFhBxb9WM5CH7-cWT2cZm6MEY35ZxM4SUwvgKR1Q2lzUFu914AQaA_rDqr76ssrgmuRrDI_-E3uo
```

This might be:
- A different type of key (not the Server Key)
- An API key instead of Server Key
- A key from a different Firebase service

### Option 3: Check Firebase Console Location

The Server Key should be found at:
- **Firebase Console** → **Project Settings** → **Cloud Messaging** tab
- Look for **"Server key"** under **"Cloud Messaging API (Legacy)"**
- NOT under "Cloud Messaging API (V1)" - that's different

## Troubleshooting Steps

1. **Verify the key location:**
   - Make sure you're looking at the **Cloud Messaging** tab
   - Not the **General** tab
   - Not the **Service Accounts** tab

2. **Check if Legacy API is enabled:**
   - In Cloud Messaging tab, ensure "Cloud Messaging API (Legacy)" is enabled
   - If disabled, enable it

3. **Test the key format:**
   - Server Key should be 150+ characters long
   - Usually starts with letters/numbers
   - No special characters except dashes/underscores

4. **Alternative: Use FCM HTTP v1 API**
   - This requires a Service Account JSON file
   - More secure but more complex to implement
   - See below for implementation

## If Server Key Still Doesn't Work

The legacy FCM API has been deprecated. Consider migrating to FCM HTTP v1 API which uses:
- Service Account JSON file (the "private key" you mentioned)
- More secure authentication
- Better error handling

Let me know if you want to switch to HTTP v1 API implementation.

