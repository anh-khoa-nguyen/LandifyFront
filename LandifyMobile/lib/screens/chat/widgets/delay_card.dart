import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_count_down.dart';

// Widget này cũng cần dialog hủy hẹn, nên chúng ta tạo một hàm có thể tái sử dụng
// (Bạn có thể đặt hàm này trong một file utils riêng nếu muốn)
void showCancelWithReasonDialog(BuildContext context, {required String title}) {
  final reasonController = TextEditingController();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Cuộc hẹn này sẽ bị hủy.'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                hintText: 'Nhập lý do (tùy chọn)...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Hủy'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Xác nhận'),
            onPressed: () {
              // TODO: Gửi sự kiện hủy hẹn với lý do
              print('Hủy hẹn với lý do: ${reasonController.text}');
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

const Color kButtonLightPurple = Color(0xFFF0F0FD);
const Color kButtonDarkPurple = Color(0xFF5856D6);

class DelayRequestCard extends StatefulWidget {
  const DelayRequestCard({super.key});

  @override
  State<DelayRequestCard> createState() => _DelayRequestCardState();
}

class _DelayRequestCardState extends State<DelayRequestCard> {
  bool _isCountdownActive = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.grey.shade200),
        // Thêm ảnh nền họa tiết
        image: const DecorationImage(
          image: AssetImage('assets/images/warning_background.png'), // Bạn có thể dùng ảnh họa tiết khác
          fit: BoxFit.cover,
          opacity: 0.05,
        ),
      ),
      child: _isCountdownActive ? _buildCountdownView() : _buildRequestView(),
    );
  }

  /// Giao diện ban đầu của yêu cầu
  Widget _buildRequestView() {
    return Column(
      children: [
        const Text(
          'Người hẹn xin phép trễ: 15 phút',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // Căn giữa các nút
          children: [
            // Nút "Không đồng ý"
            OutlinedButton(
              onPressed: () {
                showCancelWithReasonDialog(
                  context,
                  title: 'Bạn không đồng ý?',
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red, // Màu chữ
                side: BorderSide(color: Colors.grey.shade300), // Viền xám nhạt
                shape: const StadiumBorder(), // Bo tròn
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text('Không đồng ý'),
            ),
            const SizedBox(width: 12),

            // Nút "Đồng ý"
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isCountdownActive = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kButtonLightPurple, // Nền tím nhạt
                foregroundColor: kButtonDarkPurple, // Chữ tím đậm
                elevation: 0, // Không có bóng
                shape: const StadiumBorder(), // Bo tròn
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              ),
              child: const Text('Đồng ý'),
            ),
          ],
        )
      ],
    );
  }

  /// Giao diện khi đã đồng ý và bắt đầu đếm ngược
  Widget _buildCountdownView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.alarm, color: Colors.red, size: 24),
        const SizedBox(width: 12),
        const Text('Thời gian đếm ngược: ', style: TextStyle(fontSize: 16)),
        Countdown(
          seconds: 900, // 15 phút
          build: (_, double time) {
            int minutes = (time / 60).floor();
            int seconds = (time % 60).floor();
            return Text(
              '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            );
          },
          onFinished: () {
            print('Hết giờ!');
          },
        ),
      ],
    );
  }
}