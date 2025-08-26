import 'package:flutter/material.dart';

class AuthHeaderBanner extends StatelessWidget {
  // THAY ĐỔI 1: Xóa flex, thêm height
  final double height;
  final String imagePath;

  const AuthHeaderBanner({
    super.key,
    required this.height,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    // THAY ĐỔI 2: Xóa Expanded, thay bằng SizedBox để cung cấp chiều cao
    return SizedBox(
      height: height,
      width: double.infinity, // Đảm bảo banner chiếm toàn bộ chiều rộng
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}