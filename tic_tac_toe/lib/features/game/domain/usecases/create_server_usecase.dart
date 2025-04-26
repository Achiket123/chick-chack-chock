import "package:web_socket/browser_web_socket.dart";

import 'package:fpdart/fpdart.dart';
import 'package:tic_tac_toe/core/use_case.dart';
import 'package:tic_tac_toe/features/game/domain/repo/server_repo.dart';

class CreateServerParams {
  final String serverId;
  final String player;

  CreateServerParams({required this.serverId, required this.player});
}

class CreateServerUsecase
    implements UseCase<Either<Exception, String>, CreateServerParams> {
  final ServerRepo serverRepo;

  CreateServerUsecase(this.serverRepo);

  @override
  Future<Either<Exception, BrowserWebSocket>> call(CreateServerParams params) {
    return serverRepo.createServer(params.serverId, params.player);
  }
}
