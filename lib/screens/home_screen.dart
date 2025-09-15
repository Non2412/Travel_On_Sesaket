import 'package:flutter/material.dart';

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
      'location': 'ศรีสะเกษ',
    },
    {
      'title': 'เทศกาลดอกคูณ',
      'date': '20-22 เม.ย.',
      'location': 'อำเภอกันทรลักษ์',
    },
  ];

  final List<Map<String, dynamic>> places = [
    {
      'name': 'ปราสาทเขาพนมรุ้ง',
      'rating': 4.8,
      'distance': '2.5 km',
      'price': 'ฟรี',
    },
    {
      'name': 'อุทยานแห่งชาติเขาพระวิหาร',
      'rating': 4.6,
      'distance': '15 km',
      'price': '฿40',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[400]!, Colors.deepOrange[200]!],
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 36, color: Colors.orange),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'โปรไฟล์',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'เข้าสู่ระบบเพื่อประสบการณ์ที่ดีขึ้น',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('โปรไฟล์'),
              onTap: () {
                Navigator.pop(context);
                // ไปหน้าโปรไฟล์
                // Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('รายการโปรด'),
              onTap: () {
                Navigator.pop(context);
                // ไปหน้ารายการโปรด
              },
            ),
            ListTile(
              leading: Icon(Icons.star),
              title: Text('รีวิวของฉัน'),
              onTap: () {
                Navigator.pop(context);
                // ไปหน้ารีวิวของฉัน
              },
            ),
            ListTile(
              leading: Icon(Icons.event),
              title: Text('กิจกรรม'),
              onTap: () {
                Navigator.pop(context);
                // ไปหน้ากิจกรรม
              },
            ),
            ListTile(
              leading: Icon(Icons.place),
              title: Text('สถานที่แนะนำ'),
              onTap: () {
                Navigator.pop(context);
                // ไปหน้าสถานที่แนะนำ
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange[400]!, Colors.deepOrange[200]!],
                    begin: Alignment.topLeft,
                    end: Alignment.topRight,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // ปุ่มเมนู (hamburger)
                        Builder(
                          builder: (context) => IconButton(
                            icon: Icon(Icons.menu, color: Colors.white, size: 28),
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
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
                                'ยินดีต้อนรับสู่เที่ยวศรีสะเกษกัน',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.notifications, color: Colors.white),
                        SizedBox(width: 16),
                        Icon(Icons.person, color: Colors.white),
                      ],
                    ),
                    SizedBox(height: 20),
                    // ช่องค้นหา
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'ค้นหาสถานที่ท่องเที่ยว...',
                        prefixIcon: Icon(Icons.search, color: Colors.orange),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // หมวดหมู่
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildSection(
                  'หมวดหมู่',
                  SizedBox(
                    height: 80,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      separatorBuilder: (_, __) => SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        return Column(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.orange[100],
                              child: Text(
                                cat['icon'],
                                style: TextStyle(fontSize: 28),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(cat['name'], style: TextStyle(fontSize: 13)),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32),
              // กิจกรรม
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildSection(
                  'กิจกรรม',
                  Column(
                    children: events
                        .map(
                          (event) => Card(
                            margin: EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              title: Text(event['title']),
                              subtitle: Text(
                                '${event['date']} • ${event['location']}',
                              ),
                              leading: Icon(Icons.event, color: Colors.orange),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              SizedBox(height: 32),
              // สถานที่แนะนำ
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildSection(
                  'สถานที่แนะนำ',
                  Column(
                    children: places
                        .map(
                          (place) => Card(
                            margin: EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              title: Text(place['name']),
                              subtitle: Text(
                                '⭐ ${place['rating']}  •  ${place['distance']}  •  ${place['price']}',
                              ),
                              leading: Icon(Icons.place, color: Colors.orange),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              SizedBox(height: 24),
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
