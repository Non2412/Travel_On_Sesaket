import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesManager extends ChangeNotifier {
  static final FavoritesManager _instance = FavoritesManager._internal();
  
  factory FavoritesManager() {
    return _instance;
  }
  
  FavoritesManager._internal() {
    _loadFavorites();
  }

  final Set<String> _favoriteIds = {};
  static const String _storageKey = 'favorite_places';
  bool _isLoaded = false;

  // โหลดข้อมูลจาก SharedPreferences
  Future<void> _loadFavorites() async {
    if (_isLoaded) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedFavorites = prefs.getStringList(_storageKey);
      
      if (savedFavorites != null) {
        _favoriteIds.clear();
        _favoriteIds.addAll(savedFavorites);
      }
      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading favorites: $e');
      _isLoaded = true;
    }
  }

  // บันทึกข้อมูลลง SharedPreferences
  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_storageKey, _favoriteIds.toList());
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }

  bool isFavorite(String placeId) {
    return _favoriteIds.contains(placeId);
  }

  Future<void> toggleFavorite(String placeId) async {
    if (_favoriteIds.contains(placeId)) {
      _favoriteIds.remove(placeId);
    } else {
      _favoriteIds.add(placeId);
    }
    notifyListeners();
    await _saveFavorites();
  }

  // เพิ่มสถานที่เข้ารายการโปรด
  Future<void> addFavorite(String placeId) async {
    if (!_favoriteIds.contains(placeId)) {
      _favoriteIds.add(placeId);
      notifyListeners();
      await _saveFavorites();
    }
  }

  // ลบสถานที่ออกจากรายการโปรด
  Future<void> removeFavorite(String placeId) async {
    if (_favoriteIds.contains(placeId)) {
      _favoriteIds.remove(placeId);
      notifyListeners();
      await _saveFavorites();
    }
  }

  // ล้างรายการโปรดทั้งหมด
  Future<void> clearAllFavorites() async {
    _favoriteIds.clear();
    notifyListeners();
    await _saveFavorites();
  }

  List<String> get favoriteIds => _favoriteIds.toList();
  
  int get favoriteCount => _favoriteIds.length;

  bool get isLoaded => _isLoaded;
}