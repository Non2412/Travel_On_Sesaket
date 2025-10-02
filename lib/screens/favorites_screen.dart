import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme_manager.dart';
import '../favorites_manager.dart';
import 'place_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final ThemeManager _themeManager = ThemeManager();
  final FavoritesManager _favoritesManager = FavoritesManager();
  
  List<dynamic> allPlaces = [];
  List<dynamic> favoritePlaces = [];
  bool loading = true;

  // Filter options - ใช้หมวดหมู่เดียวกับข้อมูลจริง
  List<String> filterOptions = ['ทั้งหมด'];
  String selectedFilter = 'ทั้งหมด';

  @override
  void initState() {
    super.initState();
    _themeManager.addListener(_onThemeChanged);
    _favoritesManager.addListener(_onFavoritesChanged);
    loadPlaces();
  }

  @override
  void dispose() {
    _themeManager.removeListener(_onThemeChanged);
    _favoritesManager.removeListener(_onFavoritesChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onFavoritesChanged() {
    if (mounted) {
      loadPlaces();
    }
  }

  Future<void> loadPlaces() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/data/response_1759296972786.json'
      );
      final data = json.decode(response);
      
      setState(() {
        allPlaces = data['data'] ?? [];
        
        // กรองเฉพาะสถานที่ที่อยู่ในรายการโปรด
        favoritePlaces = allPlaces.where((place) {
          final placeId = place['placeId']?.toString() ?? '';
          return _favoritesManager.isFavorite(placeId);
        }).toList();
        
        // สร้างรายการหมวดหมู่จากข้อมูลจริง
        Set<String> categories = {'ทั้งหมด'};
        for (var place in favoritePlaces) {
          if (place['category'] != null && place['category']['name'] != null) {
            categories.add(place['category']['name']);
          }
        }
        filterOptions = categories.toList();
        
        loading = false;
      });
    } catch (e) {
      debugPrint('Error loading places: $e');
      setState(() => loading = false);
    }
  }

  void toggleFavorite(String placeId) {
    _favoritesManager.toggleFavorite(placeId);
  }

  List<dynamic> getFilteredPlaces() {
    if (selectedFilter == 'ทั้งหมด') {
      return favoritePlaces;
    }
    return favoritePlaces.where((place) => 
      place['category']['name'] == selectedFilter
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

    final filteredPlaces = getFilteredPlaces();

    return Scaffold(
      backgroundColor: _themeManager.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: _themeManager.textPrimaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'รายการโปรด',
          style: TextStyle(
            color: _themeManager.textPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter Section
          if (favoritePlaces.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: filterOptions.map((filter) {
                    bool isSelected = selectedFilter == filter;
                    return Container(
                      margin: EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            selectedFilter = filter;
                          });
                        },
                        backgroundColor: _themeManager.isDarkMode ? Colors.grey[700] : Colors.grey[100],
                        selectedColor: _themeManager.primaryColor.withValues(alpha: 0.2),
                        labelStyle: TextStyle(
                          color: isSelected ? _themeManager.primaryColor : _themeManager.textSecondaryColor,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected ? _themeManager.primaryColor : Colors.transparent,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

          // Content
          Expanded(
            child: filteredPlaces.isEmpty 
              ? _buildEmptyState()
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  itemCount: filteredPlaces.length,
                  itemBuilder: (context, index) {
                    final place = filteredPlaces[index];
                    return _buildPlaceCard(place);
                  },
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: _themeManager.textSecondaryColor.withValues(alpha: 0.5),
          ),
          SizedBox(height: 16),
          Text(
            'ยังไม่มีรายการโปรด',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _themeManager.textSecondaryColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'เริ่มเพิ่มสถานที่ที่คุณชอบลงในรายการโปรด',
            style: TextStyle(
              color: _themeManager.textSecondaryColor.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _themeManager.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: Text(
              'เริ่มสำรวจ',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceCard(dynamic place) {
    final placeId = place['placeId']?.toString() ?? '';
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
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: _themeManager.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _themeManager.isDarkMode 
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.grey.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: _themeManager.isDarkMode ? Colors.grey[700] : Colors.grey[300],
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: thumbnailUrl != null
                      ? Image.network(
                          thumbnailUrl,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image,
                                    size: 48,
                                    color: _themeManager.textSecondaryColor,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'รูปภาพสถานที่',
                                    style: TextStyle(
                                      color: _themeManager.textSecondaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image,
                                size: 48,
                                color: _themeManager.textSecondaryColor,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'รูปภาพสถานที่',
                                style: TextStyle(
                                  color: _themeManager.textSecondaryColor,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                  ),
                  // Category Badge
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _themeManager.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        place['category']['name'] ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // SHA Badge
                  if (hasSHA)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _themeManager.primaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              place['category']['name'] ?? '',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 4),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'SHA',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.green[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  // Favorite Button
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () => toggleFavorite(placeId),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _themeManager.cardColor.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.favorite,
                          color: Colors.red[400],
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place['name'] ?? '',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _themeManager.textPrimaryColor,
                    ),
                  ),
                  
                  SizedBox(height: 12),
                  
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: _themeManager.textSecondaryColor,
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '$districtName • ${place['category']['name'] ?? ''}',
                          style: TextStyle(
                            fontSize: 14,
                            color: _themeManager.textSecondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 8),
                  
                  Row(
                    children: [
                      Icon(
                        Icons.remove_red_eye,
                        size: 14,
                        color: _themeManager.textSecondaryColor,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${place['viewer'] ?? 0} ครั้ง',
                        style: TextStyle(
                          fontSize: 14,
                          color: _themeManager.textSecondaryColor,
                        ),
                      ),
                      if (place['updatedAt'] != null) ...[
                        SizedBox(width: 16),
                        Icon(
                          Icons.update,
                          size: 14,
                          color: _themeManager.textSecondaryColor,
                        ),
                        SizedBox(width: 4),
                        Text(
                          _formatDate(place['updatedAt']),
                          style: TextStyle(
                            fontSize: 14,
                            color: _themeManager.textSecondaryColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                  
                  SizedBox(height: 12),
                  
                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Add navigation functionality
                      },
                      icon: Icon(Icons.directions, size: 18, color: Colors.white),
                      label: Text(
                        'นำทาง',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _themeManager.primaryColor,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
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