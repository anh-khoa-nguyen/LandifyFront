import 'package:flutter/material.dart';

/// Widget hiển thị giao diện ban đầu của mục "Hình ảnh" khi chưa có ảnh nào được chọn.
///
/// Bao gồm hộp thông tin, các nút hành động, và các mục hướng dẫn có thể xổ ra.
class InitialImageView extends StatelessWidget {
  final VoidCallback onAddFromDevice;
  final VoidCallback onSelectFromLibrary;
  final bool isRulesExpanded;
  final ValueChanged<bool> onRulesExpansionChanged;
  final bool is360GuideExpanded;
  final ValueChanged<bool> on360GuideExpansionChanged;

  const InitialImageView({
    super.key,
    required this.onAddFromDevice,
    required this.onSelectFromLibrary,
    required this.isRulesExpanded,
    required this.onRulesExpansionChanged,
    required this.is360GuideExpanded,
    required this.on360GuideExpansionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Hộp thông tin yêu cầu
        _buildInfoBox('Đăng tối thiểu 3 ảnh thường'),
        const SizedBox(height: 12),

        // Nút "Thêm ảnh từ thiết bị"
        _buildActionButton(
          icon: Icons.add_photo_alternate_outlined,
          label: 'Thêm ảnh từ thiết bị',
          onPressed: onAddFromDevice,
        ),
        const SizedBox(height: 8),

        // Nút "Chọn từ thư viện BĐS"
        _buildActionButton(
          icon: Icons.collections_outlined,
          label: 'Chọn từ thư viện BĐS',
          onPressed: onSelectFromLibrary,
        ),
        const Divider(height: 32),

        // Mục hướng dẫn có thể xổ ra/thu lại
        _buildExpansionTile(
          icon: Icons.image_outlined,
          title: 'Quy định đăng ảnh thường',
          isExpanded: isRulesExpanded,
          onExpansionChanged: onRulesExpansionChanged,
          content: 'Để đảm bảo tải lên hình ảnh hợp lệ cho tin đăng, cần tuân thủ các quy định sau:\n'
              '• Các định dạng ảnh được hỗ trợ bao gồm: png, jpg, jpeg, gif, heic.\n'
              '• Đăng tối đa 24 ảnh với tất cả các loại tin.\n'
              '• Mỗi ảnh kích thước tối thiểu 100x100 px, dung lượng tối đa 15 MB.\n'
              '• Mô tả ảnh tối đa 45 kí tự.\n'
              '• Hãy dùng ảnh thật, không trùng, không chèn SĐT.',
        ),
        const Divider(indent: 40), // Đường kẻ thụt vào
        _buildExpansionTile(
          icon: Icons.threesixty_outlined,
          title: 'Hướng dẫn đăng ảnh 360°',
          isExpanded: is360GuideExpanded,
          onExpansionChanged: on360GuideExpansionChanged,
          content: 'Ảnh 360° được hỗ trợ bao gồm ảnh dạng hình cầu (Photo Sphere) và ảnh toàn cảnh (Panorama). Tin đăng có ảnh 360° sẽ được gắn nhãn 360°.\n'
              'Các bước thực hiện:\n'
              '1. Chụp ảnh 360° bất động sản của bạn theo một trong các cách sau:\n'
              '   a. Sử dụng thiết bị chụp ảnh 360° chuyên dụng.\n'
              '   b. Sử dụng điện thoại thông minh có chế độ chụp ảnh toàn cảnh Panorama.\n'
              '   c. Sử dụng điện thoại thông minh có cài đặt ứng dụng bên thứ 3. (VD: Google Street View hoặc Cardboard Camera)\n'
              '2. Tải ảnh lên bằng nút đăng ảnh hoặc kéo thả ảnh như thông thường.\n'
              '3. Đánh dấu vào ô 360° để chọn những ảnh bạn muốn hiển thị theo chế độ 360°.',
        ),
      ],
    );
  }

  // --- CÁC WIDGET HELPER ---

  /// Xây dựng hộp thông tin màu xám
  Widget _buildInfoBox(String text) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.grey.shade700),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  /// Xây dựng một nút hành động có viền
  Widget _buildActionButton({required IconData icon, required String label, required VoidCallback onPressed}) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        foregroundColor: Colors.black,
        side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
    );
  }

  /// Xây dựng một mục có thể xổ ra/thu lại
  Widget _buildExpansionTile({
    required IconData icon,
    required String title,
    required String content,
    required bool isExpanded,
    required ValueChanged<bool> onExpansionChanged,
  }) {
    return ExpansionTile(
      key: ValueKey(title), // Thêm key để giữ trạng thái khi rebuild
      initiallyExpanded: isExpanded,
      onExpansionChanged: onExpansionChanged,
      tilePadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(content, style: TextStyle(color: Colors.grey.shade700, height: 1.5)),
        ),
      ],
    );
  }
}