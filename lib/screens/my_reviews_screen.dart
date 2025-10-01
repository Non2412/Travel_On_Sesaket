import 'package:flutter/material.dart';

class MyReviewsScreen extends StatelessWidget {
  // ตัวอย่างข้อมูลรีวิว (ในอนาคตควรดึงจากฐานข้อมูลหรือ API)
  final List<Map<String, String>> myReviews = const [
    {
      'place': 'วัดพระธาตุเชิงชุม',
      'review': 'บรรยากาศดีมาก สงบ ร่มรื่น',
      'date': '2025-09-01',
    },
    {
      'place': 'สวนสมเด็จศรีนครินทร์',
      'review': 'เหมาะกับการพักผ่อนและถ่ายรูป',
      'date': '2025-08-20',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รีวิวของฉัน', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orange,
      ),
      body: myReviews.isEmpty
          ? Center(child: Text('ยังไม่มีรีวิวของคุณ'))
          : ListView.builder(
              itemCount: myReviews.length,
              itemBuilder: (context, index) {
                final review = myReviews[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Icon(Icons.rate_review, color: Colors.orange),
                    title: Text(review['place'] ?? ''),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(review['review'] ?? ''),
                        SizedBox(height: 4),
                        Text('วันที่: ${review['date']}', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
