// Firestore service for database operations
// Handles CRUD operations for books, users, chats, and swap offers

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book_model.dart';
import '../models/user_model.dart';
import '../models/chat_model.dart';
import '../models/swap_offer_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ============ BOOK OPERATIONS ============

  // Get all available listings
  Stream<List<Book>> getAllListings() {
    return _firestore
        .collection('books')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Book.fromJson(doc.data(), doc.id))
            .toList());
  }

  // Get user's own listings
  Stream<List<Book>> getUserListings(String userId) {
    return _firestore
        .collection('books')
        .where('ownerId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Book.fromJson(doc.data(), doc.id))
            .toList());
  }

  // Get single book by ID
  Future<Book?> getBookById(String bookId) async {
    final doc = await _firestore.collection('books').doc(bookId).get();
    if (doc.exists) {
      return Book.fromJson(doc.data()!, doc.id);
    }
    return null;
  }

  // Create a new book listing
  Future<String> createBook(Book book) async {
    final docRef = await _firestore.collection('books').add(book.toJson());
    return docRef.id;
  }

  // Update a book listing
  Future<void> updateBook(String bookId, Map<String, dynamic> updates) async {
    await _firestore.collection('books').doc(bookId).update(updates);
  }

  // Delete a book listing
  Future<void> deleteBook(String bookId) async {
    await _firestore.collection('books').doc(bookId).delete();
  }

  // ============ USER OPERATIONS ============

  // Get user profile
  Future<UserModel?> getUserProfile(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      return UserModel.fromJson(doc.data()!, doc.id);
    }
    return null;
  }

  // Update user profile
  Future<void> updateUserProfile(String userId, Map<String, dynamic> updates) async {
    await _firestore.collection('users').doc(userId).update(updates);
  }

  // ============ SWAP OFFER OPERATIONS ============

  // Create swap offer
  Future<String> createSwapOffer(SwapOffer offer) async {
    final docRef = await _firestore.collection('swapOffers').add(offer.toJson());
    
    // Update book status to pending
    await updateBook(offer.bookId, {'status': 'pending'});
    
    return docRef.id;
  }

  // Get swap offers for a user (sent or received)
  Stream<List<SwapOffer>> getUserSwapOffers(String userId) {
    return _firestore
        .collection('swapOffers')
        .where('participantIds', arrayContains: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SwapOffer.fromJson(doc.data(), doc.id))
            .toList());
  }

  // Update swap offer status
  Future<void> updateSwapOfferStatus(String offerId, String status) async {
    await _firestore.collection('swapOffers').doc(offerId).update({
      'status': status,
    });
  }

  // ============ CHAT OPERATIONS ============

  // Create or get existing chat
  Future<String> createOrGetChat({
    required String userId1,
    required String userId2,
    required String userName1,
    required String userName2,
    String? bookId,
    String? bookTitle,
  }) async {
    // Check if chat already exists
    final existingChats = await _firestore
        .collection('chats')
        .where('participantIds', arrayContains: userId1)
        .get();

    for (var doc in existingChats.docs) {
      final data = doc.data();
      final participants = List<String>.from(data['participantIds']);
      if (participants.contains(userId2)) {
        return doc.id;
      }
    }

    // Create new chat
    final chatData = {
      'participantIds': [userId1, userId2],
      'participantNames': {
        userId1: userName1,
        userId2: userName2,
      },
      'bookId': bookId,
      'bookTitle': bookTitle,
      'lastMessage': '',
      'lastMessageTime': FieldValue.serverTimestamp(),
    };

    final docRef = await _firestore.collection('chats').add(chatData);
    return docRef.id;
  }

  // Get user's chats
  Stream<List<Chat>> getUserChats(String userId) {
    return _firestore
        .collection('chats')
        .where('participantIds', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Chat.fromJson(doc.data(), doc.id))
            .toList());
  }

  // Send message
  Future<void> sendMessage(String chatId, String senderId, String text) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'senderId': senderId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Update last message in chat
    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': text,
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
  }

  // Get messages for a chat
  Stream<List<Message>> getChatMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Message.fromJson(doc.data(), doc.id))
            .toList());
  }
}