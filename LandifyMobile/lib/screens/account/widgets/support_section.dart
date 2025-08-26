import 'package:flutter/material.dart';
import 'package:landifymobile/utils/theme/app_colors.dart';

class SupportSection extends StatelessWidget { // Đã đổi tên từ _SupportSection
  const SupportSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildSupportItem(Icons.headset_mic_outlined, 'Trung tâm hỗ trợ'),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _buildSupportItem(Icons.security_outlined, 'Trung tâm bảo mật'),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _buildSupportItem(Icons.settings_outlined, 'Cài đặt ứng dụng'),
        ],
      ),
    );
  }

  Widget _buildSupportItem(IconData icon, String label) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryBlue),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {},
    );
  }
}