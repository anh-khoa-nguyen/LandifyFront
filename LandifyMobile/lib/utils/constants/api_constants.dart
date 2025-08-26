// lib/utils/constants/api_constants.dart
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = "https://presumably-literate-bluejay.ngrok-free.app";

  // Endpoints
  static const String login = "/o/token/";
  static const String registerOrUpdateUser = "/users/";
  static const String verifyOtp = "/auth/verify-otp/";

  // User
  static const String currentUser = "/users/current_user/";
  static const String changeAvatar = "/users/change_avatar/";
}