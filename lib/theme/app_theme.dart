// ============================================================
// app_theme.dart — WARNA & TEMA
// Semua warna aplikasi dikumpulkan di sini supaya mudah diganti.
// Contoh pemakaian: AppTheme.purple, AppTheme.ink, AppTheme.canvas.
// ============================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTheme {
  // In-app palette (taken from the Figma frames)
  static const purple = Color(0xFFB974E9);
  static const purpleDark = Color(0xFF5C18B6);
  static const lilac = Color(0xFFF2E5FF);
  static const teal = Color(0xFF45D1C1);
  static const tealDark = Color(0xFF1CA897);
  static const ink = Color(0xFF29283A);
  static const muted = Color(0xFF9291A5);
  static const canvas = Color(0xFFEEF2FF);
  static const line = Color(0xFFE3E1F0);
  static const rose = Color(0xFFC64F70);
  static const roseSoft = Color(0xFFFFE7EE);

  // Auth screens
  static const authBackdrop = Color(0xFFF2ECFB);
  static const authWelcome = Color(0xFFEEF4FF);
  static const authPurple = Color(0xFFC789F3);
  static const authInk = Color(0xFF30283A);
  static const authSub = Color(0xFF70429A);

  static const softShadow = [
    BoxShadow(color: Color(0x155C18B6), blurRadius: 18, offset: Offset(0, 6)),
  ];

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: canvas,
      colorScheme: ColorScheme.fromSeed(
        seedColor: purpleDark,
        primary: purpleDark,
        secondary: teal,
        surface: Colors.white,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: purple,
          foregroundColor: Colors.white,
          // jarak dalam (padding): kiri-kanan: 20, atas-bawah: 14
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            // sudut membulat radius 15
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
    return base.copyWith(textTheme: GoogleFonts.latoTextTheme(base.textTheme));
  }
}
