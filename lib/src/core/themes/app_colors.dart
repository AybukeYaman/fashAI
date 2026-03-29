import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Figma'dan Gelen Brand Palette ──────────────────────────────────────────
  /// Ana arka plan rengi (Figma: #FAF9F6)
  static const Color beige = Color(0xFFFAF9F6);

  /// Kartlar ve iç alanlar için kırık beyaz
  static const Color white = Colors.white;

  /// Vurgu rengi (Figma: #E8927C) - Butonlar ve ikonlar için
  static const Color coral = Color(0xFFE8927C);

  /// İkincil vurgu - Daha yumuşak mercan tonu
  static const Color lightCoral = Color(0xFFFDF7F5);

  // ── Neutral Palette ───────────────────────────────────────────────────────
  /// Ana metin rengi (Koyu gri/Siyahımsı)
  static const Color charcoal = Color(0xFF1A1A1A);

  /// Yardımcı metin rengi (Sıcak gri)
  static const Color warmGray = Color(0xFF7D746D);

  /// Kategorilerdeki seçilmeyen buton rengi
  static const Color grey = Color(0xFFECECEC);

  static const Color dustyRose = Color(0xFFDB7964);

  // ── Gradient ──────────────────────────────────────────────────────────────
  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFFF5C1B3), beige],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
