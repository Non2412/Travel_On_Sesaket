import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager extends ChangeNotifier {
  static final ThemeManager _instance = ThemeManager._internal();
  factory ThemeManager() => _instance;
  ThemeManager._internal();

  bool _isDarkMode = false;
  bool _isBlueTheme = false;
  
  bool get isDarkMode => _isDarkMode;
  bool get isBlueTheme => _isBlueTheme;

  // Theme Colors
  Color get primaryColor => _isBlueTheme ? Colors.blue[600]! : Colors.orange[600]!;
  Color get primaryLightColor => _isBlueTheme ? Colors.blue[400]! : Colors.orange[400]!;
  Color get primaryDarkColor => _isBlueTheme ? Colors.blue[800]! : Colors.orange[800]!;
  
  Color get backgroundColor => _isDarkMode ? Colors.grey[900]! : Colors.grey[50]!;
  Color get cardColor => _isDarkMode ? Colors.grey[800]! : Colors.white;
  Color get textPrimaryColor => _isDarkMode ? Colors.white : Colors.grey[800]!;
  Color get textSecondaryColor => _isDarkMode ? Colors.grey[300]! : Colors.grey[600]!;
  
  Gradient get headerGradient => LinearGradient(
    colors: _isBlueTheme 
      ? [Colors.blue[500]!, Colors.indigo[600]!]
      : [Colors.orange[500]!, Colors.red[500]!],
    begin: Alignment.topLeft,
    end: Alignment.topRight,
  );

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _isBlueTheme = prefs.getBool('isBlueTheme') ?? false;
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  Future<void> toggleThemeColor() async {
    _isBlueTheme = !_isBlueTheme;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isBlueTheme', _isBlueTheme);
    notifyListeners();
  }

  ThemeData get themeData {
    return ThemeData(
      primarySwatch: _isBlueTheme ? Colors.blue : Colors.orange,
      brightness: _isDarkMode ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: backgroundColor,
      cardColor: cardColor,
      fontFamily: 'Kanit',
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: textPrimaryColor),
        bodyMedium: TextStyle(color: textSecondaryColor),
      ),
    );
  }
}