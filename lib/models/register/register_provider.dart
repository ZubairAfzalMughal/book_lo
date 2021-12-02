import 'package:flutter/material.dart';

class RegisterProvider extends ChangeNotifier {
  String _name = "";
  String _email = "";
  String _password = "";
  String _confirmPassword = "";
  String _phoneNumber = "";
  bool _isLoading = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  bool get showPassword => _showPassword;
  bool get showConfirmPassword => _showConfirmPassword;
  String get name => _name;
  String get email => _email;
  String get password => _password;
  String get confirmPassword => _confirmPassword;
  String get phoneNumber => _phoneNumber;
  bool get isLoading => _isLoading;
  void setName(String n) {
    this._name = n;
    notifyListeners();
  }

  void setEmail(String e) {
    this._email = e;
    notifyListeners();
  }

  void setPhoneNumber(String pNumber) {
    this._phoneNumber = pNumber;
    notifyListeners();
  }

  void setPassword(String p) {
    this._password = p;
    notifyListeners();
  }

  void setConfirmPassword(String cPassword) {
    this._confirmPassword = cPassword;
    notifyListeners();
  }

  void showLoader() {
    this._isLoading = true;
    notifyListeners();
  }

  void offLoader() {
    this._isLoading = false;
    notifyListeners();
  }

  void displayPassword() {
    this._showPassword = !this._showPassword;
    notifyListeners();
  }

  void displayConfirmPassword() {
    this._showConfirmPassword = !this._showConfirmPassword;
    notifyListeners();
  }
}
