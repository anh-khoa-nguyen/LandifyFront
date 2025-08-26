import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TotalSummary extends StatelessWidget {
  final double price;
  final double originalPrice;
  final bool hasPromotion;

  const TotalSummary({
    super.key,
    required this.price,
    required this.originalPrice,
    required this.hasPromotion,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Tổng tiền', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (hasPromotion)
                  Text(
                    formatter.format(originalPrice),
                    style: const TextStyle(
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                Text(
                  formatter.format(price),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}