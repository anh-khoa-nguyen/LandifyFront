import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:landifymobile/screens/authentication/styles/auth_styles.dart';
import 'package:landifymobile/utils/theme/app_decorations.dart';
import 'package:landifymobile/utils/theme/app_text_styles.dart';

import 'package:landifymobile/screens/authentication/otp_screen.dart';

import 'package:landifymobile/repositories/auth_repository.dart'; // Import
import 'package:flutter_bloc/flutter_bloc.dart'; // Import

class SignupScreen extends StatefulWidget {
  static const String routeName = '/signup';
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _phoneController = TextEditingController();
  bool _isButtonEnabled = false;
  String _fullPhoneNumber = '';
  bool _isLoading = false;
  String? _errorMessage;

  late TapGestureRecognizer _termsRecognizer;
  late TapGestureRecognizer _privacyRecognizer;
  late TapGestureRecognizer _rulesRecognizer;
  late TapGestureRecognizer _policyRecognizer;



  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_validatePhoneNumber);

    // Thêm một listener để theo dõi sự thay đổi trong ô nhập liệu
    _termsRecognizer = TapGestureRecognizer()..onTap = () => _onLinkTapped('Điều khoản sử dụng');
    _privacyRecognizer = TapGestureRecognizer()..onTap = () => _onLinkTapped('Chính sách bảo mật');
    _rulesRecognizer = TapGestureRecognizer()..onTap = () => _onLinkTapped('Quy chế');
    _policyRecognizer = TapGestureRecognizer()..onTap = () => _onLinkTapped('Chính sách');
  }

  @override
  void dispose() {
    _phoneController.removeListener(_validatePhoneNumber);
    // Hủy listener và controller để tránh rò rỉ bộ nhớ
    _phoneController.dispose();

    // THAY ĐỔI 3: Hủy các Recognizer để tránh rò rỉ bộ nhớ
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    _rulesRecognizer.dispose();
    _policyRecognizer.dispose();

    super.dispose();
  }

  /// Kiểm tra xem SĐT có đủ 10 chữ số hay không và cập nhật trạng thái nút
  void _validatePhoneNumber() {
    final text = _phoneController.text;
    bool isEnabled = false;

    // Trường hợp 1: Nếu bắt đầu bằng số 0, phải đủ 10 số
    if (text.startsWith('0')) {
      isEnabled = text.length == 10;
    }
    // Trường hợp 2: Nếu không bắt đầu bằng số 0, phải đủ 9 số
    else {
      isEnabled = text.length == 9;
    }

    // Cập nhật lại state nếu có sự thay đổi
    if (isEnabled != _isButtonEnabled) {
      setState(() {
        _isButtonEnabled = isEnabled;
      });
    }
  }

  void _onContinueButtonPressed() async {
    if (!_isButtonEnabled || _isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null; // Xóa lỗi cũ khi bắt đầu
    });

    // Logic xử lý số 0 ở đầu (giữ nguyên nếu bạn đã có)
    String userEnteredPhone = _phoneController.text.trim();
    String countryCode = _fullPhoneNumber.substring(0, _fullPhoneNumber.length - userEnteredPhone.length);
    if (userEnteredPhone.startsWith('0')) {
      userEnteredPhone = userEnteredPhone.substring(1);
    }
    final String finalPhoneNumber = countryCode + userEnteredPhone;

    try {
      final statusResult = await context.read<AuthRepository>().checkPhoneStatus(finalPhoneNumber);
      final status = statusResult['status'];

      if (status == 'registered') {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Số điện thoại này đã được đăng ký.';
        });
        return;
      }

      // Nếu SĐT chưa đăng ký, tiếp tục gửi OTP
      await context.read<AuthRepository>().requestFirebaseOtp(
        phoneNumber: finalPhoneNumber,
        onCodeSent: (String verificationId) {
          setState(() => _isLoading = false);
          Navigator.of(context).pushNamed(
            OtpVerificationScreen.routeName,
            arguments: {
              'verificationId': verificationId,
              'phoneNumber': finalPhoneNumber,
              'status': status, // 'not_registered'
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
    }
  }

  void _onLinkTapped(String linkName) {
    // TODO: Thêm logic mở trang web hoặc điều hướng đến màn hình tương ứng
    print('$linkName đã được nhấn!');
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight,
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      // Sử dụng AssetImage để tải ảnh từ thư mục assets
                      image: AssetImage('assets/images/login_banner.png'), // <-- THAY BẰNG TÊN FILE ẢNH CỦA BẠN
                      // BoxFit.cover đảm bảo ảnh lấp đầy không gian mà không bị méo
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // Phần form màu trắng ở dưới
              Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: AuthStyles.whiteCard,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Đăng ký tài khoản', style: AuthStyles.header),
                      const SizedBox(height: 8),
                      const Text('Sign up a new account', style: AuthStyles.subHeader),
                      const SizedBox(height: 32),

                      // Ô nhập liệu SĐT
                      IntlPhoneField(
                        controller: _phoneController,
                        decoration: AuthStyles.textInputDecoration(labelText: '').copyWith(
                          hintText: 'Nhập số điện thoại',
                          counterText: "", // Ẩn bộ đếm ký tự
                        ),
                        // Cấu hình cho thư viện
                        initialCountryCode: 'VN', // Mặc định là Việt Nam
                        languageCode: 'vi', // Ngôn ngữ cho danh sách quốc gia
                        disableLengthCheck: true, // Tắt kiểm tra độ dài mặc định của thư viện
                        onChanged: (phone) {
                          _fullPhoneNumber = phone.completeNumber;
                          _validatePhoneNumber();
                          // Khi người dùng bắt đầu gõ lại, xóa thông báo lỗi cũ
                          if (_errorMessage != null) {
                            setState(() {
                              _errorMessage = null;
                            });
                          }
                        },
                      ),

                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ),

                      const SizedBox(height: 30),

                      // Nút "Tiếp tục"
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          // Dùng `null` để vô hiệu hóa nút khi SĐT chưa đủ 10 số
                          onPressed: _isButtonEnabled ? _onContinueButtonPressed : null,
                          style: AppDecorations.primaryButtonStyle(isEnabled: _isButtonEnabled),
                          child: const Text('Tiếp tục', style: AppTextStyles.primaryButtonText),
                        ),
                      ),

                      const SizedBox(height: 24),
                      _buildSocialAndTermsSection(),

                      const Spacer(), // Đẩy phần footer xuống dưới cùng
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Bạn đã có tài khoản?', style: AppTextStyles.normalText),
                          TextButton(
                            onPressed: () {
                              // Quay lại màn hình trước đó (màn hình đăng nhập)
                              Navigator.of(context).pop();
                            },
                            child: const Text('Đăng nhập', style: AppTextStyles.linkText),
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
    );
  }
  Widget _buildSocialAndTermsSection() {
    return Column(
      children: [
        // 1. Đường kẻ với text ở giữa
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey.shade300)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Hoặc đăng ký với', style: TextStyle(color: Colors.grey.shade600)),
            ),
            Expanded(child: Divider(color: Colors.grey.shade300)),
          ],
        ),
        const SizedBox(height: 24),

        // 2. Các nút đăng nhập MXH
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialLoginButton(
              imagePath: 'assets/images/google_logo.png',
              onPressed: () { print('Login with Google'); },
            ),
            const SizedBox(width: 24),
            _buildSocialLoginButton(
              imagePath: 'assets/images/apple_logo.png',
              onPressed: () { print('Login with Apple'); },
            ),
          ],
        ),
        const SizedBox(height: 24),

        // 3. Text điều khoản sử dụng với RichText
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.5),
              children: <TextSpan>[
                const TextSpan(text: 'Bằng việc tiếp tục, bạn đồng ý với '),
                TextSpan(
                  text: 'Điều khoản sử dụng',
                  style: const TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                  recognizer: _termsRecognizer,
                ),
                const TextSpan(text: ', '),
                TextSpan(
                  text: 'Chính sách bảo mật',
                  style: const TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                  recognizer: _privacyRecognizer,
                ),
                const TextSpan(text: ', '),
                TextSpan(
                  text: 'Quy chế',
                  style: const TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                  recognizer: _rulesRecognizer,
                ),
                const TextSpan(text: ', '),
                TextSpan(
                  text: 'Chính sách',
                  style: const TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                  recognizer: _policyRecognizer,
                ),
                const TextSpan(text: ' của chúng tôi'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Hàm helper để tạo một nút đăng nhập MXH
  Widget _buildSocialLoginButton({required String imagePath, required VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
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