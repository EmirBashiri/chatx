part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

// This event is called whenever home screen is set up
class HomeStart extends HomeEvent {}

// This event is called whenever the user stream receives an event
class HomeUpdate extends HomeEvent {
  final List<AppUser> userList;

  HomeUpdate(this.userList);
}

// This event is called whenever the user stream receives an error
class HomeError extends HomeEvent {
  final dynamic errorExecption;

  HomeError(this.errorExecption);
}
