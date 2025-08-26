import 'package:flutter/material.dart';
import 'package:landifymobile/screens/home/models/category.dart';

class LowerCategories extends StatelessWidget {
  final List<IconCategory> categories;
  const LowerCategories({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemBuilder: (context, index) {
            final category = categories[index];
            return Container(
              width: 80,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(16)),
                    child: Icon(category.icon, color: Colors.grey.shade700, size: 28),
                  ),
                  const SizedBox(height: 8),
                  Text(category.label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}