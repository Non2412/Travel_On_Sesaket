import 'package:flutter/material.dart';

class UserManager extends ChangeNotifier {
  static final UserManager _instance = UserManager._internal();
  
  factory UserManager() {
    return _instance;
  }
  
  UserManager._internal();

  bool _isLoggedIn = false;
  String _userName = 'ผู้เยี่ยมชม';
  String _userEmail = '';

  bool get isLoggedIn => _isLoggedIn;
  String get userName => _userName;
  String get userEmail => _userEmail;

  void login({required String name, required String email}) {
    _isLoggedIn = true;
    _userName = name;
    _userEmail = email;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _userName = 'ผู้เยี่ยมชม';
    _userEmail = '';
    notifyListeners();
  }

  void updateProfile({String? name, String? email}) {
    if (name != null) _userName = name;
    if (email != null) _userEmail = email;
    notifyListeners();
  }
}