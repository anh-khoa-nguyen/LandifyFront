// lib/blocs/profile/profile_event.dart
import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileFetched extends ProfileEvent {}

class ProfileAvatarChanged extends ProfileEvent {
  final File avatarFile;
  const ProfileAvatarChanged({required this.avatarFile});
  @override
  List<Object> get props => [avatarFile];
}