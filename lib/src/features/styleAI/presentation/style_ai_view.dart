import 'package:fashai/src/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class StyleAiPage extends StatelessWidget {
  const StyleAiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.beige,
      body: Center(
        child: Text(
          "Style AI",
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