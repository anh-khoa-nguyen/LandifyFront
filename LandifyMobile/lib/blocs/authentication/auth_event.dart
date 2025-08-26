import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import '../../models/user_model.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// SỬA LẠI: Bỏ dấu gạch dưới, biến nó thành một class public.
// Mặc dù nó vẫn được dùng nội bộ, việc này sẽ tránh được các lỗi phân tích của IDE.
class AuthUserChanged extends AuthEvent {
  final firebase.User? firebaseUser;

  const AuthUserChanged(this.firebaseUser);

  @override
  List<Object?> get props => [firebaseUser];
}

// Event này được UI gọi khi người dùng nhấn nút Đăng xuất.
class LogoutRequested extends AuthEvent {}

// Event này được các BLoC khác (như ProfileBloc) gọi để cập nhật
// thông tin UserModel trong AuthBloc.
class UserDataUpdated extends AuthEvent {
  final UserModel updatedUser;

  const UserDataUpdated({required this.updatedUser});

  @override
  List<Object> get props => [updatedUser];
}