import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:fashai/src/core/config/auth_bootstrap.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthUnavailableException implements Exception {
  const AuthUnavailableException(this.message);

  final String message;

  @override
  String toString() => message;
}

class AuthService {
  FirebaseAuth get _auth {
    _assertReady();
    return FirebaseAuth.instance;
  }

  Stream<User?> get authStateChanges {
    if (!AuthBootstrap.firebaseReady) {
      return Stream<User?>.value(null);
    }
    return FirebaseAuth.instance.authStateChanges();
  }

  User? get currentUser {
    if (!AuthBootstrap.firebaseReady) {
      return null;
    }
    return FirebaseAuth.instance.currentUser;
  }

  Future<UserCredential> signUpWithEmail(
    String email,
    String password, {
    String? displayName,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    if (displayName != null && displayName.trim().isNotEmpty) {
      await credential.user?.updateDisplayName(displayName.trim());
    }
    await credential.user?.sendEmailVerification();
    return credential;
  }

  Future<UserCredential> signInWithEmail(String email, String password) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential?> signInWithGoogle() async {
    if (kIsWeb) {
      return _auth.signInWithPopup(GoogleAuthProvider());
    }

    final signIn = GoogleSignIn.instance;
    await signIn.initialize();
    final account = await signIn.authenticate();
    final auth = account.authentication;
    final credential = GoogleAuthProvider.credential(idToken: auth.idToken);
    return _auth.signInWithCredential(credential);
  }

  Future<UserCredential?> signInWithApple() async {
    if (kIsWeb) {
      return _auth.signInWithPopup(OAuthProvider('apple.com'));
    }

    if (defaultTargetPlatform != TargetPlatform.iOS &&
        defaultTargetPlatform != TargetPlatform.macOS) {
      throw const AuthUnavailableException(
        'Apple sign-in is only available on Apple platforms.',
      );
    }

    final rawNonce = _generateNonce();
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: _sha256(rawNonce),
    );
    final oauthCredential = OAuthProvider(
      'apple.com',
    ).credential(idToken: credential.identityToken, rawNonce: rawNonce);
    return _auth.signInWithCredential(oauthCredential);
  }

  Future<UserCredential?> signInWithX() async {
    if (kIsWeb) {
      return _auth.signInWithPopup(TwitterAuthProvider());
    }
    throw const AuthUnavailableException(
      'X sign-in is currently wired for web only. Android needs a compatible native X OAuth plugin or custom redirect flow.',
    );
  }

  Future<void> sendEmailVerification() async {
    await _auth.currentUser?.sendEmailVerification();
  }

  Future<void> reloadUser() async {
    await _auth.currentUser?.reload();
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> signOut() async {
    if (!AuthBootstrap.firebaseReady) {
      return;
    }
    await Future.wait([
      FirebaseAuth.instance.signOut(),
      GoogleSignIn.instance.signOut().catchError((_) {}),
    ]);
  }

  String messageForError(Object error) {
    if (error is AuthUnavailableException) {
      return error.message;
    }
    if (error is FirebaseAuthException) {
      return switch (error.code) {
        'invalid-email' => 'Enter a valid email address.',
        'user-disabled' => 'This account has been disabled.',
        'user-not-found' => 'No account exists for this email.',
        'wrong-password' => 'The password is incorrect.',
        'email-already-in-use' => 'This email is already registered.',
        'weak-password' => 'Choose a stronger password.',
        'operation-not-allowed' =>
          'This sign-in method is not enabled in Firebase.',
        'popup-closed-by-user' => 'Sign-in was cancelled.',
        'network-request-failed' => 'Check your internet connection.',
        _ => error.message ?? 'Authentication failed.',
      };
    }
    return 'Authentication failed. $error';
  }

  void _assertReady() {
    if (AuthBootstrap.firebaseReady) {
      return;
    }
    final initError = AuthBootstrap.firebaseError;
    if (initError != null) {
      throw AuthUnavailableException('Firebase did not initialize: $initError');
    }
    throw const AuthUnavailableException(
      'Firebase is not configured yet. Add Firebase credentials and enable AuthConfig.firebaseEnabled.',
    );
  }

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  String _sha256(String input) {
    return sha256.convert(utf8.encode(input)).toString();
  }
}
