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
            // Filters (แนวนอน + ปุ่มดูทั้งหมด)
            Container(
              height: 48,
              margin: const EdgeInsets.only(left: 24, right: 0, bottom: 8),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: filters.length + 1,
                separatorBuilder: (_, __) => SizedBox(width: 8),
                itemBuilder: (context, index) {
                  if (index < filters.length) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        filters[index],
                        style: TextStyle(
                          color: Colors.orange[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  } else {
                    return TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('หมวดหมู่ทั้งหมด'),
                            content: SizedBox(
                              width: double.maxFinite,
                              child: ListView(
                                shrinkWrap: true,
                                children: filters.map((f) => ListTile(title: Text(f))).toList(),
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: Text('ปิด'),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text('ดูทั้งหมด', style: TextStyle(color: Colors.orange)),
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 8),
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