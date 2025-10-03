import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppUtils {
  // แสดง Toast message
  static void showToast(
    String message, {
    Toast toastLength = Toast.LENGTH_SHORT,
    ToastGravity gravity = ToastGravity.BOTTOM,
    Color backgroundColor = Colors.black87,
    Color textColor = Colors.white,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 16.0,
    );
  }

  // แสดง Success toast
  static void showSuccess(String message) {
    showToast(message, backgroundColor: Colors.green, textColor: Colors.white);
  }

  // แสดง Error toast
  static void showError(String message) {
    showToast(
      message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  // แสดง Warning toast
  static void showWarning(String message) {
    showToast(message, backgroundColor: Colors.orange, textColor: Colors.white);
  }

  // แสดง Info toast
  static void showInfo(String message) {
    showToast(message, backgroundColor: Colors.blue, textColor: Colors.white);
  }

  // ตรวจสอบว่าเป็น email ที่ถูกต้องหรือไม่
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // ตรวจสอบว่าเป็น URL ที่ถูกต้องหรือไม่
  static bool isValidUrl(String url) {
    return Uri.tryParse(url) != null &&
        (url.startsWith('http://') || url.startsWith('https://'));
  }

  // Format ตัวเลขเป็น string ที่อ่านง่าย
  static String formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  // แปลง DateTime เป็น string ที่อ่านง่าย
  static String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} วันที่แล้ว';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ชั่วโมงที่แล้ว';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} นาทีที่แล้ว';
    } else {
      return 'เมื่อสักครู่';
    }
  }

  // ตัดคำยาว
  static String truncateString(
    String text,
    int maxLength, {
    String suffix = '...',
  }) {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength - suffix.length) + suffix;
  }

  // Loading dialog
  static void showLoadingDialog(
    BuildContext context, {
    String message = 'กำลังโหลด...',
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              Text(message),
            ],
          ),
        );
      },
    );
  }

  // ปิด loading dialog
  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
