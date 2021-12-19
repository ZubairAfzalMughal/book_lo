import 'package:book_lo/apis/book.dart';
import 'package:flutter/material.dart';

enum Status { request, offer }

class PostProvider extends ChangeNotifier {
  List<String> _catList = [
    "science",
    "history",
    "arts",
    "biology",
    "physics",
    "mathematics",
    "fiction",
    "computer",
  ];
  String _title = "";
  String _desc = "";
  String _type = "";
  String _imgPath = "";
  String _category = "";
  Status? _status = Status.request;

  String get title => _title;

  String get type => _type;

  String get desc => _desc;

  String get imgPath => _imgPath;

  String get category => _category;

  Status? get status => _status;

  List<String> get catList => _catList;

  setStatus(Status? s) {
    _status = s;
    _type = _status!.index == 0 ? "request" : "offer";
    notifyListeners();
  }

  setCategory(String c) {
    _category = c;
    notifyListeners();
  }

  List<Book> _post = [
    Book(
      userId: '1',
      title: "9th Math",
      description: "I have this novel I want to donat it",
      imgUrl: "assets/images/post1.jpg",
      category: "Science",
      status: "requested",
      createdAt: DateTime.now(),
    ),
    Book(
      userId: '2',
      description: "I have this novel I want to donat it",
      title: "Science",
      imgUrl: "assets/images/post1.jpg",
      category: "Science",
      status: "requested",
      createdAt: DateTime.now(),
    ),
    Book(
      userId: '3',
      description: "I have this novel I want to donat it",
      title: "Science",
      imgUrl: "assets/images/post1.jpg",
      category: "Science",
      status: "requested",
      createdAt: DateTime.now(),
    ),
    Book(
      userId: '4',
      description:
          "I have this novel I want to donat it, I have this novel I want to donat it, I have this novel I want to donat it,",
      title: "Science",
      imgUrl: "assets/images/post1.jpg",
      category: "Science",
      status: "requested",
      createdAt: DateTime.now(),
    ),
  ];

  List<Book> get post => _post;
}
