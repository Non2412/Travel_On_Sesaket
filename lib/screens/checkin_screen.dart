import 'package:flutter/material.dart';
import '../points_manager.dart'; // Import PointsManager

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  late PointsManager _pointsManager;
  
  // รางวัลรายสัปดาห์ (วันจันทร์-อาทิตย์)
  final List<int> weeklyRewards = [5, 5, 10, 5, 5, 10, 15];
  final List<String> dayNames = ['จันทร์', 'อังคาร', 'พุธ', 'พฤหัสบดี', 'ศุกร์', 'เสาร์', 'อาทิตย์'];
  
  // จำลองข้อมูลการล็อกอิน
  List<bool> loginDays = [true, true, false, false, false, false, false];
  int currentDayIndex = 2; // วันปัจจุบัน (พุธ = index 2)
  bool canGetPointsToday = true;
  
  @override
  void initState() {
    super.initState();
    _pointsManager = PointsManager();
    // เพิ่ม listener เพื่ออัปเดต UI เมื่อแต้มเปลี่ยน
    _pointsManager.addListener(_updateUI);
  }

  @override
  void dispose() {
    _pointsManager.removeListener(_updateUI);
    super.dispose();
  }

  void _updateUI() {
    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'ล็อกอินรับแต้ม',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orange[500],
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          // แสดงแต้มปัจจุบันใน AppBar
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
              // Today's Login Reward - ปรับปรุงใหม่
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange[400]!, Colors.red[400]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withValues(alpha: 0.4),
                      blurRadius: 15,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(32),
                child: Column(
                  children: [
                    // Points Display - ขยายใหญ่ขึ้น
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
                    
                    // Get Points Button - ปรับปรุงสไตล์
                    if (canGetPointsToday)
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _claimPoints,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.orange[600],
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
              
              // Weekly Calendar Overview - ปรับปรุงสไตล์
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.15),
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
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.calendar_month,
                            color: Colors.orange[600],
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'สัปดาห์นี้',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 24),
                    
                    // Days Grid - ปรับปรุงดีไซน์
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
                                      ? Colors.orange[500]
                                      : Colors.grey[100],
                                borderRadius: BorderRadius.circular(22),
                                border: isToday && !isCompleted
                                    ? Border.all(color: Colors.orange[600]!, width: 3)
                                    : null,
                                boxShadow: isCompleted || isToday ? [
                                  BoxShadow(
                                    color: (isCompleted ? Colors.green : Colors.orange).withValues(alpha: 0.3),
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
                                    : Colors.grey[400],
                                size: 22,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              dayNames[index].substring(0, 2),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isToday ? Colors.orange[600] : Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 4),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.orange[50],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${weeklyRewards[index]}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange[600],
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Progress indicator
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
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
                              color: Colors.grey[700],
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
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
                            color: Colors.grey[800],
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
                  color: Colors.grey[600],
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
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  void _claimPoints() {
    if (!canGetPointsToday) return;
    
    final pointsEarned = weeklyRewards[currentDayIndex];
    
    setState(() {
      loginDays[currentDayIndex] = true;
      canGetPointsToday = false;
    });
    
    // เพิ่มแต้มผ่าน PointsManager
    _pointsManager.addPoints(
      pointsEarned, 
      'เช็คอินประจำวัน (${dayNames[currentDayIndex]})',
      source: 'daily_login'
    );
    
    // แสดง Dialog ยืนยัน - ปรับปรุงดีไซน์
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
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
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '+$pointsEarned แต้ม',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.orange[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 12),
              Text(
                'แต้มรวม: ${_pointsManager.currentPoints} แต้ม',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
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
                  backgroundColor: Colors.orange[500],
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