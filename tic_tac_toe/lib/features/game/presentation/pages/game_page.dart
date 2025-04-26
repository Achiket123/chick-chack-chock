import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tac_toe/core/colors.dart';
import 'package:tic_tac_toe/features/game/domain/entities/play_entity.dart';
import 'package:tic_tac_toe/features/game/presentation/blocs/play_bloc/play_bloc.dart';
import 'package:tic_tac_toe/features/game/presentation/blocs/server_bloc/server_bloc.dart';
import 'package:tic_tac_toe/features/game/presentation/widgets/o_widget.dart';
import 'package:tic_tac_toe/features/game/presentation/widgets/x_widget.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final List<bool> _isHovered = List.generate(9, (_) => false);
  List<int> _isSelected = List.generate(9, (_) => 0);
  final List<int> move = [];
  bool isTurn = false;
  late int player;
  late TextEditingController controller;
  String? playerName;
  OverlayEntry? overlayEntry;
  List<List<int>> winningsCombinations = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];
  @override
  void initState() {
    super.initState();
    Future.delayed(Durations.short1).then((_) {
      overlayEntry = OverlayEntry(
        builder:
            (context) => Container(
              color: const Color.fromARGB(162, 32, 32, 32),
              child: Dialog(
                child: Container(
                  height: 200,
                  width: 300,
                  color: Colors.black,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Enter your name to Start The Game",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              playerName = value;
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Name',
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (playerName != null && playerName!.isNotEmpty) {
                            overlayEntry?.remove();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Please enter your name")),
                            );
                          }
                        },
                        child: Text("Submit"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      );
      if (mounted) Overlay.of(context).insert(overlayEntry!);
    });
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String roomCode = "";
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final double squareSize = (width < height ? width : height) * 0.5;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.backgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Chick Chack Chock',
                style: TextStyle(color: AppColors.textColor),
              ),
              centerTitle: true,
            ),
          ),
          sliverBoxWidget(squareSize),
          SliverFillRemaining(),
        ],
      ),
      bottomSheet: Container(
        constraints: BoxConstraints(maxHeight: 100.0, minHeight: 70),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          border: Border(
            top: BorderSide(color: AppColors.buttonBorderColor, width: 1.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: () {
                overlayEntry = OverlayEntry(
                  builder:
                      (context) => Container(
                        color: const Color.fromARGB(162, 32, 32, 32),
                        child: Dialog(
                          child: Container(
                            padding: EdgeInsets.all(20),
                            height: squareSize,
                            width: squareSize,
                            decoration: BoxDecoration(
                              color: AppColors.backgroundColor,
                              border: Border.all(
                                color: AppColors.buttonBorderColor,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Create Room",
                                    style: TextStyle(
                                      color: AppColors.textColor,
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  TextField(
                                    readOnly: true,
                                    controller: controller,
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          Clipboard.setData(
                                            ClipboardData(text: roomCode),
                                          );
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Room code copied to clipboard",
                                              ),
                                            ),
                                          );
                                        },
                                        icon: Icon(Icons.copy),
                                      ),
                                      border: OutlineInputBorder(),
                                      labelText: 'Room Code',
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  BlocConsumer<ServerBloc, ServerState>(
                                    listener: (context, state) {
                                      if (state is ServerError) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(state.message),
                                          ),
                                        );
                                      } else if (state is ServerLoaded) {
                                        context.read<PlayBloc>().add(
                                          AddSocketEvent(socket: state.client),
                                        );

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Room Created , share the code with your friend",
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    builder: (context, state) {
                                      if (state is ServerLoading) {
                                        return ElevatedButton(
                                          statesController:
                                              WidgetStatesController(
                                                <WidgetState>{
                                                  WidgetState.disabled,
                                                },
                                              ),
                                          onPressed: () {},
                                          child: Transform.scale(
                                            scale: 0.5,
                                            child: CircularProgressIndicator(
                                              color: AppColors.textColor,
                                            ),
                                          ),
                                        );
                                      }
                                      if (state is ServerLoaded) {
                                        return ElevatedButton(
                                          onPressed: () {
                                            context.read<PlayBloc>().add(
                                              PlayEventStart(
                                                playEntity: PlayEntity(
                                                  player: playerName!,
                                                  serverId: roomCode,
                                                  board: _isSelected,
                                                ),
                                              ),
                                            );

                                            overlayEntry?.remove();
                                            player = 1;
                                            isTurn = true;
                                          },
                                          child: Text("Close"),
                                        );
                                      } else {
                                        return ElevatedButton(
                                          onPressed: () {
                                            _generateRoomCode();
                                            context.read<ServerBloc>().add(
                                              CreateServerEvent(
                                                serverId: roomCode,
                                                player1: playerName!,
                                              ),
                                            );
                                          },
                                          child: Text("Create"),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                );
                Overlay.of(context).insert(overlayEntry!);
              },
              label: Text("Create Room"),
              icon: Icon(Icons.group_add),
            ),
            TextButton.icon(
              onPressed: () {
                overlayEntry = OverlayEntry(
                  builder:
                      (context) => Container(
                        color: const Color.fromARGB(162, 32, 32, 32),
                        child: Dialog(
                          child: Container(
                            padding: EdgeInsets.all(20),
                            height: squareSize,
                            width: squareSize,
                            decoration: BoxDecoration(
                              color: AppColors.backgroundColor,
                              border: Border.all(
                                color: AppColors.buttonBorderColor,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Join Room",
                                    style: TextStyle(
                                      color: AppColors.textColor,
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  TextField(
                                    readOnly: true,
                                    controller: controller,
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        onPressed: () async {
                                          try {
                                            final data =
                                                await Clipboard.getData(
                                                  Clipboard.kTextPlain,
                                                );
                                            roomCode = data!.text!;

                                            setState(() {
                                              controller.text = roomCode;
                                            });
                                          } catch (e) {
                                            ScaffoldMessenger.of(
                                              mounted ? context : context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "Invalid Room Code",
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        icon: Icon(Icons.paste),
                                      ),
                                      border: OutlineInputBorder(),
                                      labelText: 'Room Code',
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  BlocConsumer<ServerBloc, ServerState>(
                                    listener: (context, state) {
                                      if (state is ServerError) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(state.message),
                                          ),
                                        );
                                      } else if (state is ServerLoaded) {
                                        context.read<PlayBloc>().add(
                                          AddSocketEvent(socket: state.client),
                                        );

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text("Room Joined"),
                                          ),
                                        );
                                      }
                                    },
                                    builder: (context, state) {
                                      if (state is ServerLoading) {
                                        return ElevatedButton(
                                          statesController:
                                              WidgetStatesController(
                                                <WidgetState>{
                                                  WidgetState.disabled,
                                                },
                                              ),
                                          onPressed: () {},
                                          child: Transform.scale(
                                            scale: 0.5,
                                            child: CircularProgressIndicator(
                                              color: AppColors.textColor,
                                            ),
                                          ),
                                        );
                                      } else if (state is ServerLoaded) {
                                        return ElevatedButton(
                                          onPressed: () {
                                            context.read<PlayBloc>().add(
                                              PlayEventStart(
                                                playEntity: PlayEntity(
                                                  player: playerName!,
                                                  serverId: roomCode,
                                                  board: _isSelected,
                                                ),
                                              ),
                                            );

                                            overlayEntry?.remove();
                                            player = 2;
                                            isTurn = false;
                                          },
                                          child: Text("Close"),
                                        );
                                      } else if (state is ServerError) {
                                        return ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("Error"),
                                        );
                                      } else {
                                        return ElevatedButton(
                                          onPressed: () {
                                            context.read<ServerBloc>().add(
                                              JoinServerEvent(
                                                serverId: roomCode,
                                                player2: playerName!,
                                              ),
                                            );
                                          },
                                          child: Text("Join Room"),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                );
                Overlay.of(context).insert(overlayEntry!);
              },
              label: Text("Join Room"),
              icon: Icon(Icons.vaping_rooms),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter sliverBoxWidget(double squareSize) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(20),
        color: AppColors.backgroundColor,
        child: Center(
          child: Column(
            children: [
              Container(
                constraints: BoxConstraints.tightFor(
                  width: squareSize,
                  height: squareSize,
                ),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  border: Border.all(
                    color: AppColors.buttonBorderColor,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),

                child: ScrollbarTheme(
                  data: ScrollbarThemeData(
                    interactive: false,
                    thumbVisibility: WidgetStatePropertyAll(false),
                  ),
                  child: BlocBuilder<PlayBloc, PlayState>(
                    builder: (context, state) {
                      if (state is PlayFromServer) {
                        if (state.board == _isSelected) {
                          move.clear();
                        }
                        _isSelected = state.board;
                        for (var i in winningsCombinations) {
                          if (_isSelected[i[0]] == _isSelected[i[1]] &&
                              _isSelected[i[1]] == _isSelected[i[2]] &&
                              _isSelected[i[0]] != 0) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => Material(
                                      color: const Color.fromARGB(
                                        162,
                                        32,
                                        32,
                                        32,
                                      ),
                                      child: Center(
                                        child: Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          backgroundColor:
                                              AppColors.backgroundColor,
                                          child: Container(
                                            padding: const EdgeInsets.all(20),
                                            height: squareSize,
                                            width: squareSize,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "${_isSelected[i[0]] == 1 ? "O" : "X"} Wins",
                                                  style: const TextStyle(
                                                    fontSize: 24,
                                                    color: AppColors.textColor,
                                                  ),
                                                ),
                                                const SizedBox(height: 20),
                                                TextButton.icon(
                                                  onPressed: () {
                                                    _isSelected = List.generate(
                                                      9,
                                                      (_) => 0,
                                                    );
                                                    move.clear();
                                                    context.read<PlayBloc>().add(
                                                      PlayFromPlayer(
                                                        playEntity: PlayEntity(
                                                          player: playerName!,
                                                          serverId: roomCode,
                                                          board: _isSelected,
                                                        ),
                                                      ),
                                                    );
                                                    Navigator.pop(context);
                                                  },
                                                  icon: const Icon(
                                                    Icons.replay,
                                                  ),
                                                  label: const Text(
                                                    "Play Again",
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                              );
                            });

                            break; // <-- important: stop looping after a win is detected
                          }
                        }

                        if (state.player != playerName) {
                          isTurn = true;
                        }
                        return GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 9,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 1.0,
                                mainAxisExtent: squareSize / 3,
                              ),
                          itemBuilder: (context, index) {
                            double density = 1;
                            if (move.length == 3 && move[0] == index) {
                              density = 0.5;
                            }
                            return GestureDetector(
                              onTap: () {
                                if (isTurn) {
                                  setState(() {
                                    _isSelected[index] = player;
                                  });
                                  context.read<PlayBloc>().add(
                                    PlayFromPlayer(
                                      playEntity: PlayEntity(
                                        player: playerName!,
                                        serverId: roomCode,
                                        board: _isSelected,
                                      ),
                                    ),
                                  );
                                  isTurn = false;
                                  move.add(index);
                                  if (move.length > 3) {
                                    _isSelected.replaceRange(
                                      move[0],
                                      move[0] + 1,
                                      [0],
                                    );
                                    move.removeAt(0);
                                  }
                                }
                              },
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                onEnter: (_) {
                                  if (isTurn) {
                                    setState(() => _isHovered[index] = true);
                                  }
                                },
                                onExit:
                                    (_) => setState(
                                      () => _isHovered[index] = false,
                                    ),
                                child: AnimatedScale(
                                  scale: _isHovered[index] ? 1.1 : 1.0,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeInOut,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.infoColor,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                      boxShadow: [
                                        if (_isHovered[index])
                                          BoxShadow(
                                            color: AppColors.buttonBorderColor
                                            // ignore: deprecated_member_use
                                            .withOpacity(0.25),
                                            blurRadius: 12.0,
                                            spreadRadius: 2.0,
                                            offset: const Offset(0, 0),
                                          )
                                        else
                                          const BoxShadow(
                                            color: Colors.transparent,
                                            blurRadius: 0,
                                            spreadRadius: 0,
                                            offset: Offset(0, 0),
                                          ),
                                      ],
                                    ),
                                    child: Center(
                                      child:
                                          _isSelected[index] != 0
                                              ? _isSelected[index] != 1
                                                  ? XWidget(density: density)
                                                  : OWidget(density: density)
                                              : null,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                      return GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 9,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.0,
                          mainAxisExtent: squareSize / 3,
                        ),
                        itemBuilder:
                            (context, index) => GestureDetector(
                              onTap: () {
                                if (isTurn && _isSelected[index] == 0) {
                                  setState(() {
                                    _isSelected[index] = player;
                                  });
                                  context.read<PlayBloc>().add(
                                    PlayFromPlayer(
                                      playEntity: PlayEntity(
                                        player: playerName!,
                                        serverId: roomCode,
                                        board: _isSelected,
                                      ),
                                    ),
                                  );
                                  isTurn = false;
                                  move.add(index);
                                }
                              },
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,

                                onEnter: (_) {
                                  if (isTurn) {
                                    setState(() => _isHovered[index] = true);
                                  }
                                },
                                onExit:
                                    (_) => setState(
                                      () =>
                                          isTurn
                                              ? _isHovered[index] = false
                                              : false,
                                    ),
                                child: AnimatedScale(
                                  scale: _isHovered[index] ? 1.1 : 1.0,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeInOut,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.infoColor,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                      boxShadow: [
                                        if (_isHovered[index])
                                          BoxShadow(
                                            color: AppColors.buttonBorderColor
                                            // ignore: deprecated_member_use
                                            .withOpacity(0.25),
                                            blurRadius: 12.0,
                                            spreadRadius: 2.0,
                                            offset: const Offset(0, 0),
                                          )
                                        else
                                          const BoxShadow(
                                            color: Colors.transparent,
                                            blurRadius: 0,
                                            spreadRadius: 0,
                                            offset: Offset(0, 0),
                                          ),
                                      ],
                                    ),
                                    child: Center(
                                      child:
                                          _isSelected[index] != 0
                                              ? _isSelected[index] != 1
                                                  ? XWidget()
                                                  : OWidget()
                                              : null,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _generateRoomCode() {
    String code = "";
    code =
        ((Random.secure().nextDouble() *
                    (Random.secure().nextInt(5) + 5) *
                    10000)
                .toInt())
            .toString();

    setState(() {
      debugPrint(code);
      roomCode = code;
      controller.text = roomCode;
    });
  }
}
