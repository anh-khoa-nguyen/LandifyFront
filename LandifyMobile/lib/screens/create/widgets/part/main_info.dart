import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Import formatter mới
import 'package:landifymobile/utils/formatters/thousands_formatter.dart';
import '../titled_card.dart';

class MainInfoSection extends StatelessWidget {
  final String? propertyType;
  final VoidCallback onPropertyTypeTapped;
  final TextEditingController areaController;
  final TextEditingController priceController;
  final Function(int) onPriceChipSelected;
  final String? priceErrorText;


  const MainInfoSection({
    super.key,
    this.propertyType,
    required this.onPropertyTypeTapped,
    required this.areaController,
    required this.priceController,
    required this.onPriceChipSelected,
    this.priceErrorText, // Thêm vào constructor

  });

  @override
  Widget build(BuildContext context) {
    return TitledCard(
      title: 'Thông tin chính',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabeledField(
            label: 'Loại BĐS',
            child: _buildDropdownField(propertyType ?? 'Chọn loại BĐS', onPropertyTypeTapped),
          ),
          const SizedBox(height: 16),
          _buildLabeledField(
            label: 'Diện tích',
            child: TextField(
              controller: areaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Nhập diện tích',
                suffixText: 'm²',
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))), // Bo tròn
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildLabeledField(
            label: 'Mức giá',
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    // THAY ĐỔI 2: Áp dụng formatter
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      ThousandsSeparatorInputFormatter(),
                    ],
                    decoration: InputDecoration(
                      hintText: 'Nhập giá',
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))), // Bo tròn
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      errorText: priceErrorText,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(30), // Bo tròn
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: 'VND',
                      items: <String>['VND', 'USD'].map((String value) {
                        return DropdownMenuItem<String>(value: value, child: Text(value));
                      }).toList(),
                      onChanged: (_) {},
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (priceController.text.isNotEmpty && priceErrorText == null) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: [
                _buildPriceChip('55,5 triệu', 55500000),
                _buildPriceChip('555 triệu', 555000000),
                _buildPriceChip('5,55 tỷ', 5550000000),
              ],
            )
          ]
        ],
      ),
    );
  }

  Widget _buildLabeledField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildDropdownField(String value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          // THAY ĐỔI 1: Bo tròn mạnh hơn
          borderRadius: BorderRadius.circular(30),
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
    );
  }

  Widget _buildPriceChip(String label, int amount) {
    return ActionChip(
      label: Text(label),
      onPressed: () => onPriceChipSelected(amount),
      shape: const StadiumBorder(),
    );
  }
}