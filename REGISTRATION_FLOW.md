# Registration and Login Flow

## Unified Flow for Both Roles

### 1. Role Selection Screen
- Both "Service Provider" and "Service Consumer" buttons navigate to **Login Screen**
- User can choose to sign up from the login screen

### 2. Login Screen
- Same screen for both roles
- Has "SIGN UP" link at the bottom
- Supports login with **username or email**
- After successful login:
  - **Provider**: Checks verification status → Goes to home if verified, shows pending message if not
  - **Consumer**: Goes directly to home

### 3. Signup Screen
- Same screen for both roles
- Collects: Name, Email, Phone, Password, Confirm Password
- After successful registration:
  - **Provider**: 
    1. Automatically logs in
    2. Navigates to **Onboarding Step 1** (Location)
    3. User completes 3-step onboarding
    4. Status set to "pending"
    5. Must wait for admin verification to login again
  - **Consumer**: 
    1. Shows success message
    2. Navigates to Login screen
    3. User logs in to access app

## Provider Onboarding Flow (After Registration)

### Step 1: Location Selection
- Select location on map
- Enter address string
- Optional referral code
- API: `POST /api/providers/onboarding_step1/`

### Step 2: Service Selection
- Select services provider offers
- Multiple selections allowed
- API: `POST /api/providers/onboarding_step2/`

### Step 3: Documents
- Personal information (name, contact, address)
- Profile photo (optional)
- PAN card (required)
- Registration certificate (required)
- API: `POST /api/providers/onboarding_step3/`

After Step 3:
- Status: "pending"
- Cannot login until admin verifies
- Shows verification pending message on login attempt

## Flow Diagram

```
Role Select Screen
    ↓
Login Screen (both roles)
    ↓
    ├─→ Sign Up → Signup Screen
    │       ↓
    │   Registration API
    │       ↓
    │   ├─→ Provider: Auto-login → Onboarding Step 1 → Step 2 → Step 3 → Pending
    │   └─→ Consumer: Login Screen
    │
    └─→ Login → Home (if verified for providers)
```

## Key Features

✅ Same registration form for both roles
✅ Same login screen for both roles
✅ Auto-login for providers after registration
✅ Seamless onboarding flow for providers
✅ Email or username login support
✅ Verification system for providers



