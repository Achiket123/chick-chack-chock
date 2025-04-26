import "package:web_socket/browser_web_socket.dart";

import 'package:fpdart/fpdart.dart';

abstract class ServerRepo {
  Future<Either<Exception, BrowserWebSocket>> createServer(
    String serverId,
    String player1,
  );
  Future<Either<Exception, BrowserWebSocket>> joinServer(
    String serverId,
    String player2,
  );
}
