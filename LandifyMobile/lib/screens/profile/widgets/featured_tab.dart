import 'package:flutter/material.dart';
import 'package:landifymobile/screens/home/models/property_listing.dart';
import 'package:landifymobile/screens/search/widgets/list_item.dart'; // Tận dụng
import 'featured_property_card.dart';

class FeaturedTab extends StatelessWidget {
  final DetailedPropertyListing listing1;
  final DetailedPropertyListing listing2;
  const FeaturedTab({super.key, required this.listing1, required this.listing2});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildSectionTitle('Bất động sản nổi bật'),
        SizedBox(
          height: 280,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              FeaturedPropertyCard(listing: listing1),
              FeaturedPropertyCard(listing: listing2),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildSectionTitle('Tin đăng của môi giới'),
        PropertyListItem(listing: listing1), // Tận dụng
        PropertyListItem(listing: listing2), // Tận dụng
      ],
    );
  }
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}