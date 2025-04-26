import 'package:equatable/equatable.dart';

class PlayEntity extends Equatable {
  final String player;
  final String serverId;
  final List<int> board;

  PlayEntity({
    required this.player,
    required this.serverId,
    required this.board,
  });

  @override
  String toString() {
    return 'PlayEntity{player: $player, serverId: $serverId, board: $board}';
  }

  factory PlayEntity.fromMap(Map<String, dynamic> json) {
    return PlayEntity(
      player: json['player'] as String,
      serverId: json['room_id'] as String,
      board: List<int>.from(json['play'].map((x) => x as int)),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'player': player,
      'room_id': serverId,
      'play': List<int>.from(board.map((x) => x)),
    };
  }

  @override
  List<Object?> get props => [player, serverId, board];
}
