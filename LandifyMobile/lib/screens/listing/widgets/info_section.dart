import 'package:flutter/material.dart';

class PropertyInfoSection extends StatelessWidget {
  const PropertyInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleSection(), // <-- Sẽ sử dụng phiên bản cuối cùng bên dưới
          const SizedBox(height: 1),
          _buildLocationAndMapSection(),
        ],
      ),
    );
  }

  /// Widget xây dựng phần tiêu đề (GIẢI PHÁP CUỐI CÙNG DÙNG RICHTEXT)
  Widget _buildTitleSection() {
    // RichText cho phép kết hợp widget và text trong cùng một khối văn bản có thể xuống dòng
    return RichText(
      text: TextSpan(
        // children chứa các phần của khối văn bản
        children: [
          // Phần 1: Tag "Xác thực" được nhúng vào như một widget
          WidgetSpan(
            // Căn chỉnh widget theo chiều dọc so với dòng chữ
            alignment: PlaceholderAlignment.middle,
            child: Container(
              // Thêm margin bên phải để tạo khoảng cách với chữ
              margin: const EdgeInsets.only(right: 8.0),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFE4F8E9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.green.shade800, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'Xác thực',
                    style: TextStyle(
                      color: Colors.green.shade800,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Phần 2: Tiêu đề là một TextSpan thông thường
          const TextSpan(
            text: 'Chủ gửi bán lô đất biệt thự 10x20m ngay KDC Bình Dân, P. Hiệp Bình Chánh đường rộng 10m giá 15,5 tỷ',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF222222),
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  /// Widget xây dựng phần địa chỉ và bản đồ (GIỮ NGUYÊN)
  Widget _buildLocationAndMapSection() {
    // ... code của phần này không thay đổi ...
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Phường Hiệp Bình Chánh, Thủ Đức, Hồ Chí Minh',
                style: TextStyle(color: Colors.black54, fontSize: 15),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () {
                  print('Xem trên bản đồ tapped!');
                },
                child: const Text(
                  'Xem trên bản đồ',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        InkWell(
          onTap: () {
            print('Map image tapped!');
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              'assets/images/maps-icon.png',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}