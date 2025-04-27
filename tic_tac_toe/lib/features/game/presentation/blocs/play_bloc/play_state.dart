part of 'play_bloc.dart';

@immutable
sealed class PlayState {}

final class PlayInitial extends PlayState {}

final class PlayFromServer extends PlayState {
  final String player;
  final String serverId;
  final List<int> board;

  PlayFromServer({
    required this.player,
    required this.serverId,
    required this.board,
  });
}

class PlayerJoinedState extends PlayState {
  final String playerName;

  PlayerJoinedState({required this.playerName});
}

class MessageReceivedState extends PlayState {
  final ChatMessageEntity message;

  MessageReceivedState({required this.message});
}
