part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class HomeStart extends HomeEvent {}

class HomeFechUserList extends HomeEvent {
  final List<AppUser> userList;

  HomeFechUserList(this.userList);
}
