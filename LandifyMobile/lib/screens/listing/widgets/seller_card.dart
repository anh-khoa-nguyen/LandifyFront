import 'package:flutter/material.dart';

class SellerCard extends StatelessWidget {
  const SellerCard({super.key});

  @override
  Widget build(BuildContext context) {
    // TOÀN BỘ HÀM BUILD NÀY GIỮ NGUYÊN (đã sửa cấu trúc theo yêu cầu)
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Phần trái giờ là 1 Column chứa 2 Row
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                // căn giữa theo chiều dọc của hàng cha
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ROW 1: Avatar + Thông tin chính (tên, phản hồi, đã bán)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Avatar
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: NetworkImage('https://picsum.photos/seed/agent/200/200'),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      // Thông tin văn bản (tên + 2 thông tin)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Hoàng Nhà Đẹp',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 6),
                            _buildInfoRow(Icons.star, 'Phản hồi: 73%'),
                            const SizedBox(height: 2),
                            _buildInfoRow(Icons.star, '5 đã bán'),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Khoảng cách giữa 2 row
                  const SizedBox(height: 6),

                  // ROW 2: Dòng hoạt động dài (bắt đầu thẳng hàng với text của Row 1)
                  // Để căn đúng, thêm SizedBox trái bằng với kích thước avatar + khoảng cách (48 + 12 = 60)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 5),
                      Expanded(
                        child: _buildInfoRow(
                          Icons.circle,
                          'Hoạt động 2 giờ trước',
                          iconSize: 6,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Cột 3: Các nút bấm (giữ nguyên như bạn yêu cầu)
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    // SỬA LẠI MÀU NÚT ĐĂNG KÝ
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Đăng ký'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 0,
                    textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Xem 11 tin đăng'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Widget helper để tạo một dòng thông tin có icon
  Widget _buildInfoRow(IconData icon, String text, {double iconSize = 14}) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade600, size: iconSize),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
