import 'package:flutter/material.dart';
import 'package:landifymobile/screens/home/models/property_listing.dart';

import 'package:landifymobile/screens/listing/detail_screen.dart';

class PropertyCard extends StatelessWidget {
  final DetailedPropertyListing listing;
  const PropertyCard({super.key, required this.listing});

  @override
  Widget build(BuildContext context) {
    // BƯỚC 2: Bọc toàn bộ widget trong GestureDetector
    return GestureDetector(
      // BƯỚC 3: Thêm sự kiện onTap để thực hiện điều hướng
      onTap: () {
        print('Card with ID ${listing.id} was tapped.'); // Dòng này để debug
        Navigator.pushNamed(
          context,
          ListingDetailScreen.routeName, // Sử dụng routeName đã định nghĩa
          arguments: listing.id, // Truyền ID của bài đăng làm đối số
        );
      },
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Phần hình ảnh
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Image.network(listing.mainImage, height: 200, width: double.infinity, fit: BoxFit.cover),
                      Positioned(
                        top: 12, left: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                          ),
                          child: Text(listing.tag, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ),
                      Positioned(
                        bottom: 8, right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            children: [
                              if (listing.videoCount > 0) ...[
                                const Icon(Icons.play_circle_outline, color: Colors.white, size: 18),
                                const SizedBox(width: 4),
                              ],
                              const Icon(Icons.photo_library_outlined, color: Colors.white, size: 18),
                              const SizedBox(width: 4),
                              Text(listing.imageCount.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Expanded(child: Image.network(listing.image2, height: 80, fit: BoxFit.cover)),
                      const SizedBox(width: 2),
                      Expanded(child: Image.network(listing.image3, height: 80, fit: BoxFit.cover)),
                      const SizedBox(width: 2),
                      Expanded(child: Image.network(listing.image4, height: 80, fit: BoxFit.cover)),
                    ],
                  ),
                ],
              ),
            ),
            // Phần thông tin chi tiết
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(listing.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(listing.price, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
                      const SizedBox(width: 4),
                      const Text('·'),
                      const SizedBox(width: 4),
                      Text(listing.area, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.red)),
                      const SizedBox(width: 6),
                      const Text('·'),
                      const SizedBox(width: 4),
                      Text(' ${listing.beds}'),
                      const SizedBox(width: 4),
                      const Icon(Icons.king_bed_outlined, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      const Text('·'),
                      const SizedBox(width: 4),
                      Text(' ${listing.baths}'),
                      const SizedBox(width: 4),
                      const Icon(Icons.shower_outlined, size: 16, color: Colors.grey),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(listing.location, style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(listing.agentAvatar),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                listing.agentName,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Đăng hôm nay',
                                style: const TextStyle(color: Colors.grey, fontSize: 12),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.call, color: Colors.white, size: 18),
                          label: Text(listing.agentPhone, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                        ),
                        const SizedBox(width: 4),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(8),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                          child: const Icon(Icons.favorite, color: Colors.black54),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
