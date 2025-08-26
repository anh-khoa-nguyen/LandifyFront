import 'package:flutter/material.dart';
import 'titled_card.dart';

class AddressSection extends StatelessWidget {
  final String? address;
  final VoidCallback onAddressTapped;

  const AddressSection({super.key, this.address, required this.onAddressTapped});

  @override
  Widget build(BuildContext context) {
    return TitledCard(
      title: 'Địa chỉ BĐS',
      child: InkWell(
        onTap: onAddressTapped,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.grey),
              const SizedBox(width: 8),

              // --- BẮT ĐẦU THAY ĐỔI ---
              // Bọc Text trong Expanded để nó chiếm hết không gian còn lại
              Expanded(
                child: Text(
                  address ?? 'Nhập địa chỉ',
                  style: TextStyle(color: address != null ? Colors.black : Colors.grey),
                  // Thêm các thuộc tính này để xử lý overflow một cách đẹp mắt
                  overflow: TextOverflow.ellipsis, // Hiển thị "..." nếu quá dài
                  maxLines: 1,                      // Chỉ hiển thị trên 1 dòng
                ),
              ),
              // --- KẾT THÚC THAY ĐỔI ---
            ],
          ),
        ),
      ),
    );
  }
}