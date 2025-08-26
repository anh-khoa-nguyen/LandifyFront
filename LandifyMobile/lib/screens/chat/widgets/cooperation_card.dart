import 'package:flutter/material.dart';
import 'request_info.dart';

// Định nghĩa các màu sắc chính
const Color kAgreeGreen = Color(0xFF0BA84A);
const Color kDeclineRed = Color(0xFFF44336);
const Color kDetailsButtonBlue = Color(0xFF5856D6);

class CooperationRequestCard extends StatefulWidget {
  const CooperationRequestCard({super.key});

  @override
  State<CooperationRequestCard> createState() => _CooperationRequestCardState();
}

class _CooperationRequestCardState extends State<CooperationRequestCard> {
  // THAY ĐỔI 2: Thêm biến state để quản lý trạng thái mở/đóng
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          image: const DecorationImage(
            image: AssetImage('assets/images/money_pattern.png'),
            fit: BoxFit.cover,
            opacity: 0.1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 2,
              blurRadius: 10,
            ),
          ],
        ),
        // THAY ĐỔI 3: Bọc trong InkWell để toàn bộ thẻ có thể được nhấn
        child: InkWell(
          onTap: () {
            // Khi nhấn, đảo ngược trạng thái và gọi setState để vẽ lại UI
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          borderRadius: BorderRadius.circular(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            // THAY ĐỔI 4: Bọc Column trong AnimatedSize để có hiệu ứng mượt mà
            child: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 12),
                  _buildRequesterInfo(),

                  // THAY ĐỔI 5: Hiển thị nội dung chi tiết một cách có điều kiện
                  if (_isExpanded) _buildExpandedContent(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(height: 30),
        // THAY ĐỔI 2: Thay thế hàm cũ bằng widget mới
        const RequestListingInfo(),
        const SizedBox(height: 10),
        _buildActionButtons(context),
      ],
    );
  }

  /// Xây dựng phần Header "Đề Nghị Hợp Tác"
  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [kAgreeGreen.withOpacity(0.8), kAgreeGreen],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.handshake, color: Colors.white, size: 28),
        ),
        const SizedBox(width: 12),
        const Text(
          'Đề Nghị Hợp Tác',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  /// Xây dựng phần thông tin người đề nghị
  Widget _buildRequesterInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.grey.shade700, fontSize: 16, height: 1.5),
            children: const <TextSpan>[
              TextSpan(text: 'Bạn '),
              TextSpan(text: 'Dung Nhà Đất', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              TextSpan(text: ' muốn trở thành đối tác '),
              TextSpan(text: 'môi giới', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              TextSpan(text: ' cho tin đăng của bạn.'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage('https://picsum.photos/seed/agent/200/200'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Dung Nhà Đất', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Phản hồi: 99%', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  const SizedBox(height: 2),
                  Text('1232 người theo dõi', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                ],
              ),
            ),
            // THAY ĐỔI 6: Thêm icon mũi tên có animation
            AnimatedRotation(
              turns: _isExpanded ? 0.5 : 0.0, // 0.5 turns = 180 độ
              duration: const Duration(milliseconds: 300),
              child: const Icon(Icons.keyboard_arrow_down, size: 28, color: Colors.black54),
            ),
          ],
        ),
      ],
    );
  }

  /// Xây dựng 2 nút "Đồng ý" và "Từ chối"
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: kAgreeGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
            child: const Text('Đồng ý'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: kDeclineRed,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
            child: const Text('Từ chối'),
          ),
        ),
      ],
    );
  }
}