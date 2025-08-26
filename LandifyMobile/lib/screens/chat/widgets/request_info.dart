import 'package:flutter/material.dart';

// Di chuyển hằng số màu vào đây vì widget này cần nó
const Color kDetailsButtonBlue = Color(0xFF5856D6);

/// Một widget con hiển thị bản xem trước của một tin đăng
/// trong một thẻ đề nghị (hợp tác, gặp mặt, etc.).
class RequestListingInfo extends StatelessWidget {
  const RequestListingInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            const Text('Tin đăng:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const Spacer(),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: kDetailsButtonBlue,
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('Xem chi tiết'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
            children: <TextSpan>[
              TextSpan(
                text: 'Tiêu đề: ',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
              ),
              TextSpan(text: '"nhà hẻm VIP ngay chợ - 127098617"'),
            ],
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network('https://picsum.photos/seed/tajmahal/400/300', fit: BoxFit.cover),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.home_outlined, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                'https://chotot.com/12323.html',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}