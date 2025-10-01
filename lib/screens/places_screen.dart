import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme_manager.dart';
import 'place_detail_screen.dart';

class PlacesScreen extends StatefulWidget {
  final String? initialCategory;
  
  const PlacesScreen({super.key, this.initialCategory});

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  late ThemeManager _themeManager;
  List<dynamic> places = [];
  String? selectedCategory;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _themeManager = ThemeManager();
    _themeManager.addListener(_onThemeChanged);
    selectedCategory = widget.initialCategory;
    loadPlaces();
  }

  @override
  void dispose() {
    _themeManager.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    if (mounted) setState(() {});
  }

  Future<void> loadPlaces() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/data/response_1759296972786.json'
      );
      final data = json.decode(response);
      
      setState(() {
        places = data['data'] ?? [];
        loading = false;
      });
    } catch (e) {
      debugPrint('Error loading places: $e');
      setState(() => loading = false);
    }
  }

  List<dynamic> get filteredPlaces {
    if (selectedCategory == null) return places;
    return places.where((place) => 
      place['category']['name'] == selectedCategory
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        backgroundColor: _themeManager.backgroundColor,
        body: Center(
          child: CircularProgressIndicator(
            color: _themeManager.primaryColor,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: _themeManager.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                selectedCategory ?? 'สถานที่ท่องเที่ยว',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: _themeManager.headerGradient,
                ),
              ),
            ),
            backgroundColor: _themeManager.primaryColor,
          ),
          
          // Header Info
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedCategory == null 
                      ? 'สถานที่ทั้งหมด (${places.length})'
                      : '$selectedCategory (${filteredPlaces.length})',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _themeManager.textPrimaryColor,
                    ),
                  ),
                  if (selectedCategory != null)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedCategory = null;
                        });
                      },
                      child: Text('ล้างตัวกรอง'),
                    ),
                ],
              ),
            ),
          ),
          
          // Places List
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final place = filteredPlaces[index];
                  return PlaceCard(
                    place: place,
                    themeManager: _themeManager,
                  );
                },
                childCount: filteredPlaces.length,
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),
        ],
      ),
    );
  }
}

class PlaceCard extends StatelessWidget {
  final dynamic place;
  final ThemeManager themeManager;
  
  const PlaceCard({
    required this.place,
    required this.themeManager,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final thumbnailUrl = place['thumbnailUrl'] != null && 
                         (place['thumbnailUrl'] as List).isNotEmpty
        ? place['thumbnailUrl'][0]
        : null;
    
    final hasSHA = place['sha'] != null;
    final location = place['location'];
    final districtName = location?['district']?['name'] ?? '';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaceDetailScreen(place: place),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: themeManager.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: themeManager.isDarkMode 
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.grey.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: Container(
                width: 100,
                height: 100,
                color: themeManager.isDarkMode 
                  ? Colors.grey[800] 
                  : Colors.grey[200],
                child: thumbnailUrl != null
                  ? Image.network(
                      thumbnailUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.image,
                            size: 40,
                            color: themeManager.textSecondaryColor,
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / 
                                loadingProgress.expectedTotalBytes!
                              : null,
                            strokeWidth: 2,
                            color: themeManager.primaryColor,
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        '📍',
                        style: TextStyle(fontSize: 32),
                      ),
                    ),
              ),
            ),
            
            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            place['name'] ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: themeManager.textPrimaryColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (hasSHA)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'SHA',
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.green[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: themeManager.textSecondaryColor,
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '$districtName • ${place['category']['name'] ?? ''}',
                            style: TextStyle(
                              fontSize: 12,
                              color: themeManager.textSecondaryColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.remove_red_eye,
                          size: 12,
                          color: themeManager.textSecondaryColor,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '${place['viewer'] ?? 0} ครั้ง',
                          style: TextStyle(
                            fontSize: 11,
                            color: themeManager.textSecondaryColor,
                          ),
                        ),
                        if (place['updatedAt'] != null) ...[
                          SizedBox(width: 12),
                          Icon(
                            Icons.update,
                            size: 12,
                            color: themeManager.textSecondaryColor,
                          ),
                          SizedBox(width: 4),
                          Text(
                            _formatDate(place['updatedAt']),
                            style: TextStyle(
                              fontSize: 11,
                              color: themeManager.textSecondaryColor,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
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
}