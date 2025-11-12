// Browse all available book listings

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/book_model.dart';
import '../providers/listings_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/book_card.dart';
import '../widgets/loading_spinner.dart';
import 'book_detail_screen.dart';
import 'post_book_screen.dart';
import 'chat_screen.dart';

class BrowseListingsScreen extends ConsumerStatefulWidget {
  const BrowseListingsScreen({super.key});

  @override
  ConsumerState<BrowseListingsScreen> createState() => _BrowseListingsScreenState();
}

class _BrowseListingsScreenState extends ConsumerState<BrowseListingsScreen> {
  Future<void> _startChat(Book book) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    try {
      final firestoreService = ref.read(firestoreServiceProvider);

      // Get current user profile
      final userProfile = await firestoreService.getUserProfile(user.uid);

      // Create or get chat
      final chatId = await firestoreService.createOrGetChat(
        userId1: user.uid,
        userId2: book.ownerId,
        userName1: userProfile?.displayName ?? user.email?.split('@')[0] ?? 'Unknown',
        userName2: book.ownerName,
        bookId: book.id,
        bookTitle: book.title,
      );

      if (mounted) {
        // Navigate to chat
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              chatId: chatId,
              recipientName: book.ownerName,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final listingsAsync = ref.watch(allListingsProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Listings'),
        centerTitle: true,
      ),
      body: listingsAsync.when(
        data: (listings) {
          if (listings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.library_books_outlined,
                    size: 80,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No listings yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Be the first to post a book!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(allListingsProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: listings.length,
              itemBuilder: (context, index) {
                final book = listings[index];
                final isNotOwner = currentUser != null && book.ownerId != currentUser.uid;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: BookCard(
                    book: book,
                    showChatButton: isNotOwner,
                    onChatTap: isNotOwner ? () => _startChat(book) : null,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BookDetailScreen(bookId: book.id),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
        loading: () => const LoadingSpinner(),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error loading listings',
                style: TextStyle(color: Colors.grey[400]),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const PostBookScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFFFDB839),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}