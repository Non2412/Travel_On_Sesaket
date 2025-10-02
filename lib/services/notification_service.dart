import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  static NotificationService get instance => _instance;

  NotificationService._internal();

  // List to store notifications
  final List<NotificationItem> _notifications = [];
  
  // Listeners for notification updates
  final List<VoidCallback> _listeners = [];

  // Get all notifications
  List<NotificationItem> get notifications => List.unmodifiable(_notifications);

  // Add listener
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  // Remove listener
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  // Notify all listeners
  void _notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }

  // Add test notification
  void addTestNotification() {
    final notification = NotificationItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'การแจ้งเตือนทดสอบ',
      message: 'นี่คือการแจ้งเตือนทดสอบจากการตั้งค่า หากคุณเห็นข้อความนี้ แสดงว่าการแจ้งเตือนทำงานปกติ',
      time: DateTime.now(),
      type: NotificationType.system,
      isRead: false,
    );
    
    _notifications.insert(0, notification);
    _notifyListeners();
  }

  // Add notification
  void addNotification(NotificationItem notification) {
    _notifications.insert(0, notification);
    _notifyListeners();
  }

  // Remove notification
  void removeNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    _notifyListeners();
  }

  // Mark notification as read
  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index].isRead = true;
      _notifyListeners();
    }
  }

  // Mark all as read
  void markAllAsRead() {
    for (var notification in _notifications) {
      notification.isRead = true;
    }
    _notifyListeners();
  }

  // Clear all notifications
  void clearAll() {
    _notifications.clear();
    _notifyListeners();
  }

  // Get unread count
  int get unreadCount => _notifications.where((n) => !n.isRead).length;
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime time;
  final NotificationType type;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    this.isRead = false,
  });
}

enum NotificationType {
  event,
  friend,
  place,
  promotion,
  system,
}