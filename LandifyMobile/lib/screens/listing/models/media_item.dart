enum MediaType { image, video, image360 }

// Class để chứa thông tin của mỗi item trong slider
class MediaItem {
  final String url;
  final MediaType type;

  MediaItem({required this.url, required this.type});
}