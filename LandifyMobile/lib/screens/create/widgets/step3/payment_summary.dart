import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../view_model/create_listing_view_model.dart';
import '../../models/listing_type.dart';

class PaymentSummaryView extends StatelessWidget {
  final CreateListingViewModel viewModel;
  final List<ListingType> listingTypes; // Cần danh sách để lấy thông tin

  const PaymentSummaryView({
    super.key,
    required this.viewModel,
    required this.listingTypes,
  });

  @override
  Widget build(BuildContext context) {
    final selectedType = listingTypes.firstWhere((t) => t.id == viewModel.selectedListingTypeId);
    final formatter = DateFormat('dd/MM/yyyy');
    final endDate = viewModel.startDate.add(Duration(days: viewModel.selectedDuration));

    // Logic tính toán giá
    final pricePerDay = double.tryParse(selectedType.pricePerDay.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
    final postingFee = pricePerDay * viewModel.selectedDuration;
    final promotionDiscount = viewModel.selectedPromotion != null ? postingFee : 0.0;
    final totalAmount = postingFee - promotionDiscount;
    final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Thanh toán', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        // Thẻ xem trước
        Card(
          child: ListTile(
            leading: Image.network('https://picsum.photos/seed/house1/200/200', width: 60, height: 60, fit: BoxFit.cover),
            title: const Text('Bsnsbsbshshsnsbsbsbsbbsjjsjj', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Xã Phước Sang, Phú Giáo, Bình Dương'),
          ),
        ),
        const SizedBox(height: 24),
        // Chi tiết thanh toán
        _buildSummaryRow('Loại tin', selectedType.title),
        _buildSummaryRow('Đơn giá', selectedType.pricePerDay),
        _buildSummaryRow('Số ngày đăng', '${viewModel.selectedDuration} ngày'),
        _buildSummaryRow('Thời gian đăng', 'Đăng tin ngay'),
        _buildSummaryRow('Thời gian kết thúc', formatter.format(endDate)),
        const Divider(height: 32),
        _buildSummaryRow('Phí đăng tin', currencyFormatter.format(postingFee)),
        _buildSummaryRow(
          'Khuyến mãi',
          '-${currencyFormatter.format(promotionDiscount)}',
          valueColor: Colors.green,
          leadingIcon: Icons.confirmation_number_outlined,
        ),
        const Divider(height: 32),
        _buildSummaryRow('Tổng tiền', currencyFormatter.format(totalAmount), isTotal: true),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color? valueColor, IconData? leadingIcon, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          if (leadingIcon != null) ...[
            Icon(leadingIcon, color: Colors.grey, size: 20),
            const SizedBox(width: 8),
          ],
          Text(label, style: TextStyle(color: Colors.grey.shade700, fontSize: isTotal ? 18 : 14)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.black,
              fontSize: isTotal ? 18 : 14,
            ),
          ),
        ],
      ),
    );
  }
}