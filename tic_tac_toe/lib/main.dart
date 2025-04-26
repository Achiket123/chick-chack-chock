import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tac_toe/core/colors.dart';
import 'package:tic_tac_toe/features/game/data/datasources/server_conn_remote_data_source.dart';
import 'package:tic_tac_toe/features/game/data/repo/server_repo_impl.dart';
import 'package:tic_tac_toe/features/game/domain/usecases/create_server_usecase.dart';
import 'package:tic_tac_toe/features/game/domain/usecases/join_server_usecase.dart';
import 'package:tic_tac_toe/features/game/presentation/blocs/play_bloc/play_bloc.dart';
import 'package:tic_tac_toe/features/game/presentation/blocs/server_bloc/server_bloc.dart';
import 'package:tic_tac_toe/features/game/presentation/pages/game_page.dart';

main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ServerBloc>(
          create:
              (context) => ServerBloc(
                createServerUsecase: CreateServerUsecase(
                  ServerRepoImpl(ServerConnRemoteDataSourceImpl()),
                ),
                joinServerUsecase: JoinServerUsecase(
                  serverRepo: ServerRepoImpl(ServerConnRemoteDataSourceImpl()),
                ),
              ),
        ),
        BlocProvider(create: (context) => PlayBloc()),
      ],
      child: MaterialApp(
        title: 'Chick Chack Chock',
        theme: AppColors.themeData,
        debugShowCheckedModeBanner: false,
        home: const GamePage(),
      ),
    );
  }
}
