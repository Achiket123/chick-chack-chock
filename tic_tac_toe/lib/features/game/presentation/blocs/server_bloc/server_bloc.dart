import 'package:tic_tac_toe/features/game/domain/usecases/create_server_usecase.dart';
import 'package:tic_tac_toe/features/game/domain/usecases/join_server_usecase.dart';
import "package:web_socket/browser_web_socket.dart";
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'server_event.dart';
part 'server_state.dart';

class ServerBloc extends Bloc<ServerEvent, ServerState> {
  final CreateServerUsecase _createServerUsecase;
  final JoinServerUsecase _joinServerUsecase;
  ServerBloc({
    required CreateServerUsecase createServerUsecase,
    required JoinServerUsecase joinServerUsecase,
  }) : _joinServerUsecase = joinServerUsecase,
       _createServerUsecase = createServerUsecase,
       super(ServerInitial()) {
    on<ServerEvent>((event, emit) {});
    on<CreateServerEvent>((event, emit) async {
      emit(ServerLoading());
      final result = await _createServerUsecase(
        CreateServerParams(serverId: event.serverId, player: event.player1),
      );
      result.fold(
        (l) => emit(ServerError(message: l.toString())),
        (r) => emit(ServerLoaded(client: r)),
      );
    });
    on<JoinServerEvent>((event, emit) async {
      emit(ServerLoading());
      final result = await _joinServerUsecase(
        CreateServerParams(serverId: event.serverId, player: event.player2),
      );
      result.fold(
        (l) => emit(ServerError(message: l.toString())),
        (r) => emit(ServerLoaded(client: r)),
      );
    });
  }
}
