import 'package:flutter/material.dart';

// Import enum đã tạo
import '../models/filter_type.dart';

class FilterBottomSheet extends StatefulWidget {
  final FilterType initialFilterType;

  final Set<String> currentSelectedCategories;

  const FilterBottomSheet({
    super.key,
    required this.initialFilterType,
    this.currentSelectedCategories = const {},
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late FilterType _currentFilterType;

  late Set<String> _tempSelectedCategories;
  // State tạm thời cho các bộ lọc
  RangeValues _currentPriceRange = const RangeValues(0, 100);
  // Thêm các state khác ở đây, ví dụ:
  // Set<String> _selectedPropertyTypes = {};

  @override
  void initState() {
    super.initState();
    _currentFilterType = widget.initialFilterType;
    _tempSelectedCategories = Set.from(widget.currentSelectedCategories);
  }

  // Hàm để lấy tiêu đề dựa trên loại filter
  String _getTitle() {
    switch (_currentFilterType) {
      case FilterType.loaiBDS:
        return 'Danh mục';
      case FilterType.gia:
        return 'Giá thuê';
      case FilterType.locNangCao:
        return 'Lọc nâng cao';
      case FilterType.muaBan:
        return 'Tình trạng'; // Ví dụ
      default:
        return 'Lọc';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Header (Tiêu đề và nút đóng)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Text(_getTitle(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(width: 48), // Để căn giữa tiêu đề
            ],
          ),
          const Divider(),
          const SizedBox(height: 16),

          // 2. Nội dung Filter (thay đổi linh hoạt)
          _buildFilterContent(),

          const SizedBox(height: 24),

          // 3. Footer (Nút Xóa lọc và Áp dụng)
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: Xử lý xóa lọc
                    Navigator.of(context).pop(<String>{}); // Đóng và trả về null
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Xóa lọc'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Trả về dữ liệu đã lọc
                    if (_currentFilterType == FilterType.loaiBDS) {
                      Navigator.of(context).pop(_tempSelectedCategories);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade800,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Áp dụng'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Widget xây dựng nội dung chính của bộ lọc
  Widget _buildFilterContent() {
    switch (_currentFilterType) {
      case FilterType.loaiBDS:
        return _buildCategoryFilter();
      case FilterType.gia:
        return _buildPriceFilter();
      case FilterType.locNangCao:
        return _buildAdvancedFilter();
      default:
        return const SizedBox.shrink();
    }
  }

  // --- Các hàm xây dựng giao diện cho từng loại filter ---

  Widget _buildCategoryFilter() {
    final categories = ['Căn hộ/Chung cư', 'Nhà ở', 'Đất', 'Văn phòng, Mặt bằng kinh doanh', 'Phòng trọ'];
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: categories.map((label) {
        // Kiểm tra xem chip có đang được chọn trong state tạm thời không
        final isSelected = _tempSelectedCategories.contains(label);
        return ChoiceChip(
          label: Text(label),
          selected: isSelected,
          onSelected: (selected) {
            // Gọi setState để cập nhật UI ngay lập tức
            setState(() {
              if (selected) {
                _tempSelectedCategories.add(label);
              } else {
                _tempSelectedCategories.remove(label);
              }
            });
          },
          // Thêm style cho đẹp hơn
          backgroundColor: Colors.grey.shade200,
          selectedColor: Colors.black,
          labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
          showCheckmark: false,
        );
      }).toList(),
    );
  }

  Widget _buildPriceFilter() {
    return Column(
      children: [
        RangeSlider(
          values: _currentPriceRange,
          min: 0,
          max: 100,
          divisions: 100,
          labels: RangeLabels(
            '${_currentPriceRange.start.round()} triệu',
            '${_currentPriceRange.end.round()} triệu',
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _currentPriceRange = values;
            });
          },
        ),
        Row(
          children: [
            Expanded(child: TextField(decoration: InputDecoration(labelText: 'Giá tối thiểu'))),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 8.0), child: Text('-')),
            Expanded(child: TextField(decoration: InputDecoration(labelText: 'Giá tối đa'))),
          ],
        ),
      ],
    );
  }

  Widget _buildAdvancedFilter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Tin có video'),
            Switch(value: false, onChanged: (val) {}),
          ],
        ),
        // Thêm các bộ lọc nâng cao khác ở đây
      ],
    );
  }
}