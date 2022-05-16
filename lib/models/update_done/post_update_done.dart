import 'package:flutter/cupertino.dart';

class PostHandle extends ChangeNotifier {
  Map<String, dynamic> _post = new Map<String, dynamic>();

  Map<String, dynamic> get post => _post;

  void setPostHandle(Map<String, dynamic> p) {
    _post = p;
    notifyListeners();
  }
}
