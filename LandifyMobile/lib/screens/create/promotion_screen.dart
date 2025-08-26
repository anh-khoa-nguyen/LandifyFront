import 'package:flutter/material.dart';

// Model giả lập cho khuyến mãi
class Promotion {
  final String id;
  final String title;
  final String description;
  final String expiryDate;
  // Bỏ quantity khỏi đây, vì nó sẽ được tính toán động

  Promotion({
    required this.id,
    required this.title,
    required this.description,
    required this.expiryDate,
  });
}

// Model mới để chứa dữ liệu đã được gom nhóm
class GroupedPromotion {
  final Promotion promotion;
  final int quantity;

  GroupedPromotion({required this.promotion, required this.quantity});
}

// Danh sách dữ liệu gốc, có thể có các khuyến mãi trùng lặp
final List<Promotion> mockPromotions = [
  Promotion(
    id: 'KHACHMOI',
    title: 'Miễn phí 1 tin thường 15 ngày cho Khách hàng mới.',
    description: 'Miễn phí 1 tin thường 15 ngày cho Khách hàng mới.',
    expiryDate: 'HSD: 02:59 16/02/2026',
  ),
  Promotion(
    id: 'KHACHMOI', // <-- Khuyến mãi trùng lặp
    title: 'Miễn phí 1 tin thường 15 ngày cho Khách hàng mới.',
    description: 'Miễn phí 1 tin thường 15 ngày cho Khách hàng mới.',
    expiryDate: 'HSD: 02:59 16/02/2026',
  ),
  Promotion(
    id: 'VIPTHANG8',
    title: 'Giảm 20% gói tin VIP Vàng trong tháng 8.',
    description: 'Áp dụng cho tất cả các tin đăng trong tháng 8.',
    expiryDate: 'HSD: 23:59 31/08/2025',
  ),
];

const Color kApplyButtonRed = Color(0xFFD92323);
const Color kGiftIconRed = Color(0xFFF44336);

class PromotionScreen extends StatefulWidget {
  static const String routeName = '/promotion';
  const PromotionScreen({super.key});

  @override
  State<PromotionScreen> createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> {
  String? _selectedPromoId;
  // Danh sách đã được gom nhóm
  List<GroupedPromotion> _groupedPromotions = [];

  @override
  void initState() {
    super.initState();
    _groupedPromotions = _groupPromotions(mockPromotions);
  }

  /// Hàm để gom nhóm các khuyến mãi trùng lặp
  List<GroupedPromotion> _groupPromotions(List<Promotion> promotions) {
    // Sử dụng Map để đếm số lần xuất hiện của mỗi id
    final Map<String, int> counts = {};
    for (var promo in promotions) {
      counts[promo.id] = (counts[promo.id] ?? 0) + 1;
    }

    // Tạo danh sách mới đã gom nhóm
    final List<GroupedPromotion> groupedList = [];
    final Set<String> processedIds = {}; // Để tránh thêm trùng lặp
    for (var promo in promotions) {
      if (!processedIds.contains(promo.id)) {
        groupedList.add(GroupedPromotion(
          promotion: promo,
          quantity: counts[promo.id]!,
        ));
        processedIds.add(promo.id);
      }
    }
    return groupedList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text('Khuyến mãi', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        // Dùng danh sách đã gom nhóm
        itemCount: _groupedPromotions.length,
        itemBuilder: (context, index) {
          final groupedPromo = _groupedPromotions[index];
          return _buildPromotionCard(groupedPromo);
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(child: OutlinedButton(onPressed: () => Navigator.of(context).pop(null), child: const Text('Bỏ khuyến mãi'))),
              const SizedBox(width: 16),
              Expanded(child: ElevatedButton(onPressed: () => Navigator.of(context).pop(_selectedPromoId), child: const Text('Áp dụng'))),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget helper để xây dựng một thẻ khuyến mãi (giờ nhận GroupedPromotion)
  Widget _buildPromotionCard(GroupedPromotion groupedPromo) {
    final promotion = groupedPromo.promotion;
    final isSelected = _selectedPromoId == promotion.id;
    return Card(
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? kApplyButtonRed : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _selectedPromoId = isSelected ? null : promotion.id;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: kGiftIconRed,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.card_giftcard, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(promotion.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text(promotion.description, style: TextStyle(color: Colors.grey.shade700)),
                        const SizedBox(height: 8),
                        Text(promotion.expiryDate, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Radio<String>(
                    value: promotion.id,
                    groupValue: _selectedPromoId,
                    onChanged: (value) {
                      setState(() => _selectedPromoId = value);
                    },
                    activeColor: kApplyButtonRed,
                  ),
                ],
              ),
            ),
          ),
          // Hiển thị số lượng từ GroupedPromotion
          if (groupedPromo.quantity > 1)
            Positioned(
              bottom: 8,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'x${groupedPromo.quantity}',
                  style: TextStyle(color: Colors.green.shade800, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }
}