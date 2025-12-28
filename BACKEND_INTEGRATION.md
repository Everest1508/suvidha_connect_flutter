# Backend Integration Guide

## API Configuration

The Flutter app connects to the Django backend. Update the base URL in `lib/services/api_service.dart`:

```dart
static const String baseUrl = 'http://10.0.2.2:8000/api'; // Android emulator
```

### Different Environments:

- **Android Emulator**: `http://10.0.2.2:8000/api`
- **iOS Simulator**: `http://localhost:8000/api`
- **Physical Device**: `http://YOUR_COMPUTER_IP:8000/api`
  - Find your IP: `ipconfig` (Windows) or `ifconfig` (Mac/Linux)
  - Example: `http://192.168.1.100:8000/api`

## Running the Backend

1. Navigate to backend directory:
```bash
cd backend
source venv/bin/activate
```

2. Run migrations (if not done):
```bash
python manage.py migrate
```

3. Create superuser (if not done):
```bash
python manage.py createsuperuser
```

4. Start the server:
```bash
python manage.py runserver
```

The API will be available at `http://localhost:8000`

## Provider Onboarding Flow

### Step 1: Location Selection
- User selects location on map
- Enters address string
- Optional referral code
- API: `POST /api/providers/onboarding_step1/`

### Step 2: Service Selection
- User selects services they provide
- Multiple selections allowed
- API: `POST /api/providers/onboarding_step2/`

### Step 3: Documents
- User enters personal information
- Uploads profile photo (optional)
- Uploads PAN card (required)
- Uploads registration certificate (required)
- API: `POST /api/providers/onboarding_step3/`

After completing all steps, the provider status is set to "pending" and they cannot login until admin verifies them.

## Admin Verification

1. Access admin panel: `http://localhost:8000/admin/`
2. Login with superuser credentials
3. Go to "Service Providers"
4. Review provider details and documents
5. Approve or reject providers
6. Approved providers can now login

## Testing the Integration

1. Start the Django backend server
2. Run the Flutter app
3. Register as a provider
4. Complete the 3-step onboarding
5. Try to login (should be blocked until admin approval)
6. Approve the provider in admin panel
7. Login again (should work now)

## Troubleshooting

### Connection Issues
- Check if backend server is running
- Verify the base URL matches your environment
- Check firewall settings
- For physical devices, ensure phone and computer are on same network

### CORS Errors
- Backend has CORS enabled for development
- If issues persist, check `backend/suvidha_connect/settings.py` CORS settings

### File Upload Issues
- Ensure proper permissions in AndroidManifest.xml
- Check file size limits
- Verify file paths are correct

