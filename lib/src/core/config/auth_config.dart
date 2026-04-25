import 'package:firebase_core/firebase_core.dart';
import 'package:fashai/firebase_options.dart';

class AuthConfig {
  const AuthConfig._();

  static const bool firebaseEnabled = true;

  static FirebaseOptions? get firebaseOptions =>
      DefaultFirebaseOptions.currentPlatform;

  static const String twitterRedirectUri = 'fashai://';
}
