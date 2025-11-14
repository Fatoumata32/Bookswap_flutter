# BookSwap - Book Exchange Application

Flutter application allowing students to exchange textbooks with each other.

Go to the branch master_fat

1. **Launch the application**
   ```bash
   flutter run
   ```

## Quick Installation

```bash
# 1. Install dependencies
flutter pub get

# 2. Run on Android (recommended for Firebase)
flutter run

# 3. Create an account in the app

```

## Features

- Secure authentication
- Browse available books
- Post books for exchange
- Real-time chat
- Exchange offer system
- Profile management
- Built-in Firestore debug tool

## Firebase Configuration

To set up Firebase for BookSwap, we first configured Firebase Authentication to allow users to sign in using both email and password authentication as well as Google Sign-In. This ensures secure and flexible user login options.

Next, we activated Firestore as our primary database to store and manage the application's data in real time. Firestore supports collections and documents, which we use to organize user profiles, book listings, chats, and swap offers efficiently.

We decided not to activate Firebase Storage because it would require additional costs, and for the current scope of the project, Firestore was sufficient to handle our data needs.

For deploying security rules and indexes related to Firestore, we use the Firebase CLI tool, which helps maintain proper access control and query performance.