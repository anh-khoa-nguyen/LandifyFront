import 'package:flutter/material.dart';
import 'package:landifymobile/screens/home/models/property_listing.dart';

class FeaturedPropertyCard extends StatelessWidget {
  final DetailedPropertyListing listing;
  const FeaturedPropertyCard({super.key, required this.listing});

  @override
  Widget build(BuildContext context) {
    // Xây dựng giao diện thẻ ngang cho BĐS nổi bật
    return SizedBox(
      width: 250,
      child: Card(
        margin: const EdgeInsets.only(right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(listing.mainImage, height: 150, width: double.infinity, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(listing.title, maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}