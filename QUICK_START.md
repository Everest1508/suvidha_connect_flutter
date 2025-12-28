# Quick Start Guide - Connect Frontend to Backend

## Step 1: Start Backend Server

```bash
cd backend
source venv/bin/activate
python manage.py runserver 0.0.0.0:8000
```

You should see: `Starting development server at http://0.0.0.0:8000/`

## Step 2: Update API URL (If Needed)

Edit `lib/services/api_service.dart`:

**For Android Emulator (default):**
```dart
static const String baseUrl = 'http://10.0.2.2:8000/api';
```

**For iOS Simulator:**
```dart
static const String baseUrl = 'http://localhost:8000/api';
```

**For Physical Device:**
1. Find your computer's IP: `ipconfig` (Windows) or `ifconfig` (Mac/Linux)
2. Update to: `http://YOUR_IP:8000/api` (e.g., `http://192.168.1.100:8000/api`)

## Step 3: Test Connection

Run the Flutter app and try to register/login. Check the console for:
- Connection status messages
- API response codes
- Any error messages

## Step 4: Verify Backend is Accessible

Open browser and test:
- http://localhost:8000/api/services/categories/
- Should return JSON list of services

## Common Issues Fixed

✅ CORS configured for all origins
✅ CSRF trusted origins set
✅ Session authentication enabled
✅ API endpoints properly routed
✅ Debug logging added to API service

## Still Having Issues?

See `CONNECTION_TROUBLESHOOTING.md` for detailed troubleshooting steps.

