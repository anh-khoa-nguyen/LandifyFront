import 'package:flutter/material.dart';
import 'package:landifymobile/screens/home/models/category.dart';

class TopCategories extends StatelessWidget {
  final List<IllustratedCategory> categories;
  const TopCategories({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: categories.map((category) {
            return Column(
              children: [
                Image.asset(
                  category.imagePath,
                  height: 70,
                  width: 70,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image_not_supported, size: 70);
                  },
                ),
                const SizedBox(height: 8),
                Text(category.label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}