// lib/blocs/profile/profile_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:landifymobile/blocs/authentication/auth_bloc.dart'; // <-- Import AuthBloc
import 'package:landifymobile/blocs/authentication/auth_event.dart'; // <-- Import AuthEvent
import 'package:landifymobile/blocs/authentication/auth_state.dart'; // <-- Import AuthState
import 'package:landifymobile/repositories/auth_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository _authRepository;
  final AuthBloc _authBloc; // <-- Thêm AuthBloc làm dependency

  ProfileBloc({
    required AuthRepository authRepository,
    required AuthBloc authBloc, // <-- Nhận AuthBloc
  })  : _authRepository = authRepository,
        _authBloc = authBloc,
        super(const ProfileState()) {
    on<ProfileAvatarChanged>(_onProfileAvatarChanged);
  }

  Future<void> _onProfileAvatarChanged(
      ProfileAvatarChanged event,
      Emitter<ProfileState> emit,
      ) async {
    // Lấy state hiện tại từ AuthBloc để có UserModel
    final authState = _authBloc.state;
    if (authState is Authenticated) {
      emit(const ProfileState(status: ProfileUpdateStatus.inProgress));
      try {
        final newAvatarUrl = await _authRepository.updateAvatar(event.avatarFile);

        // Tạo UserModel mới
        final updatedUser = authState.user.copyWith(avatar: newAvatarUrl);

        // GỬI EVENT ĐỂ CẬP NHẬT AUTHBLOC
        _authBloc.add(UserDataUpdated(updatedUser: updatedUser));

        emit(const ProfileState(status: ProfileUpdateStatus.success));
      } catch (e) {
        emit(ProfileState(status: ProfileUpdateStatus.failure, error: e.toString()));
      }
    }
  }
}