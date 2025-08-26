// lib/utils/theme/app_decorations.dart
import 'package:flutter/material.dart';
import 'package:landifymobile/utils/theme/app_colors.dart';

/// Chứa các Decoration và ButtonStyle có thể tái sử dụng trên toàn bộ ứng dụng
class AppDecorations {
  AppDecorations._();

  /// Style cho nút bấm chính (ElevatedButton)
  static ButtonStyle primaryButtonStyle({bool isEnabled = true}) {
    return ElevatedButton.styleFrom(
      backgroundColor: isEnabled ? AppColors.primaryBlue : Colors.grey.shade400,
      // backgroundColor: isEnabled ? AppColors.primaryOrange : Colors.grey.shade400,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 5,
    );
  }
}