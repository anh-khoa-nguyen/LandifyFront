import 'package:flutter/material.dart';

// Định nghĩa các màu sắc chính của bạn ở đây
const Color kPrimaryRed = Color(0xFFD92323);
const Color kPrimaryDark = Color(0xFF222222);
const Color kLightGray = Color(0xFFF0F2F5);
const Color kTextGray = Color(0xFF666666);

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final baseTheme = ThemeData.light(useMaterial3: true);

    return baseTheme.copyWith(
      // --- MÀU SẮC CHUNG ---
      primaryColor: kPrimaryRed,
      scaffoldBackgroundColor: Colors.white,

      // --- APPBAR THEME ---
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: kPrimaryDark),
        titleTextStyle: TextStyle(
          color: kPrimaryDark,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'BeVietnamPro',
        ),
      ),

      // --- ELEVATED BUTTON THEME ---
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryRed,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'BeVietnamPro',
          ),
        ),
      ),

      // --- OUTLINED BUTTON THEME ---
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: kPrimaryDark,
          side: const BorderSide(color: kPrimaryDark),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'BeVietnamPro',
          ),
        ),
      ),

      // // --- LISTTILE THEME ---
      // listTileTheme: ListTileThemeData(
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(12),
      //     side: BorderSide(color: Colors.grey.shade300),
      //   ),
      // ),

      // --- RADIO THEME ---
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return kPrimaryRed;
          }
          return Colors.grey;
        }),
      ),

      // --- CARD THEME (ĐÃ SỬA LỖI CHÍNH XÁC) ---
      // Thay đổi CardTheme thành CardThemeData
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: Colors.grey.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200),
        ),
      ),

      // Thêm các theme khác ở đây
    );
  }
}