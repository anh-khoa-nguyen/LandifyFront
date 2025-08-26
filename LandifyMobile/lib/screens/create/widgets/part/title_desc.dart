import 'package:flutter/material.dart';
import '../titled_card.dart';

class TitleDescSection extends StatelessWidget {
  // Truyền các controller cần thiết vào đây
  const TitleDescSection({super.key});

  @override
  Widget build(BuildContext context) {
    return TitledCard(
      title: 'Tiêu đề & Mô tả',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tạo nhanh với AI'),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Tạo với AI'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text('Bạn còn 100 lượt sử dụng đến ngày 16/09/2025'),
          const SizedBox(height: 16),
          _buildTextFieldWithHelper('Tiêu đề', 'Mô tả ngắn gọn...', 'Tối thiểu 30 ký tự, tối đa 99 ký tự'),
          const SizedBox(height: 16),
          _buildTextFieldWithHelper('Mô tả', 'Mô tả chi tiết về...', 'Tối thiểu 30 ký tự, tối đa 3000 ký tự', maxLines: 5),
        ],
      ),
    );
  }

  Widget _buildTextFieldWithHelper(String label, String hint, String helper, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 4),
        Text(helper, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
      ],
    );
  }
}