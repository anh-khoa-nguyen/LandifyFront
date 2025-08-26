import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:landifymobile/utils/theme/app_decorations.dart';
import 'package:landifymobile/utils/theme/app_text_styles.dart';
import 'package:landifymobile/utils/theme/app_colors.dart';
import 'package:landifymobile/screens/authentication/widgets/auth_header.dart';
import 'package:landifymobile/screens/authentication/styles/auth_styles.dart';

import 'package:landifymobile/screens/authentication/success_screen.dart';
import 'package:landifymobile/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserInfoScreen extends StatefulWidget {
  static const String routeName = '/user-info';
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  // State variables
  File? _avatarImage;
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController(); // THÊM CONTROLLER MẬT KHẨU
  String _selectedGender = 'Nam';
  DateTime? _selectedDate;

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Hàm xử lý việc chọn ảnh
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    // Mở thư viện ảnh
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      // THÊM CÁC THAM SỐ NÀY VÀO
      imageQuality: 80, // Giảm chất lượng xuống 80%
      maxWidth: 1024,   // Giảm chiều rộng tối đa xuống 1024px
    );

    if (image != null) {
      setState(() {
        _avatarImage = File(image.path);
      });
    }
  }

  /// Hàm xử lý việc chọn ngày sinh
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2004), // Ngày mặc định
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context)
  {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      // Bọc trong SingleChildScrollView để tránh lỗi overflow khi bàn phím hiện lên
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight,
          child: Column(
            children: [
              // 1. Header Banner
              Expanded(
                flex: 2,
                child: Stack(
                  children: [
                    // Sử dụng widget AuthHeaderBanner đã tạo
                    AuthHeaderBanner(
                      height: screenHeight * 2 / 7,
                      imagePath: 'assets/images/info_banner.png', // Hoặc một ảnh khác
                    ),
                    // Nút Back được đặt lên trên banner
                    Positioned(
                      top: 40,
                      left: 16,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Phần nội dung (Form)
              Expanded(
                flex: 5,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  decoration: AuthStyles.whiteCard,
                  // Thêm một SingleChildScrollView nội bộ cho phần form
                  // để cuộn nội dung nếu không đủ chỗ
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24), // Thêm padding trên
                        const Text('Thông tin cơ bản', style: AuthStyles.header),
                        const SizedBox(height: 8),
                        Text('Xin vui lòng dành một chút thời gian\nđể điền một số thông tin cơ bản', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                        const SizedBox(height: 10),
                        _buildAvatarSection(),
                        const SizedBox(height: 20),
                        _buildInfoCard(),
                        const SizedBox(height: 40),
                        _buildContinueButton(),
                        const SizedBox(height: 24), // Thêm padding dưới
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget cho phần Avatar
  Widget _buildAvatarSection() {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey.shade200,
          backgroundImage: _avatarImage != null ? FileImage(_avatarImage!) : null,
          child: _avatarImage == null
              ? Icon(Icons.person, size: 40, color: Colors.grey.shade400)
              : null,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            'Chụp ngay hoặc chọn từ thư viện tấm hình mà bạn yêu thích',
            style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
          ),
        ),
        const SizedBox(width: 16),
        IconButton(
          onPressed: _pickImage,
          icon: const Icon(Icons.camera_alt, color: Colors.white),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            padding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  /// Widget cho thẻ thông tin
  Widget _buildInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.grey.shade200, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTextField('Tên đầy đủ', 'Họ và tên', _nameController),
          Divider(height: 1, color: Colors.grey.shade200),
          _buildGenderSelector(),
          Divider(height: 1, color: Colors.grey.shade200),
          _buildDatePicker(context),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black12, fontWeight: FontWeight.normal),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          const Text('Giới tính:', style: TextStyle(fontSize: 16)),
          const Spacer(),
          Radio<String>(
            value: 'Nam',
            groupValue: _selectedGender,
            onChanged: (value) => setState(() => _selectedGender = value!),
          ),
          const Text('Nam'),
          const SizedBox(width: 16),
          Radio<String>(
            value: 'Nữ',
            groupValue: _selectedGender,
            onChanged: (value) => setState(() => _selectedGender = value!),
          ),
          const Text('Nữ'),
        ],
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ngày sinh', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                Text(
                  _selectedDate == null
                      ? 'Chọn ngày sinh của bạn'
                      : DateFormat('dd MMMM yyyy', 'vi_VN').format(_selectedDate!),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const Spacer(),
            Icon(Icons.calendar_today, color: AppColors.primaryBlue),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          // Lấy SĐT được truyền từ màn hình OTP
          final phoneNumber = ModalRoute.of(context)!.settings.arguments as String;

          // TODO: Thêm validation cho các trường (tên, mật khẩu không được rỗng)
          if (_nameController.text.isEmpty || _passwordController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Vui lòng điền đầy đủ tên và mật khẩu.')),
            );
            return;
          }

          // TODO: Hiển thị loading indicator

          try {
            // BƯỚC 4: Gọi API để CẬP NHẬT thông tin cho user đã được tạo ở backend
            // (Lưu ý: hàm trong repository nên được đổi tên thành updateNewUserInfo)
            await context.read<AuthRepository>().completeUserProfile(
              fullName: _nameController.text,
              gender: _selectedGender == 'Nam' ? 'male' : 'female',
              dateOfBirth: _selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : null,
              avatar: _avatarImage,
            );

            // SAU KHI THÀNH CÔNG:
            // Không cần gọi API login nữa. AuthBloc sẽ tự động phát hiện
            // trạng thái đăng nhập từ Firebase và lấy thông tin user.
            // Việc của chúng ta chỉ là điều hướng.

            // Điều hướng đến màn hình Hoàn thành và xóa tất cả các màn hình cũ
            Navigator.of(context).pushNamedAndRemoveUntil(
              SignupSuccessScreen.routeName,
                  (route) => false,
            );

          } catch (e) {
            // TODO: Ẩn loading indicator
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.toString())),
            );
          }
        },
        icon: const Icon(Icons.arrow_forward),
        label: const Text('Tiếp Tục'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}