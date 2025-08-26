import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:landifymobile/utils/theme/app_decorations.dart';
import 'package:landifymobile/utils/theme/app_text_styles.dart';
import 'package:landifymobile/screens/authentication/widgets/auth_header.dart';
import 'package:landifymobile/screens/authentication/styles/auth_styles.dart';

import 'package:landifymobile/screens/authentication/info_screen.dart';

import 'package:landifymobile/repositories/auth_repository.dart'; // Import
import 'package:flutter_bloc/flutter_bloc.dart'; // Import

import '../main_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  static const String routeName = '/otp-verification';
  final String phoneNumber;
  final String verificationId; // Thêm field mới

  const OtpVerificationScreen({super.key, required this.phoneNumber, required this.verificationId});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _pinController = TextEditingController();
  bool _isCountingDown = true; // Bắt đầu đếm ngược ngay khi vào màn hình

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _onConfirmButtonPressed() async {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final verificationId = arguments['verificationId']!;
    final phoneNumber = arguments['phoneNumber']!;
    final status = arguments['status']!; // "registered" hoặc "not_registered"

    final otpCode = _pinController.text;
    if (otpCode.length == 6) { // OTP của Firebase thường có 6 số
      // TODO: Hiển thị loading
      try {
        // Gọi repository để xác thực OTP và đăng nhập vào Firebase
        await context.read<AuthRepository>().verifyOtpAndSignIn(verificationId, otpCode);

        if (status == 'registered') {
          // Nếu SĐT đã đăng ký -> Đăng nhập thành công!
          // AuthBloc sẽ tự động nhận biết và điều hướng vào MainScreen.
          // Chúng ta không cần làm gì thêm ở đây.
          // Có thể xóa màn hình này khỏi stack để người dùng không back lại được.
          Navigator.of(context).pushNamedAndRemoveUntil(MainScreen.routeName, (route) => false);

        } else { // status == 'not_registered'
          // Nếu SĐT chưa đăng ký -> Đi đến màn hình điền thông tin
          Navigator.of(context).pushNamed(
            UserInfoScreen.routeName,
            arguments: phoneNumber,
          );
        }

      } catch (e) {
        // TODO: Ẩn loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng nhập đủ 6 số.')));
    }
  }

  void _onResendButtonPressed() {
    // TODO: Thêm logic gửi lại mã OTP ở đây
    print('Yêu cầu gửi lại mã OTP...');
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Đã gửi lại mã OTP.')));
    setState(() {
      _isCountingDown = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final defaultPinTheme = PinTheme(
      width: 60,
      height: 60,
      textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
    );

    return Scaffold(
      // Bỏ backgroundColor và appBar cũ
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight,
          child: Column(
            children: [
              // THAY ĐỔI 1: Thêm Header Banner vào đây
              // Bọc trong Stack để đặt nút Back lên trên
              Stack(
                children: [
                  AuthHeaderBanner(
                    height: screenHeight * 2 / 7, // (flex 2 / tổng flex 7)
                    imagePath: 'assets/images/otp_banner.png',
                  ),
                  Positioned(
                    top: 40,
                    left: 16,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),

              // THAY ĐỔI 2: Bọc nội dung trong Expanded và Container có style
              Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: AuthStyles.whiteCard, // Dùng lại style từ LoginScreen
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Xác Thực Mã', style: AuthStyles.header),
                      const SizedBox(height: 12),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.grey.shade700, fontSize: 16, height: 1.5),
                          children: <TextSpan>[
                            const TextSpan(text: 'Chúng tôi đã gửi mã xác thực gồm 4 chữ số\n'),
                            const TextSpan(text: 'đến số điện thoại '),
                            TextSpan(
                              text: widget.phoneNumber,
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      Center(
                        child: Pinput(
                          controller: _pinController,
                          length: 6,
                          defaultPinTheme: defaultPinTheme,
                          focusedPinTheme: defaultPinTheme.copyWith(
                            decoration: defaultPinTheme.decoration!.copyWith(
                              border: Border.all(color: Colors.orange.shade700),
                            ),
                          ),
                          onCompleted: (pin) => _onConfirmButtonPressed(),
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _onConfirmButtonPressed,
                          style: AppDecorations.primaryButtonStyle(),
                          child: const Text('Xác nhận', style: AppTextStyles.primaryButtonText),
                        ),
                      ),
                      const SizedBox(height: 40), // Thêm khoảng cách cố định

                      // THAY ĐỔI 3: Chuyển từ Row thành Column và căn giữa
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Không nhận được mã OTP?',
                              style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
                            ),
                            const SizedBox(height: 4), // Thêm khoảng cách nhỏ
                            _isCountingDown
                                ? _buildCountdownTimer()
                                : TextButton(
                              onPressed: _onResendButtonPressed,
                              child: const Text(
                                'Gửi lại',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20), // Thêm padding dưới
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget xây dựng đồng hồ đếm ngược
  Widget _buildCountdownTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Có thể gửi lại trong ', style: TextStyle(color: Colors.grey, fontSize: 15)),
        Countdown(
          seconds: 120, // 2 phút
          build: (_, double time) {
            int minutes = (time / 60).floor();
            int seconds = (time % 60).floor();
            return Text(
              '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
              style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 15),
            );
          },
          onFinished: () {
            // Khi đếm ngược kết thúc, cho phép gửi lại
            setState(() {
              _isCountingDown = false;
            });
          },
        ),
      ],
    );
  }
}