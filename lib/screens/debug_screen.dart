// Debug screen to test Firestore connection
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/auth_provider.dart';
import '../services/seed_data_service.dart';

class DebugScreen extends ConsumerStatefulWidget {
  const DebugScreen({super.key});

  @override
  ConsumerState<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends ConsumerState<DebugScreen> {
  String _testResult = '';
  bool _testing = false;
  final _seedDataService = SeedDataService();

  Future<void> _testFirestoreConnection() async {
    setState(() {
      _testing = true;
      _testResult = 'Testing Firestore connection...\n\n';
    });

    try {
      // Test 1: Check auth
      final user = FirebaseAuth.instance.currentUser;
      setState(() {
        _testResult += '✓ User authenticated: ${user?.email ?? "Not authenticated"}\n';
        _testResult += '  User ID: ${user?.uid}\n\n';
      });

      if (user == null) {
        setState(() {
          _testResult += '✗ ERROR: User not authenticated!\n';
          _testResult += '  Please sign in first.\n';
          _testing = false;
        });
        return;
      }

      // Test 2: Check Firestore connection
      setState(() {
        _testResult += 'Testing Firestore read...\n';
      });

      final firestore = FirebaseFirestore.instance;

      // Try to read books collection
      try {
        final booksSnapshot = await firestore
            .collection('books')
            .limit(1)
            .get()
            .timeout(const Duration(seconds: 10));

        setState(() {
          _testResult += '✓ Books collection accessible\n';
          _testResult += '  Found ${booksSnapshot.docs.length} document(s)\n\n';
        });
      } catch (e) {
        setState(() {
          _testResult += '✗ ERROR reading books collection:\n';
          _testResult += '  ${e.toString()}\n\n';
        });
      }

      // Try to read user's books
      try {
        setState(() {
          _testResult += 'Testing user books query...\n';
        });

        final userBooksSnapshot = await firestore
            .collection('books')
            .where('ownerId', isEqualTo: user.uid)
            .limit(1)
            .get()
            .timeout(const Duration(seconds: 10));

        setState(() {
          _testResult += '✓ User books query successful\n';
          _testResult += '  Found ${userBooksSnapshot.docs.length} book(s)\n\n';
        });
      } catch (e) {
        setState(() {
          _testResult += '✗ ERROR querying user books:\n';
          _testResult += '  ${e.toString()}\n';
          if (e.toString().contains('index')) {
            _testResult += '\n  ⚠ This looks like an index error!\n';
            _testResult += '  Check Firebase Console for index creation link.\n';
          }
          _testResult += '\n';
        });
      }

      // Try to read chats
      try {
        setState(() {
          _testResult += 'Testing chats query...\n';
        });

        final chatsSnapshot = await firestore
            .collection('chats')
            .where('participantIds', arrayContains: user.uid)
            .limit(1)
            .get()
            .timeout(const Duration(seconds: 10));

        setState(() {
          _testResult += '✓ Chats query successful\n';
          _testResult += '  Found ${chatsSnapshot.docs.length} chat(s)\n\n';
        });
      } catch (e) {
        setState(() {
          _testResult += '✗ ERROR querying chats:\n';
          _testResult += '  ${e.toString()}\n';
          if (e.toString().contains('index')) {
            _testResult += '\n  ⚠ This looks like an index error!\n';
            _testResult += '  Check Firebase Console for index creation link.\n';
          }
          _testResult += '\n';
        });
      }

      // Test write permissions
      try {
        setState(() {
          _testResult += 'Testing write permissions...\n';
        });

        await firestore.collection('test').doc('test').set({
          'test': true,
          'timestamp': FieldValue.serverTimestamp(),
        });

        await firestore.collection('test').doc('test').delete();

        setState(() {
          _testResult += '✓ Write permissions OK\n\n';
        });
      } catch (e) {
        setState(() {
          _testResult += '✗ ERROR testing write:\n';
          _testResult += '  ${e.toString()}\n\n';
        });
      }

    } catch (e) {
      setState(() {
        _testResult += '\n✗ UNEXPECTED ERROR:\n${e.toString()}\n';
      });
    }

    setState(() {
      _testing = false;
    });
  }

  Future<void> _createSampleData() async {
    setState(() {
      _testing = true;
      _testResult = 'Creating sample data...\n\n';
    });

    try {
      await _seedDataService.createAllSampleData();
      setState(() {
        _testResult += '✓ Created 3 sample books\n';
        _testResult += '✓ Created 2 sample chats with messages\n';
        _testResult += '✓ Created 2 demo users\n\n';
        _testResult += 'Go to Home to see books!\n';
        _testResult += 'Go to Chats to see conversations!\n';
      });
    } catch (e) {
      setState(() {
        _testResult += '✗ ERROR: ${e.toString()}\n';
      });
    }

    setState(() {
      _testing = false;
    });
  }

  Future<void> _clearData() async {
    setState(() {
      _testing = true;
      _testResult = 'Clearing user data...\n\n';
    });

    try {
      await _seedDataService.clearUserData();
      setState(() {
        _testResult += '✓ All your data has been cleared\n';
        _testResult += '  (Books, chats, messages)\n\n';
        _testResult += 'You can now create fresh sample data!\n';
      });
    } catch (e) {
      setState(() {
        _testResult += '✗ ERROR: ${e.toString()}\n';
      });
    }

    setState(() {
      _testing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore Debug'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current User:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('Email: ${user?.email ?? "Not signed in"}'),
                    Text('UID: ${user?.uid ?? "N/A"}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _testing ? null : _testFirestoreConnection,
              icon: _testing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.play_arrow),
              label: Text(_testing ? 'Testing...' : 'Run Firestore Tests'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: const Color(0xFFFDB839),
                foregroundColor: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _testing ? null : _createSampleData,
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('Create Sample Data'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(14),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _testing ? null : () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Clear All Data?'),
                          content: const Text(
                            'This will delete all your books, chats, and messages. This action cannot be undone.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        _clearData();
                      }
                    },
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Clear Data'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(14),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Sample data: 3 books, 2 chats with conversations',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _testResult.isEmpty ? 'Press button to test Firestore' : _testResult,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
