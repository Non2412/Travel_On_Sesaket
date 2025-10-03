import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'thread_detail_screen.dart';

class ThreadListScreen extends StatefulWidget {
  @override
  _ThreadListScreenState createState() => _ThreadListScreenState();
}

class _ThreadListScreenState extends State<ThreadListScreen> {
  final List<Map<String, dynamic>> _threads = [];

  void _addThread(String title, {File? imageFile, String? imageUrl}) {
    setState(() {
      _threads.add({
        'title': title,
        'imageFile': imageFile,
        'imageUrl': imageUrl,
        'comments': <String>[]
      });
    });
  }

  Future<void> _pickImageAndAddThread() async {
    File? imageFile;
    String? imageUrl;
    if (kIsWeb) {
      // ใช้ file_picker สำหรับเว็บ
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.single.bytes != null) {
        imageUrl = 'data:image/png;base64,' + base64Encode(result.files.single.bytes!);
      }
    } else {
      // ใช้ image_picker สำหรับมือถือ/เดสก์ท็อป
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
      }
    }
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('เพิ่มหัวข้อกระทู้'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'ชื่อหัวข้อกระทู้'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  _addThread(controller.text.trim(), imageFile: imageFile, imageUrl: imageUrl);
                  Navigator.pop(context);
                }
              },
              child: Text('เพิ่ม'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // จัดอันดับหัวข้อกระทู้ตามจำนวนความคิดเห็น
    List<Map<String, dynamic>> sortedThreads = List.from(_threads);
    sortedThreads.sort((a, b) => (b['comments'].length as int).compareTo(a['comments'].length as int));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFA726), Color(0xFFF44336)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Text('กระทู้', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: ListView.builder(
        itemCount: sortedThreads.length,
        itemBuilder: (context, index) {
          final thread = sortedThreads[index];
          Widget imageWidget;
          if (kIsWeb && thread['imageUrl'] != null) {
            imageWidget = Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.blueAccent, width: 2),
              ),
              padding: EdgeInsets.all(6),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  thread['imageUrl'],
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            );
          } else if (!kIsWeb && thread['imageFile'] != null) {
            imageWidget = Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.blueAccent, width: 2),
              ),
              padding: EdgeInsets.all(6),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  thread['imageFile'],
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            );
          } else {
            imageWidget = Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.grey, width: 1),
              ),
              child: Icon(Icons.image, color: Colors.grey[600], size: 40),
            );
          }
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ThreadDetailScreen(
                    title: thread['title'],
                    comments: thread['comments'],
                    onAddComment: (comment) {
                      setState(() {
                        thread['comments'].add(comment);
                      });
                    },
                  ),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 6),
                  ),
                ],
                border: Border.all(color: Colors.blueAccent, width: 1.5),
              ),
              child: Row(
                children: [
                  imageWidget,
                  SizedBox(width: 18),
                  Expanded(
                    child: Text(
                      thread['title'],
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 22, color: Colors.blueAccent),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_a_photo),
        onPressed: _pickImageAndAddThread,
      ),
    );
  }
}
