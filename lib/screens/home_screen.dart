import 'my_reviews_screen.dart';
import 'package:flutter/material.dart';
import 'thread_list_screen.dart';
import 'points_screen.dart';
import 'checkin_screen.dart';
import '../points_manager.dart'; // Import PointsManager

// Import the global activity data from main.dart
import '../main.dart';

class HomeScreen extends StatefulWidget {
  final Function(int)? onNavigateToTab;
  
  const HomeScreen({super.key, this.onNavigateToTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PointsManager _pointsManager;
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _pointsManager = PointsManager();
    _pointsManager.addListener(_onPointsChanged);
    // Add listener for activity updates
    ActivityData.addListener(_refreshData);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pointsManager.removeListener(_onPointsChanged);
    // Remove listener when widget is disposed
    ActivityData.removeListener(_refreshData);
    super.dispose();
  }

  void _onPointsChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  // Add method to refresh when returning from other screens
  void _refreshData() {
    if (mounted) {
      setState(() {
        // This will trigger rebuild with latest data
      });
    }
  }
  
  final List<Map<String, dynamic>> categories = const [
    {'icon': '🏛️', 'name': 'ประวัติศาสตร์', 'count': 15},
    {'icon': '🌿', 'name': 'ธรรมชาติ', 'count': 23},
    {'icon': '🏛️', 'name': 'วัด', 'count': 18},
    {'icon': '🍜', 'name': 'อาหาร', 'count': 45},
    {'icon': '🛍️', 'name': 'ช้อปปิ้ง', 'count': 12},
    {'icon': '🎭', 'name': 'วัฒนธรรม', 'count': 8},
  ];

  final List<Map<String, dynamic>> places = const [
    {
      'name': 'ปราสาทเขาพนมรุ้ง',
      'rating': 4.8,
      'distance': '2.5 km',
      'price': 'ฟรี'
    },
    {
      'name': 'อุทยานแห่งชาติเขาพระวิหาร',
      'rating': 4.6,
      'distance': '15 km', 
      'price': '฿40'
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Get activities from global state
    final events = ActivityData.getEvents();
    final allActivities = ActivityData.getActivities();
    
    // Debug print to check data
    print('Events count: ${events.length}');
    print('All activities count: ${allActivities.length}');
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      // เพิ่ม Drawer
      drawer: _buildDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange[500]!, Colors.red[500]!],
                    begin: Alignment.topLeft,
                    end: Alignment.topRight,
                  ),
                ),
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Top Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            // ใช้ Builder เพื่อเปิด Drawer
                            Builder(
                              builder: (context) => GestureDetector(
                                onTap: () => Scaffold.of(context).openDrawer(),
                                child: Icon(Icons.menu, color: Colors.white),
                              ),
                            ),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'สวัสดีครับ! 👋',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'มาเที่ยวศรีสะเกษกัน',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Navigate to notifications tab (index 3)
                                if (widget.onNavigateToTab != null) {
                                  widget.onNavigateToTab!(3);
                                }
                              },
                              child: Icon(Icons.notifications, color: Colors.white),
                            ),
                            SizedBox(width: 12),
                            CircleAvatar(
                              backgroundColor: Colors.white.withValues(alpha: 0.2),
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Updated Search Bar - Removed camera icon and made it interactive
                    GestureDetector(
                      onTap: () {
                        // Navigate to search tab (index 1)
                        if (widget.onNavigateToTab != null) {
                          widget.onNavigateToTab!(1);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: Colors.grey[600]),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'ค้นหาสถานที่ท่องเที่ยว...',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ),
                            // Camera icon removed
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Categories
                    _buildSection(
                      'หมวดหมู่',
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final cat = categories[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(cat['icon'] as String, style: TextStyle(fontSize: 32)),
                                SizedBox(height: 8),
                                Text(
                                  cat['name'] as String,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  '${cat['count']} แห่ง',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    
                    SizedBox(height: 24),
                    
                    // Events
                    _buildSection(
                      'กิจกรรม',
                      allActivities.isEmpty
                          ? _buildEmptyEventsState()
                          : Column(
                              children: allActivities.take(3).map((event) => _buildEventCard(event)).toList(),
                            ),
                      showSeeAll: allActivities.isNotEmpty,
                      onSeeAllTap: () {
                        // Navigate to activities tab (index 2)
                        if (widget.onNavigateToTab != null) {
                          widget.onNavigateToTab!(2);
                        }
                      },
                    ),
                    
                    SizedBox(height: 24),
                    
                    // Places
                    _buildSection(
                      'สถานที่แนะนำ',
                      Column(
                        children: places.map((place) => Container(
                          margin: EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.1),
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image Placeholder
                              Container(
                                width: double.infinity,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.image,
                                        size: 48,
                                        color: Colors.grey[400],
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'รูปภาพสถานที่',
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              
                              // Content
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            place['name'] as String,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.favorite_border,
                                          color: Colors.grey[400],
                                        ),
                                      ],
                                    ),
                                    
                                    SizedBox(height: 12),
                                    
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.star, color: Colors.amber, size: 16),
                                            SizedBox(width: 4),
                                            Text('${place['rating']}', 
                                              style: TextStyle(fontWeight: FontWeight.w600)),
                                            SizedBox(width: 16),
                                            Icon(Icons.location_on, color: Colors.grey[500], size: 16),
                                            SizedBox(width: 4),
                                            Text(place['distance'] as String,
                                              style: TextStyle(color: Colors.grey[600])),
                                          ],
                                        ),
                                        Text(
                                          place['price'] as String,
                                          style: TextStyle(
                                            color: Colors.green[600],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )).toList(),
                      ),
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

  // เพิ่ม Drawer Widget
  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange[500]!, Colors.red[500]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 35,
                        color: Colors.orange[500],
                      ),
                    ),
                    Spacer(),
                    // Points Display in Drawer Header - ใช้ข้อมูลจาก PointsManager
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PointsScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.stars,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              '${_pointsManager.currentPoints}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'แต้ม',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'โปรไฟล์',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'จัดการบัญชีและข้อมูลการท่องเที่ยว',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.person,
                  title: 'โปรไฟล์',
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to profile or handle profile action
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.event_available,
                  title: 'เช็คอินรับแต้มฟรี',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckInScreen(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.favorite,
                  title: 'รายการโปรด',
                  onTap: () {
                    Navigator.pop(context);
                    // Handle favorites
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.star,
                  title: 'รีวิวของฉัน',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyReviewsScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.event,
                  title: 'กิจกรรม',
                  onTap: () {
                    Navigator.pop(context);
                    if (widget.onNavigateToTab != null) {
                      widget.onNavigateToTab!(2); // Navigate to activities tab
                    }
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.location_on,
                  title: 'สถานที่ใกล้ฉัน',
                  onTap: () {
                    Navigator.pop(context);
                    // Handle nearby places
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.forum,
                  title: 'กระทู้',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ThreadListScreen(),
                      ),
                    );
                  },
                ),
                Divider(),
                _buildDrawerItem(
                  icon: Icons.settings,
                  title: 'ตั้งค่า',
                  onTap: () {
                    Navigator.pop(context);
                    // Handle settings
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.help,
                  title: 'ช่วยเหลือ',
                  onTap: () {
                    Navigator.pop(context);
                    // Handle help
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.logout,
                  title: 'ออกจากระบบ',
                  onTap: () {
                    Navigator.pop(context);
                    // Handle logout
                    _showLogoutDialog();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.grey[600],
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[800],
        ),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ออกจากระบบ'),
          content: Text('คุณต้องการออกจากระบบหรือไม่?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Handle actual logout logic here
                print('User logged out');
              },
              child: Text(
                'ออกจากระบบ',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyEventsState() {
    return Container(
      padding: EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.event_note,
            size: 48,
            color: Colors.grey[400],
          ),
          SizedBox(height: 12),
          Text(
            'ยังไม่มีกิจกรรม',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 4),
          Text(
            'เพิ่มกิจกรรมใหม่ได้ในแท็บกิจกรรม',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.orange[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.event,
              color: Colors.orange[600],
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event['title'] as String,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  event['location'] as String,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                if (event['date'] != null && event['time'] != null)
                  Text(
                    _formatEventDateTime(event),
                    style: TextStyle(
                      color: Colors.orange[500],
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatEventDateTime(Map<String, dynamic> event) {
    if (event['date'] != null && event['time'] != null) {
      final date = event['date'] as DateTime;
      final time = event['time'] as TimeOfDay;
      return '${date.day}/${date.month}/${date.year} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
    return '';
  }
  
  Widget _buildSection(String title, Widget content, {bool showSeeAll = true, VoidCallback? onSeeAllTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            if (showSeeAll)
              GestureDetector(
                onTap: onSeeAllTap,
                child: Text(
                  'ดูทั้งหมด',
                  style: TextStyle(
                    color: Colors.orange[500],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 16),
        content,
      ],
    );
  }
}