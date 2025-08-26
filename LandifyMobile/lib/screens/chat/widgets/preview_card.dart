import 'package:flutter/material.dart';

const Color kPrimaryBlue = Color(0xFF165DFF);
const Color kPropertyCardBg = Color(0xFFFFF4D9);

class PropertyPreviewCard extends StatelessWidget {
  const PropertyPreviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      decoration: BoxDecoration(
        color: kPropertyCardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 12, top: 10, right: 12),
            child: Text('https://chotot.com/127098617.htm', style: TextStyle(color: kPrimaryBlue, fontSize: 13)),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            child: Image.network('https://i.imgur.com/4QfKuz1.jpg', height: 140, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('nhà hẻm VIP ngay chợ - 127098617', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text('Nhà pháp lý rõ ràng - 2 mặt tiền hẻm xe công...', style: TextStyle(color: Colors.grey.shade800, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.home, size: 14, color: Colors.orange),
                      SizedBox(width: 6),
                      Text('www.nhatot.com', style: TextStyle(fontSize: 12, color: Colors.orange)),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}