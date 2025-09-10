// main.dart
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(SiSaKetTravelApp());
}

class SiSaKetTravelApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ท่องเที่ยวศรีสะเกษ',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Kanit',
      ),
      home: MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    HomeScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.orange[600],
        unselectedItemColor: Colors.grey[600],
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'หน้าหลัก',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'ค้นหา',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'โปรไฟล์',
          ),
        ],
      ),
    );
  }
}

// screens/home_screen.dart
class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {'icon': '🏛️', 'name': 'ประวัติศาสตร์', 'count': 15},
    {'icon': '🌿', 'name': 'ธรรมชาติ', 'count': 23},
    {'icon': '🏛️', 'name': 'วัด', 'count': 18},
    {'icon': '🍜', 'name': 'อาหาร', 'count': 45},
    {'icon': '🛍️', 'name': 'ช้อปปิ้ง', 'count': 12},
    {'icon': '🎭', 'name': 'วัฒนธรรม', 'count': 8},
  ];

  final List<Map<String, dynamic>> events = [
    {
      'title': 'งานบุญบั้งไฟศรีสะเกษ',
      'date': '15-17 มี.ค.',
      'location': 'ศรีสะเกษ'
    },
    {
      'title': 'เทศกาลดอกคูณ', 
      'date': '20-22 เม.ย.',
      'location': 'อำเภอกันทรลักษ์'
    },
  ];

  final List<Map<String, dynamic>> places = [
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
    return Scaffold(
      backgroundColor: Colors.grey[50],
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
                            Icon(Icons.menu, color: Colors.white),
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
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.notifications, color: Colors.white),
                            SizedBox(width: 12),
                            CircleAvatar(
                              backgroundColor: Colors.white.withOpacity(0.2),
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
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
                          Icon(Icons.camera_alt, color: Colors.orange[500]),
                        ],
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
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(cat['icon'], style: TextStyle(fontSize: 32)),
                                SizedBox(height: 8),
                                Text(
                                  cat['name'],
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
                      Column(
                        children: events.map((event) => Container(
                          margin: EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
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
                                      event['title'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      event['location'],
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      event['date'],
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
                        )).toList(),
                      ),
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
                                color: Colors.grey.withOpacity(0.1),
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
                                            place['name'],
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
                                            Text(place['distance'],
                                              style: TextStyle(color: Colors.grey[600])),
                                          ],
                                        ),
                                        Text(
                                          place['price'],
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
  
  Widget _buildSection(String title, Widget content) {
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
            Text(
              'ดูทั้งหมด',
              style: TextStyle(
                color: Colors.orange[500],
                fontWeight: FontWeight.w500,
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

// screens/search_screen.dart
class SearchScreen extends StatelessWidget {
  final List<String> filters = ['ทั้งหมด', 'ใกล้ฉัน', 'ยอดนิยม'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Search Header
            Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Icon(Icons.search, color: Colors.grey[600]),
                              SizedBox(width: 12),
                              Text(
                                'ค้นหา...',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.orange[500],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Filters
                  Row(
                    children: filters.asMap().entries.map((entry) {
                      int index = entry.key;
                      String filter = entry.value;
                      return Container(
                        margin: EdgeInsets.only(right: 8),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: index == 0 ? Colors.orange[500] : Colors.grey[100],
                            foregroundColor: index == 0 ? Colors.white : Colors.grey[600],
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(filter),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            
            // Empty State
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search,
                      size: 64,
                      color: Colors.grey[300],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'เริ่มค้นหา',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'ค้นหาสถานที่ที่คุณสนใจ',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// screens/profile_screen.dart
class ProfileScreen extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems = [
    {'icon': Icons.favorite, 'label': 'รายการโปรด', 'count': '0'},
    {'icon': Icons.location_on, 'label': 'สถานที่ที่เยี่ยม', 'count': '0'},
    {'icon': Icons.star, 'label': 'รีวิวของฉัน', 'count': '0'},
    {'icon': Icons.notifications, 'label': 'การแจ้งเตือน'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'โปรไฟล์',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.person,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ผู้เยี่ยมชม',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'เข้าสู่ระบบเพื่อประสบการณ์ที่ดีขึ้น',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Content
              Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Auth Buttons
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[500],
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'เข้าสู่ระบบ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 12),
                    
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          side: BorderSide(color: Colors.grey[300]!),
                        ),
                        child: Text(
                          'สมัครสมาชิก',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 32),
                    
                    // Menu Items
                    Column(
                      children: menuItems.map((item) => Container(
                        margin: EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(item['icon'], color: Colors.grey[600]),
                          ),
                          title: Text(
                            item['label'],
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (item['count'] != null)
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    item['count'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                              SizedBox(width: 8),
                              Icon(Icons.chevron_right, color: Colors.grey[400]),
                            ],
                          ),
                        ),
                      )).toList(),
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
}