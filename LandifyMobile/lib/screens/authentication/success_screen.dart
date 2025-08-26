import 'package:flutter/material.dart';
import 'package:landifymobile/screens/authentication/login_screen.dart';
import 'package:landifymobile/screens/main_screen.dart';

class SignupSuccessScreen extends StatelessWidget {
  static const String routeName = '/signup-success';
  const SignupSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          // Sử dụng Center để căn giữa toàn bộ nội dung theo chiều dọc
          child: Center(
            child: Column(
              // Căn các widget con ở giữa theo chiều dọc của Column
              mainAxisAlignment: MainAxisAlignment.center,
              // Căn các widget con ở giữa theo chiều ngang của Column
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. Icon dấu tick
                Image.asset(
                  'assets/images/success_check.png', // <-- THAY BẰNG TÊN FILE ẢNH CỦA BẠN
                  height: 100,
                ),
                const SizedBox(height: 32),

                // 2. Tiêu đề "Hoàn thành!"
                const Text(
                  'HOÀN THÀNH!',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),

                // 3. Phụ đề
                Text(
                  'Quá trình đăng ký tài khoản của bạn đã hoàn tất, bạn có thể',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 48),

                // 4. Nút "Tới trang chủ"
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Điều hướng đến màn hình chính và xóa hết các màn hình cũ
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        MainScreen.routeName,
                            (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Tới trang chủ'),
                  ),
                ),
                const SizedBox(height: 16),

                // 5. Nút "Về đăng nhập"
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Điều hướng về màn hình đăng nhập và xóa hết các màn hình cũ
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        LoginScreen.routeName,
                            (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade800,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Về đăng nhập'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}