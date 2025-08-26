// lib/screens/verification/widgets/camera_overlay.dart
import 'package:flutter/material.dart';

class FaceOverlay extends StatelessWidget {
  const FaceOverlay({super.key});
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: true,
        child: CustomPaint(painter: FaceOverlayPainter()),
      ),
    );
  }
}

class CardOverlay extends StatelessWidget {
  const CardOverlay({super.key});
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: true,
        child: CustomPaint(painter: CardOverlayPainter()),
      ),
    );
  }
}

class FaceOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.55);
    canvas.drawRect(Offset.zero & size, paint);
    final ovalWidth = size.width * 0.75;
    final ovalHeight = ovalWidth * 1.25;
    final center = Offset(size.width / 2, size.height * 0.4);
    final r = RRect.fromRectAndRadius(Rect.fromCenter(center: center, width: ovalWidth, height: ovalHeight), Radius.circular(ovalWidth * 0.5));
    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawRRect(r, Paint()..blendMode = BlendMode.clear);
    final border = Paint()..color = Colors.white.withOpacity(0.95)..style = PaintingStyle.stroke..strokeWidth = 3;
    canvas.drawRRect(r, border);
    canvas.restore();
    final tp = TextPainter(text: const TextSpan(text: 'Đặt khuôn mặt vào khung', style: TextStyle(color: Colors.white70, fontSize: 14)), textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, Offset(center.dx - tp.width / 2, center.dy + ovalHeight / 2 + 12));
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CardOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.55);
    canvas.drawRect(Offset.zero & size, paint);
    final rectWidth = size.width * 0.9;
    final rectHeight = rectWidth * 0.63;
    final center = Offset(size.width / 2, size.height * 0.4);
    final rRect = RRect.fromRectAndRadius(Rect.fromCenter(center: center, width: rectWidth, height: rectHeight), const Radius.circular(14));
    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawRRect(rRect, Paint()..blendMode = BlendMode.clear);
    final border = Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 3;
    canvas.drawRRect(rRect, border);
    canvas.restore();
    final tp = TextPainter(text: const TextSpan(text: 'Đặt thẻ vào khung và chụp rõ ràng', style: TextStyle(color: Colors.white70, fontSize: 14)), textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, Offset(center.dx - tp.width / 2, center.dy + rectHeight / 2 + 12));
  }

  // THÊM PHƯƠNG THỨC CÒN THIẾU VÀO ĐÂY
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

