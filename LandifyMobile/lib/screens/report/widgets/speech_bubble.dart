import 'package:flutter/material.dart';

class SpeechBubble extends StatelessWidget {
  final String text;
  const SpeechBubble({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Phần thân của bong bóng (vẽ trước)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            text,
            style: TextStyle(color: Colors.grey.shade800, fontSize: 16),
          ),
        ),

        // Phần đuôi của bong bóng (một hình tam giác)
        Positioned(
          // THAY ĐỔI: Đặt vị trí ở cạnh trái và đẩy ra ngoài
          top: 15,   // Đặt ở vị trí 15px từ trên xuống
          left: -10, // Đẩy ra ngoài 10px về bên trái
          child: Transform.rotate(
            angle: -45 * 3.1415926535 / 180, // Vẫn xoay 45 độ để tạo hình thoi
            child: Container(
              width: 20,
              height: 20,
              color: Colors.grey.shade200, // Cùng màu với thân bong bóng
            ),
          ),
        ),
      ],
    );
  }
}