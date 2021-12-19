class Book {
  final String userId;
  final String title;
  final String description;
  final String imgUrl;
  final String category;
  final String status;
  final DateTime createdAt;

  Book({
    required this.category,
    required this.title,
    required this.userId,
    required this.description,
    required this.imgUrl,
    required this.status,
    required this.createdAt
  });

  factory Book.fromMap(Map<String, dynamic> json) {
    return Book(
      category: json['category'],
      title: json['title'],
      userId: json['userId'],
      description: json['description'],
      imgUrl: json['imgUrl'],
      status: json['status'],
      createdAt: json['createdAt']
    );
  }
}
