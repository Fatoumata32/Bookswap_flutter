// Browse all available book listings

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/listings_provider.dart';
import '../widgets/book_card.dart';
import '../widgets/loading_spinner.dart';
import 'book_detail_screen.dart';
import 'post_book_screen.dart';

class BrowseListingsScreen extends ConsumerWidget {
  const BrowseListingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listingsAsync = ref.watch(allListingsProvider);

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
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: BookCard(
                    book: book,
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