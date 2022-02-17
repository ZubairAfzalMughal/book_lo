class Chat {
  final String senderId;
  final String receiverId;
  final String createdAt;
  final String message;
  final String timeStamp;

  Chat({
    required this.senderId,
    required this.receiverId,
    required this.createdAt,
    required this.message,
    required this.timeStamp,
  });

  Map<String, dynamic> toMap() => {
        'senderId': senderId,
        'receiverId': receiverId,
        'createdAt': createdAt,
        'message': message,
        'timeStamp': timeStamp
      };

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
        senderId: json['senderId'],
        receiverId: json['receiverId'],
        createdAt: json['createdAt'],
        message: json['message'],
        timeStamp: json['timeStamp']);
  }
}
