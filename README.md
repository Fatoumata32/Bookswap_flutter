# BookSwap - Book Exchange Application

Flutter application allowing students to exchange textbooks with each other.

## FIRESTORE ISSUES? READ THIS!

### Error: "Error loading chats" or "Error loading your listings"

**THIS IS NORMAL!** Firestore requires indexes to function properly.

### Solution in 3 steps (2 minutes)

1. **Launch the application**
   ```bash
   flutter run
   ```

2. **Go to Settings > "Firestore Debug"**

3. **Click on "Run Firestore Tests"**
   - The logs will display Firebase links
   - Click on these links to automatically create the indexes
   - Wait 2-3 minutes for the indexes to be created
   - Restart the application

**That's it!** The application will work perfectly after.

## Quick Installation

```bash
# 1. Install dependencies
flutter pub get

# 2. Run on Android (recommended for Firebase)
flutter run

# 3. Create an account in the app
# 4. Use "Firestore Debug" to configure indexes
```

## Features

- Secure authentication
- Browse available books
- Post books for exchange
- Real-time chat
- Exchange offer system
- Profile management
- Built-in Firestore debug tool

## Firebase Configuration (if needed)

### Option 1: Via Firebase CLI
```bash
firebase login
firebase deploy --only firestore:indexes,firestore:rules
```

### Option 2: Use the debug screen
Settings > Firestore Debug > Run Tests > Click on the links

## Structure

- `lib/screens/` - App screens
- `lib/models/` - Data models
- `lib/services/` - Firebase services
- `lib/providers/` - Global state (Riverpod)
- `lib/widgets/` - Reusable components

## Debug

If the app doesn't work:
1. Check that Firebase is configured
2. Use "Firestore Debug" in Settings
3. Check the logs to see exact errors
4. Click on the Firestore index links

## More Info

See `FIREBASE_SETUP.md` for more details on Firebase configuration.
