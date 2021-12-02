import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  String _email = "";
  String _passowrd = "";
  bool _showPassword = false;
  String get email => _email;
  String get passowrd => _passowrd;
  bool get showPassword => _showPassword;
  void setEmail(String e) {
    this._email = e;
    notifyListeners();
  }

  void setPassowrd(String p) {
    this._passowrd = p;
    notifyListeners();
  }

  void displayPassword() {
    this._showPassword = !this._showPassword;
    notifyListeners();
  }
}
