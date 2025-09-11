import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  final List<String> filters = ['ทั้งหมด', 'ใกล้ฉัน', 'ยอดนิยม'];
  final List<Map<String, dynamic>> results = [
    {
      'name': 'วัดพระธาตุเรืองรอง',
      'type': 'วัด',
      'distance': '3.2 km',
      'rating': 4.7,
    },
    {
      'name': 'อุทยานแห่งชาติเขาพระวิหาร',
      'type': 'ธรรมชาติ',
      'distance': '15 km',
      'rating': 4.6,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Text(
                'ค้นหาสถานที่ท่องเที่ยว',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[700],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'ค้นหาสถานที่หรือกิจกรรม...',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            // Filters
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: filters.map((f) => Container(
                  margin: EdgeInsets.only(right: 12),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    f,
                    style: TextStyle(
                      color: Colors.orange[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )).toList(),
              ),
            ),
            SizedBox(height: 16),
            // Results
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 24),
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final place = results[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      leading: Icon(Icons.place, color: Colors.orange),
                      title: Text(place['name']),
                      subtitle: Text('${place['type']} • ${place['distance']} • ⭐ ${place['rating']}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}