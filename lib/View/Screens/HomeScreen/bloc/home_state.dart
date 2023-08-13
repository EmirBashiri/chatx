part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoadingScreen extends HomeState {}

class HomeMainScreen extends HomeState {
  final List<AppUser> userList;
  final AppUser currnetUser;

  HomeMainScreen({required this.userList, required this.currnetUser});
}
