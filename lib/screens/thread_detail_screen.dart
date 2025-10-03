import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class ThreadDetailScreen extends StatefulWidget {
  final String title;
  final List<String> comments;
  final Function(String) onAddComment;

  ThreadDetailScreen({
    required this.title,
    required this.comments,
    required this.onAddComment,
  });

  @override
  _ThreadDetailScreenState createState() => _ThreadDetailScreenState();
}

class _ThreadDetailScreenState extends State<ThreadDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  File? _selectedImage;
  String? _selectedImageUrl;
  Future<void> _pickImage() async {
    if (kIsWeb) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.single.bytes != null) {
        setState(() {
          _selectedImageUrl = 'data:image/png;base64,' + base64Encode(result.files.single.bytes!);
        });
      }
    } else {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
          title: Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.comments.length,
              itemBuilder: (context, index) {
                final comment = widget.comments[index];
                if (comment.toString().contains('[img]')) {
                  final imgData = comment.toString().replaceAll('[img]', '');
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 16,
                              offset: Offset(0, 8),
                            ),
                          ],
                          border: Border.all(color: Colors.deepPurpleAccent, width: 2.5),
                        ),
                        padding: EdgeInsets.all(12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: kIsWeb
                              ? Image.network(imgData, height: 220, width: 320, fit: BoxFit.cover)
                              : Image.file(File(imgData), height: 220, width: 320, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  );
                } else {
                  return ListTile(
                    leading: Icon(Icons.comment, color: Colors.blue),
                    title: Text(comment),
                  );
                }
              },
            ),
          ),
          if (_selectedImage != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.file(_selectedImage!, height: 80),
            ),
          if (_selectedImageUrl != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(_selectedImageUrl!, height: 80),
            ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.image),
                  onPressed: _pickImage,
                ),
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'แสดงความคิดเห็น...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_selectedImage != null) {
                      widget.onAddComment('[img]' + _selectedImage!.path);
                      _selectedImage = null;
                    }
                    if (_selectedImageUrl != null) {
                      widget.onAddComment('[img]' + _selectedImageUrl!);
                      _selectedImageUrl = null;
                    }
                    if (_commentController.text.trim().isNotEmpty) {
                      widget.onAddComment(_commentController.text.trim());
                      _commentController.clear();
                    }
                    setState(() {});
                  },
                  child: Text('ส่ง'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
