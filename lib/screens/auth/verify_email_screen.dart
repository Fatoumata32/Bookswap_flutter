// Email verification screen

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/custom_button.dart';
import '../../providers/auth_provider.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  Timer? _timer;
  bool _isCheckingVerification = false;

  @override
  void initState() {
    super.initState();
    _startVerificationCheck();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startVerificationCheck() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      await ref.read(authServiceProvider).reloadUser();
      final user = ref.read(authServiceProvider).currentUser;
      
      if (user?.emailVerified ?? false) {
        timer.cancel();
        // User will be automatically redirected by AuthWrapper
      }
    });
  }

  Future<void> _resendVerificationEmail() async {
    setState(() => _isCheckingVerification = true);
    
    try {
      await ref.read(authServiceProvider).sendEmailVerification();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification email sent!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isCheckingVerification = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authServiceProvider).currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authServiceProvider).signOut(),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.email_outlined,
                size: 100,
                color: Color(0xFFFDB839),
              ),
              const SizedBox(height: 32),
              
              const Text(
                'Verify Your Email',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              
              Text(
                'We sent a verification email to:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              
              Text(
                user?.email ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFDB839),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              
              Text(
                'Please check your inbox and click the verification link.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[400],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              
              CustomButton(
                text: 'Resend Verification Email',
                onPressed: _resendVerificationEmail,
                isLoading: _isCheckingVerification,
                isOutlined: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}