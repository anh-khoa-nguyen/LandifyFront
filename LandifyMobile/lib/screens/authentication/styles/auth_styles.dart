// lib/screens/authentication/styles/auth_styles.dart
import 'package:flutter/material.dart';
import 'package:landifymobile/utils/theme/app_colors.dart';

/// Chứa các style chỉ dành riêng cho các màn hình trong feature Authentication
class AuthStyles {
  AuthStyles._();

  // --- Text Styles ---

  /// Style cho tiêu đề chính (ví dụ: 'Đăng nhập')
  static const TextStyle header = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  /// Style cho tiêu đề phụ (ví dụ: 'Sign in to your account')
  static const TextStyle subHeader = TextStyle(
    fontSize: 16,
    color: AppColors.darkGrey,
  );

  // --- Decorations ---

  /// Decoration cho các ô TextFormField
  static InputDecoration textInputDecoration({required String labelText}) {
    return InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2.0),
      ),
      filled: true,
      fillColor: AppColors.lightGrey,
      contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
    );
  }

  /// Decoration cho container màu trắng bo góc
  static const BoxDecoration whiteCard = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(40.0),
      topRight: Radius.circular(40.0),
    ),
  );
}