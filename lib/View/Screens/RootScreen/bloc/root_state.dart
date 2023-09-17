part of 'root_bloc.dart';

@immutable
abstract class RootState {}

class RootInitial extends RootState {}

//  This state is launched when the user is not logged in
class RootShowIntro extends RootState {}

// This state is launched when the user is logged in
class RootShowHomeScreen extends RootState {}
