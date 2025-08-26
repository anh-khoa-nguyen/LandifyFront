import 'package:image_picker/image_picker.dart';

class ImageAsset {
  final XFile file;
  String? description;
  bool isCover;
  bool is360;

  ImageAsset({
    required this.file,
    this.description,
    this.isCover = false,
    this.is360 = false,
  });
}