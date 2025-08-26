import 'package:flutter/material.dart';
import 'package:landifymobile/screens/mine/posted_listings.dart';

class ActionBar extends StatelessWidget { // Đã đổi tên từ _ActionBar
  const ActionBar({super.key});

  @override
  Widget build(BuildContext context) {
// VẤN ĐỀ 1: Bọc toàn bộ widget trong một Card
    return Card(
      // Chuyển margin từ Container cũ vào đây
      color: Colors.white,
      margin: const EdgeInsets.only(top: 40, left: 16, right: 16),
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Truyền hàm xử lý sự kiện cho mỗi item
            _buildActionItem(
              context: context,
              icon: Icons.favorite_border,
              label: 'Tin đăng\nquan tâm',
              onTap: () {
                print('Tin đăng quan tâm tapped!');
                // TODO: Điều hướng đến trang tin quan tâm
              },
            ),
            _buildActionItem(
              context: context,
              icon: Icons.star_border,
              label: 'Đánh giá\ntừ tôi',
              onTap: () {
                print('Đánh giá từ tôi tapped!');
                // TODO: Điều hướng đến trang đánh giá
              },
            ),
            _buildActionItem(
              context: context,
              icon: Icons.business_outlined,
              label: 'Bất động sản\ncủa tôi',
              onTap: () {
                // THAY ĐỔI 3: Thực hiện điều hướng đến màn hình "Tin đã đăng"
                Navigator.of(context).pushNamed(PostedListingsScreen.routeName);
              },
            ),
            _buildActionItem(
              context: context,
              icon: Icons.history,
              label: 'Lịch sử\ngiao dịch',
              onTap: () {
                print('Lịch sử giao dịch tapped!');
                // TODO: Điều hướng đến trang lịch sử
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem({
    required BuildContext context, // Cần context để điều hướng
    required IconData icon,
    required String label,
    required VoidCallback onTap, // Một hàm callback để xử lý sự kiện nhấn
  }) {
    // THAY ĐỔI 2: Bọc toàn bộ widget trong InkWell
    return InkWell(
      onTap: onTap, // Gán hàm xử lý sự kiện
      // Thêm borderRadius để hiệu ứng gợn sóng được bo tròn đẹp mắt
      borderRadius: BorderRadius.circular(8.0),
      child: Padding(
        // Thêm padding để tăng vùng có thể nhấn
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Giúp Column co lại vừa với nội dung
          children: [
            Icon(icon, color: Colors.grey.shade700, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
