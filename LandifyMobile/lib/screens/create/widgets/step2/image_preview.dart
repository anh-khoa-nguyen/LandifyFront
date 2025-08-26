import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/image_asset.dart';

/// Widget hiển thị giao diện khi người dùng ĐÃ chọn ít nhất một ảnh.
///
/// Bao gồm một GridView các ảnh đã chọn và nút để thêm ảnh mới.
class ImagePreviewSection extends StatelessWidget {
  final List<ImageAsset> selectedImages;
  final VoidCallback onAddFromDevice;
  // Không cần onRemoveImage ở đây vì việc xóa/quản lý sẽ được thực hiện
  // trong màn hình Chỉnh sửa.
  final Function(int) onRemoveImage;


  const ImagePreviewSection({
    super.key,
    required this.selectedImages,
    required this.onAddFromDevice,
    required this.onRemoveImage,

  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // GridView hiển thị các ảnh đã chọn
        GridView.builder(
          // shrinkWrap và physics là bắt buộc khi đặt GridView trong SingleChildScrollView
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: selectedImages.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Hiển thị 2 ảnh trên một hàng
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.0, // Đảm bảo các ô là hình vuông
          ),
          itemBuilder: (context, index) {
            final imageAsset = selectedImages[index];
            return Stack(
              fit: StackFit.expand, // Cho phép các con chiếm toàn bộ không gian của ô
              clipBehavior: Clip.none, // Cho phép nút X tràn ra ngoài
              children: [
                // Ảnh chính
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(imageAsset.file.path),
                    fit: BoxFit.cover,
                    // Thêm frameBuilder để có hiệu ứng loading đẹp mắt
                    frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                      if (wasSynchronouslyLoaded) return child;
                      return AnimatedOpacity(
                        opacity: frame == null ? 0 : 1,
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeOut,
                        child: child,
                      );
                    },
                  ),
                ),
                // Tag "Ảnh đại diện"
                if (imageAsset.isCover)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Ảnh đại diện',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                // Lớp phủ "Thêm mô tả" ở dưới cùng
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      // TODO: Mở dialog để người dùng nhập mô tả cho ảnh này
                      print('Sửa mô tả cho ảnh tại index $index');
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              imageAsset.description ?? 'Thêm mô tả...',
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const Icon(Icons.edit, color: Colors.white, size: 16),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: -8,
                  right: -8,
                  child: GestureDetector(
                    onTap: () => onRemoveImage(index), // Gọi callback khi nhấn
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: Colors.white, size: 16),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        // Nút "Thêm ảnh từ thiết bị" sau khi đã có ảnh
        OutlinedButton.icon(
          onPressed: onAddFromDevice,
          icon: const Icon(Icons.add),
          label: const Text('Thêm ảnh từ thiết bị'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            foregroundColor: Colors.black,
            side: BorderSide(color: Colors.grey.shade300),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          ),
        ),
      ],
    );
  }
}