import 'package:flutter/material.dart';

const Color kPrimaryBlue = Color(0xFF165DFF);

class BottomProductCard extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onTap;
  const BottomProductCard({super.key, required this.onClose, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), image: const DecorationImage(image: NetworkImage('https://i.imgur.com/BoN9kdC.png'), fit: BoxFit.cover)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('nhà hẻm VIP ngay chợ', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('5,6 tỷ', style: TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              IconButton(onPressed: onClose, icon: const Icon(Icons.close, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}