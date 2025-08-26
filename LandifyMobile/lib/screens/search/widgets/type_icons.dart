import 'package:flutter/material.dart';
import 'package:landifymobile/screens/search/models/property_type.dart';

final List<PropertyType> propertyTypes = [
  PropertyType(icon: Icons.apartment, label: 'Căn hộ/\nChung cư'),
  PropertyType(icon: Icons.home_outlined, label: 'Nhà ở'),
  PropertyType(icon: Icons.landscape_outlined, label: 'Đất'),
  PropertyType(icon: Icons.store_mall_directory_outlined, label: 'Văn phòng,\nMặt bằng'),
  PropertyType(icon: Icons.villa_outlined, label: 'Biệt thự'),
  PropertyType(icon: Icons.cabin_outlined, label: 'Nhà trọ'),
  PropertyType(icon: Icons.factory_outlined, label: 'Kho, xưởng'),
];

class PropertyTypeIcons extends StatelessWidget {
  const PropertyTypeIcons({super.key});

  @override
  Widget build(BuildContext context) {
    // THAY ĐỔI 3: Sử dụng SingleChildScrollView để cho phép cuộn ngang.
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      // Thêm padding để danh sách không bị dính sát vào lề màn hình
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
      child: Row(
        // Dùng .map() để tự động tạo các widget từ danh sách dữ liệu
        children: propertyTypes.map((type) {
          return _buildTypeIcon(type.icon, type.label);
        }).toList(),
      ),
    );
  }

  Widget _buildTypeIcon(IconData icon, String label) {
    // THAY ĐỔI 4: Bọc trong InkWell để biến mỗi mục thành một nút bấm.
    return InkWell(
      onTap: () {
        // TODO: Thêm logic xử lý sự kiện khi nhấn vào một loại BĐS
        print('$label đã được nhấn!');
      },
      // Thêm borderRadius để hiệu ứng gợn sóng được bo tròn đẹp mắt
      borderRadius: BorderRadius.circular(8.0),
      child: Padding(
        // Thêm padding để tăng vùng có thể nhấn và tạo khoảng cách giữa các mục
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 32, color: Colors.black87),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}