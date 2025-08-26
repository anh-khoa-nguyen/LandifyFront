import 'package:flutter/material.dart';
import '../titled_card.dart';

class ContactInfoSection extends StatelessWidget {
  // Truyền các controller và state cần thiết vào đây
  const ContactInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return TitledCard(
      title: 'Thông tin liên hệ',
      child: Column(
        children: [
          _buildTextFieldWithLabel('Tên liên hệ', 'user12542773'),
          const SizedBox(height: 16),
          _buildTextFieldWithLabel('Email', '9gbtsqhn5n@privaterelay.appleid.com', isOptional: true),
          const SizedBox(height: 16),
          _buildTextFieldWithLabel('Số điện thoại', '0862465874'),
        ],
      ),
    );
  }

  Widget _buildTextFieldWithLabel(String label, String initialValue, {bool isOptional = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            children: [
              TextSpan(text: label),
              if (isOptional)
                TextSpan(
                  text: ' (không bắt buộc)',
                  style: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey.shade600),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
      ],
    );
  }
}