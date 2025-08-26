import 'package:flutter/material.dart';
import '../../models/listing_type.dart';

class ListingTypeCard extends StatelessWidget {
  final ListingType type;
  final bool isSelected;
  final bool isConfigView;
  final VoidCallback onTap;
  final Widget? durationOptions;

  const ListingTypeCard({
    super.key,
    required this.type,
    required this.isSelected,
    this.isConfigView = false,
    required this.onTap,
    this.durationOptions,
  });

  @override
  Widget build(BuildContext context) {
    // THAY THẾ Card BẰNG Container ĐỂ KIỂM SOÁT TỐT HƠN
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white, // Nền trắng
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? type.tagColor : Colors.grey.shade200,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: type.tagColor.withOpacity(0.15),
              blurRadius: 8,
              spreadRadius: 2,
            ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _VipLevelIcon(color: type.tagColor, level: type.vipLevel),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          type.title,
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: type.titleColor),
                        ),
                        // Sửa màu subtitle thành màu đen
                        SizedBox(height: 4),
                        Text(type.subtitle, style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(type.pricePerDay, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
              if (type.benefitTag.isNotEmpty) ...[
                const SizedBox(height: 8),
                _BenefitTag(text: type.benefitTag, color: type.tagColor),
              ],
              if (isConfigView && durationOptions != null) durationOptions!,
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget tùy chỉnh cho icon cấp độ VIP (ĐÃ SỬA LẠI)
class _VipLevelIcon extends StatelessWidget {
  final Color color;
  final int level;

  const _VipLevelIcon({required this.color, required this.level});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      child: Column(
        children: List.generate(4, (index) {
          final barIndex = index + 1;
          return Container(
            height: 4, // Tất cả các thanh có cùng độ dày
            margin: const EdgeInsets.only(bottom: 3),
            decoration: BoxDecoration(
              // Chỉ thanh được chọn mới có màu, còn lại màu xám
              color: barIndex == level ? color : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
      ),
    );
  }
}

/// Widget tùy chỉnh cho tag lợi ích (ĐÃ SỬA LẠI)
class _BenefitTag extends StatelessWidget {
  final String text;
  final Color color;

  const _BenefitTag({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    final parts = text.split(' ');
    final highlightPart = parts.first;
    final restPart = parts.sublist(1).join(' ');

    return ClipRRect(
      borderRadius: BorderRadius.circular(20), // Bo tròn mạnh hơn
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Phần 1: Hộp màu đặc cho "X30"
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            color: color,
            child: Text(
              highlightPart,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          // Phần 2: Hộp có nền gradient cho phần text còn lại
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.25), Colors.transparent],
                begin: Alignment.centerLeft,
                end: const Alignment(0.8, 0), // Gradient kết thúc sớm hơn
              ),
            ),
            child: Text(
              restPart,
              // Sửa màu chữ thành xám ghi
              style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w500, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}