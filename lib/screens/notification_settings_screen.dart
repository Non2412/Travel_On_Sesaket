import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme_manager.dart';
import '../services/notification_service.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  final ThemeManager _themeManager = ThemeManager();
  
  // Notification settings
  bool _allNotifications = true;
  bool _eventNotifications = true;
  bool _friendNotifications = true;
  bool _placeNotifications = true;
  bool _promotionNotifications = true;
  bool _systemNotifications = true;
  
  // Sound and vibration
  bool _sound = true;
  bool _vibration = true;
  
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _themeManager.addListener(_onThemeChanged);
    _loadSettings();
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

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _allNotifications = prefs.getBool('all_notifications') ?? true;
      _eventNotifications = prefs.getBool('event_notifications') ?? true;
      _friendNotifications = prefs.getBool('friend_notifications') ?? true;
      _placeNotifications = prefs.getBool('place_notifications') ?? true;
      _promotionNotifications = prefs.getBool('promotion_notifications') ?? true;
      _systemNotifications = prefs.getBool('system_notifications') ?? true;
      _sound = prefs.getBool('notification_sound') ?? true;
      _vibration = prefs.getBool('notification_vibration') ?? true;
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('all_notifications', _allNotifications);
    await prefs.setBool('event_notifications', _eventNotifications);
    await prefs.setBool('friend_notifications', _friendNotifications);
    await prefs.setBool('place_notifications', _placeNotifications);
    await prefs.setBool('promotion_notifications', _promotionNotifications);
    await prefs.setBool('system_notifications', _systemNotifications);
    await prefs.setBool('notification_sound', _sound);
    await prefs.setBool('notification_vibration', _vibration);
  }

  void _toggleAllNotifications(bool value) {
    setState(() {
      _allNotifications = value;
      if (!value) {
        _eventNotifications = false;
        _friendNotifications = false;
        _placeNotifications = false;
        _promotionNotifications = false;
        _systemNotifications = false;
      } else {
        _eventNotifications = true;
        _friendNotifications = true;
        _placeNotifications = true;
        _promotionNotifications = true;
        _systemNotifications = true;
      }
    });
    _saveSettings();
  }

  void _updateNotificationSetting(String type, bool value) {
    setState(() {
      switch (type) {
        case 'event':
          _eventNotifications = value;
          break;
        case 'friend':
          _friendNotifications = value;
          break;
        case 'place':
          _placeNotifications = value;
          break;
        case 'promotion':
          _promotionNotifications = value;
          break;
        case 'system':
          _systemNotifications = value;
          break;
      }
      
      // Update all notifications toggle
      _allNotifications = _eventNotifications && 
                         _friendNotifications && 
                         _placeNotifications && 
                         _promotionNotifications && 
                         _systemNotifications;
    });
    _saveSettings();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: _themeManager.backgroundColor,
        appBar: AppBar(
          title: const Text(
            'การตั้งค่าการแจ้งเตือน',
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
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: _themeManager.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'การตั้งค่าการแจ้งเตือน',
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
          // Master Toggle
          _buildSectionHeader('การแจ้งเตือนทั่วไป'),
          _buildSettingsCard([
            _buildSwitchTile(
              icon: Icons.notifications_active,
              title: 'เปิดการแจ้งเตือนทั้งหมด',
              subtitle: _allNotifications 
                  ? 'รับการแจ้งเตือนทุกประเภท' 
                  : 'ปิดการแจ้งเตือนทั้งหมด',
              value: _allNotifications,
              onChanged: _toggleAllNotifications,
              iconColor: Colors.blue,
            ),
          ]),

          const SizedBox(height: 24),

          // Notification Types
          _buildSectionHeader('ประเภทการแจ้งเตือน'),
          _buildSettingsCard([
            _buildSwitchTile(
              icon: Icons.event,
              title: 'กิจกรรมและอีเวนท์',
              subtitle: 'การแจ้งเตือนเกี่ยวกับกิจกรรมใหม่',
              value: _eventNotifications,
              onChanged: (value) => _updateNotificationSetting('event', value),
              iconColor: Colors.blue,
              enabled: _allNotifications,
            ),
            Divider(color: _themeManager.textSecondaryColor.withOpacity(0.3)),
            _buildSwitchTile(
              icon: Icons.location_on,
              title: 'สถานที่ท่องเที่ยว',
              subtitle: 'การแจ้งเตือนสถานที่แนะนำ',
              value: _placeNotifications,
              onChanged: (value) => _updateNotificationSetting('place', value),
              iconColor: Colors.orange,
              enabled: _allNotifications,
            ),
            Divider(color: _themeManager.textSecondaryColor.withOpacity(0.3)),
            _buildSwitchTile(
              icon: Icons.local_offer,
              title: 'โปรโมชั่นและข้อเสนอ',
              subtitle: 'การแจ้งเตือนโปรโมชั่นพิเศษ',
              value: _promotionNotifications,
              onChanged: (value) => _updateNotificationSetting('promotion', value),
              iconColor: Colors.purple,
              enabled: _allNotifications,
            ),
            Divider(color: _themeManager.textSecondaryColor.withOpacity(0.3)),
            _buildSwitchTile(
              icon: Icons.info,
              title: 'ระบบและการอัพเดท',
              subtitle: 'การแจ้งเตือนจากระบบ',
              value: _systemNotifications,
              onChanged: (value) => _updateNotificationSetting('system', value),
              iconColor: Colors.grey,
              enabled: _allNotifications,
            ),
          ]),

          const SizedBox(height: 24),

          // Sound and Vibration
          _buildSectionHeader('เสียงและการสั่น'),
          _buildSettingsCard([
            _buildSwitchTile(
              icon: Icons.volume_up,
              title: 'เสียงแจ้งเตือน',
              subtitle: _sound ? 'เปิดเสียง' : 'ปิดเสียง',
              value: _sound,
              onChanged: (value) {
                setState(() {
                  _sound = value;
                });
                _saveSettings();
              },
              iconColor: Colors.amber,
              enabled: _allNotifications,
            ),
            Divider(color: _themeManager.textSecondaryColor.withOpacity(0.3)),
            _buildSwitchTile(
              icon: Icons.vibration,
              title: 'การสั่น',
              subtitle: _vibration ? 'เปิดการสั่น' : 'ปิดการสั่น',
              value: _vibration,
              onChanged: (value) {
                setState(() {
                  _vibration = value;
                });
                _saveSettings();
              },
              iconColor: Colors.teal,
              enabled: _allNotifications,
            ),
          ]),

          const SizedBox(height: 24),

          // Test Notification
          _buildSettingsCard([
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _themeManager.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.send,
                  color: _themeManager.primaryColor,
                  size: 24,
                ),
              ),
              title: Text(
                'ทดสอบการแจ้งเตือน',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _themeManager.textPrimaryColor,
                ),
              ),
              subtitle: Text(
                'ส่งการแจ้งเตือนทดสอบ',
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
              onTap: _allNotifications ? _sendTestNotification : null,
            ),
          ]),

          const SizedBox(height: 16),

          // Info Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _themeManager.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _themeManager.primaryColor.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: _themeManager.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'การตั้งค่าเหล่านี้จะมีผลกับการแจ้งเตือนที่แสดงในแอปเท่านั้น',
                    style: TextStyle(
                      fontSize: 14,
                      color: _themeManager.textSecondaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
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
              ? Colors.black.withOpacity(0.3)
              : Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required Color iconColor,
    bool enabled = true,
  }) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: ListTile(
        enabled: enabled,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: iconColor,
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
          onChanged: enabled ? onChanged : null,
          activeThumbColor: _themeManager.primaryColor,
          activeTrackColor: _themeManager.primaryColor.withOpacity(0.3),
        ),
      ),
    );
  }

  void _sendTestNotification() {
    // เพิ่มการแจ้งเตือนทดสอบไปยัง NotificationService
    NotificationService.instance.addTestNotification();
    
    // แสดง Dialog ยืนยัน
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: _themeManager.cardColor,
          title: Row(
            children: [
              Icon(
                Icons.notifications_active,
                color: _themeManager.primaryColor,
              ),
              const SizedBox(width: 12),
              Text(
                'ส่งการแจ้งเตือนแล้ว',
                style: TextStyle(color: _themeManager.textPrimaryColor),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'การแจ้งเตือนทดสอบถูกส่งแล้ว',
                style: TextStyle(
                  color: _themeManager.textPrimaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'ตรวจสอบในหน้าการแจ้งเตือนเพื่อดูข้อความทดสอบ',
                style: TextStyle(color: _themeManager.textSecondaryColor),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'การตั้งค่าทำงานถูกต้อง',
                        style: TextStyle(
                          color: _themeManager.textPrimaryColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'ตกลง',
                style: TextStyle(color: _themeManager.primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }
}