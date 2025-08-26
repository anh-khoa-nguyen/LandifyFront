import 'package:flutter/material.dart';

class BrokerProfileHeader extends StatelessWidget {
  const BrokerProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // THAY ĐỔI 1: Widget gốc giờ là một Stack để quản lý các lớp
    return Stack(
      children: [
        // LỚP 1 (DƯỚI CÙNG): Nền trắng và nội dung text
        Column(
          children: [
            // Tạo một khoảng trống có chiều cao bằng với ảnh bìa
            const SizedBox(height: 180),
            // Container màu trắng chứa toàn bộ thông tin
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 52, 16, 16), // Padding top lớn để chừa chỗ cho avatar
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hàng 1: Các nút bấm
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.share, size: 16),
                        label: const Text('Chia sẻ'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.green.shade800,
                          side: BorderSide(color: Colors.green.shade200),
                          backgroundColor: Colors.green.shade50,
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          textStyle: const TextStyle(fontSize: 13),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add, size: 16, color: Colors.red),
                        label: const Text('Theo dõi'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade50,
                          foregroundColor: Colors.red,
                          elevation: 0,
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          textStyle: const TextStyle(fontSize: 13),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Hàng 2: Tên người dùng
                  const Text(
                    'Nguyễn Anh Khoa',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),

                  // Hàng 3: Đánh giá
                  Row(
                    children: [
                      const Text('0.0', style: TextStyle(color: Colors.grey)),
                      const SizedBox(width: 4),
                      for (int i = 0; i < 5; i++) const Icon(Icons.star_border, color: Colors.grey, size: 16),
                      const SizedBox(width: 8),
                      Text('(0 đánh giá)', style: TextStyle(color: Colors.blue.shade700)),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Hàng 4: Người theo dõi và tin đăng
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                      children: const <TextSpan>[
                        TextSpan(text: 'Người theo dõi: '),
                        TextSpan(text: '3', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                        TextSpan(text: '   Tin đăng: '),
                        TextSpan(text: '48 tin', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // LỚP 2 (TRÊN CÙNG): Ảnh bìa và Avatar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 220,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/property_cover.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withOpacity(0.4)],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('Hoạt động 1 giờ trước', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ),
                Positioned(
                  bottom: -40,
                  left: 16,
                  child: CircleAvatar(
                    radius: 42,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/images/cate4.png'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}