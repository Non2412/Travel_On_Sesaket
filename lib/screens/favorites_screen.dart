import 'package:flutter/material.dart';
import '../theme_manager.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final ThemeManager _themeManager = ThemeManager();
  
  // Sample favorite places data
  List<Map<String, dynamic>> favoritePlaces = [
    {
      'id': 1,
      'name': 'ปราสาทเขาพนมรุ้ง',
      'rating': 4.8,
      'distance': '2.5 km',
      'price': 'ฟรี',
      'category': 'ประวัติศาสตร์',
      'isFavorite': true,
    },
    {
      'id': 2,
      'name': 'อุทยานแห่งชาติเขาพระวิหาร',
      'rating': 4.6,
      'distance': '15 km',
      'price': '฿40',
      'category': 'ธรรมชาติ',
      'isFavorite': true,
    },
    {
      'id': 3,
      'name': 'วัดสระบุรี',
      'rating': 4.5,
      'distance': '3.2 km',
      'price': 'ฟรี',
      'category': 'วัด',
      'isFavorite': true,
    },
  ];

  // Filter options
  final List<String> filterOptions = ['ทั้งหมด', 'ประวัติศาสตร์', 'ธรรมชาติ', 'วัด', 'อาหาร'];
  String selectedFilter = 'ทั้งหมด';

  @override
  void initState() {
    super.initState();
    _themeManager.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    _themeManager.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void toggleFavorite(int placeId) {
    setState(() {
      favoritePlaces = favoritePlaces.map((place) {
        if (place['id'] == placeId) {
          place['isFavorite'] = !place['isFavorite'];
        }
        return place;
      }).toList();

      // Remove unfavorited places from the list
      favoritePlaces.removeWhere((place) => !place['isFavorite']);
    });
  }

  List<Map<String, dynamic>> getFilteredPlaces() {
    if (selectedFilter == 'ทั้งหมด') {
      return favoritePlaces;
    }
    return favoritePlaces.where((place) => place['category'] == selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
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
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: _themeManager.textSecondaryColor),
            onPressed: () {
              // Add search functionality here
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Section
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

  Widget _buildPlaceCard(Map<String, dynamic> place) {
    return Container(
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
          // Image Placeholder
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
                Center(
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
                      place['category'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Favorite Button
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () => toggleFavorite(place['id']),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _themeManager.cardColor.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        place['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                        color: place['isFavorite'] ? Colors.red[400] : _themeManager.textSecondaryColor,
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
                  place['name'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _themeManager.textPrimaryColor,
                  ),
                ),
                
                SizedBox(height: 12),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        SizedBox(width: 4),
                        Text('${place['rating']}', 
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: _themeManager.textPrimaryColor,
                          )),
                        SizedBox(width: 16),
                        Icon(Icons.location_on, color: _themeManager.textSecondaryColor, size: 16),
                        SizedBox(width: 4),
                        Text(place['distance'],
                          style: TextStyle(color: _themeManager.textSecondaryColor)),
                      ],
                    ),
                    Text(
                      place['price'],
                      style: TextStyle(
                        color: Colors.green[600],
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 12),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Add navigation functionality
                        },
                        icon: Icon(Icons.directions, size: 16),
                        label: Text('นำทาง'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _themeManager.primaryColor,
                          side: BorderSide(color: _themeManager.primaryColor.withValues(alpha: 0.7)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Add details functionality
                        },
                        icon: Icon(Icons.info, size: 16),
                        label: Text('รายละเอียด'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _themeManager.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}