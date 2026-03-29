import 'package:flutter/material.dart';

class PlatformUtils {
  PlatformUtils._();

  static bool isIOS(BuildContext context) =>
      Theme.of(context).platform == TargetPlatform.iOS;

  static bool isAndroid(BuildContext context) =>
      Theme.of(context).platform == TargetPlatform.android;

  // Scrolling physics — bouncy on iOS, clamped on Android
  static ScrollPhysics scrollPhysics(BuildContext context) => isIOS(context)
      ? const BouncingScrollPhysics()
      : const ClampingScrollPhysics();

  // Top padding — accounts for notch on iOS, status bar on Android
  static double topPadding(BuildContext context) =>
      MediaQuery.of(context).padding.top;

  // Horizontal page padding
  static double horizontalPadding(BuildContext context) =>
      isIOS(context) ? 24.0 : 20.0;

  // Font family — PT Serif for headings stays same, body text differs
  static String bodyFont(BuildContext context) =>
      isIOS(context) ? "PTSerif-Regular" : "Roboto";

  // Bottom safe area — iOS home indicator, Android nav bar
  static double bottomPadding(BuildContext context) =>
      MediaQuery.of(context).padding.bottom;
}
