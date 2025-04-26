import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:tic_tac_toe/features/game/domain/entities/play_entity.dart';
import 'package:web_socket/browser_web_socket.dart';
import 'package:web_socket/web_socket.dart';

part 'play_event.dart';
part 'play_state.dart';

class PlayBloc extends Bloc<PlayEvent, PlayState> {
  BrowserWebSocket? _socket;
  set Socket(BrowserWebSocket socket) {
    debugPrint("Socket: $socket");
    _socket = socket;
  }

  PlayBloc() : super(PlayInitial()) {
    on<AddSocketEvent>((event, emit) {
      Socket = event.socket;
    });
    on<PlayEventStart>((event, emit) {
      _socket?.events.listen((WebSocketEvent event) {
        switch (event) {
          case TextDataReceived(text: final text):
            debugPrint('Received Text: $text');
            final play = PlayEntity.fromMap(jsonDecode(text));
            add(PlayEventReceivedFromServer(play));
          case BinaryDataReceived(data: final data):
            debugPrint('Received Binary: $data');
          case CloseReceived(code: final code, reason: final reason):
            debugPrint('Connection to server closed: $code [$reason]');
        }
      });
    });
    on<PlayEventReceivedFromServer>((event, emit) {
      emit(
        PlayFromServer(
          player: event.play.player,
          serverId: event.play.serverId,
          board: event.play.board,
        ),
      );
    });
    on<PlayFromPlayer>((event, emit) {
      debugPrint("Socket: ${_socket}");
      if (_socket != null) {
        _socket?.sendText(jsonEncode(event.playEntity.toMap()));
      }
      emit(
        PlayFromServer(
          player: event.playEntity.player,
          serverId: event.playEntity.serverId,
          board: event.playEntity.board,
        ),
      );
    });
  }
}
