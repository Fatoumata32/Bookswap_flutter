// Service to populate Firestore with sample data for testing
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SeedDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create sample books
  Future<void> createSampleBooks() async {
    final user = _auth.currentUser;
    if (user == null) throw 'User must be authenticated';

    final books = [
      {
        'title': 'Introduction to Algorithms',
        'author': 'Thomas H. Cormen',
        'condition': 'Good',
        'swapFor': 'Any programming book',
        'imageUrl': 'https://via.placeholder.com/300x400.png?text=Algorithms',
        'ownerId': user.uid,
        'ownerName': user.displayName ?? user.email?.split('@')[0] ?? 'User',
        'status': 'available',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'title': 'Clean Code',
        'author': 'Robert C. Martin',
        'condition': 'Like New',
        'swapFor': 'Design patterns book',
        'imageUrl': 'https://via.placeholder.com/300x400.png?text=Clean+Code',
        'ownerId': user.uid,
        'ownerName': user.displayName ?? user.email?.split('@')[0] ?? 'User',
        'status': 'available',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'title': 'The Pragmatic Programmer',
        'author': 'Andrew Hunt',
        'condition': 'Good',
        'swapFor': 'Web development book',
        'imageUrl': 'https://via.placeholder.com/300x400.png?text=Pragmatic',
        'ownerId': user.uid,
        'ownerName': user.displayName ?? user.email?.split('@')[0] ?? 'User',
        'status': 'available',
        'createdAt': FieldValue.serverTimestamp(),
      },
    ];

    final batch = _firestore.batch();
    for (final book in books) {
      final docRef = _firestore.collection('books').doc();
      batch.set(docRef, book);
    }
    await batch.commit();
  }

  // Create a sample user for testing (demo user)
  Future<String> createDemoUser() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw 'User must be authenticated';

    // Create a demo user document
    final demoUserId = 'demo_user_${DateTime.now().millisecondsSinceEpoch}';
    await _firestore.collection('users').doc(demoUserId).set({
      'email': 'demo@bookswap.com',
      'displayName': 'Demo User',
      'createdAt': FieldValue.serverTimestamp(),
      'notificationsEnabled': true,
      'emailUpdatesEnabled': true,
    });

    return demoUserId;
  }

  // Create a sample chat with messages
  Future<void> createSampleChat() async {
    final user = _auth.currentUser;
    if (user == null) throw 'User must be authenticated';

    // Create demo user
    final demoUserId = await createDemoUser();
    final demoUserName = 'Demo User';
    final currentUserName = user.displayName ?? user.email?.split('@')[0] ?? 'You';

    // Create a sample book for the chat context
    final bookDoc = await _firestore.collection('books').add({
      'title': 'Data Structures & Algorithms',
      'author': 'Michael T. Goodrich',
      'condition': 'Good',
      'swapFor': 'Any CS book',
      'imageUrl': 'https://via.placeholder.com/300x400.png?text=Data+Structures',
      'ownerId': demoUserId,
      'ownerName': demoUserName,
      'status': 'available',
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Create chat
    final chatDoc = await _firestore.collection('chats').add({
      'participantIds': [user.uid, demoUserId],
      'participantNames': {
        user.uid: currentUserName,
        demoUserId: demoUserName,
      },
      'bookId': bookDoc.id,
      'bookTitle': 'Data Structures & Algorithms',
      'lastMessage': 'Great! When can we meet?',
      'lastMessageTime': FieldValue.serverTimestamp(),
    });

    // Add sample messages
    final messages = [
      {
        'senderId': user.uid,
        'text': 'Hi! I\'m interested in your Data Structures book.',
        'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 2))),
      },
      {
        'senderId': demoUserId,
        'text': 'Hello! Yes, it\'s still available. What book do you have for exchange?',
        'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 1, minutes: 55))),
      },
      {
        'senderId': user.uid,
        'text': 'I have Clean Code by Robert Martin. Are you interested?',
        'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 1, minutes: 45))),
      },
      {
        'senderId': demoUserId,
        'text': 'Yes! That sounds perfect. I\'ve been wanting to read that book.',
        'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 1, minutes: 30))),
      },
      {
        'senderId': user.uid,
        'text': 'Great! When can we meet for the exchange?',
        'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 1, minutes: 15))),
      },
      {
        'senderId': demoUserId,
        'text': 'How about tomorrow at 2 PM at the library?',
        'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 1))),
      },
      {
        'senderId': user.uid,
        'text': 'Perfect! See you there 👍',
        'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(minutes: 45))),
      },
    ];

    final batch = _firestore.batch();
    for (final message in messages) {
      final messageRef = chatDoc.collection('messages').doc();
      batch.set(messageRef, message);
    }
    await batch.commit();
  }

  // Create another sample chat
  Future<void> createAnotherSampleChat() async {
    final user = _auth.currentUser;
    if (user == null) throw 'User must be authenticated';

    // Create another demo user
    final demoUserId = 'demo_user_2_${DateTime.now().millisecondsSinceEpoch}';
    await _firestore.collection('users').doc(demoUserId).set({
      'email': 'alice@bookswap.com',
      'displayName': 'Alice Martin',
      'createdAt': FieldValue.serverTimestamp(),
      'notificationsEnabled': true,
      'emailUpdatesEnabled': true,
    });

    final demoUserName = 'Alice Martin';
    final currentUserName = user.displayName ?? user.email?.split('@')[0] ?? 'You';

    // Create a book
    final bookDoc = await _firestore.collection('books').add({
      'title': 'Introduction to Machine Learning',
      'author': 'Ethem Alpaydin',
      'condition': 'Like New',
      'swapFor': 'Python book',
      'imageUrl': 'https://via.placeholder.com/300x400.png?text=ML+Book',
      'ownerId': demoUserId,
      'ownerName': demoUserName,
      'status': 'available',
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Create chat
    final chatDoc = await _firestore.collection('chats').add({
      'participantIds': [user.uid, demoUserId],
      'participantNames': {
        user.uid: currentUserName,
        demoUserId: demoUserName,
      },
      'bookId': bookDoc.id,
      'bookTitle': 'Introduction to Machine Learning',
      'lastMessage': 'Thanks for the info!',
      'lastMessageTime': FieldValue.serverTimestamp(),
    });

    // Add messages
    final messages = [
      {
        'senderId': user.uid,
        'text': 'Hi Alice! Is your ML book still available?',
        'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 1))),
      },
      {
        'senderId': demoUserId,
        'text': 'Hi! Yes it is. What would you like to exchange it for?',
        'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 23))),
      },
      {
        'senderId': user.uid,
        'text': 'I have "Python Crash Course". Interested?',
        'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 22))),
      },
      {
        'senderId': demoUserId,
        'text': 'That would be great! Is it in good condition?',
        'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 21))),
      },
      {
        'senderId': user.uid,
        'text': 'Yes, barely used. Like new condition.',
        'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 20))),
      },
      {
        'senderId': demoUserId,
        'text': 'Perfect! Thanks for the info!',
        'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 19))),
      },
    ];

    final batch = _firestore.batch();
    for (final message in messages) {
      final messageRef = chatDoc.collection('messages').doc();
      batch.set(messageRef, message);
    }
    await batch.commit();
  }

  // Create all sample data
  Future<void> createAllSampleData() async {
    await createSampleBooks();
    await createSampleChat();
    await createAnotherSampleChat();
  }

  // Clear all user's data (for testing)
  Future<void> clearUserData() async {
    final user = _auth.currentUser;
    if (user == null) throw 'User must be authenticated';

    // Delete user's books
    final booksSnapshot = await _firestore
        .collection('books')
        .where('ownerId', isEqualTo: user.uid)
        .get();

    final batch = _firestore.batch();
    for (final doc in booksSnapshot.docs) {
      batch.delete(doc.reference);
    }

    // Delete user's chats
    final chatsSnapshot = await _firestore
        .collection('chats')
        .where('participantIds', arrayContains: user.uid)
        .get();

    for (final doc in chatsSnapshot.docs) {
      // Delete messages subcollection
      final messagesSnapshot = await doc.reference.collection('messages').get();
      for (final msgDoc in messagesSnapshot.docs) {
        batch.delete(msgDoc.reference);
      }
      batch.delete(doc.reference);
    }

    await batch.commit();
  }
}
