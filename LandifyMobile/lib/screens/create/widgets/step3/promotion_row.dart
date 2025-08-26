import 'package:flutter/material.dart';

class PromotionRow extends StatelessWidget {
  final bool hasPromotion;
  final VoidCallback onTap;

  const PromotionRow({super.key, required this.hasPromotion, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade300)),
      leading: const Icon(Icons.confirmation_number_outlined),
      title: const Text('Khuyến mãi'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
              hasPromotion ? 'Đã áp dụng' : 'Miễn phí 1 tin...',
              style: const TextStyle(color: Colors.green)
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: onTap,
    );
  }
}