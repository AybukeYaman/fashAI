import 'package:fashai/src/core/routes/app_routes.dart';
import 'package:fashai/src/core/themes/app_colors.dart';
import 'package:fashai/src/features/home/presentation/home_model.dart';
import 'package:fashai/src/features/login/presentation/login_view.dart';
import 'package:fashai/src/features/main/presentation/main_view.dart';
import 'package:fashai/src/features/onboarding/presentation/your_ai_stylist_page.dart';
import 'package:fashai/src/features/outfit/presentation/outfit_detail_view.dart';
import 'package:fashai/src/features/profile/presentation/app_settings_view.dart';
import 'package:fashai/src/features/profile/presentation/cycle_settings_view.dart';
import 'package:fashai/src/features/profile/presentation/style_preferences_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Combime',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.dustyRose,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.coral,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.onboarding,
      routes: {
        AppRoutes.onboarding: (context) => const YourAiStylistPage(),
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.home: (context) => const MainPage(),
        AppRoutes.main: (context) => const MainPage(),
        AppRoutes.stylePreferences: (context) => StylePreferencesPage(),
        AppRoutes.cycleSettings: (context) => const CycleSettingsPage(),
        AppRoutes.appSettings: (context) => const AppSettingsPage(),
        AppRoutes.outfitDetail: (context) {
          final outfit =
              ModalRoute.of(context)!.settings.arguments as OutfitModel;
          return OutfitDetailPage(outfit: outfit);
        },
      },
    );
  }
}
