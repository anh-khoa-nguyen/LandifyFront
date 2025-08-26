import 'package:flutter/material.dart';
import 'package:landifymobile/screens/create/widgets/titled_card.dart';
import 'package:landifymobile/screens/create/widgets/map_view.dart';

class AddressDisplay extends StatelessWidget {
  final String address;
  final VoidCallback onEdit;

  const AddressDisplay({super.key, required this.address, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return TitledCard(
      title: 'Địa chỉ BĐS',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text(address, style: const TextStyle(fontWeight: FontWeight.bold))),
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                onPressed: onEdit,
              ),
            ],
          ),
          const SizedBox(height: 8),
          MapView(address: address),
        ],
      ),
    );
  }
}