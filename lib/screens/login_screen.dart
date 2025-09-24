import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  final bool isSignup;
  const LoginScreen({Key? key, this.isSignup = false}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late bool isLogin;
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String name = '';

  @override
  void initState() {
    super.initState();
    isLogin = !widget.isSignup;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 32),
                if (!isLogin)
                  TextFormField(
                    decoration: InputDecoration(labelText: 'ชื่อผู้ใช้'),
                    onChanged: (val) => name = val,
                    validator: (val) => val!.isEmpty ? 'กรุณากรอกชื่อ' : null,
                  ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'อีเมล'),
                  onChanged: (val) => email = val,
                  validator: (val) => val!.isEmpty ? 'กรุณากรอกอีเมล' : null,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'รหัสผ่าน'),
                  obscureText: true,
                  onChanged: (val) => password = val,
                  validator: (val) => val!.length < 6 ? 'รหัสผ่านอย่างน้อย 6 ตัว' : null,
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // ส่งข้อมูลกลับไป ProfileScreen (mock)
                      Navigator.of(context).pop({
                        'name': name.isNotEmpty ? name : 'ผู้ใช้ใหม่',
                        'email': email,
                      });
                    }
                  },
                  child: Text(isLogin ? 'เข้าสู่ระบบ' : 'สมัครสมาชิก'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: Size(double.infinity, 48),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isLogin = !isLogin;
                    });
                  },
                  child: Text(isLogin
                      ? 'ยังไม่มีบัญชี? สมัครสมาชิก'
                      : 'มีบัญชีแล้ว? เข้าสู่ระบบ'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}