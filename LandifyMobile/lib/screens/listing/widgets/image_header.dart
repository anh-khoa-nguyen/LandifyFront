import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chewie/chewie.dart';
import '../models/media_item.dart';
// import 'package:panorama/panorama.dart';
import 'package:panorama_viewer/panorama_viewer.dart';
import 'package:video_player/video_player.dart';

import 'photo_view.dart';

class PropertyImageHeader extends StatefulWidget {
  // Widget này giờ sẽ nhận một danh sách các media item
  final List<MediaItem> mediaItems;
  const PropertyImageHeader({super.key, required this.mediaItems});

  @override
  State<PropertyImageHeader> createState() => _PropertyImageHeaderState();
}

class _PropertyImageHeaderState extends State<PropertyImageHeader> {
  int _currentIndex = 0;

  void _openGallery(BuildContext context, int tappedIndex) {
    // 1. Lọc ra danh sách chỉ chứa URL của ảnh
    final List<String> imageUrls = widget.mediaItems
        .where((item) => item.type == MediaType.image)
        .map((item) => item.url)
        .toList();


    // 2. Tìm index mới của ảnh được nhấn trong danh sách chỉ chứa ảnh
    final String tappedImageUrl = widget.mediaItems[tappedIndex].url;
    final int initialIndexInGallery = imageUrls.indexOf(tappedImageUrl);

    // 3. Điều hướng đến màn hình xem ảnh
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewScreen(
          imageUrls: imageUrls,
          initialIndex: initialIndexInGallery,
        ),
      ),
    );
  }

  // Widget builder cho từng loại media
  Widget _buildMediaWidget(BuildContext context, int index) {
    final item = widget.mediaItems[index];
    Widget mediaWidget;

    switch (item.type) {
      case MediaType.image:
        mediaWidget = Image.network(item.url, fit: BoxFit.cover, width: double.infinity);
        break;
      case MediaType.video:
        mediaWidget = _VideoPlayerWidget(url: item.url);
        break;
      case MediaType.image360:
      // THAY ĐỔI 2: Đổi tên widget từ Panorama sang PanoramaViewer
        mediaWidget = PanoramaViewer(
          child: Image.network(item.url),
        );
        break;
    }

    // Bọc widget trong GestureDetector để bắt sự kiện nhấn
    return GestureDetector(
      onTap: () {
        // Chỉ mở gallery nếu item là ảnh
        if (item.type == MediaType.image) {
          _openGallery(context, index);
        }
      },
      child: mediaWidget,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Sử dụng Stack để đặt chỉ số slide ("1 / 5") lên trên slider
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider.builder(
          itemCount: widget.mediaItems.length,
          itemBuilder: (context, index, realIndex) {
            return _buildMediaWidget(context, index);
          },
          options: CarouselOptions(
            height: 350, // Tăng chiều cao để phù hợp với video và ảnh 360
            viewportFraction: 1.0, // Mỗi item chiếm toàn bộ chiều rộng
            enableInfiniteScroll: false, // Tắt cuộn vô hạn cho danh sách BĐS
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        // Chỉ số slide (ví dụ: "1 / 5")
        Positioned(
          bottom: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_currentIndex + 1} / ${widget.mediaItems.length}',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}

// Widget con chuyên để xử lý video player
class _VideoPlayerWidget extends StatefulWidget {
  final String url;
  const _VideoPlayerWidget({required this.url});

  @override
  State<_VideoPlayerWidget> createState() => __VideoPlayerWidgetState();
}

class __VideoPlayerWidgetState extends State<_VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    await _videoPlayerController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: true,
      // Tùy chỉnh thêm các option khác tại đây
    );
    setState(() {}); // Cập nhật UI sau khi controller đã sẵn sàng
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
        ? Chewie(controller: _chewieController!)
        : const Center(child: CircularProgressIndicator());
  }
}