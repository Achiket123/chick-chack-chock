import 'package:equatable/equatable.dart';

class ChatMessageEntity extends Equatable {
  final String sender;
  final String message;
  final bool isMe;

  ChatMessageEntity({
    required this.sender,
    required this.message,
    required this.isMe,
  });
  Map<String, dynamic> toMap() {
    return {
      'event': 'message',
      'message': {'sender': sender, 'message': message, 'isMe': false},
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [sender, message, isMe];
}
