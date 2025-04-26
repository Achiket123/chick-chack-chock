import "package:equatable/equatable.dart";

class ServerEntity extends Equatable {
  final String id;
  final String player1;
  final String player2;

  ServerEntity({
    required this.id,
    required this.player1,
    required this.player2,
  });

  @override
  String toString() {
    return 'ServerEntity{id: $id, player1: $player1, player2: $player2}';
  }

  @override
  List<Object?> get props => [id, player1, player2];
}
