import "package:web_socket/browser_web_socket.dart";
import 'package:fpdart/src/either.dart';
import 'package:tic_tac_toe/features/game/data/datasources/server_conn_remote_data_source.dart';
import 'package:tic_tac_toe/features/game/domain/repo/server_repo.dart';

class ServerRepoImpl implements ServerRepo {
  final ServerConnRemoteDataSource serverConnRemoteDataSource;
  ServerRepoImpl(this.serverConnRemoteDataSource);
  @override
  Future<Either<Exception, BrowserWebSocket>> createServer(
    String serverId,
    String player1,
  ) async {
    return serverConnRemoteDataSource.createServer(serverId, player1);
  }

  @override
  Future<Either<Exception, BrowserWebSocket>> joinServer(
    String serverId,
    String player2,
  ) {
    return serverConnRemoteDataSource.joinServer(serverId, player2);
  }
}
