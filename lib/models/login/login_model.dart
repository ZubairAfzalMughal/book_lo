import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  String _email = "";
  String _passowrd = "";
  bool _isLoading = false;
  bool _showPassword = false;
  bool get isLoading => _isLoading;
  String get email => _email;
  String get passowrd => _passowrd;
  bool get showPassword => _showPassword;
  void setEmail(String e) {
    this._email = e;
    notifyListeners();
  }

  void showLoader() {
    _isLoading = true;
    notifyListeners();
  }

  void offLoader() {
    _isLoading = false;
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

  //Log in

  Future<UserCredential> signIn(String e, String p) {
    return auth.signInWithEmailAndPassword(email: e, password: p);
  }
}
