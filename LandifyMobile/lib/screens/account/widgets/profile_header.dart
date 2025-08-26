import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:landifymobile/models/user_model.dart';

import 'package:landifymobile/blocs/profile/profile_bloc.dart';
import 'package:landifymobile/blocs/profile/profile_event.dart';
import 'package:landifymobile/blocs/profile/profile_state.dart';

import 'package:landifymobile/utils/theme/app_colors.dart';
import 'package:landifymobile/screens/verification/verification_screen.dart';
import 'package:landifymobile/screens/profile/profile_screen.dart';

// Phần Header và Thẻ thông tin cá nhân
class ProfileHeader extends StatefulWidget {
  final UserModel user;
  const ProfileHeader({super.key, required this.user});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  File? _avatarImage;

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Chụp ảnh mới'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Chọn từ thư viện'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Hàm xử lý việc chọn ảnh và gửi event đến BLoC
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    // Lấy ảnh từ camera hoặc thư viện, có nén và giảm kích thước để upload nhanh hơn
    final XFile? image = await picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 800,
    );

    if (image != null) {
      final imageFile = File(image.path);

      // 1. Cập nhật UI ngay lập tức để người dùng thấy ảnh mới
      setState(() {
        _avatarImage = imageFile;
      });

      // 2. Gửi event đến ProfileBloc để bắt đầu upload lên server
      // context.read<ProfileBloc>() sẽ tìm ProfileBloc được cung cấp ở AccountScreen
      context.read<ProfileBloc>().add(ProfileAvatarChanged(avatarFile: imageFile));
    }
  }

  @override
  Widget build(BuildContext context) {
    final String initials = widget.user.fullName.isNotEmpty
        ? widget.user.fullName.split(' ').map((e) => e[0]).take(2).join()
        : '';

    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        final bool isUpdating = profileState.status == ProfileUpdateStatus.inProgress;

        final String initials = widget.user.fullName.isNotEmpty
            ? widget.user.fullName.split(' ').map((e) => e[0]).take(2).join().toUpperCase()
            : '';

        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: AppColors.primaryOrange.withOpacity(0.15),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
            ),
              Positioned(
                top: 60,
                right: 16,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.palette_outlined, size: 18),
                  label: const Text('Đổi hình nền'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black54,
                    shape: const StadiumBorder(),
                    elevation: 2,
                  ),
                ),
              ),
            SizedBox(height: 10),
            Positioned(
              top: 120,
              left: 16,
              right: 16,
              child: Card(
                color: Colors.white, // Đảm bảo nền thẻ là màu trắng
                elevation: 4,
                shadowColor: Colors.grey.withOpacity(0.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 16, left: 16, right: 16),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildFollowButton('Người theo dõi', 0),
                            _buildFollowButton('Đang theo dõi', 0),
                          ],
                        ),
                      ),
                      Text(widget.user.fullName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(widget.user.phoneNumber, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                          const SizedBox(width: 8),
                          _buildVerificationBadge(widget.user),
                        ],
                      ),
                      const SizedBox(height: 5),
                      const Divider(),
                      Row(
                        children: [
                          Expanded(
                            child: _buildLinkButton(Icons.qr_code_2, 'Trang cá nhân', () {
                              Navigator.of(context).pushNamed(BrokerProfileScreen.routeName);
                            }),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildLinkButton(Icons.fingerprint, 'Sinh trắc học', () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const VerificationSelectionPage(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Avatar
            Positioned(
              top: 85,
              // THAY ĐỔI 3: Bọc Stack của Avatar trong GestureDetector để bắt sự kiện nhấn
              child: GestureDetector(
                onTap: isUpdating ? null : () => _showImageSourceActionSheet(context),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 38,
                        backgroundColor: const Color(0xFFFDE8D7),
                        // THAY ĐỔI 4: Cập nhật backgroundImage và child để hiển thị ảnh đã chọn
                        backgroundImage: _avatarImage != null
                            ? FileImage(_avatarImage!)
                            : (widget.user.avatar != null
                            ? NetworkImage(widget.user.avatar!) // <-- HIỂN THỊ AVATAR TỪ API
                            : null) as ImageProvider?,
                        child: (_avatarImage == null && widget.user.avatar == null)
                            ? Text(
                          initials, // <-- HIỂN THỊ CHỮ CÁI ĐẦU
                          style: const TextStyle(fontSize: 28, color: AppColors.primaryOrange, fontWeight: FontWeight.bold),
                        )
                            : null,
                      ),
                    ),
                    if (isUpdating)
                    const CircularProgressIndicator(color: Colors.white),
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_circle, color: Colors.green, size: 20),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      }
    );
  }

  Widget _buildVerificationBadge(UserModel user) {
    // Sử dụng getter isBiometricVerified từ model
    if (user.isBiometricVerified) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.green.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text('Đã sinh trắc học', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text('Chưa sinh trắc học', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
      );
    }
  }

  Widget _buildFollowButton(String label, int count) {
    return TextButton(
      onPressed: () {
        // TODO: Thêm hành động điều hướng ở đây
        print('$label được nhấn!');
      },
      style: TextButton.styleFrom(
        foregroundColor: Colors.grey, // Màu chữ
        padding: EdgeInsets.zero, // Bỏ padding mặc định
        tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Thu nhỏ vùng nhận tương tác
      ),
      // Sử dụng RichText để làm đậm số
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.grey, fontSize: 13, fontFamily: 'Be Vietnam Pro'), // Đảm bảo dùng đúng font
          children: <TextSpan>[
            TextSpan(text: '$label '),
            TextSpan(
              text: count.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkButton(IconData icon, String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade100, // Nền xám nhạt
        foregroundColor: Colors.black87,       // Màu chữ và icon
        elevation: 0,                         // Không có shadow
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Bo góc
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.pink, size: 20),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ],
      ),
    );
  }
}
