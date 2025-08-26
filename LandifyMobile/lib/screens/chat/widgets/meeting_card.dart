import 'package:flutter/material.dart';
import 'request_info.dart';

// Định nghĩa các màu sắc chính
const Color kAgreeGreen = Color(0xFF0BA84A);
const Color kOrange = Color(0xFFFF884A);
const Color kDeclineRed = Color(0xFFF44336);
const Color kDetailsButtonBlue = Color(0xFF5856D6);

class MeetingRequestCard extends StatefulWidget {
  const MeetingRequestCard({super.key});

  @override
  State<MeetingRequestCard> createState() => _MeetingRequestCardState();
}

class _MeetingRequestCardState extends State<MeetingRequestCard> {
  // THAY ĐỔI 2: Thêm biến state để quản lý trạng thái mở/đóng
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          image: const DecorationImage(
            image: AssetImage('assets/images/meeting_background.png'),
            fit: BoxFit.cover,
            opacity: 0.07,
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

                  // THAY ĐỔI 5: Hiển thị các nút bấm một cách có điều kiện
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
        // Thêm đường kẻ phân cách
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Divider(),
        ),
        // Thêm widget thông tin tin đăng vào đây
        const RequestListingInfo(),
        const SizedBox(height: 16),
        // Giữ lại các nút bấm
        _buildActionButtons(context),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [kOrange.withOpacity(0.8), kOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          // Thay đổi icon cho phù hợp
          child: const Icon(Icons.calendar_today_outlined, color: Colors.white, size: 28),
        ),
        const SizedBox(width: 12),
        const Text(
          'Mong Muốn Gặp Mặt',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  /// Xây dựng phần thông tin người đề nghị (THÊM ICON MŨI TÊN)
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
              TextSpan(text: ' muốn '),
              TextSpan(text: 'gặp riêng', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              TextSpan(text: ' với bạn để trao đổi thêm thông tin.'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage('https://pics.craiyon.com/2023-07-15/dc2ec5a571974417a5571420a4fb858a.webp'),
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