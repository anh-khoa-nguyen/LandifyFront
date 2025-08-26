import 'package:flutter/material.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  const StepIndicator({super.key, required this.currentStep});

  // Helper function để lấy tiêu đề tương ứng với bước hiện tại
  String _getStepTitle(int step) {
    switch (step) {
      case 1:
        return 'Bước 1. Thông tin BĐS';
      case 2:
        return 'Bước 2. Mô tả';
      case 3:
        return 'Bước 3. Hoàn tất';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      // THAY ĐỔI 1: Layout gốc là một Column
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Hàng chứa Text: Chỉ hiển thị tiêu đề của bước hiện tại
          Text(
            _getStepTitle(currentStep),
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14, // Có thể điều chỉnh font size nếu muốn
            ),
          ),
          const SizedBox(height: 8),

          // 2. Hàng chứa các thanh Progress Bar
          Row(
            children: [
              // Sử dụng vòng lặp để tạo 3 thanh bar, giúp code gọn hơn
              for (int i = 1; i <= 3; i++) ...[
                // Expanded để mỗi thanh chiếm không gian bằng nhau
                Expanded(
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      // Nếu bước hiện tại >= chỉ số của thanh, tô màu đỏ
                      color: currentStep >= i ? Colors.red : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // Thêm khoảng cách giữa các thanh, trừ thanh cuối cùng
                if (i < 3) const SizedBox(width: 4),
              ],
            ],
          ),
        ],
      ),
    );
  }
}