part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeMainScreen extends HomeState {
  final List<AppUser> userList;

  HomeMainScreen(this.userList);
}
