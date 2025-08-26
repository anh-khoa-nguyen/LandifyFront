// lib/utils/theme/app_text_styles.dart
import 'package:flutter/material.dart';
import 'package:landifymobile/utils/theme/app_colors.dart';

/// Chứa các TextStyle có thể tái sử dụng trên toàn bộ ứng dụng
class AppTextStyles {
  AppTextStyles._();

  /// Style cho các nút bấm chính (ví dụ: ElevatedButton)
  static const TextStyle primaryButtonText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  /// Style cho các link hoặc TextButton
  static const TextStyle linkText = TextStyle(
    color: AppColors.primaryBlue,
    fontWeight: FontWeight.bold,
  );

  /// Style cho các đoạn text thông thường, không nhấn mạnh
  static const TextStyle normalText = TextStyle(
    color: AppColors.darkGrey,
  );
}