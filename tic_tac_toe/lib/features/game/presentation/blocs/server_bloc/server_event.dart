part of 'server_bloc.dart';

@immutable
sealed class ServerEvent {}

class CreateServerEvent extends ServerEvent {
  final String serverId;
  final String player1;

  CreateServerEvent({required this.serverId, required this.player1});
}

class JoinServerEvent extends ServerEvent {
  final String serverId;
  final String player2;

  JoinServerEvent({required this.serverId, required this.player2});
}
