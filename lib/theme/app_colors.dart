import 'package:flutter/material.dart';

/// Palet warna minimalis elegan mewah bertema Oren, Emas, dan Hitam Obsidian
class AppColors {
  // Backgrounds (Hitam Obsidian & Arang Elegan)
  static const Color bgDark = Color(0xFF0C0A09); // Obsidian black
  static const Color bgSurface = Color(0xFF171412); // Charcoal warm surface
  static const Color bgCard = Color(0xFF221E1A); // Deep carbon card
  static const Color bgCardHover = Color(0xFF2F2922); // Card hover warm carbon

  // Accents (Oren Neon & Emas Kemilau)
  static const Color primary = Color(0xFFFF7A00); // Neon Cyber Orange
  static const Color primaryLight = Color(0xFFFFA24C); // Warm Sunset Orange
  static const Color secondary = Color(0xFFFFB800); // Radiant Cyber Gold
  static const Color secondaryLight = Color(0xFFFFD54F); // Champagne Gold Glow
  static const Color accent = Color(0xFF10B981); // Emerald pulse
  static const Color accentRose = Color(0xFFF43F5E); // Neon Rose
  static const Color accentAmber = Color(0xFFF59E0B); // Amber warning

  // Text
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFFA8A29E); // Warm stone secondary
  static const Color textMuted = Color(0xFF78716C); // Muted warm stone

  // Glassmorphism borders & fills
  static const Color glassFill = Color(0x1A221E1A);
  static const Color glassBorder = Color(0x26FFFFFF);
  static const Color glassBorderHover = Color(0x4DFF7A00); // Orange border glow hover

  // Gradients (Kombinasi Mewah Oren & Emas)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary], // Orange to Gold
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, primaryLight], // Gold to Warm Sunset
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGlowGradient = LinearGradient(
    colors: [Color(0x33FF7A00), Color(0x1AFFB800), Colors.transparent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient avatarBorderGradient = LinearGradient(
    colors: [primary, secondary, primaryLight, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
