part of 'root_bloc.dart';

@immutable
abstract class RootEvent {}
// This state is launched whenever application's UI is starting up
class RootStart extends RootEvent {}

