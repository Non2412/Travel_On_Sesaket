import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/api_models.dart';
import 'services/api_service.dart';

class ReviewManager extends ChangeNotifier {
  static final ReviewManager _instance = ReviewManager._internal();
  factory ReviewManager() => _instance;
  ReviewManager._internal();

  static const String _reviewsKey = 'user_reviews';
  List<Review> _reviews = [];
  bool _isInitialized = false;

  List<Review> get reviews => List.from(_reviews);
  bool get isInitialized => _isInitialized;

  /// Initialize the manager and load saved reviews
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _loadReviews();
      _isInitialized = true;
      debugPrint(
        'ReviewManager: โหลดข้อมูลสำเร็จ - รีวิว: ${_reviews.length} รายการ',
      );

      // เพิ่มรีวิวตัวอย่างสำหรับการทดสอบ (ถ้ายังไม่มีรีวิว)
      if (_reviews.isEmpty) {
        await _addSampleReviews();
      }
    } catch (e) {
      debugPrint('ReviewManager: เกิดข้อผิดพลาดในการโหลดข้อมูล - $e');
      _reviews = [];
      _isInitialized = true;
    }
  }

  /// เพิ่มรีวิวตัวอย่างสำหรับการทดสอบ
  Future<void> _addSampleReviews() async {
    // รีวิวตัวอย่างสำหรับสถานที่ต่างๆ
    final sampleReviews = [
      Review(
        id: 1,
        attractionId: 31552, // ID ของบ้านนาจะเรีย (ทับทิมสยาม 06)
        userId: 1,
        userFullName: 'ทดสอบ ผู้ใช้',
        rating: 4.5,
        comment: 'ร้านอาหารดี รสชาติอร่อย บรรยากาศเป็นกันเอง',
        createdAt: DateTime.now().subtract(Duration(days: 2)),
      ),
      Review(
        id: 2,
        attractionId: 31552, // ID ของบ้านนาจะเรีย (ทับทิมสยาม 06)
        userId: 2,
        userFullName: 'นักชิม',
        rating: 5.0,
        comment: 'แนะนำมากครับ! อาหารอีสานแซ่บๆ ราคาไม่แพง',
        createdAt: DateTime.now().subtract(Duration(days: 1)),
      ),
    ];

    _reviews.addAll(sampleReviews);
    await _saveReviews();
    notifyListeners();
    debugPrint(
      'ReviewManager: เพิ่มรีวิวตัวอย่าง ${sampleReviews.length} รายการ',
    );
  }

  /// Load reviews from SharedPreferences
  Future<void> _loadReviews() async {
    final prefs = await SharedPreferences.getInstance();
    final reviewsJson = prefs.getString(_reviewsKey);

    if (reviewsJson != null) {
      final List<dynamic> reviewsList = jsonDecode(reviewsJson);
      _reviews = reviewsList.map((json) => Review.fromJson(json)).toList();
    }
  }

  /// Save reviews to SharedPreferences
  Future<void> _saveReviews() async {
    final prefs = await SharedPreferences.getInstance();
    final reviewsJson = jsonEncode(
      _reviews.map((review) => review.toJson()).toList(),
    );
    await prefs.setString(_reviewsKey, reviewsJson);
  }

  /// Add a new review
  Future<void> addReview({
    required int attractionId,
    required String attractionName,
    required double rating,
    required String comment,
  }) async {
    // 1. บันทึกใน local storage ก่อน
    final newReview = Review(
      id: DateTime.now().millisecondsSinceEpoch, // ใช้ timestamp เป็น ID
      attractionId: attractionId,
      userId: 1, // TODO: ใช้ user ID จริงเมื่อมีระบบ authentication
      userFullName: 'ผู้ใช้', // TODO: ใช้ชื่อจริงเมื่อมีระบบ authentication
      rating: rating,
      comment: comment,
      createdAt: DateTime.now(),
    );

    _reviews.insert(0, newReview); // เพิ่มที่ด้านบน (รายการใหม่สุด)
    await _saveReviews();
    notifyListeners();

    debugPrint(
      'ReviewManager: เพิ่มรีวิวใหม่สำหรับ $attractionName (คะแนน: $rating)',
    );

    // 2. พยายามส่งไปยัง API (ไม่บล็อก UI)
    _syncToApi(newReview, attractionName);
  }

  /// ซิงค์รีวิวไปยัง API (background operation)
  Future<void> _syncToApi(Review review, String attractionName) async {
    try {
      final result = await ApiService.createReview(
        attractionId: review.attractionId,
        rating: review.rating,
        comment: review.comment,
      );

      if (result != null) {
        debugPrint('ReviewManager: ส่งรีวิวไปยัง API สำเร็จ - $attractionName');
        // แสดง success message ใน production
        if (!kDebugMode) {
          // AppUtils.showSuccess('รีวิวถูกบันทึกเรียบร้อยแล้ว');
        }
      } else {
        debugPrint(
          'ReviewManager: ไม่สามารถส่งรีวิวไปยัง API ได้ - $attractionName',
        );
        // รีวิวยังคงอยู่ใน local storage แม้ API จะล้มเหลว
      }
    } catch (e) {
      debugPrint('ReviewManager: ข้อผิดพลาดในการส่งรีวิวไปยัง API - $e');
      // รีวิวยังคงอยู่ใน local storage แม้ API จะล้มเหลว
    }
  }

  /// Update an existing review
  Future<void> updateReview(Review updatedReview) async {
    final index = _reviews.indexWhere(
      (review) => review.id == updatedReview.id,
    );
    if (index != -1) {
      _reviews[index] = updatedReview;
      await _saveReviews();
      notifyListeners();
      debugPrint('ReviewManager: อัพเดทรีวิว ID: ${updatedReview.id}');
    }
  }

  /// Delete a review
  Future<void> deleteReview(int reviewId) async {
    final initialLength = _reviews.length;
    _reviews.removeWhere((review) => review.id == reviewId);

    if (_reviews.length < initialLength) {
      await _saveReviews();
      notifyListeners();
      debugPrint('ReviewManager: ลบรีวิว ID: $reviewId');
    }
  }

  /// Get reviews for a specific attraction
  List<Review> getReviewsForAttraction(int attractionId) {
    return _reviews
        .where((review) => review.attractionId == attractionId)
        .toList();
  }

  /// Check if user has reviewed a specific attraction
  bool hasReviewedAttraction(int attractionId) {
    return _reviews.any((review) => review.attractionId == attractionId);
  }

  /// Get user's review for a specific attraction
  Review? getUserReviewForAttraction(int attractionId) {
    try {
      return _reviews.firstWhere(
        (review) => review.attractionId == attractionId,
      );
    } catch (e) {
      return null;
    }
  }

  /// Get total number of reviews
  int get totalReviews => _reviews.length;

  /// Get average rating from all user's reviews
  double get averageRating {
    if (_reviews.isEmpty) return 0.0;
    final totalRating = _reviews.fold(
      0.0,
      (sum, review) => sum + review.rating,
    );
    return totalRating / _reviews.length;
  }

  /// Clear all reviews (for testing or logout)
  Future<void> clearAllReviews() async {
    _reviews.clear();
    await _saveReviews();
    notifyListeners();
    debugPrint('ReviewManager: ลบรีวิวทั้งหมด');
  }

  /// Get reviews sorted by date (newest first)
  List<Review> get reviewsSortedByDate {
    final sortedReviews = List<Review>.from(_reviews);
    sortedReviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sortedReviews;
  }

  /// Get reviews sorted by rating (highest first)
  List<Review> get reviewsSortedByRating {
    final sortedReviews = List<Review>.from(_reviews);
    sortedReviews.sort((a, b) => b.rating.compareTo(a.rating));
    return sortedReviews;
  }
}
