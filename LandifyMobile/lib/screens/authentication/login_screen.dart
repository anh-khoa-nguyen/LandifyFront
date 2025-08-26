// lib/screens/authentication/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart'; // <-- THÊM IMPORT

import 'package:landifymobile/blocs/authentication/auth_bloc.dart';
import 'package:landifymobile/blocs/authentication/auth_state.dart';
import 'package:landifymobile/repositories/auth_repository.dart'; // <-- THÊM IMPORT
import 'package:landifymobile/screens/authentication/otp_screen.dart'; // <-- THÊM IMPORT
import 'package:landifymobile/screens/authentication/signup_screen.dart';

import 'package:landifymobile/screens/authentication/styles/auth_styles.dart';
import 'package:landifymobile/screens/main_screen.dart';

import 'package:landifymobile/utils/theme/app_colors.dart';
import 'package:landifymobile/utils/theme/app_decorations.dart';
import 'package:landifymobile/utils/theme/app_text_styles.dart';

import 'package:landifymobile/screens/home/home_screen.dart';


class LoginScreen extends StatefulWidget {
  static const String routeName = '/';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  bool _isButtonEnabled = false;
  String _fullPhoneNumber = '';
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_validatePhoneNumber);
  }

  @override
  void dispose() {
    _phoneController.removeListener(_validatePhoneNumber);
    _phoneController.dispose();
    super.dispose();
  }

  void _validatePhoneNumber() {
    // Logic này có thể được cải tiến để kiểm tra độ dài chính xác hơn
    // nhưng hiện tại chỉ cần kiểm tra có số là đủ để bật nút
    final text = _phoneController.text;
    final bool isEnabled = text.isNotEmpty;

    if (isEnabled != _isButtonEnabled) {
      setState(() {
        _isButtonEnabled = isEnabled;
      });
    }
  }

  void _signInWithGoogle() async {
    // Nếu đang loading thì không làm gì cả
    if (_isLoading) return;

    // Bắt đầu loading
    setState(() {
      _isLoading = true;
    });

    try {
      // Gọi hàm signInWithGoogle từ repository
      await context.read<AuthRepository>().signInWithGoogle();

      // **LƯU Ý QUAN TRỌNG:**
      // Chúng ta không cần gọi Navigator.push ở đây.
      // Sau khi đăng nhập Firebase thành công, AuthBloc sẽ tự động
      // nhận biết, cập nhật state thành `Authenticated`, và BlocListener
      // ở trên cùng sẽ tự động xử lý việc điều hướng.

    } catch (e) {
      // Nếu có lỗi, hiển thị SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      // Dù thành công hay thất bại, luôn phải tắt loading
      // `if (mounted)` để đảm bảo widget vẫn còn tồn tại trước khi gọi setState
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onContinueButtonPressed() async {
    if (!_isButtonEnabled || _isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null; // Xóa lỗi cũ mỗi khi người dùng nhấn nút
    });

    String userEnteredPhone = _phoneController.text.trim();
    String countryCode = _fullPhoneNumber.substring(
        0, _fullPhoneNumber.length - userEnteredPhone.length);
    if (userEnteredPhone.startsWith('0')) {
      userEnteredPhone = userEnteredPhone.substring(1);
    }
    final String finalPhoneNumber = countryCode + userEnteredPhone;

    try {
      // SỬ DỤNG SỐ ĐIỆN THOẠI ĐÃ ĐƯỢC XỬ LÝ
      final statusResult = await context
          .read<AuthRepository>()
          .checkPhoneStatus(finalPhoneNumber);
      final status = statusResult['status'];

      if (status == 'not_registered') {
        // ... logic thông báo lỗi và gợi ý đăng ký ...
        setState(() {
          _isLoading = false;
          _errorMessage = 'Số điện thoại này chưa được đăng ký.';
        });
        return;
      }

      await context.read<AuthRepository>().requestFirebaseOtp(
        phoneNumber: finalPhoneNumber,
        onCodeSent: (String verificationId) {
          setState(() => _isLoading = false);
          Navigator.of(context).pushNamed(
            OtpVerificationScreen.routeName,
            arguments: {
              'verificationId': verificationId,
              'phoneNumber': finalPhoneNumber, // Truyền đi số đã được chuẩn hóa
              'status': status,
            },
          );
        },
        onVerificationFailed: (e) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi gửi OTP: ${e.message}')),
          );
        },
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())));
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        // BlocListener này vẫn rất quan trọng: nó sẽ tự động đăng nhập
        // nếu người dùng đã đăng nhập từ phiên trước đó.
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.of(context).pushReplacementNamed(MainScreen.routeName);
          }
          // Không cần xử lý AuthFailure ở đây vì màn hình này không chủ động gây ra lỗi
        },
        child: SingleChildScrollView(
          child: SizedBox(
            height: screenHeight,
            child: Column(
              children: [
                // --- PHẦN BANNER GIỮ NGUYÊN ---
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/login_banner.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // --- PHẦN FORM THAY ĐỔI HOÀN TOÀN ---
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: AuthStyles.whiteCard,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Đăng nhập', style: AuthStyles.header),
                        const SizedBox(height: 8),
                        const Text('Log in with your phone number',
                            style: AuthStyles.subHeader),
                        const SizedBox(height: 32),

                        // Ô NHẬP SĐT TỪ SIGNUPSCREEN
                        IntlPhoneField(
                          controller: _phoneController,
                          decoration: AuthStyles.textInputDecoration(
                              labelText: '').copyWith(
                            hintText: 'Nhập số điện thoại',
                            counterText: "",
                          ),
                          initialCountryCode: 'VN',
                          languageCode: 'vi',
                          disableLengthCheck: true,
                          onChanged: (phone) {
                            _fullPhoneNumber = phone.completeNumber;
                            _validatePhoneNumber();
                            if (_errorMessage != null) {
                              setState(() {
                                _errorMessage = null;
                              });
                            }
                          },
                        ),
                        if (_errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, left: 12.0),
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 14),
                            ),
                          ),

                        const SizedBox(height: 30),

                        // NÚT "TIẾP TỤC"
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: (_isButtonEnabled && !_isLoading)
                                ? _onContinueButtonPressed
                                : null,
                            style: AppDecorations.primaryButtonStyle(
                                isEnabled: _isButtonEnabled && !_isLoading),
                            child: _isLoading
                                ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 3),
                            )
                                : const Text('Tiếp tục',
                                style: AppTextStyles.primaryButtonText),
                          ),
                        ),

                        const SizedBox(height: 24),
                        _buildSocialLoginSection(), // <-- GỌI WIDGET MỚI Ở ĐÂY

                        const Spacer(), // Đẩy phần footer xuống dưới

                        // PHẦN FOOTER
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Bạn chưa có tài khoản?',
                                style: AppTextStyles.normalText),
                            TextButton(
                              onPressed: () {
                                // Điều hướng đến màn hình đăng ký (vốn có logic tương tự)
                                Navigator.of(context).pushNamed(
                                    SignupScreen.routeName);
                              },
                              child: const Text(
                                  'Đăng ký', style: AppTextStyles.linkText),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLoginSection() {
    return Column(
      children: [
        // Dòng kẻ "Hoặc đăng nhập với"
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey.shade300)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Hoặc đăng nhập với',
                  style: TextStyle(color: Colors.grey.shade600)),
            ),
            Expanded(child: Divider(color: Colors.grey.shade300)),
          ],
        ),
        const SizedBox(height: 24),
        // Các nút đăng nhập
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialLoginButton(
              imagePath: 'assets/images/google_logo.png',
              // Đảm bảo bạn có file này
              onPressed: _signInWithGoogle, // Sẽ tạo hàm này ở bước sau
            ),
            // Bạn có thể thêm các nút khác ở đây, ví dụ Facebook
            // const SizedBox(width: 24),
            // _buildSocialLoginButton(
            //   imagePath: 'assets/images/facebook_logo.png',
            //   onPressed: _signInWithFacebook,
            // ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialLoginButton({required String imagePath, required VoidCallback onPressed}) {
    return InkWell(
      onTap: _isLoading ? null : onPressed,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
            )
          ],
        ),
        child: Image.asset(imagePath, height: 24, width: 24),
      ),
    );
  }
}