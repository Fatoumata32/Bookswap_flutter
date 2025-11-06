// Riverpod providers for chat state management

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_model.dart';
import '../services/firestore_service.dart';
import 'auth_provider.dart';

// User's chats stream provider
final userChatsProvider = StreamProvider<List<Chat>>((ref) {
  final userId = ref.watch(currentUserProvider)?.uid;
  if (userId == null) return Stream.value([]);
  return ref.watch(firestoreServiceProvider).getUserChats(userId);
});

// Messages for a specific chat
final chatMessagesProvider = StreamProvider.family<List<Message>, String>((ref, chatId) {
  return ref.watch(firestoreServiceProvider).getChatMessages(chatId);
});