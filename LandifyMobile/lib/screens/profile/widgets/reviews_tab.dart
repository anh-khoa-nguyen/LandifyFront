import 'package:flutter/material.dart';

class ReviewsTab extends StatelessWidget {
  const ReviewsTab({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildSectionTitle('Đánh giá từ khách hàng'),
          const SizedBox(height: 24),
          Image.asset('assets/images/reviews_placeholder.png'), // Thay bằng ảnh của bạn
          const SizedBox(height: 24),
          const Text('Bạn chưa có đánh giá nào', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          const Text('Hãy mua bán trên Chợ Tốt và đánh giá để xây dựng\ncộng đồng mua bán chất lượng hơn nhé!', textAlign: TextAlign.center),
        ],
      ),
    );
  }
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}