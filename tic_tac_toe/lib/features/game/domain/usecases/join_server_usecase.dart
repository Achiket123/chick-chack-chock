import 'package:fpdart/fpdart.dart';
import 'package:tic_tac_toe/core/use_case.dart';
import 'package:tic_tac_toe/features/game/domain/repo/server_repo.dart';
import 'package:tic_tac_toe/features/game/domain/usecases/create_server_usecase.dart';

class JoinServerUsecase
    implements UseCase<Either<Exception, String>, CreateServerParams> {
  final ServerRepo serverRepo;

  JoinServerUsecase({required this.serverRepo});
  @override
  call(CreateServerParams param) {
    return serverRepo.joinServer(param.serverId, param.player);
  }
}
