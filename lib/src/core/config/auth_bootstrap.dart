import 'package:fashai/src/core/config/auth_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class AuthBootstrap {
  const AuthBootstrap._();

  static bool _firebaseReady = false;
  static Object? _firebaseError;

  static bool get firebaseReady => _firebaseReady;
  static Object? get firebaseError => _firebaseError;

  static Future<void> initialize() async {
    if (!AuthConfig.firebaseEnabled) {
      return;
    }

    try {
      final options = AuthConfig.firebaseOptions;
      if (options != null) {
        await Firebase.initializeApp(options: options);
      } else {
        await Firebase.initializeApp();
      }
      _firebaseReady = true;
    } catch (error, stackTrace) {
      _firebaseError = error;
      debugPrint('Firebase initialization failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}
