# Debug Login Issues

## Issue
cURL login works, but frontend shows "Invalid Credentials"

## Debugging Steps

### 1. Check Flutter Console Logs
When you try to login, check the console for:
- `Logging in user: ...`
- `Login URL: ...`
- `Request body: ...`
- `Login response status: ...`
- `Login response body: ...`

### 2. Compare Request Bodies

**cURL (working):**
```json
{
  "username": "riteshmahale15@gmail.com",
  "password": "Ritesh@123"
}
```

**Frontend should send:**
```json
{
  "username": "riteshmahale15@gmail.com",
  "password": "Ritesh@123"
}
```

### 3. Common Issues

#### Whitespace
- Frontend now trims inputs automatically
- Check if there are any hidden characters

#### Encoding
- Check if special characters in password are encoded correctly
- The `@` symbol should be fine in JSON

#### Network
- Verify the baseUrl is correct: `http://192.168.1.15:8000/api`
- Check if backend is accessible from device/emulator

### 4. Test with Exact Same Data

Try logging in with:
- Email: `riteshmahale15@gmail.com`
- Password: `Ritesh@123`

### 5. Check Backend Logs

When frontend tries to login, check Django console for:
- Request received
- Authentication attempt
- Response sent

### 6. Verify Response Parsing

The frontend expects:
- Status 200 → Success
- Status 401 → Invalid credentials
- Status 403 → Provider not verified

Check if the response status code matches what's expected.

## Quick Test

Run the app and check console output. You should see detailed logs showing:
1. What's being sent
2. What's being received
3. How it's being parsed

Share the console output if the issue persists.



