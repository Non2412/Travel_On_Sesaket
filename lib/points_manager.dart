import 'package:flutter/foundation.dart';

class PointsManager extends ChangeNotifier {
  static final PointsManager _instance = PointsManager._internal();
  factory PointsManager() => _instance;
  PointsManager._internal();

  // เริ่มต้นจาก 0 แต้ม
  int _currentPoints = 0;
  
  // ประวัติเริ่มต้นเป็นรายการว่าง
  final List<Map<String, dynamic>> _pointsHistory = [];

  // Getters
  int get currentPoints => _currentPoints;
  List<Map<String, dynamic>> get pointsHistory => List.unmodifiable(_pointsHistory);

  // Add points method
  void addPoints(int points, String title, {String source = 'system'}) {
    _currentPoints += points;
    
    final now = DateTime.now();
    final newEntry = {
      'type': points > 0 ? 'earned' : 'used',
      'title': title,
      'points': points,
      'date': '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}',
      'time': '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
      'icon': _getIconForSource(source),
      'color': points > 0 ? 'green' : 'red',
      'source': source,
      'timestamp': now, // เพิ่ม timestamp สำหรับการเรียงลำดับ
    };
    
    _pointsHistory.insert(0, newEntry);
    notifyListeners();
  }

  // Remove points method
  void removePoints(int points, String title) {
    _currentPoints -= points;
    
    final now = DateTime.now();
    final newEntry = {
      'type': 'used',
      'title': title,
      'points': -points,
      'date': '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}',
      'time': '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
      'icon': 'redeem',
      'color': 'red',
      'source': 'redeem',
      'timestamp': now, // เพิ่ม timestamp สำหรับการเรียงลำดับ
    };
    
    _pointsHistory.insert(0, newEntry);
    notifyListeners();
  }

  String _getIconForSource(String source) {
    switch (source) {
      case 'checkin':
        return 'event_available';
      case 'daily_login':
        return 'login';
      case 'review':
        return 'star_rate';
      case 'location':
        return 'location_on';
      case 'share':
        return 'share';
      case 'event':
        return 'event';
      case 'redeem':
        return 'redeem';
      default:
        return 'stars';
    }
  }

  // Check if user has enough points
  bool hasEnoughPoints(int requiredPoints) {
    return _currentPoints >= requiredPoints;
  }

  // Get total earned points today
  int getTodayEarnedPoints() {
    final today = DateTime.now();
    final todayString = '${today.day.toString().padLeft(2, '0')}/${today.month.toString().padLeft(2, '0')}/${today.year}';
    
    return _pointsHistory
        .where((entry) => entry['date'] == todayString && entry['type'] == 'earned')
        .fold(0, (sum, entry) => sum + (entry['points'] as int));
  }

  // Get weekly earned points
  int getWeeklyEarnedPoints() {
    final now = DateTime.now();
    final weekAgo = now.subtract(Duration(days: 7));
    
    return _pointsHistory
        .where((entry) {
          final entryDateParts = (entry['date'] as String).split('/');
          final entryDate = DateTime(
            int.parse(entryDateParts[2]),
            int.parse(entryDateParts[1]),
            int.parse(entryDateParts[0]),
          );
          return entryDate.isAfter(weekAgo) && entry['type'] == 'earned';
        })
        .fold(0, (sum, entry) => sum + (entry['points'] as int));
  }

  // เพิ่มเมธอดสำหรับรีเซ็ตข้อมูล (สำหรับการทดสอบ)
  void resetPoints() {
    _currentPoints = 0;
    _pointsHistory.clear();
    notifyListeners();
  }

  // เพิ่มเมธอดสำหรับเพิ่มแต้มตัวอย่าง (สำหรับการทดสอบ)
  void addSamplePoints() {
    addPoints(10, 'เช็คอินประจำวัน', source: 'daily_login');
    addPoints(20, 'รีวิวสถานที่ท่องเที่ยว', source: 'review');
    addPoints(15, 'เช็คอินที่สถานที่ท่องเที่ยว', source: 'checkin');
  }
}