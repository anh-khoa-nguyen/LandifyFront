import 'package:flutter/material.dart';
// Import widget header con mà SliverAppBar này cần
import 'profile_header.dart';

/// Một SliverAppBar tùy chỉnh cho màn hình trang cá nhân của môi giới.
///
/// Widget này chứa header có thể co giãn (ảnh bìa, avatar, các nút)
/// và sẽ thu nhỏ lại thành một AppBar thông thường khi cuộn.
class BrokerSliverAppBar extends StatelessWidget {
  const BrokerSliverAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300.0,
      floating: false,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 1.0,
      leading: const BackButton(color: Colors.black),
      actions: [
        IconButton(icon: const Icon(Icons.favorite_border, color: Colors.black54), onPressed: () {}),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        // Tiêu đề sẽ hiện ra khi cuộn lên
        title: const Text('MUỘI NHÀ ĐẤT 68', style: TextStyle(color: Colors.black, fontSize: 16)),
        centerTitle: false,
        // Nội dung chi tiết của header được cung cấp bởi widget BrokerProfileHeader
        background: const BrokerProfileHeader(),
      ),
    );
  }
}