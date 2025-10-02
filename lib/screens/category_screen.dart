import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  final String categoryName;
  final String categoryIcon;

  const CategoryScreen({
    Key? key,
    required this.categoryName,
    required this.categoryIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ตัวอย่างข้อมูล สามารถเปลี่ยนเป็นดึงจาก API หรือ model จริงได้
    final List<Map<String, dynamic>> items = List.generate(
      10,
      (index) => {
        'name': '$categoryName สถานที่ที่ {index + 1}',
        'desc': 'รายละเอียดของ $categoryName สถานที่ที่ {index + 1}',
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('$categoryIcon $categoryName'),
        backgroundColor: Colors.orange,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(24),
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            child: ListTile(
              title: Text(item['name']),
              subtitle: Text(item['desc']),
            ),
          );
        },
      ),
    );
  }
}
