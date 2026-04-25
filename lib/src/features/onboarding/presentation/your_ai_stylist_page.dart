import 'package:fashai/src/core/constants/sizes.dart';
import 'package:fashai/src/core/providers/shared_preferences_provider.dart';
import 'package:fashai/src/core/routes/app_routes.dart';
import 'package:fashai/src/core/themes/app_colors.dart';
import 'package:fashai/src/core/utils/platform_utils.dart';
import 'package:fashai/src/features/auth/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class YourAiStylistPage extends ConsumerStatefulWidget {
  const YourAiStylistPage({super.key});

  @override
  ConsumerState<YourAiStylistPage> createState() => _YourAiStylistPageState();
}

class _YourAiStylistPageState extends ConsumerState<YourAiStylistPage> {
  @override
  Widget build(BuildContext context) {
    final deviceOrientation = MediaQuery.of(context).orientation;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: deviceOrientation == Orientation.portrait ? myColumn() : myRow(),
      ),
    );
  }

  Column myColumn() {
    return Column(
      children: [
        Center(child: ticketContainer(0.66, 0.525)),
        Column(
          children: [
            firstTextSizedBox(0.075, 1, TSizes.fontSizeLG * 2.2),
            secondTextSizedBox(0.125, 0.8, TSizes.fontSizeMD),
          ],
        ),
        sliderContainer(0.05, 0.05),
        GestureDetector(
          onTap: _completeOnboarding,
          child: _getStartedButton(
            height: MediaQuery.of(context).size.height * 0.09,
            width: MediaQuery.of(context).size.width * 0.8,
            fontSize: TSizes.fontSizeLG,
          ),
        ),
        accountTextSizedBox(0.125, 1),
      ],
    );
  }

  Row myRow() {
    return Row(
      children: [
        Center(child: ticketContainer(0.30, 0.50)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            firstTextSizedBox(0.14, 0.35, TSizes.fontSizeLG * 1.8),
            secondTextSizedBox(0.3, 0.35, TSizes.fontSizeSM),
            sliderContainer(0.05, 0.35),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _completeOnboarding,
              child: _getStartedButton(
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width * 0.25,
                fontSize: TSizes.fontSizeMD,
              ),
            ),
            accountTextSizedBox(0.05, 0.35),
          ],
        ),
      ],
    );
  }

  /////////////////////////////////////////////////////////////////////////////
  // Shared Widgets

  Container _getStartedButton({
    required double height,
    required double width,
    required double fontSize,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.dustyRose,
        borderRadius: BorderRadius.circular(TSizes.borderRadiusLg * 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.dustyRose.withValues(alpha: 0.2),
            spreadRadius: TSizes.xl,
            blurRadius: TSizes.xl,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        "Get Started",
        style: TextStyle(
          color: AppColors.white,
          fontFamily: PlatformUtils.bodyFont(context),
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
        ),
      ),
    );
  }

  GestureDetector accountTextSizedBox(double sH, double sW) {
    return GestureDetector(
      onTap: _completeOnboarding,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * sH,
        width: MediaQuery.of(context).size.width * sW,
        child: Text(
          "I already have an account",
          style: TextStyle(
            color: AppColors.warmGray,
            fontFamily: PlatformUtils.bodyFont(context),
            fontWeight: FontWeight.w400,
            fontSize: TSizes.fontSizeMD,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Container sliderContainer(double sH, double sW) {
    return Container(
      height: MediaQuery.of(context).size.height * sH,
      width: MediaQuery.of(context).size.width * sW,
      decoration: BoxDecoration(
        color: AppColors.dustyRose,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.dustyRose.withValues(alpha: 0.2),
            spreadRadius: TSizes.xl,
            blurRadius: TSizes.xl,
          ),
        ],
      ),
      alignment: Alignment.center,
    );
  }

  Container ticketContainer(double sW, double sH) {
    return Container(
      height: MediaQuery.of(context).size.height * sH,
      width: MediaQuery.of(context).size.width * sW,
      decoration: BoxDecoration(
        color: AppColors.dustyRose,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.dustyRose.withValues(alpha: 0.2),
            spreadRadius: TSizes.xl,
            blurRadius: TSizes.xl,
          ),
        ],
      ),
      child: Icon(
        Icons.label_outline_rounded,
        size: TSizes.iconXl * 3,
        color: AppColors.white,
      ),
    );
  }

  SizedBox firstTextSizedBox(double sH, double sW, double fS) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * sH,
      width: MediaQuery.of(context).size.width * sW,
      child: Text(
        "Your AI Stylist",
        style: TextStyle(
          color: AppColors.charcoal,
          fontFamily: "PT_Serif",
          fontWeight: FontWeight.w600,
          fontSize: fS,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  SizedBox secondTextSizedBox(double sH, double sW, double fS) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * sH,
      width: MediaQuery.of(context).size.width * sW,
      child: Center(
        child: Text(
          "Get personalized outfit recommendations based on your wardrobe, mood, and the weather",
          style: TextStyle(
            color: AppColors.warmGray,
            fontFamily: PlatformUtils.bodyFont(context),
            fontWeight: FontWeight.w400,
            fontSize: fS,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Future<void> _completeOnboarding() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setBool('has_seen_onboarding', true);
    ref.invalidate(hasSeenOnboardingProvider);
    if (mounted) {
      context.go(AppRoutes.login);
    }
  }
}
