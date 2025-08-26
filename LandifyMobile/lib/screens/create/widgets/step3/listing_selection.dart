import 'package:flutter/material.dart';
import '../../view_model/create_listing_view_model.dart';
import '../../models/listing_type.dart';
import 'listing_type.dart';
import 'promotion_row.dart';
import 'total_summary.dart';

class ListingTypeSelectionView extends StatelessWidget {
  final CreateListingViewModel viewModel;
  final List<ListingType> listingTypes;
  final VoidCallback onNavigateToPromotion;

  const ListingTypeSelectionView({
    super.key,
    required this.viewModel,
    required this.listingTypes,
    required this.onNavigateToPromotion,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Chọn loại tin', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton.icon(onPressed: () {}, icon: const Text('So sánh loại tin và giá'), label: const Icon(Icons.info_outline, size: 16)),
          ],
        ),
        const SizedBox(height: 8),
        ...listingTypes.map((type) => ListingTypeCard(
          type: type,
          isSelected: viewModel.selectedListingTypeId == type.id,
          onTap: () => viewModel.updateListingType(type.id),
        )),
        const SizedBox(height: 24),
        PromotionRow(
          hasPromotion: viewModel.selectedPromotion != null,
          onTap: onNavigateToPromotion,
        ),
        const SizedBox(height: 16),
        TotalSummary(price: 0, originalPrice: 0, hasPromotion: false), // Hiển thị giá 0 ban đầu
      ],
    );
  }
}