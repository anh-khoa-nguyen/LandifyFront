import 'package:flutter/material.dart';
import 'feature_row.dart'; // Import widget con

// Tốt hơn là nên tạo một model nhỏ cho dữ liệu để code sạch hơn
class FeatureItem {
  final IconData icon;
  final String title;
  final String value;
  FeatureItem({required this.icon, required this.title, required this.value});
}

// Danh sách dữ liệu mẫu
final List<FeatureItem> features = [
  FeatureItem(icon: Icons.price_check_outlined, title: 'Mức giá', value: '3,2 tỷ'),
  FeatureItem(icon: Icons.square_foot_outlined, title: 'Diện tích', value: '56 m²'),
  FeatureItem(icon: Icons.explore_outlined, title: 'Hướng nhà', value: 'Đông - Nam'),
  FeatureItem(icon: Icons.balcony_outlined, title: 'Hướng ban công', value: 'Đông - Nam'),
  FeatureItem(icon: Icons.bed_outlined, title: 'Số phòng ngủ', value: '2 phòng'),
  FeatureItem(icon: Icons.bathtub_outlined, title: 'Số phòng tắm, vệ sinh', value: '2 phòng'),
  FeatureItem(icon: Icons.article_outlined, title: 'Pháp lý', value: 'Hợp đồng mua bán'),
  FeatureItem(icon: Icons.chair_outlined, title: 'Nội thất', value: 'Đầy đủ'),
];

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Đặc điểm bất động sản', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          // --- BẮT ĐẦU THAY ĐỔI CHÍNH ---
          // Container để tạo khung, viền và bóng đổ
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              // Viền mờ nhẹ
              border: Border.all(color: Colors.grey.shade200, width: 1.0),
              // Shadow nhẹ
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            // ClipRRect để đảm bảo các con bên trong cũng được bo góc
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              // Sử dụng ListView.separated để tự động thêm Divider
              child: ListView.separated(
                padding: EdgeInsets.zero,
                // Bắt buộc phải có 2 dòng này khi đặt ListView trong Column
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),

                itemCount: features.length,
                itemBuilder: (context, index) {
                  final feature = features[index];
                  return FeatureRow(
                    icon: feature.icon,
                    title: feature.title,
                    value: feature.value,
                  );
                },
                // Hàm xây dựng đường kẻ phân cách
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.grey.shade200,
                    // indent và endIndent để làm cho đường kẻ ngắn lại
                    indent: 16.0,
                    endIndent: 16.0,
                  );
                },
              ),
            ),
          ),
          // --- KẾT THÚC THAY ĐỔI CHÍNH ---
        ],
      ),
    );
  }
}