  // lib/repositories/auth_repository.dart
  import 'dart:io';
  import 'package:dio/dio.dart';
  import 'package:landifymobile/utils/api/api_client.dart';
  import 'package:landifymobile/utils/constants/api_constants.dart';
  import 'package:shared_preferences/shared_preferences.dart';

  import 'package:landifymobile/models/user_model.dart';

  import 'dart:async';
  import 'package:firebase_auth/firebase_auth.dart' as firebase;
  import 'package:shared_preferences/shared_preferences.dart';
  import 'package:google_sign_in/google_sign_in.dart';

  class AuthRepository {
    final ApiClient _apiClient;
    final firebase.FirebaseAuth _firebaseAuth;
    final GoogleSignIn _googleSignIn = GoogleSignIn();


    AuthRepository({required ApiClient apiClient})
        : _apiClient = apiClient,
          _firebaseAuth = firebase.FirebaseAuth.instance;

    Stream<firebase.User?> get authStateChanges => _firebaseAuth.authStateChanges();

    Future<Map<String, dynamic>> checkPhoneStatus(String phoneNumber) async {
      try {
        // SỬA LẠI: Dùng publicDio cho request không cần token
        final response = await _apiClient.publicDio.post(
          '/auth/check-phone/',
          data: {'phone_number': phoneNumber},
        );
        return response.data;
      } on DioException catch (e) {
        throw e.response?.data['error'] ?? 'Lỗi kiểm tra số điện thoại.';
      }
    }

    Future<void> requestFirebaseOtp({
      required String phoneNumber,
      required Function(String verificationId) onCodeSent,
      required Function(firebase.FirebaseAuthException e) onVerificationFailed,
    }) async {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (credential) async {
          // Tự động xác thực trên Android, có thể đăng nhập luôn
          await _firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: onVerificationFailed,
        codeSent: (String verificationId, int? resendToken) {
          // Gửi mã thành công, gọi callback để UI có thể điều hướng
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    }

    Future<void> verifyOtpAndSignIn(String verificationId, String smsCode) async {
      try {
        final credential = firebase.PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: smsCode,
        );
        // Đăng nhập vào Firebase, sau bước này, FirebaseAuth.instance.currentUser sẽ có giá trị
        await _firebaseAuth.signInWithCredential(credential);
      } on firebase.FirebaseAuthException catch (e) {
        // Ném lỗi để UI có thể bắt và hiển thị
        throw e.message ?? 'Mã OTP không hợp lệ hoặc đã hết hạn.';
      }
    }

    Future<void> completeUserProfile({
      required String fullName,
      String? gender,
      String? dateOfBirth,
      File? avatar,
    }) async {
      try {
        final formData = FormData.fromMap({
          'full_name': fullName,
          if (gender != null) 'gender': gender,
          if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
          if (avatar != null) 'avatar': await MultipartFile.fromFile(avatar.path),
        });

        // GỌI ĐẾN ENDPOINT MỚI BẰNG PHƯƠNG THỨC PATCH
        // ApiClient sẽ tự động đính kèm Firebase ID Token
        await _apiClient.patch('/users/complete-profile/', data: formData);

      } on DioException catch (e) {

        print('>>> LỖI DIO:');
        print('>>> Status Code: ${e.response?.statusCode}');
        print('>>> Data: ${e.response?.data}');

        // In ra thông tin request đã gửi đi
        print('>>> Request Path: ${e.requestOptions.path}');
        print('>>> Request Data: ${e.requestOptions.data}');
        print('>>> Request Headers: ${e.requestOptions.headers}');

        throw e.response?.data['error'] ?? 'Không thể hoàn tất hồ sơ.';
      }
    }

    Future<void> signInWithGoogle() async {
      try {
        // 1. Bắt đầu luồng đăng nhập của Google
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        // 2. Nếu người dùng hủy, ném ra lỗi để UI xử lý
        if (googleUser == null) {
          throw 'Đăng nhập Google đã bị hủy.';
        }

        // 3. Lấy thông tin xác thực (chứa idToken và accessToken)
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        // 4. Tạo credential cho Firebase
        // Phiên bản 6.x.x có cả idToken và accessToken trên googleAuth
        final credential = firebase.GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        // 5. Dùng credential để đăng nhập vào Firebase
        await _firebaseAuth.signInWithCredential(credential);
        // Sau khi thành công, AuthBloc sẽ tự động cập nhật state

      } catch (e) {
        // In lỗi ra console để debug và ném lại lỗi để UI hiển thị
        print('Lỗi signInWithGoogle: ${e.toString()}');
        throw 'Đăng nhập với Google thất bại. Vui lòng thử lại.';
      }
    }


    Future<void> logout() async {
      await _firebaseAuth.signOut();
      // Không cần xóa token từ SharedPreferences nữa vì ApiClient lấy trực tiếp từ SDK
    }

    Future<UserModel> getCurrentUser() async {
      try {
        final response = await _apiClient.get(ApiConstants.currentUser);
        return UserModel.fromJson(response.data);
      } on DioException catch (e) {
        throw e.response?.data['detail'] ?? 'Lỗi khi lấy thông tin người dùng.';
      } catch (e) {
        throw 'Đã xảy ra lỗi không mong muốn.';
      }
    }

    Future<String> updateAvatar(File imageFile) async {
      try {
        final formData = FormData.fromMap({
          'avatar': await MultipartFile.fromFile(imageFile.path),
        });

        final response = await _apiClient.patch(
          ApiConstants.changeAvatar,
          data: formData,
        );

        if (response.data['avatar'] != null) {
          return response.data['avatar'];
        } else {
          throw 'Cập nhật avatar thất bại.';
        }
      } on DioException catch (e) {
        throw e.response?.data['message'] ?? 'Lỗi mạng khi cập nhật avatar.';
      } catch (e) {
        throw 'Đã xảy ra lỗi không mong muốn.';
      }
    }

  }