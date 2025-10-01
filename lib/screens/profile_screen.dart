import 'package:flutter/material.dart';
import '../theme_manager.dart';
import 'favorites_screen.dart';

class LoginScreen extends StatefulWidget {
  final bool isSignup;
  const LoginScreen({Key? key, this.isSignup = false}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late bool isLogin;
  final _formKey = GlobalKey<FormState>();
  final ThemeManager _themeManager = ThemeManager();
  String email = '';
  String password = '';
  String name = '';

  @override
  void initState() {
    super.initState();
    isLogin = !widget.isSignup;
    _themeManager.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    _themeManager.removeListener(_onThemeChanged);
    super.dispose();
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: _themeManager.textPrimaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isLogin ? 'เข้าสู่ระบบ' : 'สมัครสมาชิก',
                  style: TextStyle(
                    fontSize: 28, 
                    fontWeight: FontWeight.bold,
                    color: _themeManager.primaryColor,
                  ),
                ),
                SizedBox(height: 32),
                if (!isLogin)
                  Container(
                    margin: EdgeInsets.only(bottom: 16),
                    child: TextFormField(
                      style: TextStyle(color: _themeManager.textPrimaryColor),
                      decoration: InputDecoration(
                        labelText: 'ชื่อผู้ใช้',
                        labelStyle: TextStyle(color: _themeManager.textSecondaryColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: _themeManager.textSecondaryColor.withValues(alpha: 0.3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: _themeManager.primaryColor),
                        ),
                        prefixIcon: Icon(Icons.person, color: _themeManager.textSecondaryColor),
                      ),
                      onChanged: (val) => name = val,
                      validator: (val) => val!.isEmpty ? 'กรุณากรอกชื่อ' : null,
                    ),
                  ),
                Container(
                  margin: EdgeInsets.only(bottom: 16),
                  child: TextFormField(
                    style: TextStyle(color: _themeManager.textPrimaryColor),
                    decoration: InputDecoration(
                      labelText: 'อีเมล',
                      labelStyle: TextStyle(color: _themeManager.textSecondaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: _themeManager.textSecondaryColor.withValues(alpha: 0.3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: _themeManager.primaryColor),
                      ),
                      prefixIcon: Icon(Icons.email, color: _themeManager.textSecondaryColor),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (val) => email = val,
                    validator: (val) => val!.isEmpty ? 'กรุณากรอกอีเมล' : null,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 24),
                  child: TextFormField(
                    style: TextStyle(color: _themeManager.textPrimaryColor),
                    decoration: InputDecoration(
                      labelText: 'รหัสผ่าน',
                      labelStyle: TextStyle(color: _themeManager.textSecondaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: _themeManager.textSecondaryColor.withValues(alpha: 0.3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: _themeManager.primaryColor),
                      ),
                      prefixIcon: Icon(Icons.lock, color: _themeManager.textSecondaryColor),
                    ),
                    obscureText: true,
                    onChanged: (val) => password = val,
                    validator: (val) => val!.length < 6 ? 'รหัสผ่านอย่างน้อย 6 ตัว' : null,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.of(context).pop({
                          'name': name.isNotEmpty ? name : 'ผู้ใช้ใหม่',
                          'email': email,
                          'isLoggedIn': true,
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _themeManager.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isLogin ? 'เข้าสู่ระบบ' : 'สมัครสมาชิก',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isLogin = !isLogin;
                    });
                  },
                  child: Text(
                    isLogin
                        ? 'ยังไม่มีบัญชี? สมัครสมาชิก'
                        : 'มีบัญชีแล้ว? เข้าสู่ระบบ',
                    style: TextStyle(color: _themeManager.primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ThemeManager _themeManager = ThemeManager();
  bool isLoggedIn = false;
  String userName = 'ผู้เยี่ยมชม';
  String userEmail = '';

  final List<Map<String, dynamic>> menuItems = const [
    {'icon': Icons.favorite, 'label': 'รายการโปรด', 'count': '3', 'route': 'favorites'},
    {'icon': Icons.location_on, 'label': 'สถานที่ที่เยี่ยม', 'count': '0'},
    {'icon': Icons.star, 'label': 'รีวิวของฉัน', 'count': '0'},
    {'icon': Icons.notifications, 'label': 'การแจ้งเตือน'},
  ];

  @override
  void initState() {
    super.initState();
    _themeManager.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    _themeManager.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _handleMenuTap(String? route, String label) {
    if (route == 'favorites') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FavoritesScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('กำลังพัฒนา: $label'),
          backgroundColor: _themeManager.primaryColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _themeManager.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                decoration: BoxDecoration(
                  gradient: _themeManager.headerGradient,
                ),
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'โปรไฟล์',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        if (isLoggedIn)
                          IconButton(
                            onPressed: () {
                              setState(() {
                                isLoggedIn = false;
                                userName = 'ผู้เยี่ยมชม';
                                userEmail = '';
                              });
                            },
                            icon: Icon(Icons.logout, color: Colors.white),
                          ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            isLoggedIn ? Icons.account_circle : Icons.person,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userName,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                isLoggedIn 
                                    ? userEmail 
                                    : 'เข้าสู่ระบบเพื่อประสบการณ์ที่ดีขึ้น',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          ),
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
                    // Auth Buttons (แสดงเฉพาะเมื่อยังไม่ได้ล็อกอิน)
                    if (!isLoggedIn) ...[
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(isSignup: false),
                              ),
                            );
                            
                            if (result != null && result['isLoggedIn'] == true) {
                              setState(() {
                                isLoggedIn = true;
                                userName = result['name'] ?? 'ผู้ใช้ใหม่';
                                userEmail = result['email'] ?? '';
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _themeManager.primaryColor,
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
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(isSignup: true),
                              ),
                            );
                            
                            if (result != null && result['isLoggedIn'] == true) {
                              setState(() {
                                isLoggedIn = true;
                                userName = result['name'] ?? 'ผู้ใช้ใหม่';
                                userEmail = result['email'] ?? '';
                              });
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            side: BorderSide(color: _themeManager.textSecondaryColor.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            'สมัครสมาชิก',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _themeManager.textSecondaryColor,
                            ),
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 32),
                    ],
                    
                    // Menu Items
                    Column(
                      children: menuItems.map((item) => Container(
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
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: item['route'] == 'favorites' 
                                  ? Colors.red[50] 
                                  : _themeManager.primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              item['icon'] as IconData, 
                              color: item['route'] == 'favorites' 
                                  ? Colors.red[400] 
                                  : _themeManager.primaryColor
                            ),
                          ),
                          title: Text(
                            item['label'] as String,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: _themeManager.textPrimaryColor,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (item['count'] != null)
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: item['route'] == 'favorites' 
                                        ? Colors.red[100] 
                                        : _themeManager.primaryColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    item['count'] as String,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: item['route'] == 'favorites' 
                                          ? Colors.red[700] 
                                          : _themeManager.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              SizedBox(width: 8),
                              Icon(Icons.chevron_right, color: _themeManager.textSecondaryColor),
                            ],
                          ),
                          onTap: () => _handleMenuTap(
                            item['route'] as String?, 
                            item['label'] as String
                          ),
                        ),
                      )).toList(),
                    ),
                    
                    // เพิ่มข้อมูลผู้ใช้เมื่อล็อกอินแล้ว
                    if (isLoggedIn) ...[
                      SizedBox(height: 32),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ข้อมูลบัญชี',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _themeManager.textPrimaryColor,
                              ),
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.person, color: _themeManager.textSecondaryColor),
                                SizedBox(width: 8),
                                Text(
                                  'ชื่อ: $userName',
                                  style: TextStyle(color: _themeManager.textPrimaryColor),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.email, color: _themeManager.textSecondaryColor),
                                SizedBox(width: 8),
                                Text(
                                  'อีเมล: $userEmail',
                                  style: TextStyle(color: _themeManager.textPrimaryColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
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