import 'package:flutter/material.dart';
// Import model và widget item đã có
import 'package:landifymobile/screens/home/models/property_listing.dart';
import 'package:landifymobile/screens/search/widgets/list_item.dart'; // Giả sử đây là đường dẫn đúng

// --- DỮ LIỆU MẪU ---
// Bạn có thể thay thế bằng dữ liệu thật từ API
final List<DetailedPropertyListing> mockPostedListings = [
  DetailedPropertyListing(
    id: 'prop1',
    mainImage: 'https://picsum.photos/seed/mountain/800/600',
    image2: '', image3: '', image4: '',
    tag: 'Tin ưu tiên',
    imageCount: 11,
    videoCount: 0,
    title: 'NHÀ NGAY CHỢ MINH PHÁT, CHUNG CƯ PIKITY',
    price: '5,5 tỷ',
    pricePerSqm: '100 tr/m²',
    area: '55 m²',
    beds: 4,
    baths: 3,
    location: 'Tp Hồ Chí Minh',
    agentAvatar: 'https://picsum.photos/seed/agent1/100/100',
    agentName: 'Mrtrường',
    agentPhone: '',
  ),
  DetailedPropertyListing(
    id: 'prop2',
    mainImage: 'https://picsum.photos/seed/sunset/800/600',
    image2: '', image3: '', image4: '',
    tag: 'Tin thường',
    imageCount: 8,
    videoCount: 1,
    title: 'BÁN NHÀ ĐẸP LUNG LINH, GIÁP Q1, TẶNG NỘI THẤT CƠ BẢN',
    price: '4,95 tỷ',
    pricePerSqm: '141 tr/m²',
    area: '35 m²',
    beds: 3,
    baths: 2,
    location: 'Tp Hồ Chí Minh',
    agentAvatar: 'https://picsum.photos/seed/agent2/100/100',
    agentName: 'Hoàng Yến',
    agentPhone: '',
  ),
  // Thêm vài item nữa để danh sách dài hơn
  DetailedPropertyListing(
    id: 'prop3',
    mainImage: 'https://picsum.photos/seed/mountain/800/600',
    image2: '', image3: '', image4: '',
    tag: 'Tin ưu tiên',
    imageCount: 11,
    videoCount: 0,
    title: 'NHÀ NGAY CHỢ MINH PHÁT, CHUNG CƯ PIKITY',
    price: '5,5 tỷ',
    pricePerSqm: '100 tr/m²',
    area: '55 m²',
    beds: 4,
    baths: 3,
    location: 'Tp Hồ Chí Minh',
    agentAvatar: 'https://picsum.photos/seed/agent1/100/100',
    agentName: 'Mrtrường',
    agentPhone: '',
  ),
];

/// Màn hình hiển thị danh sách các tin đã đăng của người dùng.
class PostedListingsScreen extends StatelessWidget {
  static const String routeName = '/posted-listings';
  const PostedListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // DefaultTabController là cách dễ nhất để kết nối TabBar và TabBarView
    return DefaultTabController(
      length: 3, // Số lượng tab
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1.0, // Thêm một đường bóng mờ nhẹ
          leading: const BackButton(color: Colors.black87),
          title: const Text(
            'Tin đã đăng',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
          ),
          // `bottom` của AppBar là nơi hoàn hảo để đặt TabBar
          bottom: const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            tabs: [
              Tab(text: 'Tất cả'),
              Tab(text: 'Cá nhân'),
              Tab(text: 'Môi giới'),
            ],
          ),
        ),
        // TabBarView chứa nội dung cho mỗi tab
        body: TabBarView(
          children: [
            // Nội dung cho tab "Tất cả"
            _buildListingsView(),

            // Placeholder cho các tab khác
            const Center(child: Text('Danh sách tin cá nhân')),
            const Center(child: Text('Danh sách tin môi giới')),
          ],
        ),
      ),
    );
  }

  /// Widget xây dựng danh sách các tin đăng.
  /// Tái sử dụng widget PropertyListItem.
  Widget _buildListingsView() {
    return ListView.separated(
      // Thêm padding để danh sách không bị dính sát vào TabBar
      padding: const EdgeInsets.only(top: 8.0),
      itemCount: mockPostedListings.length,
      itemBuilder: (context, index) {
        // Tận dụng lại widget bạn đã cung cấp
        return PropertyListItem(listing: mockPostedListings[index]);
      },
      // Thêm đường kẻ phân cách giữa các item
      separatorBuilder: (context, index) => Divider(
        height: 1,
        thickness: 1,
        color: Colors.grey.shade200,
        indent: 16,
        endIndent: 16,
      ),
    );
  }
}