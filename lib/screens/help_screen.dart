import 'package:flutter/material.dart';
import '../theme_manager.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final ThemeManager _themeManager = ThemeManager();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _themeManager.backgroundColor,
      appBar: AppBar(
        title: Text(
          'ช่วยเหลือ',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: _themeManager.primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: _themeManager.headerGradient,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Contact Section
          _buildSectionHeader('ติดต่อเรา'),
          _buildHelpCard([
            _buildContactTile(
              icon: Icons.email,
              title: 'อีเมล',
              subtitle: 'stu6612732104@sskru.ac.th',
            ),
            Divider(color: _themeManager.textSecondaryColor.withValues(alpha: 0.3)),
            _buildContactTile(
              icon: Icons.phone,
              title: 'โทรศัพท์',
              subtitle: '062-715-6667',
            ),
            Divider(color: _themeManager.textSecondaryColor.withValues(alpha: 0.3)),
            _buildContactTile(
              icon: Icons.location_on,
              title: 'ที่อยู่',
              subtitle: 'สาขาวิทยาการคอมพิวเตอร์ มหาวิทยาลัยราชภัฏศรีสะเกษ',
            ),
          ]),

          SizedBox(height: 24),

          // FAQ Section
          _buildSectionHeader('คำถามที่พบบ่อย'),
          _buildFAQItem(
            question: 'แอปนี้ใช้งานอย่างไร?',
            answer: 'คุณสามารถเลือกดูกิจกรรมต่างๆ ในหน้าหลัก กดที่กิจกรรมที่สนใจเพื่อดูรายละเอียด และสามารถบันทึกกิจกรรมที่ชอบได้ที่หน้ารายการโปรด',
          ),
          SizedBox(height: 12),
          _buildFAQItem(
            question: 'จะเปลี่ยนธีมของแอปได้อย่างไร?',
            answer: 'ไปที่หน้าตั้งค่า (Settings) แล้วเลือกเปิด/ปิดโหมดมืด หรือเปลี่ยนสีธีมระหว่างน้ำเงินและส้ม',
          ),
          SizedBox(height: 12),
          _buildFAQItem(
            question: 'ข้อมูลกิจกรรมมาจากไหน?',
            answer: 'ข้อมูลกิจกรรมทั้งหมดมาจากหน่วยงานการท่องเที่ยวจังหวัดศรีสะเกษ และมีการอัพเดทอย่างสม่ำเสมอ',
          ),
          SizedBox(height: 12),
          _buildFAQItem(
            question: 'จะรายงานปัญหาหรือข้อผิดพลาดได้อย่างไร?',
            answer: 'คุณสามารถติดต่อเราผ่านอีเมลหรือโทรศัพท์ด้านบน ทีมงานจะดำเนินการแก้ไขโดยเร็วที่สุด',
          ),
          SizedBox(height: 12),
          _buildFAQItem(
            question: 'แอปนี้ใช้งานได้ฟรีหรือไม่?',
            answer: 'ใช่ค่ะ แอปนี้ให้บริการฟรีสำหรับทุกคน เพื่อส่งเสริมการท่องเที่ยวในจังหวัดศรีสะเกษ',
          ),

          SizedBox(height: 24),

          // Feedback Section
          _buildSectionHeader('ให้คำติชม'),
          _buildHelpCard([
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'เราต้องการฟังความคิดเห็นของคุณ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _themeManager.textPrimaryColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'หากคุณมีข้อเสนอแนะหรือพบปัญหาในการใช้งาน กรุณาติดต่อเราผ่านช่องทางด้านบน',
                    style: TextStyle(
                      fontSize: 14,
                      color: _themeManager.textSecondaryColor,
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _showFeedbackDialog();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _themeManager.primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'ส่งคำติชม',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: _themeManager.textPrimaryColor,
        ),
      ),
    );
  }

  Widget _buildHelpCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: _themeManager.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _themeManager.isDarkMode 
              ? Colors.black.withValues(alpha: 0.3)
              : Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildContactTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _themeManager.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: _themeManager.primaryColor,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: _themeManager.textPrimaryColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: _themeManager.textSecondaryColor,
        ),
      ),
    );
  }

  Widget _buildFAQItem({
    required String question,
    required String answer,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _themeManager.cardColor,
        borderRadius: BorderRadius.circular(12),
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
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: EdgeInsets.fromLTRB(16, 0, 16, 16),
          leading: Icon(
            Icons.help_outline,
            color: _themeManager.primaryColor,
          ),
          title: Text(
            question,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: _themeManager.textPrimaryColor,
            ),
          ),
          children: [
            Text(
              answer,
              style: TextStyle(
                fontSize: 14,
                color: _themeManager.textSecondaryColor,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFeedbackDialog() {
    final TextEditingController feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: _themeManager.cardColor,
          title: Text(
            'ส่งคำติชม',
            style: TextStyle(color: _themeManager.textPrimaryColor),
          ),
          content: TextField(
            controller: feedbackController,
            maxLines: 5,
            style: TextStyle(color: _themeManager.textPrimaryColor),
            decoration: InputDecoration(
              hintText: 'กรุณาเขียนคำติชมของคุณที่นี่...',
              hintStyle: TextStyle(color: _themeManager.textSecondaryColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: _themeManager.primaryColor),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'ยกเลิก',
                style: TextStyle(color: _themeManager.textSecondaryColor),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('ขอบคุณสำหรับคำติชมของคุณ'),
                    backgroundColor: _themeManager.primaryColor,
                  ),
                );
              },
              child: Text(
                'ส่ง',
                style: TextStyle(color: _themeManager.primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }
}