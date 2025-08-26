import 'package:flutter/material.dart';
import '../titled_card.dart';

class OtherInfoSection extends StatelessWidget {
  final int bedroomCount;
  final Function(int) onBedroomChanged;
  final int bathroomCount;
  final Function(int) onBathroomChanged;
  final int floorCount;
  final Function(int) onFloorChanged;
  // Thêm các state và callback khác nếu cần

  final String? legalPaper;
  final VoidCallback onLegalPaperTapped;
  final String? interior;
  final VoidCallback onInteriorTapped;
  final String? houseDirection;
  final VoidCallback onHouseDirectionTapped;
  final String? balconyDirection;
  final VoidCallback onBalconyDirectionTapped;

  const OtherInfoSection({
    super.key,
    required this.bedroomCount,
    required this.onBedroomChanged,
    required this.bathroomCount,
    required this.onBathroomChanged,
    required this.floorCount,
    required this.onFloorChanged,
    // Thêm vào constructor
    this.legalPaper,
    required this.onLegalPaperTapped,
    this.interior,
    required this.onInteriorTapped,
    this.houseDirection,
    required this.onHouseDirectionTapped,
    this.balconyDirection,
    required this.onBalconyDirectionTapped,
  });

  @override
  Widget build(BuildContext context) {
    return TitledCard(
      title: 'Thông tin khác',
      isOptional: true,
      child: Column(
        children: [
          _buildDropdownField('Giấy tờ pháp lý', legalPaper ?? 'Chọn giấy tờ pháp lý', onLegalPaperTapped),
          const SizedBox(height: 16),
          _buildDropdownField('Nội thất', interior ?? 'Chọn nội thất', onInteriorTapped),
          const Divider(height: 32),
          _buildNumberStepper('Số phòng ngủ', bedroomCount, onBedroomChanged),
          const Divider(height: 32),
          _buildNumberStepper('Số phòng tắm, vệ sinh', bathroomCount, onBathroomChanged),
          const Divider(height: 32),
          _buildNumberStepper('Số tầng', floorCount, onFloorChanged),
          const SizedBox(height: 16),
          _buildDropdownField('Hướng nhà', houseDirection ?? 'Chọn hướng nhà', onHouseDirectionTapped),
          const SizedBox(height: 16),
          _buildDropdownField('Hướng ban công', balconyDirection ?? 'Chọn hướng ban công', onBalconyDirectionTapped),
        ],
      ),
    );
  }

  /// Widget helper để tạo một ô dropdown giả
  Widget _buildDropdownField(String label, String value, VoidCallback onTap) {
    // Xác định xem đây là placeholder hay giá trị thật
    final bool isPlaceholder = value.startsWith('Chọn');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30), // Bo tròn mạnh hơn
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // THAY ĐỔI 3: Đổi màu chữ dựa trên isPlaceholder
                Text(
                  value,
                  style: TextStyle(color: isPlaceholder ? Colors.grey : Colors.black),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Widget helper để tạo một bộ đếm số (tăng/giảm)
  Widget _buildNumberStepper(String label, int count, Function(int) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              // Vô hiệu hóa nút trừ khi số lượng > 0
              onPressed: count > 0 ? () => onChanged(count - 1) : null,
            ),
            Text('$count', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => onChanged(count + 1),
            ),
          ],
        ),
      ],
    );
  }
}