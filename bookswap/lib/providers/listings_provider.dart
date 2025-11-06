// Riverpod providers for book listings state management

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/book_model.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';
import 'auth_provider.dart';

// Storage service provider
final storageServiceProvider = Provider<StorageService>((ref) => StorageService());

// All listings stream provider
final allListingsProvider = StreamProvider<List<Book>>((ref) {
  return ref.watch(firestoreServiceProvider).getAllListings();
});

// User's own listings stream provider
final userListingsProvider = StreamProvider<List<Book>>((ref) {
  final userId = ref.watch(currentUserProvider)?.uid;
  if (userId == null) return Stream.value([]);
  return ref.watch(firestoreServiceProvider).getUserListings(userId);
});

// Single book provider
final bookProvider = FutureProvider.family<Book?, String>((ref, bookId) {
  return ref.watch(firestoreServiceProvider).getBookById(bookId);
});