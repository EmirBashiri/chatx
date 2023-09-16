part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

// This state is launched whenever home screen is being ready
class HomeLoadingScreen extends HomeState {}

// This state is launched whenever home screen is ready
class HomeMainScreen extends HomeState {
  final List<AppUser> userList;
  final AppUser currnetUser;

  HomeMainScreen({required this.userList, required this.currnetUser});
}

// This state is launched whenever an error detected in home screen setup process
class HomeErrorScreen extends HomeState {
  final AppUser? currentUser;
  final String errorMessage;

  HomeErrorScreen({required this.currentUser, required this.errorMessage});
}
