import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../points_manager.dart';
import '../theme_manager.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  late PointsManager _pointsManager;
  final ThemeManager _themeManager = ThemeManager();
  
  // รางวัลรายสัปดาห์ (วันจันทร์-อาทิตย์)
  final List<int> weeklyRewards = [5, 5, 10, 5, 5, 10, 15];
  final List<String> dayNames = ['จันทร์', 'อังคาร', 'พุธ', 'พฤหัสบดี', 'ศุกร์', 'เสาร์', 'อาทิตย์'];
  
  List<bool> loginDays = List.filled(7, false);
  int currentDayIndex = 0;
  bool canGetPointsToday = false;
  SharedPreferences? _prefs;
  
  @override
  void initState() {
    super.initState();
    _pointsManager = PointsManager();
    _pointsManager.addListener(_updateUI);
    _themeManager.addListener(_updateUI);
    _initializeData();
  }

  @override
  void dispose() {
    _pointsManager.removeListener(_updateUI);
    _themeManager.removeListener(_updateUI);
    super.dispose();
  }

  void _updateUI() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _initializeData() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadWeeklyData();
    _updateCurrentDay();
  }

  void _updateCurrentDay() {
    final now = DateTime.now();
    currentDayIndex = now.weekday - 1;
    
    final today = _getTodayKey();
    final hasCheckedInToday = _prefs?.getBool('checkin_$today') ?? false;
    
    setState(() {
      canGetPointsToday = !hasCheckedInToday;
    });
  }

  String _getTodayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  String _getWeekKey() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    return '${monday.year}-W${_getWeekOfYear(monday)}';
  }

  int _getWeekOfYear(DateTime date) {
    final firstJan = DateTime(date.year, 1, 1);
    final daysSinceFirstJan = date.difference(firstJan).inDays;
    return ((daysSinceFirstJan + firstJan.weekday - 1) / 7).ceil();
  }

  Future<void> _loadWeeklyData() async {
    final weekKey = _getWeekKey();
    final savedWeekKey = _prefs?.getString('current_week') ?? '';
    
    if (savedWeekKey != weekKey) {
      await _resetWeeklyData(weekKey);
    } else {
      await _loadCurrentWeekData();
    }
  }

  Future<void> _resetWeeklyData(String newWeekKey) async {
    await _prefs?.setString('current_week', newWeekKey);
    loginDays = List.filled(7, false);
    
    for (int i = 0; i < 7; i++) {
      await _prefs?.setBool('day_$i', false);
    }
  }

  Future<void> _loadCurrentWeekData() async {
    for (int i = 0; i < 7; i++) {
      loginDays[i] = _prefs?.getBool('day_$i') ?? false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _themeManager.backgroundColor,
      appBar: AppBar(
        title: Text(
          'ล็อกอินรับแต้ม',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: _themeManager.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: _themeManager.headerGradient,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.stars, size: 16, color: Colors.white),
                SizedBox(width: 4),
                Text(
                  '${_pointsManager.currentPoints}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              // Today's Login Reward
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: _themeManager.headerGradient,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: _themeManager.primaryColor.withValues(alpha: 0.4),
                      blurRadius: 15,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(32),
                child: Column(
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(70),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.5),
                          width: 4,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            canGetPointsToday ? '+${weeklyRewards[currentDayIndex]}' : '✓',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'แต้ม',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 24),
                    
                    Text(
                      'วันนี้ (${dayNames[currentDayIndex]})',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    
                    SizedBox(height: 8),
                    
                    Text(
                      canGetPointsToday 
                          ? 'พร้อมรับแต้มแล้ว!' 
                          : 'ได้รับแต้มแล้วในวันนี้',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    SizedBox(height: 28),
                    
                    if (canGetPointsToday)
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _claimPoints,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: _themeManager.primaryColor,
                            padding: EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 8,
                            shadowColor: Colors.black.withValues(alpha: 0.3),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.stars, size: 24),
                              SizedBox(width: 8),
                              Text(
                                'รับแต้ม ${weeklyRewards[currentDayIndex]} แต้ม',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle, color: Colors.white, size: 24),
                            SizedBox(width: 8),
                            Text(
                              'รับแต้มแล้วสำหรับวันนี้',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              
              SizedBox(height: 32),
              
              // Weekly Calendar Overview
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: _themeManager.cardColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: _themeManager.isDarkMode
                        ? Colors.black.withValues(alpha: 0.3)
                        : Colors.grey.withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _themeManager.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.calendar_month,
                            color: _themeManager.primaryColor,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'สัปดาห์นี้',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: _themeManager.textPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 24),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(7, (index) {
                        final isToday = index == currentDayIndex;
                        final isCompleted = loginDays[index];
                        
                        return Column(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: isCompleted 
                                    ? Colors.green[500]
                                    : isToday 
                                      ? _themeManager.primaryColor
                                      : _themeManager.isDarkMode
                                        ? Colors.grey[800]
                                        : Colors.grey[100],
                                borderRadius: BorderRadius.circular(22),
                                border: isToday && !isCompleted
                                    ? Border.all(color: _themeManager.primaryColor, width: 3)
                                    : null,
                                boxShadow: isCompleted || isToday ? [
                                  BoxShadow(
                                    color: (isCompleted ? Colors.green : _themeManager.primaryColor).withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ] : null,
                              ),
                              child: Icon(
                                isCompleted 
                                    ? Icons.check
                                    : isToday
                                      ? Icons.star
                                      : Icons.circle_outlined,
                                color: isCompleted || isToday 
                                    ? Colors.white
                                    : _themeManager.textSecondaryColor,
                                size: 22,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              dayNames[index].substring(0, 2),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isToday ? _themeManager.primaryColor : _themeManager.textSecondaryColor,
                              ),
                            ),
                            SizedBox(height: 4),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: _themeManager.primaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${weeklyRewards[index]}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: _themeManager.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                    
                    SizedBox(height: 20),
                    
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _themeManager.isDarkMode
                          ? Colors.grey[800]
                          : Colors.grey[50],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.trending_up, color: Colors.green[600], size: 20),
                          SizedBox(width: 8),
                          Text(
                            'ความคืบหน้า: ${loginDays.where((day) => day).length}/7 วัน',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _themeManager.textPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 24),
              
              // Quick Stats Card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: _themeManager.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: _themeManager.isDarkMode
                        ? Colors.black.withValues(alpha: 0.3)
                        : Colors.grey.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.analytics, color: Colors.blue[600], size: 24),
                        SizedBox(width: 12),
                        Text(
                          'สถิติการรับแต้ม',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _themeManager.textPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatItem(
                            'วันนี้', 
                            '${_pointsManager.getTodayEarnedPoints()}', 
                            'แต้ม', 
                            Colors.green,
                            Icons.today
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildStatItem(
                            'สัปดาห์นี้', 
                            '${_pointsManager.getWeeklyEarnedPoints()}', 
                            'แต้ม', 
                            Colors.blue,
                            Icons.date_range
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String unit, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: _themeManager.textSecondaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              SizedBox(width: 4),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 14,
                  color: _themeManager.textSecondaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Future<void> _claimPoints() async {
    if (!canGetPointsToday) return;
    
    final pointsEarned = weeklyRewards[currentDayIndex];
    final todayKey = _getTodayKey();
    
    await _prefs?.setBool('checkin_$todayKey', true);
    await _prefs?.setBool('day_$currentDayIndex', true);
    
    setState(() {
      loginDays[currentDayIndex] = true;
      canGetPointsToday = false;
    });
    
    _pointsManager.addPoints(
      pointsEarned, 
      'เช็คอินประจำวัน (${dayNames[currentDayIndex]})',
      source: 'daily_login'
    );
    
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: _themeManager.cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green[400]!, Colors.green[600]!],
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    Icons.check_circle,
                    size: 56,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'รับแต้มสำเร็จ!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _themeManager.textPrimaryColor,
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _themeManager.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '+$pointsEarned แต้ม',
                    style: TextStyle(
                      fontSize: 22,
                      color: _themeManager.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'แต้มรวม: ${_pointsManager.currentPoints} แต้ม',
                  style: TextStyle(
                    fontSize: 16,
                    color: _themeManager.textSecondaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            actions: [
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    backgroundColor: _themeManager.primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'เยี่ยมเลย!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }
}