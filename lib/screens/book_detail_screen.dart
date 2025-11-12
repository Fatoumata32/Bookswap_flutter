// Detailed view of a book listing with swap functionality

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/book_model.dart';
import '../models/swap_offer_model.dart';
import '../providers/listings_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/loading_spinner.dart';
import 'post_book_screen.dart';
import 'chat_screen.dart';

class BookDetailScreen extends ConsumerStatefulWidget {
  final String bookId;

  const BookDetailScreen({super.key, required this.bookId});

  @override
  ConsumerState<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends ConsumerState<BookDetailScreen> {
  bool _isInitiatingSwap = false;
  bool _isStartingChat = false;

  Future<void> _startChat(Book book) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    setState(() => _isStartingChat = true);

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
    } finally {
      if (mounted) setState(() => _isStartingChat = false);
    }
  }

  Future<void> _initiateSwap(Book book) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    setState(() => _isInitiatingSwap = true);

    try {
      final firestoreService = ref.read(firestoreServiceProvider);
      
      // Get current user profile
      final userProfile = await firestoreService.getUserProfile(user.uid);
      
      // Create swap offer
      final swapOffer = SwapOffer(
        id: '',
        bookId: book.id,
        bookTitle: book.title,
        senderId: user.uid,
        senderName: userProfile?.displayName ?? 'Unknown',
        recipientId: book.ownerId,
        recipientName: book.ownerName,
        createdAt: DateTime.now(),
      );

      await firestoreService.createSwapOffer(swapOffer);

      // Create or get chat
      final chatId = await firestoreService.createOrGetChat(
        userId1: user.uid,
        userId2: book.ownerId,
        userName1: userProfile?.displayName ?? 'Unknown',
        userName2: book.ownerName,
        bookId: book.id,
        bookTitle: book.title,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Swap request sent!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to chat
        Navigator.of(context).pushReplacement(
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
    } finally {
      if (mounted) setState(() => _isInitiatingSwap = false);
    }
  }

  Future<void> _deleteBook(Book book) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF242B47),
        title: const Text('Delete Book', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to delete this listing?',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final firestoreService = ref.read(firestoreServiceProvider);
        final storageService = ref.read(storageServiceProvider);

        // Delete image from storage
        if (book.imageUrl.isNotEmpty) {
          await storageService.deleteImage(book.imageUrl);
        }

        // Delete book from Firestore
        await firestoreService.deleteBook(book.id);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Book deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting book: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookAsync = ref.watch(bookProvider(widget.bookId));
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
        centerTitle: true,
        actions: bookAsync.when(
          data: (book) {
            if (book != null && book.ownerId == user?.uid) {
              return [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PostBookScreen(book: book),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteBook(book),
                ),
              ];
            }
            return [];
          },
          loading: () => [],
          error: (_, __) => [],
        ),
      ),
      body: bookAsync.when(
        data: (book) {
          if (book == null) {
            return const Center(
              child: Text(
                'Book not found',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          final isOwner = book.ownerId == user?.uid;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Book cover image
                CachedNetworkImage(
                  imageUrl: book.imageUrl,
                  height: 300,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 300,
                    color: Colors.grey[800],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 300,
                    color: Colors.grey[800],
                    child: const Icon(Icons.book, size: 80),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        book.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Author
                      Text(
                        'By ${book.author}',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Condition
                      _buildInfoRow('Condition', book.condition),
                      const SizedBox(height: 16),

                      // Swap For
                      _buildInfoRow('Swap For', book.swapFor),
                      const SizedBox(height: 16),

                      // Owner
                      _buildInfoRow('Owner', book.ownerName),
                      const SizedBox(height: 16),

                      // Status
                      _buildInfoRow(
                        'Status',
                        book.status == 'available' ? 'Available' : 'Pending Swap',
                      ),
                      const SizedBox(height: 32),

                      // Action buttons
                      if (!isOwner && book.status == 'available') ...[
                        CustomButton(
                          text: _isInitiatingSwap ? 'Initiating...' : 'I\'m Interested!',
                          onPressed: () => _initiateSwap(book),
                          isLoading: _isInitiatingSwap,
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: _isStartingChat ? null : () => _startChat(book),
                          icon: _isStartingChat
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFFFDB839),
                                  ),
                                )
                              : const Icon(
                                  Icons.chat_bubble_outline,
                                  color: Color(0xFFFDB839),
                                ),
                          label: Text(
                            _isStartingChat ? 'Starting...' : 'Chat with Owner',
                            style: const TextStyle(
                              color: Color(0xFFFDB839),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(
                              color: Color(0xFFFDB839),
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],

                      if (!isOwner && book.status == 'pending')
                        OutlinedButton.icon(
                          onPressed: _isStartingChat ? null : () => _startChat(book),
                          icon: _isStartingChat
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFFFDB839),
                                  ),
                                )
                              : const Icon(
                                  Icons.chat_bubble_outline,
                                  color: Color(0xFFFDB839),
                                ),
                          label: Text(
                            _isStartingChat ? 'Starting...' : 'Chat with Owner',
                            style: const TextStyle(
                              color: Color(0xFFFDB839),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(
                              color: Color(0xFFFDB839),
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                      if (book.status == 'pending')
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.schedule, color: Colors.orange),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  isOwner
                                      ? 'Someone has expressed interest in this book'
                                      : 'Your swap request is pending',
                                  style: const TextStyle(color: Colors.orange),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
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
                'Error loading book details',
                style: TextStyle(color: Colors.grey[400]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}