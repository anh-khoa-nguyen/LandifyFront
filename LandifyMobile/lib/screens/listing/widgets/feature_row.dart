import 'package:flutter/material.dart';

/// Widget hàng tính năng nhỏ (icon + title + value)
class FeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  const FeatureRow({super.key, required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    // Thêm padding để tạo khoảng cách bên trong khung
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      child: Row(
        children: [
          Icon(icon, size: 22, color: Colors.black54), // Icon màu tối hơn
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 15, color: Colors.black87), // Chữ không in đậm
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
              fontWeight: FontWeight.bold, // Giá trị in đậm
            ),
          ),
        ],
      ),
    );
  }
}