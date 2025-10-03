import 'package:flutter/material.dart';
import '../theme_manager.dart';
import 'privacy_policy_screen.dart';
import 'notification_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
        title: const Text(
          'ตั้งค่า',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: _themeManager.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: _themeManager.headerGradient,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme Settings Section
          _buildSectionHeader('ธีม'),
          _buildSettingsCard([
            _buildThemeToggle(
              icon: _themeManager.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              title: 'โหมดมืด',
              subtitle: _themeManager.isDarkMode ? 'เปิดใช้งาน' : 'ปิดใช้งาน',
              value: _themeManager.isDarkMode,
              onChanged: (value) => _themeManager.toggleDarkMode(),
            ),
            Divider(color: _themeManager.textSecondaryColor.withValues(alpha: 0.3)),
            _buildThemeToggle(
              icon: _themeManager.isBlueTheme ? Icons.palette : Icons.palette_outlined,
              title: 'สีธีม',
              subtitle: _themeManager.isBlueTheme ? 'น้ำเงิน' : 'ส้ม',
              value: _themeManager.isBlueTheme,
              onChanged: (value) => _themeManager.toggleThemeColor(),
            ),
          ]),

          const SizedBox(height: 24),

          // App Settings Section
          _buildSectionHeader('การตั้งค่าแอป'),
          _buildSettingsCard([
            _buildSettingsTile(
              icon: Icons.notifications,
              title: 'การแจ้งเตือน',
              subtitle: 'จัดการการแจ้งเตือน',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationSettingsScreen()),
                );
              },
            ),
          ]),

          const SizedBox(height: 24),

          // About Section
          _buildSectionHeader('เกี่ยวกับ'),
          _buildSettingsCard([
            _buildSettingsTile(
              icon: Icons.info,
              title: 'เกี่ยวกับแอป',
              subtitle: 'เวอร์ชัน 1.0.0',
              onTap: () {
                _showAboutDialog();
              },
            ),
            Divider(color: _themeManager.textSecondaryColor.withValues(alpha: 0.3)),
            _buildSettingsTile(
              icon: Icons.privacy_tip,
              title: 'นโยบายความเป็นส่วนตัว',
              subtitle: 'อ่านนโยบายความเป็นส่วนตัว',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
                );
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
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

  Widget _buildSettingsCard(List<Widget> children) {
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
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
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
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: _themeManager.textSecondaryColor,
      ),
      onTap: onTap,
    );
  }

  Widget _buildThemeToggle({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
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
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _themeManager.primaryColor;
          }
          return null;
        }),
        activeTrackColor: _themeManager.primaryColor.withValues(alpha: 0.3),
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: _themeManager.cardColor,
          title: Text(
            'เกี่ยวกับแอป',
            style: TextStyle(color: _themeManager.textPrimaryColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'แอปท่องเที่ยวศรีสะเกษ',
                style: TextStyle(
                  color: _themeManager.textPrimaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'เวอร์ชัน 1.0.0',
                style: TextStyle(color: _themeManager.textSecondaryColor),
              ),
              const SizedBox(height: 16),
              Text(
                'แอปพลิเคชันสำหรับค้นหาและดูกิจกรรมที่จัดในจังหวัดศรีสะเกษเพื่อช้วยให้การท่องเที่ยวในจังหวัดศรีสะเกษสวกสบายยิ่งขึ้น',
                style: TextStyle(color: _themeManager.textSecondaryColor),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'ปิด',
                style: TextStyle(color: _themeManager.primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }
}