part of 'server_bloc.dart';

@immutable
sealed class ServerState {}

final class ServerInitial extends ServerState {}

final class ServerLoading extends ServerState {}

final class ServerLoaded extends ServerState {
  final BrowserWebSocket client;

  ServerLoaded({required this.client});
}

final class ServerError extends ServerState {
  final String message;

  ServerError({required this.message});
}
