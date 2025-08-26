import 'package:flutter/material.dart';
import 'package:landifymobile/screens/home/models/property_listing.dart';

class PropertyListItem extends StatelessWidget {
  final DetailedPropertyListing listing;
  const PropertyListItem({super.key, required this.listing});

  @override
  Widget build(BuildContext context) {
    final String propertyInfo = '${listing.beds} PN · Nhà ngõ, hẻm';
    final bool isPriority = listing.tag.toLowerCase().contains('ưu tiên');

    // THAY ĐỔI 1: Bọc trong GestureDetector để toàn bộ item có thể được nhấn
    return GestureDetector(
      onTap: () {
        // TODO: Điều hướng đến trang chi tiết
        print('Tapped on item with ID: ${listing.id}');
      },
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        // THAY ĐỔI 2: Sử dụng Row làm layout chính
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Căn các item lên trên cùng
          children: [
            // Phần ảnh bên trái
            _buildImageSection(isPriority),
            const SizedBox(width: 16), // Khoảng cách giữa ảnh và thông tin

            // THAY ĐỔI 3: Bọc phần thông tin trong Expanded
            // Điều này rất quan trọng để text có thể tự động xuống dòng
            Expanded(
              child: _buildInfoSection(propertyInfo),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(bool isPriority) {
    // THAY ĐỔI 4: Bọc trong SizedBox để giới hạn chiều rộng của ảnh
    return SizedBox(
      width: 120,
      height: 170,
      child: Stack(
        fit: StackFit.expand, // Đảm bảo ClipRRect chiếm toàn bộ không gian của Stack
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.network(
              listing.mainImage,
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          if (isPriority)
            Positioned(
              // THAY ĐỔI 5: Di chuyển "Tin ưu tiên" xuống dưới
              bottom: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Tin ưu tiên', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            ),
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    listing.imageCount.toString(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String propertyInfo) {
    // Lưu ý: Model của bạn không có "số tin đăng", tôi sẽ tạm hard-code để giống UI
    const String agentListingCount = '8 tin đăng';

    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Phần thông tin trên cùng
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                listing.title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(propertyInfo, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
              const SizedBox(height: 8),
              // Dùng Wrap để giá tự xuống dòng nếu không đủ chỗ
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8.0, // Khoảng cách ngang
                runSpacing: 4.0, // Khoảng cách dọc khi xuống dòng
                children: [
                  Text(listing.price, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
                  Text(listing.pricePerSqm, style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                  Text('${listing.area} m²', style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, color: Colors.grey.shade600, size: 16),
                  const SizedBox(width: 4),
                  Text(listing.location, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                ],
              ),
            ],
          ),

          // Phần thông tin người bán ở dưới cùng
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundImage: NetworkImage(listing.agentAvatar),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(listing.agentName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(width: 4),
                      Icon(Icons.work_outline, size: 14, color: Colors.grey.shade600),
                    ],
                  ),
                  Text(agentListingCount, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                ],
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite_outline, color: Colors.black54, size: 28),
              ),
            ],
          ),
        ],
      ),
    );
  }
}