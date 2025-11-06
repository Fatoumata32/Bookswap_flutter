// Riverpod providers for authentication state management

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';

// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// Firestore service provider
final firestoreServiceProvider = Provider<FirestoreService>((ref) => FirestoreService());

// Auth state stream provider
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

// Current user provider
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authServiceProvider).currentUser;
});

// User profile provider
final userProfileProvider = StreamProvider.family<UserModel?, String>((ref, userId) {
  return ref.watch(firestoreServiceProvider).getUserProfile(userId).asStream();
});