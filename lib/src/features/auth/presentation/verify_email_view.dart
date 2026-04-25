import 'dart:async';

import 'package:fashai/src/core/constants/sizes.dart';
import 'package:fashai/src/core/routes/app_routes.dart';
import 'package:fashai/src/core/themes/app_colors.dart';
import 'package:fashai/src/features/auth/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class VerifyEmailPage extends ConsumerStatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  ConsumerState<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends ConsumerState<VerifyEmailPage> {
  static const int _cooldownSeconds = 60;

  Timer? _timer;
  bool _busy = false;
  int _secondsRemaining = 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _reloadUser() async {
    await _run(() async {
      await ref.read(authServiceProvider).reloadUser();
      ref.invalidate(authStateProvider);
      if (mounted &&
          ref.read(authServiceProvider).currentUser?.emailVerified == true) {
        context.go(AppRoutes.home);
      }
    });
  }

  Future<void> _resendEmail() async {
    if (_secondsRemaining > 0) {
      return;
    }
    await _run(() async {
      await ref.read(authServiceProvider).sendEmailVerification();
      _startCooldown();
    }, success: 'Verification email sent.');
  }

  Future<void> _signOut() async {
    await ref.read(authServiceProvider).signOut();
    if (mounted) {
      context.go(AppRoutes.login);
    }
  }

  Future<void> _run(Future<void> Function() action, {String? success}) async {
    setState(() => _busy = true);
    try {
      await action();
      if (success != null && mounted) {
        _showSnack(success);
      }
    } catch (error) {
      if (mounted) {
        _showSnack(ref.read(authServiceProvider).messageForError(error));
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  void _startCooldown() {
    _timer?.cancel();
    setState(() => _secondsRemaining = _cooldownSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 1) {
        timer.cancel();
        setState(() => _secondsRemaining = 0);
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).value;
    final email = user?.email ?? 'your email';

    return Scaffold(
      backgroundColor: AppColors.beige,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Icon(
                Icons.mark_email_unread_outlined,
                color: AppColors.coral,
                size: 72,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              const Text(
                'Verify your email',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.charcoal,
                  fontFamily: 'PT_Serif',
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: TSizes.md),
              Text(
                'We sent a verification link to $email. Open the link, then return here and confirm.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.warmGray,
                  fontSize: TSizes.fontSizeSM,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _busy ? null : _reloadUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.coral,
                    foregroundColor: AppColors.white,
                  ),
                  child: Text(_busy ? 'Checking...' : "I've verified my email"),
                ),
              ),
              const SizedBox(height: TSizes.md),
              OutlinedButton(
                onPressed: _busy || _secondsRemaining > 0 ? null : _resendEmail,
                child: Text(
                  _secondsRemaining > 0
                      ? 'Resend in $_secondsRemaining seconds'
                      : 'Resend email',
                ),
              ),
              TextButton(
                onPressed: _busy ? null : _signOut,
                child: const Text('Sign out'),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
