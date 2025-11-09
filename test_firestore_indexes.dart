// Quick script to test Firestore indexes
// Run with: dart run test_firestore_indexes.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  print('🔍 Testing Firestore Indexes...\n');

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✓ Firebase initialized\n');

    final firestore = FirebaseFirestore.instance;

    // Test 1: Books index (ownerId + createdAt)
    print('📚 Testing books index (ownerId + createdAt)...');
    try {
      await firestore
          .collection('books')
          .where('ownerId', isEqualTo: 'test_user')
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get()
          .timeout(Duration(seconds: 10));
      print('✓ Books index: WORKING\n');
    } catch (e) {
      print('✗ Books index: FAILED');
      print('  Error: $e\n');
    }

    // Test 2: Chats index (participantIds + lastMessageTime)
    print('💬 Testing chats index (participantIds + lastMessageTime)...');
    try {
      await firestore
          .collection('chats')
          .where('participantIds', arrayContains: 'test_user')
          .orderBy('lastMessageTime', descending: true)
          .limit(1)
          .get()
          .timeout(Duration(seconds: 10));
      print('✓ Chats index: WORKING\n');
    } catch (e) {
      print('✗ Chats index: FAILED');
      print('  Error: $e\n');
    }

    // Test 3: SwapOffers index (participantIds + createdAt)
    print('🔄 Testing swapOffers index (participantIds + createdAt)...');
    try {
      await firestore
          .collection('swapOffers')
          .where('participantIds', arrayContains: 'test_user')
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get()
          .timeout(Duration(seconds: 10));
      print('✓ SwapOffers index: WORKING\n');
    } catch (e) {
      print('✗ SwapOffers index: FAILED');
      print('  Error: $e\n');
    }

    print('✅ All tests completed!');
    print('\nIf any index failed, you need to create it in Firebase Console.');
    print('The error message should contain a link to create the index automatically.');

  } catch (e) {
    print('❌ Fatal error: $e');
  }
}
