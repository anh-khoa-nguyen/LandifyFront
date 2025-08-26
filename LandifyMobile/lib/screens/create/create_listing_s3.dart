import 'package:flutter/material.dart';
import 'package:landifymobile/screens/create/promotion_screen.dart';
import 'view_model/create_listing_view_model.dart';
import 'models/listing_type.dart';
// Import các widget con của Bước 3
import 'widgets/step3/listing_selection.dart';
import 'widgets/step3/detailed_config.dart';
import 'widgets/step3/payment_summary.dart';

const Color kCardVipRed = Color(0xFFC20000);
const Color kCardVipGold = Color(0xFFC3810A);

class CreateListingStep3 extends StatefulWidget {
  final CreateListingViewModel viewModel;
  const CreateListingStep3({super.key, required this.viewModel});

  @override
  State<CreateListingStep3> createState() => _CreateListingStep3State();
}

class _CreateListingStep3State extends State<CreateListingStep3> {
  // Dữ liệu mẫu


  final List<ListingType> _listingTypes = [
    ListingType(
      id: 'vip_diamond',
      title: 'VIP Kim Cương',
      titleColor: kCardVipRed,
      subtitle: 'Hiển thị trên cùng',
      pricePerDay: '330.000 đ/ngày',
      benefitTag: 'x30 lượt liên hệ so với tin thường',
      tagColor: kCardVipRed,
      vipLevel: 1, // Cấp cao nhất
    ),
    ListingType(
      id: 'vip_gold',
      title: 'VIP Vàng',
      titleColor: kCardVipGold,
      subtitle: 'Dưới VIP Kim Cương',
      pricePerDay: '130.000 đ/ngày',
      benefitTag: 'x15 lượt liên hệ so với tin thường',
      tagColor: kCardVipGold,
      vipLevel: 2, // Cấp 2
    ),
    // Thêm các loại VIP khác nếu cần
  ];

  void _navigateToPromotion() async {
    final result = await Navigator.of(context).pushNamed(PromotionScreen.routeName);
    if (result != null && result is String) {
      widget.viewModel.updatePromotion(result);
    } else if (result == null) {
      widget.viewModel.updatePromotion(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sử dụng state từ ViewModel để quyết định hiển thị widget nào
    if (widget.viewModel.isConfirmingPayment) {
      // Hiển thị màn hình tóm tắt thanh toán
      return PaymentSummaryView(
        viewModel: widget.viewModel,
        listingTypes: _listingTypes,
      );
    } else if (widget.viewModel.selectedListingTypeId == null) {
      // Hiển thị màn hình chọn loại tin
      return ListingTypeSelectionView(
        viewModel: widget.viewModel,
        listingTypes: _listingTypes,
        onNavigateToPromotion: _navigateToPromotion,
      );
    } else {
      // --- BẮT ĐẦU SỬA LỖI ---
      // 1. Tìm đối tượng ListingType tương ứng
      final selectedType = _listingTypes.firstWhere(
            (t) => t.id == widget.viewModel.selectedListingTypeId,
        orElse: () => _listingTypes.first, // Fallback an toàn
      );

      // 2. Trả về widget cấu hình chi tiết và truyền đối tượng đã tìm thấy vào
      return DetailedConfigView(
        viewModel: widget.viewModel,
        selectedType: selectedType, // <-- SỬ DỤNG BIẾN ĐÃ KHAI BÁO
        onNavigateToPromotion: _navigateToPromotion,
      );
      // --- KẾT THÚC SỬA LỖI ---
    }
  }
}