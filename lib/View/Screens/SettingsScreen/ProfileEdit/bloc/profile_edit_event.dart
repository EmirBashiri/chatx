part of 'profile_edit_bloc.dart';

@immutable
sealed class ProfileEditEvent {}

// This eveis is called whenever profile edit screen is setting up
class ProfileEditStart extends ProfileEditEvent {}

// This eveis is called whenever the user taps to change avatar
class ProfileEditSetAvatar extends ProfileEditEvent {}

// This eveis is called whenever the user taps to save profile button (with new avatar state)
class ProfileEditSaveWithAvatar extends ProfileEditEvent {
  final String newAvatarPath;
  final UserEntity userEntity;

  ProfileEditSaveWithAvatar(
      {required this.newAvatarPath, required this.userEntity});
}

// This eveis is called whenever the user taps to save profile button (without new avatar state)
class ProfileEditSaveWithoutAvatar extends ProfileEditEvent {
  final UserEntity userEntity;

  ProfileEditSaveWithoutAvatar({required this.userEntity});
}
