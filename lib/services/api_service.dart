import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  // URL ของ API ที่ deploy บน Railway
  static const String baseUrl =
      'https://sittirapi-production.up.railway.app/api';

  // Backup API URL (JSONPlaceholder-style mock API)
  static const String backupApiUrl = 'https://jsonplaceholder.typicode.com';

  // Headers สำหรับ request
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // ตรวจสอบการเชื่อมต่ออินเทอร์เน็ต
  static Future<bool> _hasConnection() async {
    try {
      final connectivityResult = await (Connectivity().checkConnectivity());
      return !connectivityResult.contains(ConnectivityResult.none);
    } catch (e) {
      debugPrint('Connectivity check error: $e');
      return false;
    }
  }

  // ตรวจสอบการเชื่อมต่อ API และสถานะเซิร์ฟเวอร์
  static Future<bool> checkApiStatus() async {
    try {
      if (!await _hasConnection()) {
        debugPrint('No internet connection');
        return false;
      }

      final response = await http
          .get(Uri.parse('$baseUrl/attractions/'), headers: headers)
          .timeout(const Duration(seconds: 10));

      debugPrint('API Status Check: ${response.statusCode}');
      debugPrint(
        'API Response: ${response.body.substring(0, math.min(200, response.body.length))}',
      );

      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      debugPrint('API status check failed: $e');
      return false;
    }
  }

  // Helper method สำหรับ API calls
  static Future<Map<String, dynamic>?> _makeRequest(
    String endpoint, {
    String method = 'GET',
    Map<String, dynamic>? body,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    if (!await _hasConnection()) {
      debugPrint('No internet connection available');
      return null;
    }

    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      http.Response response;

      switch (method.toUpperCase()) {
        case 'POST':
          response = await http
              .post(
                uri,
                headers: headers,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(timeout);
          break;
        case 'PUT':
          response = await http
              .put(
                uri,
                headers: headers,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(timeout);
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: headers).timeout(timeout);
          break;
        default:
          response = await http.get(uri, headers: headers).timeout(timeout);
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          return jsonDecode(response.body);
        }
        return {'success': true};
      } else {
        debugPrint('API Error ${response.statusCode}: ${response.body}');
        return null;
      }
    } on SocketException {
      debugPrint('Network error: No internet connection');
      return null;
    } on HttpException catch (e) {
      debugPrint('HTTP error: $e');
      return null;
    } catch (e) {
      debugPrint('API request error: $e');
      return null;
    }
  }

  // ============ Authentication ============

  /// ลงทะเบียนผู้ใช้ใหม่
  static Future<Map<String, dynamic>?> register({
    required String username,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    return await _makeRequest(
      '/auth/register/',
      method: 'POST',
      body: {
        'username': username,
        'email': email,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
      },
    );
  }

  /// เข้าสู่ระบบ
  static Future<Map<String, dynamic>?> login({
    required String username,
    required String password,
  }) async {
    return await _makeRequest(
      '/auth/login/',
      method: 'POST',
      body: {'username': username, 'password': password},
    );
  }

  // ============ Tourist Attractions ============

  /// ดึงสถานที่ท่องเที่ยวทั้งหมด
  static Future<List<dynamic>?> getTouristAttractions() async {
    try {
      debugPrint('Attempting to fetch tourist attractions...');

      // ลองเชื่อมต่อ API ก่อน แต่มี timeout สั้น
      try {
        final data = await _makeRequest('/attractions/').timeout(
          const Duration(seconds: 3), // timeout สั้น
        );
        if (data != null) {
          debugPrint(
            'Successfully fetched ${(data['results'] ?? data).length} attractions from API',
          );
          return data['results'] ??
              data; // รองรับทั้ง paginated และ non-paginated
        }
      } catch (e) {
        debugPrint('API failed, using fallback data: $e');
      }

      // ใช้ข้อมูลสำรองทันที
      debugPrint('Using fallback data');
      return _getFallbackAttractions();
    } catch (e) {
      debugPrint('Get attractions error: $e - providing fallback data');
      return _getFallbackAttractions();
    }
  }

  /// ข้อมูลสำรอง (fallback) สำหรับเมื่อ API ไม่สามารถเข้าถึงได้
  static List<Map<String, dynamic>> _getFallbackAttractions() {
    return [
      {
        'id': 1,
        'name': 'วัดเล็งเน่ยยี่',
        'description':
            'วัดที่มีประวัติศาสตร์ยาวนานและเป็นสถานที่ท่องเที่ยวที่สำคัญของศรีสะเกษ',
        'category': 'วัด/ศาสนสถาน',
        'district': 'เมืองศรีสะเกษ',
        'address': 'ตำบลเมืองใต้ อำเภอเมืองศรีสะเกษ จังหวัดศรีสะเกษ',
        'image_url': 'https://via.placeholder.com/400x300?text=วัดเล็งเน่ยยี่',
        'average_rating': 4.5,
        'review_count': 120,
        'latitude': 15.1181,
        'longitude': 104.3220,
        'opening_hours': '06:00-18:00',
        'contact_info': '045-123-456',
        'website': null,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 2,
        'name': 'ปราสาทศรีสะเกษ',
        'description':
            'ปราสาทหินทรายในสมัยอาณาจักรขอม ตั้งอยู่ในใจกลางเมืองศรีสะเกษ',
        'category': 'โบราณสถาน',
        'district': 'เมืองศรีสะเกษ',
        'address': 'ตำบลเมือง อำเภอเมืองศรีสะเกษ จังหวัดศรีสะเกษ',
        'image_url': 'https://via.placeholder.com/400x300?text=ปราสาทศรีสะเกษ',
        'average_rating': 4.2,
        'review_count': 89,
        'latitude': 15.1162,
        'longitude': 104.3225,
        'opening_hours': '08:00-17:00',
        'contact_info': '045-123-789',
        'website': null,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 3,
        'name': 'อนุสาวรีย์ท้าวสุรนารี',
        'description':
            'อนุสาวรีย์เพื่อเป็นเกียรติแก่วีรสตรีผู้กล้าหาญของแผ่นดิน',
        'category': 'อนุสาวรีย์/อนุสรณ์',
        'district': 'เมืองศรีสะเกษ',
        'address': 'ตำบลเมือง อำเภอเมืองศรีสะเกษ จังหวัดศรีสะเกษ',
        'image_url':
            'https://via.placeholder.com/400x300?text=อนุสาวรีย์ท้าวสุรนารี',
        'average_rating': 4.0,
        'review_count': 67,
        'latitude': 15.1145,
        'longitude': 104.3201,
        'opening_hours': 'ตลอด 24 ชั่วโมง',
        'contact_info': null,
        'website': null,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 4,
        'name': 'พิพิธภัณฑ์ศรีสะเกษ',
        'description':
            'พิพิธภัณฑ์ที่เก็บรวบรวมประวัติศาสตร์และวัฒนธรรมของจังหวัดศรีสะเกษ',
        'category': 'พิพิธภัณฑ์',
        'district': 'เมืองศรีสะเกษ',
        'address': 'ถนนศรีสะเกษ ตำบลเมือง อำเภอเมืองศรีสะเกษ',
        'image_url':
            'https://via.placeholder.com/400x300?text=พิพิธภัณฑ์ศรีสะเกษ',
        'average_rating': 3.8,
        'review_count': 45,
        'latitude': 15.1156,
        'longitude': 104.3215,
        'opening_hours': '09:00-16:00',
        'contact_info': '045-111-222',
        'website': null,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 5,
        'name': 'สวนสาธารณะศรีสะเกษ',
        'description':
            'สวนสาธารณะใจกลางเมือง เหมาะสำหรับการพักผ่อนและออกกำลังกาย',
        'category': 'สวนสาธารณะ',
        'district': 'เมืองศรีสะเกษ',
        'address': 'ถนนกสิกรรม ตำบลเมือง อำเภอเมืองศรีสะเกษ',
        'image_url':
            'https://via.placeholder.com/400x300?text=สวนสาธารณะศรีสะเกษ',
        'average_rating': 4.1,
        'review_count': 78,
        'latitude': 15.1175,
        'longitude': 104.3198,
        'opening_hours': '05:00-20:00',
        'contact_info': null,
        'website': null,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
    ];
  }

  /// ค้นหาสถานที่ท่องเที่ยว
  static Future<List<dynamic>?> searchAttractions({
    String? query,
    String? category,
    String? district,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (query != null && query.isNotEmpty) queryParams['search'] = query;
      if (category != null && category.isNotEmpty)
        queryParams['category'] = category;
      if (district != null && district.isNotEmpty)
        queryParams['district'] = district;

      String endpoint = '/attractions/search/';
      if (queryParams.isNotEmpty) {
        final uri = Uri.parse(
          '$baseUrl$endpoint',
        ).replace(queryParameters: queryParams);
        final response = await http
            .get(uri, headers: headers)
            .timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return data['results'] ?? data;
        } else {
          debugPrint('Search attractions failed: ${response.statusCode}');
          return null;
        }
      } else {
        final data = await _makeRequest(endpoint);
        if (data != null) {
          return data['results'] ?? data;
        }
        return null;
      }
    } catch (e) {
      debugPrint('Search attractions error: $e');
      return null;
    }
  }

  /// ดึงหมวดหมู่สถานที่ท่องเที่ยว
  static Future<List<dynamic>?> getAttractionCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/attractions/categories/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Get categories failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Get categories error: $e');
      return null;
    }
  }

  /// ดึงอำเภอทั้งหมด
  static Future<List<dynamic>?> getDistricts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/attractions/districts/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Get districts failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Get districts error: $e');
      return null;
    }
  }

  // ============ Accommodations ============

  /// ดึงที่พักทั้งหมด
  static Future<List<dynamic>?> getAccommodations() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/accommodations/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['results'] ?? data;
      } else {
        print('Get accommodations failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Get accommodations error: $e');
      return null;
    }
  }

  /// ค้นหาที่พัก
  static Future<List<dynamic>?> searchAccommodations({
    String? query,
    String? accommodationType,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (query != null && query.isNotEmpty) queryParams['search'] = query;
      if (accommodationType != null && accommodationType.isNotEmpty) {
        queryParams['accommodation_type'] = accommodationType;
      }
      if (minPrice != null) queryParams['min_price'] = minPrice.toString();
      if (maxPrice != null) queryParams['max_price'] = maxPrice.toString();

      final uri = Uri.parse(
        '$baseUrl/accommodations/search/',
      ).replace(queryParameters: queryParams);
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['results'] ?? data;
      } else {
        print('Search accommodations failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Search accommodations error: $e');
      return null;
    }
  }

  // ============ Tour Packages ============

  /// ดึงแพ็คเกจทัวร์ทั้งหมด
  static Future<List<dynamic>?> getTourPackages() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/tour-packages/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['results'] ?? data;
      } else {
        print('Get tour packages failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Get tour packages error: $e');
      return null;
    }
  }

  // ============ Dashboard/Statistics ============

  /// ดึงสถิติ Dashboard
  static Future<Map<String, dynamic>?> getDashboardStats() async {
    try {
      return await _makeRequest('/dashboard/stats/');
    } catch (e) {
      debugPrint('Get dashboard stats error: $e');
      return null;
    }
  }

  /// ดึงสถานที่ยอดนิยม
  static Future<List<dynamic>?> getPopularDestinations({int limit = 10}) async {
    try {
      final uri = Uri.parse(
        '$baseUrl/dashboard/popular-destinations/',
      ).replace(queryParameters: {'limit': limit.toString()});
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Get popular destinations failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Get popular destinations error: $e');
      return null;
    }
  }

  /// ดึง Highlights ของศรีสะเกษ
  static Future<Map<String, dynamic>?> getSisaketHighlights() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/dashboard/sisaket-highlights/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Get sisaket highlights failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Get sisaket highlights error: $e');
      return null;
    }
  }

  // ============ Reviews ============

  /// สร้างรีวิวใหม่
  static Future<Map<String, dynamic>?> createReview({
    int? attractionId,
    required double rating,
    required String comment,
    int? accommodationId,
    int? tourPackageId,
  }) async {
    try {
      final body = {'rating': rating.round(), 'comment': comment};

      // เพิ่ม target ตามประเภทที่รีวิว
      if (attractionId != null) body['attraction'] = attractionId;
      if (accommodationId != null) body['accommodation'] = accommodationId;
      if (tourPackageId != null) body['tour_package'] = tourPackageId;

      // TODO: ในอนาคตต้องมี tourist_id จากระบบ authentication
      // body['tourist'] = user_id;

      final response = await http.post(
        Uri.parse('$baseUrl/reviews/'),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        print(
          'Create review failed: ${response.statusCode} - ${response.body}',
        );
        return null;
      }
    } catch (e) {
      print('Create review error: $e');
      return null;
    }
  }

  /// ดึงรีวิวของสถานที่ท่องเที่ยว
  static Future<List<dynamic>?> getAttractionReviews(int attractionId) async {
    try {
      final uri = Uri.parse(
        '$baseUrl/reviews/by_attraction/',
      ).replace(queryParameters: {'attraction_id': attractionId.toString()});
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Get attraction reviews failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Get attraction reviews error: $e');
      return null;
    }
  }

  // ============ Utility Methods ============

  /// ตรวจสอบการเชื่อมต่อ API
  static Future<bool> checkConnection() async {
    try {
      final response = await http
          .get(Uri.parse(baseUrl), headers: headers)
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      print('API connection check failed: $e');
      return false;
    }
  }
}
