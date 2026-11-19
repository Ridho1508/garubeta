import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  // Nama font. Kalau file font belum dipasang di pubspec, Flutter otomatis
  // pakai font bawaan, jadi aplikasi tetap jalan.
  static const _heading = 'Quicksand';
  static const _body = 'NunitoSans';

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.gold),
      scaffoldBackgroundColor: AppColors.cream,
    );

    final textTheme = base.textTheme.copyWith(
      headlineLarge: const TextStyle(
        fontFamily: _heading,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: AppColors.mocha,
      ),
      headlineMedium: const TextStyle(
        fontFamily: _heading,
        fontSize: 26,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: AppColors.mocha,
      ),
      titleLarge: const TextStyle(
        fontFamily: _heading,
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.25,
        color: AppColors.mocha,
      ),
      bodyLarge: const TextStyle(
        fontFamily: _body,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: AppColors.mocha,
      ),
      bodyMedium: const TextStyle(
        fontFamily: _body,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: AppColors.mocha,
      ),
    );

    return base.copyWith(textTheme: textTheme);
  }
}