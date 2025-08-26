import 'package:flutter/material.dart';

/// Một SliverPersistentHeader chứa TabBar để ghim nó ở trên cùng khi cuộn.
class BrokerStickyTabBar extends StatelessWidget {
  final TabController tabController;

  // Không cần currentIndex nữa
  const BrokerStickyTabBar({
    super.key,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: SliverTabBarDelegate(
        TabBar(
          controller: tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.orange,
          indicatorWeight: 3.0,

          // SỬ DỤNG LẠI CÁCH LÀM ĐƠN GIẢN VÀ HIỆU QUẢ
          labelStyle: const TextStyle(
            fontSize: 13.0, // Giảm font size
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 13.0, // Giảm font size
            fontWeight: FontWeight.normal,
          ),

          // Dùng lại Tab với text đơn giản
          tabs: const [
            Tab(text: 'GIỚI THIỆU'),
            Tab(text: 'NỔI BẬT'),
            Tab(text: 'TIN ĐĂNG'),
            Tab(text: 'ĐÁNH GIÁ'),
          ],
        ),
      ),
      pinned: true,
    );
  }
}

/// Lớp Delegate để ghim TabBar.
class SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  SliverTabBarDelegate(this._tabBar);
  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Colors.white, child: _tabBar);
  }

  @override
  bool shouldRebuild(SliverTabBarDelegate oldDelegate) => false;
}