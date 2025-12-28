# Connection Troubleshooting Guide

## Quick Fixes

### 1. Check Backend is Running
```bash
cd backend
source venv/bin/activate
python manage.py runserver 0.0.0.0:8000
```

The server should show: `Starting development server at http://0.0.0.0:8000/`

### 2. Update API Base URL

Edit `lib/services/api_service.dart` and update the `baseUrl`:

**For Android Emulator:**
```dart
static const String baseUrl = 'http://10.0.2.2:8000/api';
```

**For iOS Simulator:**
```dart
static const String baseUrl = 'http://localhost:8000/api';
```

**For Physical Device:**
1. Find your computer's IP address:
   - Windows: `ipconfig` (look for IPv4 Address)
   - Mac/Linux: `ifconfig` or `ip addr`
2. Update the URL:
```dart
static const String baseUrl = 'http://192.168.1.100:8000/api'; // Replace with your IP
```

### 3. Test Connection

Add this to test if backend is reachable:

```dart
// In your app, call:
final isConnected = await ApiService.testConnection();
print('Backend connected: $isConnected');
```

### 4. Common Issues

#### Issue: "Connection refused" or "Failed host lookup"
**Solution:**
- Ensure backend server is running
- Check the base URL matches your environment
- For physical device, ensure phone and computer are on same WiFi network
- Check firewall isn't blocking port 8000

#### Issue: "403 Forbidden" or CSRF errors
**Solution:**
- Backend should have CSRF exemption for API endpoints (already configured)
- Check `backend/suvidha_connect/settings.py` has `CORS_ALLOW_ALL_ORIGINS = True`

#### Issue: "404 Not Found"
**Solution:**
- Check backend URLs in `backend/suvidha_connect/urls.py`
- Verify API endpoints match: `/api/auth/`, `/api/services/`, `/api/providers/`

#### Issue: Session not persisting
**Solution:**
- Check SharedPreferences is working
- Verify session cookie is being saved in login response
- Check backend session middleware is enabled

### 5. Debug Steps

1. **Enable Debug Logging:**
   - Check Flutter console for API service print statements
   - All API calls now print status codes and responses

2. **Test Backend Directly:**
   ```bash
   # Test service categories endpoint
   curl http://localhost:8000/api/services/categories/
   
   # Test registration
   curl -X POST http://localhost:8000/api/auth/users/register/ \
     -H "Content-Type: application/json" \
     -d '{"username":"test","email":"test@test.com","password":"test1234","password2":"test1234","phone":"1234567890","role":"customer"}'
   ```

3. **Check Backend Logs:**
   - Look at Django server console for request logs
   - Check for any error messages

4. **Verify CORS:**
   - Backend should have `CORS_ALLOW_ALL_ORIGINS = True` in settings
   - Check `CORS_ALLOW_CREDENTIALS = True` is set

### 6. Network Configuration

**For Android Emulator:**
- Use `10.0.2.2` to access host machine's localhost
- This is automatically configured

**For iOS Simulator:**
- Use `localhost` directly
- Should work without changes

**For Physical Device:**
- Both devices must be on same WiFi network
- Use computer's local IP address (not 127.0.0.1)
- Disable VPN if active
- Check router doesn't block device-to-device communication

### 7. Backend Configuration Checklist

- [ ] Backend server is running on port 8000
- [ ] `ALLOWED_HOSTS = ['*']` in settings.py (for development)
- [ ] `CORS_ALLOW_ALL_ORIGINS = True` in settings.py
- [ ] `CORS_ALLOW_CREDENTIALS = True` in settings.py
- [ ] Migrations are applied: `python manage.py migrate`
- [ ] Service categories are seeded: `python manage.py seed_services`

### 8. Flutter Configuration Checklist

- [ ] Dependencies installed: `flutter pub get`
- [ ] Base URL matches your environment
- [ ] Internet permission in AndroidManifest.xml
- [ ] App has network access (check device settings)

### 9. Still Not Working?

1. **Restart everything:**
   - Stop backend server (Ctrl+C)
   - Restart backend: `python manage.py runserver 0.0.0.0:8000`
   - Hot restart Flutter app (not just hot reload)

2. **Clear app data:**
   - Uninstall and reinstall Flutter app
   - This clears SharedPreferences

3. **Check logs:**
   - Flutter: `flutter run -v` for verbose logs
   - Backend: Check Django console output

4. **Test with Postman/curl:**
   - Verify backend endpoints work independently
   - This isolates if issue is Flutter or backend

