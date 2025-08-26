import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../view_model/create_listing_view_model.dart';
import '../../models/listing_type.dart';
import 'listing_type.dart';
import 'promotion_row.dart';
import 'total_summary.dart';

class DetailedConfigView extends StatelessWidget {
  final CreateListingViewModel viewModel;
  final ListingType selectedType;
  final VoidCallback onNavigateToPromotion;

  const DetailedConfigView({
    super.key,
    required this.viewModel,
    required this.selectedType,
    required this.onNavigateToPromotion,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListingTypeCard(
          type: selectedType,
          isSelected: true,
          isConfigView: true,
          onTap: () => viewModel.updateListingType(selectedType.id), // Vẫn cho phép nhấn
          durationOptions: _buildDurationOptions(),
        ),
        const SizedBox(height: 24),
        _buildDatePicker(context, 'Ngày bắt đầu'),
        const SizedBox(height: 16),
        _buildDropdown('Hẹn giờ đăng tin', 'Đăng ngay bây giờ'),
        const SizedBox(height: 24),
        PromotionRow(
          hasPromotion: viewModel.selectedPromotion != null,
          onTap: onNavigateToPromotion,
        ),
        const SizedBox(height: 16),
        _buildTotalSummary(),
      ],
    );
  }

  /// Xây dựng các tùy chọn về thời hạn đăng tin
  Widget _buildDurationOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 24),
        const Text('Đăng dài ngày hơn, tiết kiệm hơn!', style: TextStyle(fontWeight: FontWeight.bold)),
        _buildDurationRow(10, '3.300 đ/ngày'),
        _buildDurationRow(15, '2.900 đ/ngày'),
        _buildDurationRow(30, '2.600 đ/ngày'),
      ],
    );
  }

  /// Xây dựng một hàng tùy chọn thời hạn
  Widget _buildDurationRow(int days, String price) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text('$days ngày'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(price),
          Radio<int>(
            value: days,
            groupValue: viewModel.selectedDuration,
            onChanged: (value) => viewModel.updateDuration(value!),
          ),
        ],
      ),
      onTap: () => viewModel.updateDuration(days),
    );
  }

  /// Xây dựng ô chọn ngày
  Widget _buildDatePicker(BuildContext context, String label) {
    final endDate = viewModel.startDate.add(Duration(days: viewModel.selectedDuration));
    final formatter = DateFormat('dd/MM/yyyy');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: viewModel.startDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (pickedDate != null) {
              viewModel.updateStartDate(pickedDate);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formatter.format(viewModel.startDate)),
                const Icon(Icons.calendar_today_outlined, color: Colors.grey),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'Kết thúc ngày ${formatter.format(endDate)}',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ),
      ],
    );
  }

  /// Xây dựng một ô dropdown giả
  Widget _buildDropdown(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () {
            // TODO: Hiển thị bottom sheet hoặc menu chọn giờ
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value),
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Xây dựng phần tóm tắt tổng tiền
  Widget _buildTotalSummary() {
    // Logic tính toán giá tiền được thực hiện bên trong widget TotalSummary
    // để giữ cho widget này chỉ có nhiệm vụ hiển thị.
    // Tuy nhiên, để đơn giản, chúng ta sẽ tính toán ở đây.
    double price = 0;
    final pricePerDay = double.tryParse(selectedType.pricePerDay.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
    price = pricePerDay * viewModel.selectedDuration;

    final originalPrice = price;
    bool hasPromotion = viewModel.selectedPromotion != null;
    if (hasPromotion) {
      price = 0;
    }

    return TotalSummary(
      price: price,
      originalPrice: originalPrice,
      hasPromotion: hasPromotion,
    );
  }
}
