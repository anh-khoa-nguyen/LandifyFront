import 'package:flutter/material.dart';
import '../models/filter_type.dart';

class FilterBar extends StatelessWidget {
  final Set<FilterType> activeFilters;
  final Function(FilterType) onFilterTap;

  const FilterBar({
    super.key,
    required this.activeFilters,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          _buildFilterButton(
            label: 'Lọc',
            icon: Icons.filter_list,
            type: FilterType.locNangCao,
          ),
          _buildFilterButton(label: 'Cho thuê', type: FilterType.muaBan),
          _buildFilterButton(label: 'Loại BĐS', type: FilterType.loaiBDS),
          _buildFilterButton(label: 'Giá thuê', type: FilterType.gia),
        ],
      ),
    );
  }

  Widget _buildFilterButton({
    required String label,
    required FilterType type,
    IconData? icon,
  }) {
    final bool isActive = activeFilters.contains(type);
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ElevatedButton(
        onPressed: () => onFilterTap(type),
        style: ElevatedButton.styleFrom(
          backgroundColor: isActive ? Colors.black87 : Colors.grey.shade200,
          foregroundColor: isActive ? Colors.white : Colors.black87,
          shape: const StadiumBorder(),
          elevation: 0,
        ),
        child: Row(
          children: [
            if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 4)],
            Text(label),
            if (icon == null) const Icon(Icons.arrow_drop_down, size: 20),
          ],
        ),
      ),
    );
  }
}