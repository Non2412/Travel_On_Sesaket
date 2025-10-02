import 'package:flutter/material.dart';
import '../theme_manager.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
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
          'นโยบายความเป็นส่วนตัว',
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
          _buildInfoCard(
            icon: Icons.info_outline,
            title: 'อัพเดทล่าสุด',
            content: 'วันที่ 30 กันยายน 2568',
          ),

          SizedBox(height: 16),

          _buildSectionCard(
            title: '1. ข้อมูลที่เราเก็บรวบรวม',
            content: '''เราเก็บรวบรวมข้อมูลประเภทต่อไปนี้:

• ข้อมูลที่คุณให้โดยตรง: เช่น ชื่อ อีเมล เมื่อคุณติดต่อเรา
• ข้อมูลการใช้งาน: เช่น กิจกรรมที่คุณดู กิจกรรมที่บันทึกไว้
• ข้อมูลอุปกรณ์: เช่น รุ่นอุปกรณ์ ระบบปฏิบัติการ
• ข้อมูลตำแหน่ง: เมื่อคุณอนุญาต เพื่อแสดงกิจกรรมใกล้เคียง''',
          ),

          SizedBox(height: 16),

          _buildSectionCard(
            title: '2. การใช้ข้อมูลของคุณ',
            content: '''เราใช้ข้อมูลของคุณเพื่อ:

• ให้บริการและปรับปรุงแอปพลิเคชัน
• แนะนำกิจกรรมที่เหมาะสมกับคุณ
• ส่งการแจ้งเตือนเกี่ยวกับกิจกรรมใหม่
• วิเคราะห์การใช้งานเพื่อพัฒนาบริการ
• ตอบคำถามและให้การสนับสนุน''',
          ),

          SizedBox(height: 16),

          _buildSectionCard(
            title: '3. การแบ่งปันข้อมูล',
            content: '''เราจะไม่ขาย แลกเปลี่ยน หรือเช่าข้อมูลส่วนบุคคลของคุณให้กับบุคคลที่สาม เว้นแต่:

• เมื่อได้รับความยินยอมจากคุณ
• เพื่อปฏิบัติตามกฎหมาย
• เพื่อปกป้องสิทธิและความปลอดภัย
• กับผู้ให้บริการที่ช่วยเราดำเนินงาน (ภายใต้ข้อตกลงความลับ)''',
          ),

          SizedBox(height: 16),

          _buildSectionCard(
            title: '4. ความปลอดภัยของข้อมูล',
            content: '''เราใช้มาตรการรักษาความปลอดภัยที่เหมาะสมเพื่อปกป้องข้อมูลของคุณ:

• การเข้ารหัสข้อมูลระหว่างการส่ง
• การจำกัดการเข้าถึงข้อมูล
• การตรวจสอบความปลอดภัยอย่างสม่ำเสมอ
• การสำรองข้อมูลอย่างปลอดภัย''',
          ),

          SizedBox(height: 16),

          _buildSectionCard(
            title: '5. สิทธิของคุณ',
            content: '''คุณมีสิทธิดังต่อไปนี้:

• เข้าถึงข้อมูลส่วนบุคคลของคุณ
• แก้ไขข้อมูลที่ไม่ถูกต้อง
• ลบข้อมูลของคุณ
• คัดค้านการประมวลผลข้อมูล
• ถอนความยินยอม
• ร้องเรียนต่อหน่วยงานคุ้มครองข้อมูล''',
          ),

          SizedBox(height: 16),

          _buildSectionCard(
            title: '6. คุกกี้และเทคโนโลยีติดตาม',
            content: '''แอปอาจใช้คุกกี้และเทคโนโลยีที่คล้ายกันเพื่อ:

• จดจำการตั้งค่าของคุณ
• วิเคราะห์การใช้งาน
• ปรับปรุงประสบการณ์การใช้งาน

คุณสามารถปิดคุกกี้ได้ในการตั้งค่าอุปกรณ์ของคุณ''',
          ),

          SizedBox(height: 16),

          _buildSectionCard(
            title: '7. การเปลี่ยนแปลงนโยบาย',
            content: '''เราอาจปรับปรุงนโยบายความเป็นส่วนตัวนี้เป็นครั้งคราว การเปลี่ยนแปลงที่สำคัญจะมีการแจ้งให้คุณทราบผ่านแอป หรือทางอีเมล

การใช้งานแอปต่อไปหลังจากการเปลี่ยนแปลง ถือว่าคุณยอมรับนโยบายที่ปรับปรุงแล้ว''',
          ),

          SizedBox(height: 16),

          _buildSectionCard(
            title: '8. เด็กและเยาวชน',
            content: '''แอปนี้ไม่มีวัตถุประสงค์สำหรับผู้ใช้ที่อายุต่ำกว่า 13 ปี เราไม่เก็บรวบรวมข้อมูลจากเด็กโดยเจตนา หากคุณทราบว่ามีการส่งข้อมูลของเด็กมาให้เรา กรุณาติดต่อเราทันที''',
          ),

          SizedBox(height: 16),

          _buildContactCard(),

          SizedBox(height: 24),

          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: _themeManager.primaryColor,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'ฉันเข้าใจและยอมรับ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _themeManager.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _themeManager.primaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: _themeManager.primaryColor,
            size: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _themeManager.textPrimaryColor,
                  ),
                ),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 13,
                    color: _themeManager.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String content,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _themeManager.cardColor,
        borderRadius: BorderRadius.circular(12),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _themeManager.textPrimaryColor,
            ),
          ),
          SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: _themeManager.textSecondaryColor,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _themeManager.cardColor,
        borderRadius: BorderRadius.circular(12),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ติดต่อเรา',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _themeManager.textPrimaryColor,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'หากคุณมีคำถามเกี่ยวกับนโยบายความเป็นส่วนตัวนี้ กรุณาติดต่อเราที่:',
            style: TextStyle(
              fontSize: 14,
              color: _themeManager.textSecondaryColor,
              height: 1.6,
            ),
          ),
          SizedBox(height: 12),
          _buildContactRow(Icons.email, 'stu6612732104@sskru.ac.th'),
          SizedBox(height: 8),
          _buildContactRow(Icons.phone, '062-715-6667'),
          SizedBox(height: 8),
          _buildContactRow(Icons.location_on, 'สาขาวิทยาการคอมพิวเตอร์ มหาวิทยาลัยราชภัฏศรีสะเกษ'),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: _themeManager.primaryColor,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: _themeManager.textSecondaryColor,
            ),
          ),
        ),
      ],
    );
  }
}