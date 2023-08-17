part of 'message_box_bloc.dart';

@immutable
sealed class MessageBoxEvent {}

// This event called whenever message box screen starting up
class MessageBoxStart extends MessageBoxEvent {}

// This event called whenever user tapped on file message
class MessageDownloadFile extends MessageBoxEvent {}

// This event called whenever user tapped on downloaded file message
class MessageOpenFile extends MessageBoxEvent {}

// This event called whenever user tapped on image message
class MessageOpenImage extends MessageBoxEvent {}
