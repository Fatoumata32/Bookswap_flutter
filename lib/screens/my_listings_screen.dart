// Screen showing user's own book listings

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/listings_provider.dart';
import '../widgets/book_card.dart';
import '../widgets/loading_spinner.dart';
import 'book_detail_screen.dart';
import 'post_book_screen.dart';

class MyListingsScreen extends ConsumerWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listingsAsync = ref.watch(userListingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Listings'),
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
                    Icons.book_outlined,
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
                    'Post your first book to get started',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const PostBookScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add, color: Colors.black),
                    label: const Text(
                      'Post a Book',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFDB839),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // Separate listings by status
          final availableListings = listings
              .where((book) => book.status == 'available')
              .toList();
          final pendingListings = listings
              .where((book) => book.status == 'pending')
              .toList();

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(userListingsProvider);
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (availableListings.isNotEmpty) ...[
                  Text(
                    'Available (${availableListings.length})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...availableListings.map((book) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: BookCard(
                          book: book,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    BookDetailScreen(bookId: book.id),
                              ),
                            );
                          },
                        ),
                      )),
                ],
                if (pendingListings.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Pending Swaps (${pendingListings.length})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...pendingListings.map((book) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: BookCard(
                          book: book,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    BookDetailScreen(bookId: book.id),
                              ),
                            );
                          },
                        ),
                      )),
                ],
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
                'Error loading your listings',
                style: TextStyle(color: Colors.grey[400]),
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