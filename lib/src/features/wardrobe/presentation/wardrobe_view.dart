import 'package:fashai/src/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class WardrobePage extends StatelessWidget {
  const WardrobePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.beige,
      body: Center(
        child: Text(
          "Wardrobe",
          style: TextStyle(
            color: AppColors.charcoal,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
