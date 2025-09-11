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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.orange, size: 28),
                    SizedBox(width: 8),
                    Text(
                      'ศรีสะเกษ',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[700],
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
                              child: Text(cat['icon'], style: TextStyle(fontSize: 28)),
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
                    children: events.map((event) => Card(
                      margin: EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(event['title']),
                        subtitle: Text('${event['date']} • ${event['location']}'),
                        leading: Icon(Icons.event, color: Colors.orange),
                      ),
                    )).toList(),
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
                    children: places.map((place) => Card(
                      margin: EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(place['name']),
                        subtitle: Text('⭐ ${place['rating']}  •  ${place['distance']}  •  ${place['price']}'),
                        leading: Icon(Icons.place, color: Colors.orange),
                      ),
                    )).toList(),
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
