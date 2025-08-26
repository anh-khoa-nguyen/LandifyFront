import 'package:flutter/material.dart';
import 'package:landifymobile/screens/verification/models/auth_method.dart';
import 'package:landifymobile/screens/verification/pages/camera_scan.dart';
import 'package:landifymobile/screens/verification/widgets/verification_option.dart';

class VerificationSelectionPage extends StatefulWidget {
  const VerificationSelectionPage({super.key});
  @override
  State<VerificationSelectionPage> createState() => _VerificationSelectionPageState();
}

class _VerificationSelectionPageState extends State<VerificationSelectionPage> {
  AuthMethod _method = AuthMethod.nfcCard;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('Xác thực sinh trắc học', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.help_outline, color: Colors.black54))],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(width: 44, height: 44, decoration: BoxDecoration(color: Colors.pink.shade50, borderRadius: BorderRadius.circular(10)), child: const Center(child: Text('😺', style: TextStyle(fontSize: 22)))),
                    const SizedBox(width: 12),
                    const Expanded(child: Text('Vui lòng thực hiện sinh trắc học trước khi thực hiện các hành vi trên môi trường giao dịch.', style: TextStyle(fontWeight: FontWeight.w600))),
                  ],
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
            child: Column(
              children: [
                SizedBox(height: 8),
                Icon(Icons.account_circle, size: 96, color: Colors.black26),
                SizedBox(height: 8),
                Text('Xác thực sinh trắc học', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                SizedBox(height: 8),
                Align(alignment: Alignment.centerLeft, child: Text('Vui lòng thực hiện các bước:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6),
            child: VerificationOption(
              value: AuthMethod.nfcCard,
              groupValue: _method,
              onChanged: (v) => setState(() => _method = v),
              icon: Icons.credit_card,
              title: 'Xác thực bằng CCCD gắn chip',
              subtitle: '(Dành cho thiết bị hỗ trợ NFC)',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6),
            child: VerificationOption(
              value: AuthMethod.face,
              groupValue: _method,
              onChanged: (v) => setState(() => _method = v),
              icon: Icons.face,
              title: 'Xác thực khuôn mặt',
              subtitle: '(Đối chiếu với thẻ CCCD)',
            ),
          ),
          const Spacer(),
          Container(
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                  child: Row(
                    children: [
                      Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.pink.shade50, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.check_circle_outline, color: Colors.pink)),
                      const SizedBox(width: 12),
                      const Expanded(child: Text('Thông tin của bạn được bảo mật và chỉ sử dụng trong quá trình xác thực của Landify')),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => CameraScanPage(initialMethod: _method))),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: const Text('Xác thực ngay', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}