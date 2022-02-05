class Chat {
  final String senderId;
  final String receiverId;
  final String createdAt;
  final String message;

  Chat({
    required this.senderId,
    required this.receiverId,
    required this.createdAt,
    required this.message,
  });

  Map<String, dynamic> toMap() => {
        'senderId': senderId,
        'receiverId': receiverId,
        'createdAt': createdAt,
        'message': message
      };

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
        senderId: json['senderId'],
        receiverId: json['receiverId'],
        createdAt: json['createdAt'],
        message: json['message']);
  }
}
