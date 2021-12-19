class AppUser {
  final String name;
  final String email;
  final String phoneNumber;
  final bool isVerified;
  final String imgUrl;
  final String location;

  AppUser({
    required this.isVerified,
    required this.name,
    required this.imgUrl,
    required this.location,
    required this.phoneNumber,
    required this.email,
  });

  factory AppUser.fromDocument(Map docs) {
    return AppUser(
      isVerified: docs['isVerified'],
      name: docs['name'],
      imgUrl: docs['imgUrl'],
      location: docs['location'],
      phoneNumber: docs['phone'],
      email: docs['email'],
    );
  }
}
