import 'package:flutter/material.dart';

class ListingType {
  final String id;
  final String title;
  final Color titleColor; // <-- Thêm màu cho tiêu đề
  final String subtitle;
  final String pricePerDay;
  final String benefitTag;
  final Color tagColor;
  final int vipLevel; // <-- Thêm cấp độ VIP (1=Diamond, 2=Gold, etc.)

  ListingType({
    required this.id,
    required this.title,
    required this.titleColor,
    required this.subtitle,
    required this.pricePerDay,
    required this.benefitTag,
    required this.tagColor,
    required this.vipLevel,
  });
}