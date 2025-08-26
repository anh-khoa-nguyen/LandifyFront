import 'dart:io';
import 'package:flutter/material.dart';
import 'models/image_asset.dart';

class ImageEditScreen extends StatefulWidget {
  static const String routeName = '/image-edit';
  final List<ImageAsset> initialImages;

  const ImageEditScreen({super.key, required this.initialImages});

  @override
  State<ImageEditScreen> createState() => _ImageEditScreenState();
}

class _ImageEditScreenState extends State<ImageEditScreen> {
  late List<ImageAsset> _images;

  @override
  void initState() {
    super.initState();
    _images = List.from(widget.initialImages);
  }

  void _setAsCover(int index) {
    setState(() {
      // Bỏ chọn ảnh đại diện cũ
      for (var img in _images) {
        img.isCover = false;
      }
      // Đặt ảnh mới làm đại diện và đưa lên đầu
      _images[index].isCover = true;
      final coverImage = _images.removeAt(index);
      _images.insert(0, coverImage);
    });
  }

  void _deleteImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa hình ảnh (${_images.length})'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(_images), // Trả về danh sách đã cập nhật
        ),
      ),
      body: ReorderableListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _images.length,
        itemBuilder: (context, index) {
          final imageAsset = _images[index];
          return _buildReorderableItem(imageAsset, index, Key('$index'));
        },
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }
            final item = _images.removeAt(oldIndex);
            _images.insert(newIndex, item);
          });
        },
      ),
    );
  }

  Widget _buildReorderableItem(ImageAsset imageAsset, int index, Key key) {
    return Card(
      key: key,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        children: [
          Stack(
            children: [
              Image.file(File(imageAsset.file.path)),
              Positioned(
                top: 8,
                right: 8,
                child: ReorderableDragStartListener(
                  index: index,
                  child: const Icon(Icons.drag_handle, color: Colors.white),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Row(
                  children: [
                    _buildActionButton(
                      icon: imageAsset.isCover ? Icons.star : Icons.star_border,
                      onPressed: () => _setAsCover(index),
                      isActive: imageAsset.isCover,
                    ),
                    _buildActionButton(icon: Icons.threesixty, onPressed: () {}),
                    _buildActionButton(icon: Icons.rotate_90_degrees_ccw, onPressed: () {}),
                    _buildActionButton(icon: Icons.delete_outline, onPressed: () => _deleteImage(index)),
                  ],
                ),
              ),
            ],
          ),
          ListTile(
            title: Text(imageAsset.description ?? 'Thêm mô tả...'),
            trailing: const Icon(Icons.edit),
            onTap: () { /* TODO: Mở dialog sửa mô tả */ },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required VoidCallback onPressed, bool isActive = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: isActive ? Colors.yellow : Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}