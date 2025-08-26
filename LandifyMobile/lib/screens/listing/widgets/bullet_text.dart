import 'package:flutter/material.dart';

/// Bullet text sử dụng trong phần mô tả
class BulletText extends StatelessWidget {
  final String text;
  const BulletText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('• ', style: TextStyle(fontSize: 18)),
        SizedBox(height: 10),
        Expanded(child: Text(text, style: const TextStyle(height: 1.5))),
      ],
    );
  }
}