import 'package:flutter/material.dart';
import 'bullet_text.dart'; // Import widget con

class DescriptionSection extends StatelessWidget {
  const DescriptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Padding bên ngoài để tạo khoảng cách cho toàn bộ section
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child:
      // --- BẮT ĐẦU THAY ĐỔI ---
      // Container để tạo khung, viền và bóng đổ
      Container(
        // Thêm padding bên trong để nội dung không bị dính vào viền
        padding: const EdgeInsets.all(16.0),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Mô tả',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12), // Tăng khoảng cách một chút
            Column(
              children: const [
                BulletText(
                    'Căn hộ chung cư tại peninsula đà nẵng, tọa lạc ở Lê Văn Duyệt...'),
                BulletText('Căn hộ 1 phòng ngủ hiếm hoi còn lại'),
                BulletText(
                    'Tầng 30 view Bán đảo Sơn Trà, công viên nội khu đầy thơ mộng, tiện ích.'),
                BulletText('Không gian sống trên mây cực chill cực riêng tư.'),
                BulletText(
                    'Căn hộ được thiết kế hiện đại, nội thất cao cấp liền tường.'),
              ],
            ),
          ],
        ),
      ),
      // --- KẾT THÚC THAY ĐỔI ---
    );
  }
}