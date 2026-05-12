enum MessageStatus { sending, sent, read }

class ChatMessage {
  final String id;
  final String content;
  final bool isFromUser;
  final DateTime timestamp;
  final MessageStatus status;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.isFromUser,
    required this.timestamp,
    this.status = MessageStatus.sent,
  });

  ChatMessage copyWith({
    String? id,
    String? content,
    bool? isFromUser,
    DateTime? timestamp,
    MessageStatus? status,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      isFromUser: isFromUser ?? this.isFromUser,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'isFromUser': isFromUser,
        'timestamp': timestamp.toIso8601String(),
        'status': status.name,
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['id'] as String,
        content: json['content'] as String,
        isFromUser: json['isFromUser'] as bool,
        timestamp: DateTime.parse(json['timestamp'] as String),
        status: MessageStatus.values.firstWhere(
          (s) => s.name == json['status'],
          orElse: () => MessageStatus.sent,
        ),
      );
}
