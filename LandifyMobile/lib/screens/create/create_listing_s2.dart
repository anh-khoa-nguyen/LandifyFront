import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'models/image_asset.dart'; // Model mới cho ảnh
import 'image_edit.dart';   // Màn hình chỉnh sửa ảnh
import 'widgets/titled_card.dart';           // Widget TitledCard tái sử dụng

import 'widgets/step2/image_preview.dart';
import 'widgets/step2/initial_image_view.dart';
import 'widgets/step2/video_section.dart';

class CreateListingStep2 extends StatefulWidget {
  // Callbacks để giao tiếp với màn hình cha (ViewModel)
  final Function(ImageSource) onAddFromDevice;
  final VoidCallback onSelectFromLibrary;
  final List<ImageAsset> selectedImages;
  final Function(List<ImageAsset>) onImagesUpdated;
  final Function(int) onRemoveImage; // <-- Thêm callback này

  const CreateListingStep2({
    super.key,
    required this.onAddFromDevice,
    required this.onSelectFromLibrary,
    required this.selectedImages,
    required this.onImagesUpdated,
    required this.onRemoveImage,
  });

  @override
  State<CreateListingStep2> createState() => _CreateListingS2State();
}

class _CreateListingS2State extends State<CreateListingStep2> {
  bool _isRulesExpanded = false;
  bool _is360GuideExpanded = false;

  void _navigateToEditScreen() async {
    final updatedImages = await Navigator.of(context).push<List<ImageAsset>>(
      MaterialPageRoute(
        builder: (context) => ImageEditScreen(initialImages: widget.selectedImages),
      ),
    );
    if (updatedImages != null) {
      widget.onImagesUpdated(updatedImages);
    }
  }

  void _showImageSourceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Thêm ảnh từ thiết bị', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Chọn từ Thư viện ảnh'),
                onTap: () {
                  Navigator.of(context).pop();
                  widget.onAddFromDevice(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Chụp ảnh'),
                onTap: () {
                  Navigator.of(context).pop();
                  widget.onAddFromDevice(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Section Hình ảnh
        TitledCard(
          title: 'Hình ảnh',
          action: widget.selectedImages.isNotEmpty
              ? OutlinedButton.icon(
            onPressed: _navigateToEditScreen,
            icon: const Icon(Icons.edit_outlined, size: 16),
            label: const Text('Chỉnh sửa'),
            style: OutlinedButton.styleFrom(
              shape: const StadiumBorder(),
              foregroundColor: Colors.black,
            ),
          )
              : null,
          child: widget.selectedImages.isEmpty
          // Gọi widget con cho giao diện ban đầu
              ? InitialImageView(
            onAddFromDevice: () => _showImageSourceSheet(context),
            onSelectFromLibrary: widget.onSelectFromLibrary,
            isRulesExpanded: _isRulesExpanded,
            onRulesExpansionChanged: (expanded) => setState(() => _isRulesExpanded = expanded),
            is360GuideExpanded: _is360GuideExpanded,
            on360GuideExpansionChanged: (expanded) => setState(() => _is360GuideExpanded = expanded),
          )
          // Gọi widget con cho giao diện xem trước ảnh
              : ImagePreviewSection(
            selectedImages: widget.selectedImages,
            onAddFromDevice: () => _showImageSourceSheet(context),
            onRemoveImage: widget.onRemoveImage,
          ),
        ),
        const SizedBox(height: 16),
        // Gọi widget con cho section Video
        const VideoSection(),
      ],
    );
  }
}