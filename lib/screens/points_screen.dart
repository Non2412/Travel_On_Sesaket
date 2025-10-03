import 'package:flutter/material.dart';
import '../points_manager.dart';
import '../theme_manager.dart';

class PointsScreen extends StatefulWidget {
  const PointsScreen({super.key});

  @override
  State<PointsScreen> createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> with TickerProviderStateMixin {
  late PointsManager _pointsManager;
  late ThemeManager _themeManager;
  late TabController _tabController;
  
  // รายการรางวัล - ใช้ฟังก์ชันเพื่อให้สีเปลี่ยนตามธีม
  List<Map<String, dynamic>> get rewards => [
    {
      'id': 1,
      'name': 'ส่วนลดร้านอาหาร 15%',
      'description': 'ส่วนลดร้านอาหารในจังหวัดศรีสะเกษ',
      'points': 150,
      'icon': Icons.restaurant,
      'color': _themeManager.isBlueTheme ? Colors.blue[600]! : Colors.orange[600]!,
      'category': 'อาหาร',
      'available': 20,
    },
    {
      'id': 2,
      'name': 'ส่วนลดที่พัก 25%',
      'description': 'ส่วนลดที่พักในจังหวัดศรีสะเกษ',
      'points': 450,
      'icon': Icons.hotel,
      'color': _themeManager.isBlueTheme ? Colors.indigo[600]! : Colors.red[600]!,
      'category': 'ที่พัก',
      'available': 10,
    },
    {
      'id': 3,
      'name': 'ของที่ระลึก',
      'description': 'ของที่ระลึกพิเศษจากศรีสะเกษ',
      'points': 75,
      'icon': Icons.card_giftcard,
      'color': _themeManager.isBlueTheme ? Colors.cyan[600]! : Colors.pink[600]!,
      'category': 'ของฝาก',
      'available': 30,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pointsManager = PointsManager();
    _pointsManager.addListener(_onPointsChanged);
    _themeManager = ThemeManager();
    _themeManager.addListener(_onThemeChanged);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _pointsManager.removeListener(_onPointsChanged);
    _themeManager.removeListener(_onThemeChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onPointsChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onThemeChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _themeManager.backgroundColor,
      appBar: AppBar(
        title: Text(
          'แต้มของฉัน',
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
      ),
      body: Column(
        children: [
          // ส่วนแสดงแต้มปัจจุบัน
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: _themeManager.headerGradient,
            ),
            padding: EdgeInsets.all(32),
            child: Column(
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(75),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.5),
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 15,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.stars,
                        size: 48,
                        color: Colors.white,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${_pointsManager.currentPoints}',
                        style: TextStyle(
                          fontSize: 36,
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
                  'แต้มสะสมของคุณ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'นำแต้มไปแลกรางวัลได้เลย!',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          
          // Tab Bar
          Container(
            color: _themeManager.cardColor,
            child: TabBar(
              controller: _tabController,
              indicatorColor: _themeManager.primaryColor,
              labelColor: _themeManager.primaryColor,
              unselectedLabelColor: _themeManager.textSecondaryColor,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              tabs: [
                Tab(
                  icon: Icon(Icons.history),
                  text: 'ประวัติ',
                ),
                Tab(
                  icon: Icon(Icons.card_giftcard),
                  text: 'แลกรางวัล',
                ),
              ],
            ),
          ),
          
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildHistoryTab(),
                _buildRewardsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    final history = _pointsManager.pointsHistory;
    
    if (history.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: _themeManager.textSecondaryColor.withValues(alpha: 0.5),
            ),
            SizedBox(height: 16),
            Text(
              'ยังไม่มีประวัติการใช้แต้ม',
              style: TextStyle(
                fontSize: 18,
                color: _themeManager.textSecondaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'เริ่มสะสมแต้มและใช้แต้มกันเลย!',
              style: TextStyle(
                fontSize: 14,
                color: _themeManager.textSecondaryColor.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        final isEarned = item['type'] == 'earned';
        
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: _themeManager.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _themeManager.isDarkMode 
                  ? Colors.black.withValues(alpha: 0.3)
                  : Colors.grey.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isEarned 
                    ? Colors.green[100] 
                    : Colors.red[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getIconData(item['icon']),
                color: isEarned 
                    ? Colors.green[600] 
                    : Colors.red[600],
              ),
            ),
            title: Text(
              item['title'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: _themeManager.textPrimaryColor,
              ),
            ),
            subtitle: Text(
              '${item['date']} เวลา ${item['time']}',
              style: TextStyle(
                color: _themeManager.textSecondaryColor,
                fontSize: 14,
              ),
            ),
            trailing: Text(
              '${isEarned ? '+' : ''}${item['points']} แต้ม',
              style: TextStyle(
                color: isEarned 
                    ? Colors.green[600] 
                    : Colors.red[600],
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRewardsTab() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: rewards.length,
      itemBuilder: (context, index) {
        final reward = rewards[index];
        final canRedeem = _pointsManager.hasEnoughPoints(reward['points']);
        
        return Container(
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: _themeManager.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _themeManager.isDarkMode 
                  ? Colors.black.withValues(alpha: 0.3)
                  : Colors.grey.withValues(alpha: 0.1),
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: reward['color'].withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        reward['icon'],
                        color: reward['color'],
                        size: 32,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reward['name'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _themeManager.textPrimaryColor,
                            ),
                          ),
                          SizedBox(height: 4),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: reward['color'].withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              reward['category'],
                              style: TextStyle(
                                color: reward['color'],
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${reward['points']} แต้ม',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _themeManager.primaryColor,
                          ),
                        ),
                        Text(
                          'เหลือ ${reward['available']} ชิ้น',
                          style: TextStyle(
                            fontSize: 12,
                            color: _themeManager.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                SizedBox(height: 12),
                
                Text(
                  reward['description'],
                  style: TextStyle(
                    fontSize: 14,
                    color: _themeManager.textSecondaryColor,
                    height: 1.4,
                  ),
                ),
                
                SizedBox(height: 16),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: canRedeem && reward['available'] > 0
                        ? () => _redeemReward(reward)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canRedeem && reward['available'] > 0
                          ? _themeManager.primaryColor
                          : _themeManager.textSecondaryColor.withValues(alpha: 0.3),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: canRedeem && reward['available'] > 0 ? 2 : 0,
                    ),
                    child: Text(
                      _getButtonText(canRedeem, reward['available']),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getButtonText(bool canRedeem, int available) {
    if (available <= 0) return 'หมดแล้ว';
    if (!canRedeem) return 'แต้มไม่เพียงพอ';
    return 'แลกเลย!';
  }

  void _redeemReward(Map<String, dynamic> reward) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: _themeManager.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                reward['icon'],
                color: reward['color'],
                size: 32,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'แลกรางวัล',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _themeManager.textPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                reward['name'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _themeManager.textPrimaryColor,
                ),
              ),
              SizedBox(height: 8),
              Text(
                reward['description'],
                style: TextStyle(
                  color: _themeManager.textSecondaryColor,
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _themeManager.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.stars, color: _themeManager.primaryColor),
                    SizedBox(width: 8),
                    Text(
                      'ใช้ ${reward['points']} แต้ม',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _themeManager.primaryColor,
                      ),
                    ),
                    Spacer(),
                    Text(
                      'คงเหลือ: ${_pointsManager.currentPoints - reward['points']} แต้ม',
                      style: TextStyle(
                        fontSize: 14,
                        color: _themeManager.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'ยกเลิก',
                style: TextStyle(
                  color: _themeManager.textSecondaryColor,
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _pointsManager.removePoints(reward['points'], 'แลกรางวัล: ${reward['name']}');
                
                // ลดจำนวนรางวัลที่เหลือ
                setState(() {
                  reward['available']--;
                });
                
                Navigator.pop(context);
                
                // แสดง Dialog สำเร็จ
                _showSuccessDialog(reward);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _themeManager.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'แลกเลย!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(Map<String, dynamic> reward) {
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
                'แลกรางวัลสำเร็จ!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _themeManager.textPrimaryColor,
                ),
              ),
              SizedBox(height: 12),
              Text(
                reward['name'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: _themeManager.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                'แต้มคงเหลือ: ${_pointsManager.currentPoints} แต้ม',
                style: TextStyle(
                  fontSize: 16,
                  color: _themeManager.textSecondaryColor,
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

  IconData _getIconData(String iconString) {
    switch (iconString) {
      case 'login':
        return Icons.login;
      case 'event_available':
        return Icons.event_available;
      case 'star_rate':
        return Icons.star_rate;
      case 'location_on':
        return Icons.location_on;
      case 'share':
        return Icons.share;
      case 'event':
        return Icons.event;
      case 'redeem':
        return Icons.redeem;
      default:
        return Icons.stars;
    }
  }
}