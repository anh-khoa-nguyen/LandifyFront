// lib/models/user_model.dart

class UserModel {
  final int id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber; // Sẽ được định dạng lại ở đây
  final String? avatar;
  final String role;
  final String? dateOfBirth;
  final String gender;
  final bool isPhoneVerified;
  final bool isIdCardVerified;

  const UserModel({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    this.avatar,
    required this.role,
    this.dateOfBirth,
    required this.gender,
    required this.isPhoneVerified,
    required this.isIdCardVerified,
  });

  // Một getter tiện lợi để lấy họ tên đầy đủ
  String get fullName => '$firstName $lastName'.trim();

  bool get isBiometricVerified => isPhoneVerified && isIdCardVerified;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Xử lý logic đổi SĐT từ +84 sang 0
    String formattedPhoneNumber = json['phone_number'] ?? '';
    if (formattedPhoneNumber.startsWith('+84')) {
      formattedPhoneNumber = formattedPhoneNumber.replaceFirst('+84', '0');
    }

    return UserModel(
      id: json['id'],
      username: json['username'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: formattedPhoneNumber, // Sử dụng SĐT đã được định dạng
      avatar: json['avatar'],
      role: json['role'] ?? 'user',
      dateOfBirth: json['date_of_birth'],
      gender: json['gender'] ?? 'OTHER',
      isPhoneVerified: json['is_phone_verified'] ?? false,
      isIdCardVerified: json['is_id_card_verified'] ?? false,
    );
  }

  UserModel copyWith({
    int? id,
    String? username,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? avatar,
    String? role,
    String? dateOfBirth,
    String? gender,
    bool? isPhoneVerified,
    bool? isIdCardVerified,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      isIdCardVerified: isIdCardVerified ?? this.isIdCardVerified,
    );
  }
}