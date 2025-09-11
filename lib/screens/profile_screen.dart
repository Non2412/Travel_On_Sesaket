import 'package:flutter/material.dart';
import 'login_screen.dart';

// ตัวอย่าง user mock สำหรับเดโม
class MockUser {
  final String name;
  final String email;
  MockUser({required this.name, required this.email});
}

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // จำลองสถานะล็อกอิน (จริงๆ ควรใช้ Provider/BLoC หรือดึงจาก API)
  MockUser? user;

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
                              user != null ? user!.name : 'ผู้เยี่ยมชม',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              user != null
                                  ? user!.email
                                  : 'เข้าสู่ระบบเพื่อประสบการณ์ที่ดีขึ้น',
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
                    if (user == null) ...[
                      // Auth Buttons
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            // ไปหน้า Login แล้วรับค่ากลับมา (mock)
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                            );
                            // สมมุติล็อกอินสำเร็จ รับชื่อกับอีเมลกลับมา
                            if (result is Map<String, String>) {
                              setState(() {
                                user = MockUser(
                                  name: result['name'] ?? 'ผู้ใช้ใหม่',
                                  email: result['email'] ?? '',
                                );
                              });
                            }
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
                          onPressed: () async {
                            // ไปหน้า Login (โหมดสมัครสมาชิก)
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen(isSignup: true)),
                            );
                            if (result is Map<String, String>) {
                              setState(() {
                                user = MockUser(
                                  name: result['name'] ?? 'ผู้ใช้ใหม่',
                                  email: result['email'] ?? '',
                                );
                              });
                            }
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
                    ] else ...[
                      // Logout Button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              user = null;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            side: BorderSide(color: Colors.orange),
                          ),
                          child: Text(
                            'ออกจากระบบ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ),
                    ],
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