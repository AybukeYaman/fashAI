import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatBootstrap {
  const RevenueCatBootstrap._();

  static const String _defaultApiKey = 'test_EbDlikRyIaDpMgRoGeXjEluNRtD';
  static const String _androidApiKey = String.fromEnvironment(
    'REVENUECAT_ANDROID_API_KEY',
    defaultValue: _defaultApiKey,
  );
  static const String _iosApiKey = String.fromEnvironment(
    'REVENUECAT_IOS_API_KEY',
    defaultValue: _defaultApiKey,
  );
  static const String _macosApiKey = String.fromEnvironment(
    'REVENUECAT_MACOS_API_KEY',
    defaultValue: _defaultApiKey,
  );
  static const String _webApiKey = String.fromEnvironment(
    'REVENUECAT_WEB_API_KEY',
    defaultValue: _defaultApiKey,
  );

  static bool _configured = false;
  static Object? _configurationError;
  static String? _currentAppUserId;

  static bool get configured => _configured;
  static Object? get configurationError => _configurationError;

  static Future<void> initialize() async {
    final apiKey = _apiKeyForCurrentPlatform;
    if (apiKey == null || apiKey.isEmpty) {
      debugPrint(
        'RevenueCat initialization skipped: no API key configured for '
        '$_currentPlatformName.',
      );
      return;
    }

    try {
      await Purchases.configure(PurchasesConfiguration(apiKey));
      _configured = true;
    } catch (error, stackTrace) {
      _configurationError = error;
      debugPrint('RevenueCat initialization failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  static Future<void> syncAppUserId(String? uid) async {
    if (!_configured) {
      return;
    }

    if (uid == _currentAppUserId) {
      return;
    }

    try {
      if (uid == null || uid.isEmpty) {
        if (_currentAppUserId != null) {
          await Purchases.logOut();
        }
        _currentAppUserId = null;
        return;
      }

      await Purchases.logIn(uid);
      _currentAppUserId = uid;
    } catch (error, stackTrace) {
      debugPrint('RevenueCat user sync failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  static String? get _apiKeyForCurrentPlatform {
    if (kIsWeb) {
      return _webApiKey;
    }

    return switch (defaultTargetPlatform) {
      TargetPlatform.android => _androidApiKey,
      TargetPlatform.iOS => _iosApiKey,
      TargetPlatform.macOS =>
        _macosApiKey.isNotEmpty ? _macosApiKey : _iosApiKey,
      TargetPlatform.fuchsia ||
      TargetPlatform.linux ||
      TargetPlatform.windows => null,
    };
  }

  static String get _currentPlatformName {
    if (kIsWeb) {
      return 'web';
    }

    return defaultTargetPlatform.name;
  }
}
