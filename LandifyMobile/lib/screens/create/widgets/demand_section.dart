import 'package:flutter/material.dart';
import 'titled_card.dart';
import 'selectable_card.dart';

class DemandSection extends StatelessWidget {
  final String? selectedDemand;
  final Function(String) onDemandSelected;

  const DemandSection({super.key, this.selectedDemand, required this.onDemandSelected});

  @override
  Widget build(BuildContext context) {
    return TitledCard(
      title: 'Nhu cầu',
      child: Row(
        children: [
          Expanded(
            child: SelectableCard(
              icon: Icons.sell_outlined,
              label: 'Bán',
              isSelected: selectedDemand == 'Bán',
              onTap: () => onDemandSelected('Bán'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SelectableCard(
              icon: Icons.key_outlined,
              label: 'Cho thuê',
              isSelected: selectedDemand == 'Cho thuê',
              onTap: () => onDemandSelected('Cho thuê'),
            ),
          ),
        ],
      ),
    );
  }
}