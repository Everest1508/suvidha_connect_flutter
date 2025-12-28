# Session Management

## Overview
The app now maintains user sessions after login, allowing users to stay logged in across app restarts.

## Features

### 1. Session Persistence
- Session ID is saved to `SharedPreferences` after successful login
- User data is cached locally for quick access
- Session persists across app restarts

### 2. Session Verification
- On app startup (splash screen), the app checks if a valid session exists
- If session is valid, user is automatically logged in and redirected to home
- If session is expired or invalid, user is redirected to role selection

### 3. Automatic Session Inclusion
- All API requests automatically include the session cookie if available
- No need to manually pass authentication for each request
- Session is maintained for all authenticated endpoints

### 4. Logout Functionality
- Logout button available in Profile screen
- Clears session ID and user data from local storage
- Redirects to role selection screen

## Implementation Details

### Session Storage
- **Session ID**: Stored in `SharedPreferences` with key `session_id`
- **User Data**: Stored in `SharedPreferences` with key `user_data` (JSON string)
- **Login Status**: Stored as boolean `is_logged_in` in `SharedPreferences`

### API Service Methods

#### `isLoggedIn()`
- Checks if user has a valid session
- Verifies session by calling `/api/auth/users/me/`
- Returns `true` if session is valid, `false` otherwise
- Automatically clears expired sessions

#### `getCurrentUser()`
- Returns cached user data from `SharedPreferences`
- Returns `null` if no user data is available
- Fast, synchronous access to user information

#### `getCurrentUserInfo()`
- Fetches fresh user data from the API
- Updates cached user data
- Returns latest user information from server

#### `logout()`
- Clears session ID, user data, and login status
- Can optionally call logout endpoint (currently commented out)
- Always clears local session even if API call fails

### Flow Diagram

```
App Start (Splash Screen)
    ↓
Check Session (isLoggedIn())
    ↓
    ├─→ Valid Session → Get User Data → Check Role
    │       ↓
    │   Provider → Check Verification → Home (if verified) or Role Select
    │   Consumer → Home
    │
    └─→ Invalid/No Session → Role Select Screen
```

### Login Flow
1. User enters credentials
2. API call to `/api/auth/users/login/`
3. Session ID extracted from `Set-Cookie` header
4. Session ID saved to `SharedPreferences`
5. User data saved to `SharedPreferences`
6. `is_logged_in` flag set to `true`
7. User redirected based on role and verification status

### Logout Flow
1. User taps "Logout" in Profile screen
2. Confirmation dialog shown
3. `ApiService.logout()` called
4. Session ID, user data, and login flag cleared
5. User redirected to role selection screen

## Session Cookie Handling

### Backend (Django)
- Uses Django's session framework
- Session cookie named `sessionid`
- Session stored server-side
- Session expires based on Django settings (default: 2 weeks)

### Frontend (Flutter)
- Extracts `sessionid` from `Set-Cookie` header
- Stores in `SharedPreferences`
- Includes in `Cookie` header for all authenticated requests
- Automatically included via `_getHeaders()` method

## Security Considerations

1. **Session Validation**: Session is verified on app startup to ensure it's still valid
2. **Automatic Cleanup**: Expired sessions are automatically cleared
3. **Secure Storage**: Session ID stored in `SharedPreferences` (encrypted on iOS, can be encrypted on Android with plugins)
4. **Server-Side Validation**: Backend validates session on each authenticated request

## Usage Examples

### Check if User is Logged In
```dart
final isLoggedIn = await ApiService.isLoggedIn();
if (isLoggedIn) {
  // User has valid session
}
```

### Get Current User Data
```dart
final user = await ApiService.getCurrentUser();
if (user != null) {
  print('User: ${user['username']}');
  print('Role: ${user['role']}');
}
```

### Logout
```dart
await ApiService.logout();
// User is logged out, session cleared
```

### Refresh User Data
```dart
final result = await ApiService.getCurrentUserInfo();
if (result['success'] == true) {
  final userData = result['data'];
  // Use updated user data
}
```

## Testing

### Test Session Persistence
1. Login to the app
2. Close the app completely
3. Reopen the app
4. Should automatically log in and go to home screen

### Test Session Expiration
1. Login to the app
2. Wait for session to expire (or manually expire on backend)
3. Restart the app
4. Should redirect to role selection screen

### Test Logout
1. Login to the app
2. Go to Profile screen
3. Tap "Logout"
4. Confirm logout
5. Should redirect to role selection screen



