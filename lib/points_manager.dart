import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PointsManager extends ChangeNotifier {
  static final PointsManager _instance = PointsManager._internal();
  factory PointsManager() => _instance;
  PointsManager._internal();

  // เริ่มต้นจาก 0 แต้ม
  int _currentPoints = 0;
  
  // ประวัติเริ่มต้นเป็นรายการว่าง
  final List<Map<String, dynamic>> _pointsHistory = [];

  SharedPreferences? _prefs;
  bool _isInitialized = false;

  // Getters
  int get currentPoints => _currentPoints;
  List<Map<String, dynamic>> get pointsHistory => List.unmodifiable(_pointsHistory);
  bool get isInitialized => _isInitialized;

  // Initialize SharedPreferences และโหลดข้อมูล
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _prefs = await SharedPreferences.getInstance();
    await _loadData();
    _isInitialized = true;
    notifyListeners();
  }

  // โหลดข้อมูลจาก SharedPreferences
  Future<void> _loadData() async {
    try {
      // โหลดแต้มปัจจุบัน
      _currentPoints = _prefs?.getInt('current_points') ?? 0;
      
      // โหลดประวัติ
      final historyString = _prefs?.getString('points_history') ?? '[]';
      final historyJson = jsonDecode(historyString) as List;
      
      _pointsHistory.clear();
      for (var item in historyJson) {
        if (item is Map<String, dynamic>) {
          // แปลง timestamp string กลับเป็น DateTime object ถ้ามี
          if (item.containsKey('timestamp') && item['timestamp'] is String) {
            item['timestamp'] = DateTime.parse(item['timestamp']);
          }
          _pointsHistory.add(item);
        }
      }
      
      debugPrint('PointsManager: โหลดข้อมูลสำเร็จ - แต้ม: $_currentPoints, ประวัติ: ${_pointsHistory.length} รายการ');
    } catch (e) {
      debugPrint('PointsManager: เกิดข้อผิดพลาดในการโหลดข้อมูล: $e');
      // ถ้าเกิดข้อผิดพลาด ให้ใช้ค่าเริ่มต้น
      _currentPoints = 0;
      _pointsHistory.clear();
    }
  }

  // บันทึกข้อมูลลง SharedPreferences
  Future<void> _saveData() async {
    if (_prefs == null) return;
    
    try {
      // บันทึกแต้มปัจจุบัน
      await _prefs!.setInt('current_points', _currentPoints);
      
      // เตรียมข้อมูลประวัติสำหรับบันทึก
      final historyForSave = _pointsHistory.map((item) {
        final itemCopy = Map<String, dynamic>.from(item);
        // แปลง DateTime เป็น string สำหรับการบันทึก
        if (itemCopy['timestamp'] is DateTime) {
          itemCopy['timestamp'] = (itemCopy['timestamp'] as DateTime).toIso8601String();
        }
        return itemCopy;
      }).toList();
      
      // บันทึกประวัติ
      final historyString = jsonEncode(historyForSave);
      await _prefs!.setString('points_history', historyString);
      
      debugPrint('PointsManager: บันทึกข้อมูลสำเร็จ - แต้ม: $_currentPoints');
    } catch (e) {
      debugPrint('PointsManager: เกิดข้อผิดพลาดในการบันทึกข้อมูล: $e');
    }
  }

  // Add points method
  Future<void> addPoints(int points, String title, {String source = 'system'}) async {
    // รอให้ initialize เสร็จก่อน
    if (!_isInitialized) {
      await initialize();
    }

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
      'timestamp': now,
    };
    
    _pointsHistory.insert(0, newEntry);
    
    // บันทึกข้อมูล
    await _saveData();
    
    notifyListeners();
  }

  // Remove points method
  Future<void> removePoints(int points, String title) async {
    // รอให้ initialize เสร็จก่อน
    if (!_isInitialized) {
      await initialize();
    }

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
      'timestamp': now,
    };
    
    _pointsHistory.insert(0, newEntry);
    
    // บันทึกข้อมูล
    await _saveData();
    
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
  Future<void> resetPoints() async {
    _currentPoints = 0;
    _pointsHistory.clear();
    
    // ลบข้อมูลจาก SharedPreferences
    await _prefs?.remove('current_points');
    await _prefs?.remove('points_history');
    
    notifyListeners();
  }

  // เพิ่มเมธอดสำหรับเพิ่มแต้มตัวอย่าง (สำหรับการทดสอบ)
  Future<void> addSamplePoints() async {
    await addPoints(10, 'เช็คอินประจำวัน', source: 'daily_login');
    await addPoints(20, 'รีวิวสถานที่ท่องเที่ยว', source: 'review');
    await addPoints(15, 'เช็คอินที่สถานที่ท่องเที่ยว', source: 'checkin');
  }

  // เพิ่ม method สำหรับ refresh ข้อมูล
  Future<void> refreshData() async {
    await _loadData();
    notifyListeners();
  }
}