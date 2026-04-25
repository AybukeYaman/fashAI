import 'package:fashai/src/core/routes/app_routes.dart';
import 'package:fashai/src/features/auth/presentation/verify_email_view.dart';
import 'package:fashai/src/features/auth/providers/auth_providers.dart';
import 'package:fashai/src/features/home/presentation/home_model.dart';
import 'package:fashai/src/features/login/presentation/login_view.dart';
import 'package:fashai/src/features/main/presentation/main_view.dart';
import 'package:fashai/src/features/onboarding/presentation/your_ai_stylist_page.dart';
import 'package:fashai/src/features/outfit/presentation/outfit_detail_view.dart';
import 'package:fashai/src/features/profile/presentation/app_settings_view.dart';
import 'package:fashai/src/features/profile/presentation/cycle/presentation/cycle_settings_view.dart';
import 'package:fashai/src/features/profile/presentation/style_preferences_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.onboarding,
    refreshListenable: _AuthChangeNotifier(ref),
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      final hasSeenOnboarding = ref.read(hasSeenOnboardingProvider).value;

      final location = state.uri.path;
      final onOnboarding = location == AppRoutes.onboarding || location == '/';
      final onAuthRoute =
          location == AppRoutes.login ||
          location == AppRoutes.signUp ||
          location == AppRoutes.verifyEmail;

      if (hasSeenOnboarding == null || authState.isLoading) {
        return null;
      }

      final user = authState.value;
      if (!hasSeenOnboarding) {
        return onOnboarding ? null : AppRoutes.onboarding;
      }

      if (user == null) {
        return onAuthRoute ? null : AppRoutes.login;
      }

      if (_requiresEmailVerification(user)) {
        return location == AppRoutes.verifyEmail ? null : AppRoutes.verifyEmail;
      }

      if (onAuthRoute || onOnboarding) {
        return AppRoutes.home;
      }
      return null;
    },
    routes: [
      GoRoute(path: '/', redirect: (_, _) => AppRoutes.onboarding),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const YourAiStylistPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (context, state) =>
            const LoginPage(initialMode: LoginMode.signUp),
      ),
      GoRoute(
        path: AppRoutes.verifyEmail,
        builder: (context, state) => const VerifyEmailPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const MainPage(),
      ),
      GoRoute(
        path: AppRoutes.stylePreferences,
        builder: (context, state) => const StylePreferencesPage(),
      ),
      GoRoute(
        path: AppRoutes.cycleSettings,
        builder: (context, state) => const CycleSettingsPage(),
      ),
      GoRoute(
        path: AppRoutes.appSettings,
        builder: (context, state) => const AppSettingsPage(),
      ),
      GoRoute(
        path: AppRoutes.outfitDetail,
        builder: (context, state) {
          final outfit = state.extra;
          if (outfit is! OutfitModel) {
            return const MainPage();
          }
          return OutfitDetailPage(outfit: outfit);
        },
      ),
    ],
  );
});

bool _requiresEmailVerification(User user) {
  final providerIds = user.providerData.map((info) => info.providerId).toSet();
  final passwordOnly =
      providerIds.isEmpty ||
      (providerIds.length == 1 && providerIds.contains('password'));
  return passwordOnly && !user.emailVerified;
}

class _AuthChangeNotifier extends ChangeNotifier {
  _AuthChangeNotifier(Ref ref) {
    ref.listen(authStateProvider, (_, _) => notifyListeners());
    ref.listen(hasSeenOnboardingProvider, (_, _) => notifyListeners());
  }
}
