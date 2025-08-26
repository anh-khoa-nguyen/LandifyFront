import 'package:flutter/material.dart';
import '../models/filter_type.dart'; // Import enum để định nghĩa loại filter
import 'filter_bar.dart';         // Import widget thanh filter
import 'type_icons.dart';        // Import widget lưới icon loại BĐS

/// Widget Header cho màn hình tìm kiếm.
///
/// Widget này là StatelessWidget, nó nhận tất cả dữ liệu và các hàm xử lý
/// từ widget cha (SearchScreen) để hiển thị và thông báo lại khi có tương tác.
class SearchHeader extends StatelessWidget {
  // Dữ liệu cho bộ lọc thành phố
  final List<String> cities;
  final int selectedCityIndex;
  final Function(int) onCitySelected;

  // Dữ liệu và callback cho thanh filter chính
  final Set<FilterType> activeFilters;
  final Function(FilterType) onFilterTap;

  /// Constructor yêu cầu tất cả các tham số cần thiết.
  const SearchHeader({
    super.key,
    required this.cities,
    required this.selectedCityIndex,
    required this.onCitySelected,
    required this.activeFilters,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    // Dữ liệu giả, sau này bạn có thể truyền vào như một tham số
    String selectedLocation = 'Toàn quốc';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Dòng chọn khu vực chính và nút xóa lọc
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
          child: Row(
            children: [
              TextButton(
                onPressed: () {
                  // TODO: Thêm logic mở pop-up chọn khu vực ở đây
                  print('Nút chọn khu vực đã được nhấn!');
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  alignment: Alignment.centerLeft,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        children: <TextSpan>[
                          const TextSpan(
                            text: 'Khu vực: ',
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                          TextSpan(
                            text: selectedLocation,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_drop_down, color: Colors.black54),
                  ],
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text('Xóa lọc', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),

        // 2. Thanh Filter Bar chính (Lọc, Cho thuê, Loại BĐS, Giá)
        FilterBar(
          activeFilters: activeFilters,
          onFilterTap: onFilterTap,
        ),

        // 3. Dòng chọn nhanh các thành phố phổ biến
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 5, 16, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Khu vực:',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: List.generate(cities.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(cities[index]),
                          selected: selectedCityIndex == index,
                          onSelected: (bool selected) {
                            // Gọi callback để báo cho widget cha biết sự thay đổi
                            onCitySelected(index);
                          },
                          backgroundColor: Colors.white,
                          selectedColor: Colors.black,
                          labelStyle: TextStyle(
                            color: selectedCityIndex == index ? Colors.white : Colors.black87,
                          ),
                          shape: StadiumBorder(
                            side: BorderSide(
                              color: selectedCityIndex == index ? Colors.black : Colors.grey.shade300,
                            ),
                          ),
                          showCheckmark: false,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),

        // 4. Lưới các icon loại Bất động sản
        const PropertyTypeIcons(),

        // 5. Nút "Lưu tìm kiếm"
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.bookmark_border),
            label: const Text('Lưu tìm kiếm'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 44),
              foregroundColor: Colors.black,
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}