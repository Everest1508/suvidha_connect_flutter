# FCM HTTP v1 API Setup Guide

## Migration from Legacy API

The legacy FCM API has been deprecated. We've migrated to **FCM HTTP v1 API** which uses service account authentication.

## Step 1: Download Service Account JSON File

1. **Go to Firebase Console**
   - Visit: https://console.firebase.google.com/
   - Select your project: **suvidha-2fb5d**

2. **Navigate to Service Accounts**
   - Click the gear icon ⚙️ next to "Project Overview"
   - Select **"Project settings"**
   - Go to the **"Service accounts"** tab

3. **Generate Private Key**
   - Click **"Generate new private key"** button
   - A dialog will appear warning you about keeping the key secure
   - Click **"Generate key"**
   - A JSON file will be downloaded (e.g., `suvidha-2fb5d-firebase-adminsdk-xxxxx.json`)

4. **Save the JSON File**
   - Rename it to: `firebase-service-account.json`
   - Place it in your `backend/` directory
   - **IMPORTANT**: Never commit this file to Git! Add it to `.gitignore`

## Step 2: Update Django Settings

The settings have been updated in `backend/suvidha_connect/settings.py`:

```python
FCM_PROJECT_ID = 'suvidha-2fb5d'  # Your Firebase project ID
FCM_SERVICE_ACCOUNT_JSON_PATH = BASE_DIR / 'firebase-service-account.json'
```

**Verify:**
- `FCM_PROJECT_ID` matches your Firebase project ID
- `FCM_SERVICE_ACCOUNT_JSON_PATH` points to your downloaded JSON file

## Step 3: Install Required Packages

Run this command in your backend directory:

```bash
pip install google-auth google-auth-oauthlib google-auth-httplib2
```

Or if using requirements.txt:

```bash
pip install -r requirements.txt
```

## Step 4: Test Push Notifications

1. **Restart your Django server**
2. **Create a booking** (as a customer)
3. **Check the logs** - you should see:
   ```
   ✅ Push notification sent successfully!
   ```

## Security Notes

⚠️ **IMPORTANT**: 
- The service account JSON file contains sensitive credentials
- **Never commit it to Git**
- Add to `.gitignore`:
  ```
  firebase-service-account.json
  *.json
  ```
- Keep it secure and don't share it publicly

## Troubleshooting

### Error: "Service account JSON file not found"
- Make sure the file is in the `backend/` directory
- Check the path in `settings.py`
- Use absolute path if needed

### Error: "Project not found"
- Verify `FCM_PROJECT_ID` matches your Firebase project ID
- Find it in: Firebase Console → Project Settings → General → Project ID

### Error: "Missing required package"
- Install: `pip install google-auth google-auth-oauthlib google-auth-httplib2`

### Error: "Authentication failed"
- Verify the JSON file is valid
- Make sure you downloaded it from Service Accounts (not Cloud Messaging)
- Regenerate the key if needed

## Benefits of HTTP v1 API

✅ More secure (OAuth2 authentication)
✅ Better error handling
✅ Platform-specific customization
✅ Future-proof (legacy API is deprecated)
✅ Better message delivery tracking

