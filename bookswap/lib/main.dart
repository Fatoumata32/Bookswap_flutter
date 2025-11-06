// Main entry point for BookSwap app
// Sets up Firebase, Riverpod, and Material 3 theme

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/auth/sign_in_screen.dart';
import 'screens/auth/verify_email_screen.dart';
import 'screens/browse_listings_screen.dart';
import 'screens/my_listings_screen.dart';
import 'screens/chat_list_screen.dart';
import 'screens/settings_screen.dart';
import 'providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: BookSwapApp()));
}

class BookSwapApp extends StatelessWidget {
  const BookSwapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookSwap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFFFDB839), // Yellow accent
          secondary: const Color(0xFFFDB839),
          background: const Color(0xFF1A1F3A), // Dark navy
          surface: const Color(0xFF242B47),
          onPrimary: Colors.black,
          onSecondary: Colors.black,
        ),
        scaffoldBackgroundColor: const Color(0xFF1A1F3A),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF242B47),
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF242B47),
          selectedItemColor: Color(0xFFFDB839),
          unselectedItemColor: Colors.grey,
        ),
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return const SignInScreen();
        }
        if (!user.emailVerified) {
          return const VerifyEmailScreen();
        }
        return const MainNavigationScreen();
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const BrowseListingsScreen(),
    const MyListingsScreen(),
    const ChatListScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'My Listings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}