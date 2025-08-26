// lib/screens/saved_listings/saved_listings_screen.dart
import 'package:flutter/material.dart';
import 'package:landifymobile/screens/home/models/property_listing.dart';
import 'package:landifymobile/screens/home/widgets/property_card.dart';

class SavedListingsScreen extends StatelessWidget {
  const SavedListingsScreen({super.key});

  // Sử dụng lại dữ liệu giả từ HomeScreen để minh họa
  static final List<DetailedPropertyListing> mockSavedListings = [
    DetailedPropertyListing(id: '1', mainImage: 'https://picsum.photos/seed/apartment1/800/600', image2: 'https://picsum.photos/seed/apartment2/400/300', image3: 'https://picsum.photos/seed/apartment3/400/300', image4: 'https://picsum.photos/seed/apartment4/400/300', tag: 'VIP Kim Cương', imageCount: 22, videoCount: 1, title: 'Mua bán chung cư cao cấp giá rẻ Hà Nội Sunshine Garden cạnh Times City - Hai Bà Trưng', price: '6,8 tỷ', area: '95 m²', pricePerSqm: '71,58 tr/m²', beds: 3, baths: 2, location: 'Hai Bà Trưng, Hà Nội', agentAvatar: 'https://picsum.photos/seed/agent2/100/100', agentName: 'Lê Việt Hoàng - NHC gr...', agentPhone: '0812395***', ),
    DetailedPropertyListing(id: '2', mainImage: 'https://picsum.photos/seed/house1/800/600', image2: 'https://picsum.photos/seed/house2/400/300', image3: 'https://picsum.photos/seed/house3/400/300', image4: 'https://picsum.photos/seed/house4/400/300', tag: 'VIP Kim Cương', imageCount: 15, videoCount: 0, title: 'Bán nhà mặt phố kinh doanh sầm uất, dòng tiền ổn định, vị trí đắc địa', price: '12,5 tỷ', area: '60 m²', pricePerSqm: '208 tr/m²', beds: 4, baths: 4, location: 'Đống Đa, Hà Nội', agentAvatar: 'https://picsum.photos/seed/agent3/100/100', agentName: 'Nguyễn Văn An', agentPhone: '0987654***', ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Tin đã lưu',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.grey.withOpacity(0.2),
        automaticallyImplyLeading: false, // Tắt nút back nếu không cần
      ),
      body: ListView.builder(
        itemCount: mockSavedListings.length,
        itemBuilder: (context, index) {
          final listing = mockSavedListings[index];
          // TẬN DỤNG LẠI WIDGET `PropertyCard`
          return PropertyCard(listing: listing);
        },
      ),
    );
  }
}