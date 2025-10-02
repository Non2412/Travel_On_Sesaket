import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher/url_launcher_string.dart';
import '../theme_manager.dart';

class PlaceDetailScreen extends StatefulWidget {
  final dynamic place;
  
  const PlaceDetailScreen({super.key, required this.place});

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  // เก็บรายการรีวิว (mock local)
  List<Map<String, dynamic>> _reviews = [];

  void _showReviewDialog() {
    int rating = 5;
    TextEditingController reviewController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('เขียนรีวิว'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) => IconButton(
                  icon: Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    rating = index + 1;
                    (context as Element).markNeedsBuild();
                  },
                )),
              ),
              TextField(
                controller: reviewController,
                decoration: InputDecoration(hintText: 'เขียนรีวิวของคุณ...'),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('ยกเลิก'),
            ),
            ElevatedButton(
              onPressed: () {
                if (reviewController.text.trim().isNotEmpty) {
                  setState(() {
                    _reviews.insert(0, {
                      'rating': rating,
                      'text': reviewController.text.trim(),
                      'date': DateTime.now(),
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('ส่งรีวิว'),
            ),
          ],
        );
      },
    );
  }
  late ThemeManager _themeManager;
  int currentImageIndex = 0;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _themeManager = ThemeManager();
    _themeManager.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    _themeManager.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    if (mounted) setState(() {});
  }

  List<String> get images {
    if (widget.place['thumbnailUrl'] != null && 
        (widget.place['thumbnailUrl'] as List).isNotEmpty) {
      return List<String>.from(widget.place['thumbnailUrl']);
    }
    return [];
  }

  // ฟังก์ชันเปิด Google Maps
  Future<void> _openGoogleMaps() async {
    final placeName = widget.place['name'] ?? '';
    final location = widget.place['location'];
    final districtName = location?['district']?['name'] ?? '';
    final provinceName = location?['province']?['name'] ?? '';
    
    // สร้าง search query สำหรับ Google Maps
    final searchQuery = Uri.encodeComponent('$placeName $districtName $provinceName');
    
    // ลอง URL หลายรูปแบบเพื่อความแม่นยำ
    final List<String> mapUrls = [
      // ถ้ามี latitude, longitude ใช้พิกัดตรง
      if (location?['latitude'] != null && location?['longitude'] != null)
        'geo:${location['latitude']},${location['longitude']}?q=${location['latitude']},${location['longitude']}($searchQuery)',
      // Google Maps search URL
      'https://www.google.com/maps/search/?api=1&query=$searchQuery',
      // Intent URL สำหรับเปิด Google Maps app
      'geo:0,0?q=$searchQuery',
    ];

    bool launched = false;
    
    // ลองเปิดแต่ละ URL จนกว่าจะสำเร็จ
    for (final urlString in mapUrls) {
      try {
        final uri = Uri.parse(urlString);
        if (await canLaunchUrl(uri)) {
          launched = await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
          if (launched) break;
        }
      } catch (e) {
        debugPrint('Error launching URL: $urlString, Error: $e');
      }
    }

    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('ไม่สามารถเปิดแผนที่ได้ กรุณาติดตั้ง Google Maps'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'ตกลง',
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = widget.place['location'];
    final districtName = location?['district']?['name'] ?? '';
    final provinceName = location?['province']?['name'] ?? '';
    final hasSHA = widget.place['sha'] != null;

    return Scaffold(
      backgroundColor: _themeManager.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // Image Header
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: () {
                    // Share functionality
                  },
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (images.isNotEmpty)
                    PageView.builder(
                      itemCount: images.length,
                      onPageChanged: (index) {
                        setState(() {
                          currentImageIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Image.network(
                          images[index],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: _themeManager.isDarkMode 
                                ? Colors.grey[800] 
                                : Colors.grey[300],
                              child: Center(
                                child: Icon(
                                  Icons.image,
                                  size: 64,
                                  color: _themeManager.textSecondaryColor,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    )
                  else
                    Container(
                      color: _themeManager.isDarkMode 
                        ? Colors.grey[800] 
                        : Colors.grey[300],
                      child: Center(
                        child: Icon(
                          Icons.image,
                          size: 64,
                          color: _themeManager.textSecondaryColor,
                        ),
                      ),
                    ),
                  
                  // Image indicator
                  if (images.length > 1)
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          images.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: currentImageIndex == index
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Category
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.place['name'] ?? '',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: _themeManager.textPrimaryColor,
                              ),
                            ),
                          ),
                          if (hasSHA)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'SHA',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Category
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _themeManager.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.place['category']['name'] ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            color: _themeManager.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Stats Row
                      Row(
                        children: [
                          Icon(
                            Icons.remove_red_eye,
                            size: 18,
                            color: _themeManager.textSecondaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.place['viewer'] ?? 0} ครั้ง',
                            style: TextStyle(
                              fontSize: 14,
                              color: _themeManager.textSecondaryColor,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Icon(
                            Icons.update,
                            size: 18,
                            color: _themeManager.textSecondaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(widget.place['updatedAt'] ?? ''),
                            style: TextStyle(
                              fontSize: 14,
                              color: _themeManager.textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const Divider(height: 1),
                
                // Location & Description
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: _themeManager.primaryColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$districtName, $provinceName',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: _themeManager.textPrimaryColor,
                                  ),
                                ),
                                if ((widget.place['detail'] != null && widget.place['detail'].toString().isNotEmpty) ||
                                    (widget.place['introduction'] != null && widget.place['introduction'].toString().isNotEmpty))
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'รายละเอียด',
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: _themeManager.primaryColor,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            widget.place['detail']?.toString().isNotEmpty == true
                                                ? widget.place['detail']
                                                : widget.place['introduction'] ?? '',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey[800],
                                              height: 1.6,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                
                const SizedBox(height: 16),

                // ปุ่มเขียนรีวิว
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.rate_review),
                      label: Text('เขียนรีวิว'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: _showReviewDialog,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // แสดงรายการรีวิว
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'รีวิว (${_reviews.length})',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _themeManager.textPrimaryColor),
                  ),
                ),
                const SizedBox(height: 8),
                if (_reviews.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Text('ยังไม่มีรีวิวสำหรับสถานที่นี้', style: TextStyle(color: Colors.grey)),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _reviews.length,
                    itemBuilder: (context, index) {
                      final review = _reviews[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Row(
                                    children: List.generate(5, (i) => Icon(
                                      i < (review['rating'] ?? 0) ? Icons.star : Icons.star_border,
                                      color: Colors.amber,
                                      size: 20,
                                    )),
                                  ),
                                  SizedBox(width: 8),
                                  Text(_formatDate((review['date'] as DateTime).toIso8601String()), style: TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                              SizedBox(height: 6),
                              Text(review['text'] ?? '', style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 80), // Space for bottom button
              ],
            ),
          ),
        ],
      ),
      
      // Bottom Button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _themeManager.cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton.icon(
            onPressed: _openGoogleMaps,
            icon: const Icon(Icons.directions),
            label: const Text('นำทาง'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _themeManager.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);
      
      if (difference.inDays == 0) {
        return 'วันนี้';
      } else if (difference.inDays == 1) {
        return 'เมื่อวาน';
      } else if (difference.inDays < 30) {
        return '${difference.inDays} วันที่แล้ว';
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        return '$months เดือนที่แล้ว';
      } else {
        final years = (difference.inDays / 365).floor();
        return '$years ปีที่แล้ว';
      }
    } catch (e) {
      return '';
    }
  }
  
  // ไม่ต้องมีฟังก์ชัน canLaunchUrl ซ้ำ เพราะใช้ของ url_launcher โดยตรง
}