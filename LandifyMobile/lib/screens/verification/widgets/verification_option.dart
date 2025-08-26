import 'package:flutter/material.dart';
import 'package:landifymobile/screens/verification/models/auth_method.dart';

class VerificationOption extends StatelessWidget {
  final AuthMethod value;
  final AuthMethod groupValue;
  final Function(AuthMethod) onChanged;
  final IconData icon;
  final String title;
  final String subtitle;

  const VerificationOption({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Colors.pink.shade50 : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.pink.shade200 : Colors.grey.shade300,
            width: 1.8,
          ),
        ),
        child: Row(
          children: [
            Radio<AuthMethod>(
              value: value,
              groupValue: groupValue,
              onChanged: (v) => onChanged(v!),
              activeColor: Colors.pink,
            ),
            const SizedBox(width: 6),
            Icon(icon, color: Colors.pink),
            const SizedBox(width: 8),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w700, fontSize: 15, fontFamily: 'Be Vietnam Pro'),
                  children: [
                    TextSpan(text: '$title\n'),
                    TextSpan(
                        text: subtitle,
                        style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black54, fontSize: 13)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}