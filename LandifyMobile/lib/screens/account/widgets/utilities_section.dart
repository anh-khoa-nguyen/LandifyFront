import 'package:flutter/material.dart';
import 'package:landifymobile/utils/theme/app_colors.dart';

class UtilitiesSection extends StatelessWidget { // Đã đổi tên từ _UtilitiesSection
  const UtilitiesSection({super.key});

  static final List<Map<String, dynamic>> _utilities = [
    {'icon': Icons.group_add_outlined, 'label': 'Hẹn gặp mặt'},
    {'icon': Icons.explore_outlined, 'label': 'Xem phong thủy'},
    {'icon': Icons.receipt_long_outlined, 'label': 'Thanh toán'},
    {'icon': Icons.real_estate_agent_outlined, 'label': 'Môi giới BĐS'},
    {'icon': Icons.support_agent_outlined, 'label': 'Chatbot'},
    {'icon': Icons.card_giftcard_outlined, 'label': 'Quà của tôi'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tiện ích', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          GridView.builder(
            // SỬA LẠI HOÀN TOÀN gridDelegate
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              // Bỏ `childAspectRatio`
              // THÊM `mainAxisExtent` để gán chiều cao CỐ ĐỊNH cho mỗi thẻ
              mainAxisExtent: 85, // Bạn có thể tinh chỉnh giá trị này
            ),
            itemCount: _utilities.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final utility = _utilities[index];
              return _buildUtilityCard(utility['icon'], utility['label']);
            },
          )
        ],
      ),
    );

  }

  Widget _buildUtilityCard(IconData icon, String label) {
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.white,
      elevation: 1,
      shadowColor: Colors.grey.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primaryBlue, size: 28),
            const Spacer(), // Dùng Spacer để đẩy Text xuống dưới
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
