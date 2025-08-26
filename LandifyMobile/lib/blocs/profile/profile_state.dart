import 'package:equatable/equatable.dart';

enum ProfileUpdateStatus { initial, inProgress, success, failure }

class ProfileState extends Equatable {
  final ProfileUpdateStatus status;
  final String? error;

  const ProfileState({
    this.status = ProfileUpdateStatus.initial,
    this.error,
  });

  @override
  List<Object?> get props => [status, error];
}