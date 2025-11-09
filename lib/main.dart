// Main entry point for BookSwap app
// Minimal test version without Firebase

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BookSwapApp());
}

class BookSwapApp extends StatelessWidget {
  const BookSwapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookSwap Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFFFDB839),
          secondary: const Color(0xFFFDB839),
          background: const Color(0xFF1A1F3A),
          surface: const Color(0xFF242B47),
          onPrimary: Colors.black,
          onSecondary: Colors.black,
        ),
        scaffoldBackgroundColor: const Color(0xFF1A1F3A),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('BookSwap - Test Mode'),
          backgroundColor: const Color(0xFF242B47),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.book,
                size: 100,
                color: Color(0xFFFDB839),
              ),
              const SizedBox(height: 24),
              const Text(
                'BookSwap App',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Test version - running on Android 16',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(horizontal: 32),
                decoration: BoxDecoration(
                  color: const Color(0xFF242B47),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'If you can see this screen, the app launches successfully!\n\nThe issue was with Firebase initialization on Android 16.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}