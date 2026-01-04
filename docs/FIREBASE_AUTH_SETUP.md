# Firebase Authentication Setup Guide

This guide covers the setup required for Firebase Authentication after a fresh git clone.

## Prerequisites

- Flutter SDK installed
- Access to Firebase configuration files (provided by team member)

## Step 1: Firebase Configuration Files

Get the following files from the team member or shared drive and place them in the correct locations:

### Required Files

| File | Location | Platform |
|------|----------|----------|
| `google-services.json` | `android/app/google-services.json` | Android |
| `GoogleService-Info.plist` | `ios/Runner/GoogleService-Info.plist` | iOS |
| `firebase_options.dart` | `lib/firebase_options.dart` | Both |

### File Placement

```
who-mobile-project/
├── android/
│   └── app/
│       └── google-services.json      <-- Place here
├── ios/
│   └── Runner/
│       └── GoogleService-Info.plist  <-- Place here
└── lib/
    └── firebase_options.dart         <-- Place here
```

> **Note:** These files are gitignored for security. Contact the project maintainer to get them.

## Step 2: Verify Setup

### Run the App

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

### Test Login

1. Navigate to Admin Login page
2. Login with super admin credentials:
   - Email: `admin@who.int`
   - Password: `check the telegram group`
3. Verify access to Admin Panel
4. Test creating a new admin user

## Troubleshooting

### Missing Configuration Files

**Error:** `No Firebase App '[DEFAULT]' has been created`

**Solution:** Ensure all 3 configuration files are placed in correct locations (see Step 1)

### Authentication Failed

**Error:** `Access denied. Admin privileges required.`

**Solution:** Contact project maintainer - your account may not have admin privileges in Firebase

## Role System

| Role | Access Level |
|------|--------------|
| `guest` | Default, limited features |
| `admin` | Full access, can login |
| `superAdmin` | Full access + admin management |
