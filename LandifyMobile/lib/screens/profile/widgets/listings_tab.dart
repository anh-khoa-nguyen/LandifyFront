import 'package:flutter/material.dart';
import 'package:landifymobile/screens/home/models/property_listing.dart';
import 'package:landifymobile/screens/search/widgets/list_item.dart'; // Tận dụng

class ListingsTab extends StatelessWidget {
  final List<DetailedPropertyListing> listings;
  const ListingsTab({super.key, required this.listings});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: listings.length,
      itemBuilder: (context, index) => PropertyListItem(listing: listings[index]), // Tận dụng
    );
  }
}