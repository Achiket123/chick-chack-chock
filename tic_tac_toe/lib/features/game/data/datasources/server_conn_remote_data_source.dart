import "package:web_socket/browser_web_socket.dart";

import 'package:flutter/widgets.dart';
import 'package:fpdart/fpdart.dart';
import 'package:web_socket/web_socket.dart';

abstract class ServerConnRemoteDataSource {
  Future<Either<Exception, BrowserWebSocket>> createServer(
    String serverId,
    String player1,
  );
  Future<Either<Exception, BrowserWebSocket>> joinServer(
    String serverId,
    String player2,
  );
}

class ServerConnRemoteDataSourceImpl implements ServerConnRemoteDataSource {
  @override
  Future<Either<Exception, BrowserWebSocket>> createServer(
    String serverId,
    String player1,
  ) async {
    try {
      final conn = await BrowserWebSocket.connect(
        Uri.parse(
          "wss://chick-chack-chock-backend.onrender.com/ws?id=$serverId&name=$player1",
        ),
      );

      return right(conn);
    } catch (e) {
      WebSocketException webSocketException = e as WebSocketException;
      debugPrint("Error: ${webSocketException.message}");
      return left(e as Exception);
    }
  }

  @override
  Future<Either<Exception, BrowserWebSocket>> joinServer(
    String serverId,
    String player2,
  ) async {
    try {
      final conn = await BrowserWebSocket.connect(
        Uri.parse(
          "wss://chick-chack-chock-backend.onrender.com/ws?id=$serverId&name=$player2",
        ),
      );

      return right(conn);
    } catch (e) {
      debugPrint("Error: $e");
      rethrow;
    }
  }
}
