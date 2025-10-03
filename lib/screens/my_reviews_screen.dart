import 'package:flutter/material.dart';
import '../models/api_models.dart';
import '../theme_manager.dart';
import '../review_manager.dart';

class MyReviewsScreen extends StatefulWidget {
  const MyReviewsScreen({super.key});

  @override
  State<MyReviewsScreen> createState() => _MyReviewsScreenState();
}

class _MyReviewsScreenState extends State<MyReviewsScreen> {
  late ThemeManager _themeManager;
  late ReviewManager _reviewManager;
  List<Review> myReviews = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _themeManager = ThemeManager();
    _reviewManager = ReviewManager();
    _themeManager.addListener(_onThemeChanged);
    _reviewManager.addListener(_onReviewsChanged);
    _initializeAndLoadReviews();
  }

  @override
  void dispose() {
    _themeManager.removeListener(_onThemeChanged);
    _reviewManager.removeListener(_onReviewsChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    if (mounted) setState(() {});
  }

  void _onReviewsChanged() {
    if (mounted) {
      setState(() {
        myReviews = _reviewManager.reviewsSortedByDate;
      });
    }
  }

  Future<void> _initializeAndLoadReviews() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      await _reviewManager.initialize();
      setState(() {
        myReviews = _reviewManager.reviewsSortedByDate;
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = 'เกิดข้อผิดพลาดในการโหลดรีวิว: $e';
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _themeManager.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'รีวิวของฉัน',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: _themeManager.headerGradient,
          ),
        ),
        backgroundColor: _themeManager.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddReviewDialog();
        },
        backgroundColor: _themeManager.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildBody() {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              error!,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _initializeAndLoadReviews,
              child: const Text('ลองใหม่'),
            ),
          ],
        ),
      );
    }

    if (myReviews.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rate_review_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'ยังไม่มีรีวิวของคุณ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'เริ่มเขียนรีวิวสถานที่ที่คุณเคยไปเที่ยว',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _showAddReviewDialog,
              icon: const Icon(Icons.add),
              label: const Text('เขียนรีวิวแรก'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _themeManager.primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _initializeAndLoadReviews,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: myReviews.length,
        itemBuilder: (context, index) {
          final review = myReviews[index];
          return _buildReviewCard(review);
        },
      ),
    );
  }

  Widget _buildReviewCard(Review review) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: _themeManager.cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _themeManager.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.location_on,
                    color: _themeManager.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'สถานที่ท่องเที่ยว #${review.attractionId}', // TODO: ใช้ชื่อสถานที่จริง
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _themeManager.textPrimaryColor,
                    ),
                  ),
                ),
                Row(
                  children: List.generate(5, (starIndex) {
                    return Icon(
                      starIndex < review.rating.floor()
                          ? Icons.star
                          : starIndex < review.rating
                              ? Icons.star_half
                              : Icons.star_border,
                      color: Colors.amber,
                      size: 18,
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              review.comment,
              style: TextStyle(
                fontSize: 14,
                color: _themeManager.textPrimaryColor,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'โดย ${review.userFullName}',
                  style: TextStyle(
                    fontSize: 12,
                    color: _themeManager.textSecondaryColor,
                  ),
                ),
                Text(
                  _formatDate(review.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: _themeManager.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) {
      return 'วันนี้';
    } else if (difference == 1) {
      return 'เมื่อวาน';
    } else if (difference < 7) {
      return '$difference วันที่แล้ว';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showAddReviewDialog() {
    final _commentController = TextEditingController();
    final _attractionNameController = TextEditingController();
    double _rating = 4.0;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('เขียนรีวิว'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _attractionNameController,
                  decoration: const InputDecoration(
                    labelText: 'ชื่อสถานที่',
                    hintText: 'กรอกชื่อสถานที่ที่เคยไปเที่ยว',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('คะแนน: '),
                    ...List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          setDialogState(() {
                            _rating = (index + 1).toDouble();
                          });
                        },
                        child: Icon(
                          index < _rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 30,
                        ),
                      );
                    }),
                    const SizedBox(width: 8),
                    Text('(${_rating.toStringAsFixed(0)}/5)'),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _commentController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'รีวิว',
                    hintText: 'แบ่งปันประสบการณ์ของคุณ...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ยกเลิก'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_attractionNameController.text.trim().isEmpty ||
                    _commentController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('กรุณากรอกข้อมูลให้ครบถ้วน'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // สร้าง ID สุ่มสำหรับสถานที่ (จำลอง)
                final attractionId = DateTime.now().millisecondsSinceEpoch ~/ 1000;
                
                await _reviewManager.addReview(
                  attractionId: attractionId,
                  attractionName: _attractionNameController.text.trim(),
                  rating: _rating,
                  comment: _commentController.text.trim(),
                );

                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('เพิ่มรีวิวสำเร็จ!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _themeManager.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('บันทึก'),
            ),
          ],
        ),
      ),
    );
  }
}
