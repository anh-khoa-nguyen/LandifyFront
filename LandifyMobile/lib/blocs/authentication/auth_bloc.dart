import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:landifymobile/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  late final StreamSubscription<firebase.User?> _userSubscription;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthLoading()) {

    _userSubscription = _authRepository.authStateChanges.listen((firebaseUser) {
      // SỬA LẠI: Gọi event public mới
      add(AuthUserChanged(firebaseUser));
    });

    // SỬA LẠI: Đăng ký handler cho event public mới
    on<AuthUserChanged>(_onAuthUserChanged);
    on<LogoutRequested>(_onLogoutRequested);
    on<UserDataUpdated>(_onUserDataUpdated);
  }

  // SỬA LẠI: Handler giờ đây nhận event public mới
  Future<void> _onAuthUserChanged(
      AuthUserChanged event,
      Emitter<AuthState> emit,
      ) async {
    final firebaseUser = event.firebaseUser;

    if (firebaseUser == null) {
      emit(Unauthenticated());
    } else {
      try {
        final userModel = await _authRepository.getCurrentUser();
        emit(Authenticated(user: userModel));
      } catch (e) {
        emit(AuthFailure(error: e.toString()));
      }
    }
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event,
      Emitter<AuthState> emit,
      ) async {
    await _authRepository.logout();
  }

  Future<void> _onUserDataUpdated(
      UserDataUpdated event,
      Emitter<AuthState> emit,
      ) async {
    emit(Authenticated(user: event.updatedUser));
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}