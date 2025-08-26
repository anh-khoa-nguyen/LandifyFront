import 'package:flutter/material.dart';
import '../titled_card.dart';

class VideoSection extends StatelessWidget {
  const VideoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return TitledCard(
      title: 'Video',
      isOptional: true,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Dán đường dẫn Youtube hoặc Tiktok',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}