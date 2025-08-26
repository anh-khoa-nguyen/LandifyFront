import 'package:flutter/material.dart';
import 'widgets/action_bottom.dart';
import 'widgets/comments_section.dart';
import 'widgets/description_section.dart';
import 'widgets/features_section.dart';
import 'widgets/image_header.dart';
import 'widgets/info_section.dart';
import 'widgets/seller_card.dart';

import 'models/media_item.dart';
import 'widgets/image_header.dart';

import 'package:share_plus/share_plus.dart';

import 'package:landifymobile/screens/report/report_screen.dart';
import 'package:landifymobile/screens/protest/protest_screen.dart';


enum MenuOption { report, save, share, protest }

final List<MediaItem> mockMedia = [
  MediaItem(url: 'https://res.cloudinary.com/dq2jtbrda/image/upload/v1752912326/tocotrachieu_uqllag.webp', type: MediaType.image),
  MediaItem(url: 'https://res.cloudinary.com/dq2jtbrda/image/upload/v1752912326/tocotrachieu_uqllag.webp', type: MediaType.image),
  // URL video mẫu
  MediaItem(
    url: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    type: MediaType.video,
  ),
  // URL ảnh 360 mẫu (cần là ảnh equirectangular)
  MediaItem(
    url: 'https://upload.wikimedia.org/wikipedia/commons/3/3f/2017.02.18_Equirectangular_DC_People_and_Places_3780_%2832132214284%29.jpg',
    type: MediaType.image360,
  ),
  MediaItem(url: 'https://picsum.photos/seed/slide3/900/600', type: MediaType.image),
];


class ListingDetailScreen extends StatelessWidget {
  static const routeName = '/listing-detail';
  final String listingId;

  const ListingDetailScreen({super.key, required this.listingId});

  void _onMenuSelected(MenuOption result, BuildContext context) async {
    const String listingTitle = 'CHÍNH CHỦ THANH LÝ NHÀ 2 TẦNG';
    final String listingUrl = 'https://example.com/listing/$listingId';

    switch (result) {
      case MenuOption.report:
        Navigator.of(context).pushNamed(ReportScreen.routeName);
        break;
      case MenuOption.save:
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('Đã thêm vào danh sách yêu thích!')));
        break;
      case MenuOption.protest:
        Navigator.of(context).pushNamed(ProtestScreen.routeName);
        break;
      case MenuOption.share:
      // 1. Tạo đối tượng ShareParams
        final params = ShareParams(
          text: 'Xem tin đăng này: $listingTitle\n$listingUrl',
          subject: 'Tin đăng bất động sản: $listingTitle',
        );
        final shareResult = await SharePlus.instance.share(params);
        if (shareResult.status == ShareResultStatus.success) {
          print('Chia sẻ thành công!');
        } else if (shareResult.status == ShareResultStatus.dismissed) {
          print('Người dùng đã hủy chia sẻ.');
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double bottomBarHeight = 76.0;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: const BackButton(color: Colors.white),
        actions: [
          PopupMenuButton<MenuOption>(
            onSelected: (result) => _onMenuSelected(result, context),
            icon: const Icon(Icons.more_vert, color: Colors.white),
            // Hàm xây dựng các item trong menu
            itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuOption>>[
              const PopupMenuItem<MenuOption>(
                value: MenuOption.report,
                child: Row(
                  children: [
                    Icon(Icons.flag_outlined, color: Colors.black54),
                    SizedBox(width: 8),
                    Text('Báo cáo tin'),
                  ],
                ),
              ),
              const PopupMenuItem<MenuOption>(
                value: MenuOption.protest,
                child: Row(
                  children: [
                    Icon(Icons.flag_outlined, color: Colors.black54),
                    SizedBox(width: 8),
                    Text('Kháng nghị tin'),
                  ],
                ),
              ),
              const PopupMenuItem<MenuOption>(
                value: MenuOption.save,
                child: Row(
                  children: [
                    Icon(Icons.bookmark_border, color: Colors.black54),
                    SizedBox(width: 8),
                    Text('Lưu tin'),
                  ],
                ),
              ),
              const PopupMenuItem<MenuOption>(
                value: MenuOption.share,
                child: Row(
                  children: [
                    Icon(Icons.share_outlined, color: Colors.black54),
                    SizedBox(width: 8),
                    Text('Chia sẻ tin'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: bottomBarHeight + 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            PropertyImageHeader(mediaItems: mockMedia),
            const PropertyInfoSection(),
            Divider(height: 8),
            const SellerCard(),
            SizedBox(height: 8),
            const FeaturesSection(),
            Divider(height: 30),
            const DescriptionSection(),
            Divider(height: 30),
            const CommentsSection(),
          ],
        ),
      ),
      // bottom cố định: 3 nút SMS, Chat, Gọi
      bottomNavigationBar: const ActionBottomBar(),
    );
  }
}