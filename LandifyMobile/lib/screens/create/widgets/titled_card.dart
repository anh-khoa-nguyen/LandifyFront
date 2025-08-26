import 'package:flutter/material.dart';

class TitledCard extends StatelessWidget {
  final String title;
  final Widget child;
  final bool isOptional;
  final Widget? action;

  const TitledCard({
    super.key,
    required this.title,
    required this.child,
    // THAY ĐỔI 2: Thêm vào constructor với giá trị mặc định là false
    this.isOptional = false,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tiêu đề
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(text: title),
                      if (isOptional)
                        TextSpan(
                          text: ' (không bắt buộc)',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              // THAY ĐỔI 3: Hiển thị widget action nếu nó không phải là null
              if (action != null)
                action!
              else
              // Nếu không có action, hiển thị icon mũi tên như cũ
                const Icon(Icons.keyboard_arrow_up),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}