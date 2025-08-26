import 'package:flutter/material.dart';

class IntroductionTab extends StatelessWidget {
  const IntroductionTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Giới thiệu'),
          const Text('👉 Chuyên mua bán, ký gửi Nhà Phố, đất ở Quận 12, Hóc Môn, SHR'),
          const Text('👉 Cam kết tin thật, thông tin chuẩn, pháp lý rõ ràng'),
          const Text('👉 Hỗ trợ xem nhà nhanh - tư vấn miễn phí'),
          const SizedBox(height: 24),
          _buildSectionTitle('Thông tin môi giới'),
          _buildBrokerInfoTable(),
          const SizedBox(height: 24),
          _buildSectionTitle('Khu vực hoạt động'),
          _buildInfoRow(Icons.location_on_outlined, 'Quận 12, Tp Hồ Chí Minh'),
          _buildInfoRow(Icons.location_on_outlined, 'Huyện Hóc Môn, Tp Hồ Chí Minh'),
          const SizedBox(height: 24),
          _buildSectionTitle('Loại hình môi giới'),
          _buildInfoRow(Icons.business_center_outlined, 'Mua bán - Nhà ở'),
          _buildInfoRow(Icons.business_center_outlined, 'Mua bán - Đất'),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 20),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
  Widget _buildBrokerInfoTable() {
    return Table(
      children: [
        TableRow(children: [_buildInfoCell('Số người theo dõi', '3'), _buildInfoCell('Đánh giá', '0.0 ⭐⭐⭐⭐⭐ (0)')]),
        TableRow(children: [_buildInfoCell('Tổng số tin đăng', '48 tin'), _buildInfoCell('Số tin đăng đã bán', '0 tin')]),
        TableRow(children: [_buildInfoCell('Tốc độ phản hồi chat', '85% (Trong 1 giờ)'), _buildInfoCell('Thời gian hoạt động', '--')]),
        TableRow(children: [_buildInfoCell('Địa chỉ liên hệ', ''), _buildInfoCell('', '')]),
      ],
    );
  }
  Widget _buildInfoCell(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}