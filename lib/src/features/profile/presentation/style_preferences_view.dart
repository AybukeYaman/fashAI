import 'package:fashai/src/core/constants/text_strings.dart';
import 'package:fashai/src/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class StylePreferencesPage extends StatelessWidget {
  const StylePreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.beige,
      appBar: AppBar(
        backgroundColor: AppColors.beige,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: AppColors.charcoal),
        ),
        title: Text(
          Ttexts.stylePreferences,
          style: const TextStyle(
            color: AppColors.charcoal,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Text(
          "${Ttexts.stylePreferences}\n${Ttexts.comingSoon}",
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.warmGray, fontSize: 18),
        ),
      ),
    );
  }
}
