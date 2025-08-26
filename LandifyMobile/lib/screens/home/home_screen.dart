// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:landifymobile/screens/home/models/category.dart';
import 'package:landifymobile/screens/home/models/property_listing.dart';
import 'package:landifymobile/screens/home/widgets/home_header.dart';
import 'package:landifymobile/screens/home/widgets/listing_header.dart';
import 'package:landifymobile/screens/home/widgets/lower_categories.dart';
import 'package:landifymobile/screens/home/widgets/property_card.dart';
import 'package:landifymobile/screens/home/widgets/search_bar.dart';
import 'package:landifymobile/screens/home/widgets/top_categories.dart';

import 'package:landifymobile/screens/map/select_location.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
// --- DỮ LIỆU GIẢ ---
final List<IllustratedCategory> mockTopCategories = [
  IllustratedCategory(imagePath: 'assets/images/cate1.png', label: 'Mua bán'),
  IllustratedCategory(imagePath: 'assets/images/cate2.png', label: 'Cho Thuê'),
  IllustratedCategory(imagePath: 'assets/images/cate3.png', label: 'Dự án'),
  IllustratedCategory(imagePath: 'assets/images/cate4.png', label: 'Môi giới'),
];
final List<IconCategory> mockLowerCategories = [ IconCategory(icon: Icons.bar_chart_rounded, label: 'Biểu đồ giá'), IconCategory(icon: Icons.account_balance_wallet_outlined, label: 'Vay mua nhà'), IconCategory(icon: Icons.book_outlined, label: 'Kinh nghiệm'), IconCategory(icon: Icons.workspace_premium_outlined, label: 'Gói Pro'), IconCategory(icon: Icons.business_center_outlined, label: 'Tài khoản DN'), ];
final List<DetailedPropertyListing> mockListings = [ DetailedPropertyListing( id:"1",mainImage: 'https://picsum.photos/seed/livingroom/800/600', image2: 'https://picsum.photos/seed/sunset/400/300', image3: 'https://picsum.photos/seed/hallway/400/300', image4: 'https://picsum.photos/seed/bedroom/400/300', tag: 'VIP Kim Cương', imageCount: 10, videoCount: 1, title: 'Masterise Lakeside: Quỹ căn 2N, 3N VIP đẹp, cam kết giá tốt nhất thị trường. LH 0862200***', price: '4,55 tỷ', area: '71,5 m²', pricePerSqm: '63,66 tr/m²', beds: 2, baths: 2, location: 'Gia Lâm, Hà Nội', agentAvatar: 'https://picsum.photos/seed/agent/100/100', agentName: 'Lê Thị Hoàng Yến', agentPhone: '0862200***', ), ];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// --- GIAO DIỆN CHÍNH ---
class _HomeScreenState  extends State<HomeScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openLocationPicker() async {
    // THAY ĐỔI 2: Kết quả trả về bây giờ là một Map
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SelectLocationScreen(),
      ),
    );

    // THAY ĐỔI 3: Xử lý kết quả là Map
    if (result != null && result is Map) {
      final LatLng selectedPosition = result['position'];
      final String selectedAddress = result['address'];

      // Cập nhật text vào controller
      _searchController.text = selectedAddress;

      print('Vị trí đã chọn: Lat: ${selectedPosition.latitude}, Lng: ${selectedPosition.longitude}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã chọn địa chỉ: $selectedAddress')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomScrollView(
        slivers: [
          const HomeHeader(),
          HomeSearchBar(
            controller: _searchController,
            onMapPressed: _openLocationPicker,
          ),
          TopCategories(categories: mockTopCategories),
          LowerCategories(categories: mockLowerCategories),
          const ListingHeader(),
          SliverList.builder(
            itemCount: mockListings.length,
            itemBuilder: (context, index) {
              return PropertyCard(listing: mockListings[index]);
            },
          ),
        ],
      ),
    );
  }
}