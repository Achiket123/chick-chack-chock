part of 'play_bloc.dart';

@immutable
sealed class PlayEvent {}

class PlayEventStart extends PlayEvent {
  final PlayEntity playEntity;

  PlayEventStart({required this.playEntity});
}

class AddSocketEvent extends PlayEvent {
  final BrowserWebSocket socket;

  AddSocketEvent({required this.socket});
}

class PlayEventReceivedFromServer extends PlayEvent {
  final PlayEntity play;

  PlayEventReceivedFromServer(this.play);
}

class PlayFromPlayer extends PlayEvent {
  final PlayEntity playEntity;

  PlayFromPlayer({required this.playEntity});
}

class PlayerJoined extends PlayEvent {
  final String playerName;

  PlayerJoined({required this.playerName});
}

class MessageReceivedEvent extends PlayEvent {
  final ChatMessageEntity message;
  MessageReceivedEvent({required this.message});
}

class SendMessageEvent extends PlayEvent {
  final ChatMessageEntity message;
  SendMessageEvent({required this.message});
}
