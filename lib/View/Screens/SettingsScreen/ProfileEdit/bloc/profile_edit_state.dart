part of 'profile_edit_bloc.dart';

@immutable
sealed class ProfileEditState {}

final class ProfileEditInitial extends ProfileEditState {}

// This state is profile edit screens main state
class ProfileEditMainState extends ProfileEditState {}

// This state is launched whenever the user selects new avatar
class ProfileEditNewAvatarState extends ProfileEditState {
  final String imageFilePath;

  ProfileEditNewAvatarState(this.imageFilePath);
}

// This state is launched whenever the screen needs loading
class ProfileEditLoadingState extends ProfileEditState {}

// This state is launched whenever an error detected in save process
class ProfileEditErrorState extends ProfileEditState {
  final String errorMessage;

  ProfileEditErrorState(this.errorMessage);
}
