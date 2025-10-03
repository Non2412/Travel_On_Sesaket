import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ApiTestScreen extends StatefulWidget {
  const ApiTestScreen({super.key});

  @override
  State<ApiTestScreen> createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  String _testResult = 'ยังไม่ได้ทดสอบ';
  bool _testing = false;

  Future<void> _testApiConnection() async {
    setState(() {
      _testing = true;
      _testResult = 'กำลังทดสอบการเชื่อมต่อ...';
    });

    try {
      // ทดสอบการเชื่อมต่อพื้นฐาน
      final connected = await ApiService.checkConnection();
      if (!connected) {
        setState(() {
          _testResult = 'ไม่สามารถเชื่อมต่อกับ API ได้';
          _testing = false;
        });
        return;
      }

      // ทดสอบดึงข้อมูลสถานที่ท่องเที่ยว
      final attractions = await ApiService.getTouristAttractions();
      if (attractions == null) {
        setState(() {
          _testResult = 'เชื่อมต่อได้แต่ไม่สามารถดึงข้อมูลสถานที่ท่องเที่ยวได้';
          _testing = false;
        });
        return;
      }

      // ทดสอบดึงหมวดหมู่
      final categories = await ApiService.getAttractionCategories();
      
      // ทดสอบดึงอำเภอ
      final districts = await ApiService.getDistricts();

      setState(() {
        _testResult = '''
API Connection: ✅ สำเร็จ
สถานที่ท่องเที่ยว: ${attractions.length} แห่ง
หมวดหมู่: ${categories?.length ?? 0} หมวด
อำเภอ: ${districts?.length ?? 0} อำเภอ

API Base URL: ${ApiService.baseUrl}
''';
        _testing = false;
      });

    } catch (e) {
      setState(() {
        _testResult = 'เกิดข้อผิดพลาด: $e';
        _testing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ทดสอบ API'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ข้อมูล API',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('URL: ${ApiService.baseUrl}'),
                    const Text('Platform: Web Browser'),
                    const Text('Method: HTTP GET/POST'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _testing ? null : _testApiConnection,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _testing
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text('กำลังทดสอบ...'),
                      ],
                    )
                  : const Text(
                      'ทดสอบการเชื่อมต่อ API',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
            const SizedBox(height: 24),
            const Text(
              'ผลการทดสอบ:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _testResult,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Card(
              color: Colors.orange,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  '⚠️ หมายเหตุ: หากทดสอบใน Web Browser และไม่สามารถเชื่อมต่อได้ อาจเป็นปัญหา CORS ของ API Server แต่จะทำงานปกติใน Mobile App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}