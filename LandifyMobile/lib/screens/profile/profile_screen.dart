import 'package:flutter/material.dart';
import 'package:landifymobile/screens/home/models/property_listing.dart';
// Import các widget con
import 'widgets/introduction_tab.dart';
import 'widgets/featured_tab.dart';
import 'widgets/listings_tab.dart';
import 'widgets/reviews_tab.dart';
import 'widgets/bottom_action_bar.dart';
import 'widgets/profile_header.dart';
import 'widgets/tab_bar.dart';
import 'widgets/app_bar.dart';

// --- DỮ LIỆU MẪU ---
final DetailedPropertyListing mockListing1 = DetailedPropertyListing(
  id: 'prop1', mainImage: 'https://picsum.photos/seed/bighouse/800/600', image2: '', image3: '', image4: '', tag: '', imageCount: 12, videoCount: 1, title: 'BÁN NHÀ 2 TẦNG TÂN PHÚ TRUNG - CỦ CHI | GIÁ CH...', price: '6.000.000.000 đ', pricePerSqm: '20 triệu/m²', area: '300 m²', beds: 4, baths: 3, location: 'Tp Hồ Chí Minh', agentAvatar: '', agentName: '', agentPhone: '',
);
final DetailedPropertyListing mockListing2 = DetailedPropertyListing(
  id: 'prop2', mainImage: 'https://picsum.photos/seed/apartment/800/600', image2: '', image3: '', image4: '', tag: '', imageCount: 5, videoCount: 0, title: 'BÁN NHÀ 4 TẦNG HẺM NHỰA 6M THÔNG HIỆP T...', price: '5.000.000.000 đ', pricePerSqm: '', area: '52 m²', beds: 4, baths: 4, location: 'Tp Hồ Chí Minh', agentAvatar: '', agentName: '', agentPhone: '',
);

final List<DetailedPropertyListing> mockAllListings = [mockListing1, mockListing2, mockListing1, mockListing2];
// --- KẾT THÚC DỮ LIỆU MẪU ---

class BrokerProfileScreen extends StatefulWidget {
  static const String routeName = '/broker-profile';
  const BrokerProfileScreen({super.key});

  @override
  State<BrokerProfileScreen> createState() => _BrokerProfileScreenState();
}

class _BrokerProfileScreenState extends State<BrokerProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    // THAY ĐỔI 2: Xóa listener khi không cần thiết
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            _buildSliverAppBar(context),
            BrokerStickyTabBar(
              tabController: _tabController,
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            const IntroductionTab(),
            FeaturedTab(listing1: mockListing1, listing2: mockListing2),
            ListingsTab(listings: mockAllListings),
            const ReviewsTab(),
          ],
        ),
      ),
      bottomNavigationBar: const BottomActionBar(),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      // THAY ĐỔI 2: Tăng chiều cao để có đủ không gian cho thông tin mới
      expandedHeight: 348.0,
      pinned: true,
      // ... các thuộc tính khác của SliverAppBar giữ nguyên
      flexibleSpace: FlexibleSpaceBar(
        // ...
        // THAY ĐỔI 3: Xóa title ở đây vì nó đã được xử lý trong header mới
        // title: const Text('MUỘI NHÀ ĐẤT 68', ...),
        background: const BrokerProfileHeader(),
      ),
    );
  }

}
