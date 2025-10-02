import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme_manager.dart';
import 'place_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ThemeManager _themeManager = ThemeManager();
  String searchQuery = '';
  List<dynamic> allPlaces = [];
  List<String> categories = [];
  String? selectedCategory;
  List<String> searchHistory = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _themeManager.addListener(_onThemeChanged);
    loadPlaces();
    loadSearchHistory();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _themeManager.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    if (mounted) {
      setState(() {});
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
        categories = _extractCategories(allPlaces);
        loading = false;
      });
    } catch (e) {
      debugPrint('Error loading places: $e');
      setState(() => loading = false);
    }
  }

  List<String> _extractCategories(List<dynamic> places) {
    Set<String> categorySet = {};
    for (var place in places) {
      if (place['category'] != null && place['category']['name'] != null) {
        categorySet.add(place['category']['name']);
      }
    }
    return categorySet.toList()..sort();
  }

  Future<void> loadSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        searchHistory = prefs.getStringList('search_history') ?? [];
      });
    } catch (e) {
      debugPrint('Error loading search history: $e');
    }
  }

  Future<void> saveSearchHistory(String query) async {
    if (query.trim().isEmpty) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Remove if already exists
      searchHistory.remove(query);
      
      // Add to beginning
      searchHistory.insert(0, query);
      
      // Keep only last 10
      if (searchHistory.length > 10) {
        searchHistory = searchHistory.sublist(0, 10);
      }
      
      await prefs.setStringList('search_history', searchHistory);
      
      setState(() {});
    } catch (e) {
      debugPrint('Error saving search history: $e');
    }
  }

  Future<void> clearSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('search_history');
      setState(() {
        searchHistory = [];
      });
    } catch (e) {
      debugPrint('Error clearing search history: $e');
    }
  }

  void performSearch(String query) {
    setState(() {
      searchQuery = query;
      _searchController.text = query;
    });
    saveSearchHistory(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _themeManager.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Search Header
            Container(
              color: _themeManager.cardColor,
              padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Field
                  Container(
                    decoration: BoxDecoration(
                      color: _themeManager.isDarkMode 
                        ? Colors.grey[800] 
                        : Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(color: _themeManager.textPrimaryColor),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          saveSearchHistory(value.trim());
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'ค้นหา...',
                        hintStyle: TextStyle(color: _themeManager.textSecondaryColor),
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search, 
                          color: _themeManager.textSecondaryColor
                        ),
                        suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: _themeManager.textSecondaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  searchQuery = '';
                                  selectedCategory = null;
                                });
                              },
                            )
                          : null,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  
                  // Search History
                  if (searchHistory.isNotEmpty) ...[
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ค้นหาล่าสุด',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _themeManager.textPrimaryColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: _themeManager.cardColor,
                                title: Text(
                                  'ล้างประวัติการค้นหา',
                                  style: TextStyle(color: _themeManager.textPrimaryColor),
                                ),
                                content: Text(
                                  'คุณต้องการล้างประวัติการค้นหาทั้งหมดหรือไม่?',
                                  style: TextStyle(color: _themeManager.textSecondaryColor),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('ยกเลิก'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      clearSearchHistory();
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'ล้าง',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Text(
                            'ล้าง',
                            style: TextStyle(
                              fontSize: 12,
                              color: _themeManager.textSecondaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: searchHistory.take(5).map((query) {
                          return Container(
                            margin: EdgeInsets.only(right: 8),
                            child: InkWell(
                              onTap: () => performSearch(query),
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _themeManager.isDarkMode 
                                    ? Colors.grey[800]
                                    : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.history,
                                      size: 14,
                                      color: _themeManager.textSecondaryColor,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      query,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: _themeManager.textPrimaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                  
                  SizedBox(height: 16),
                  
                  // Categories Label
                  Text(
                    'หมวดหมู่',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _themeManager.textPrimaryColor,
                    ),
                  ),
                  
                  SizedBox(height: 10),
                  
                  // Categories Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: categories.map((category) {
                        bool isSelected = selectedCategory == category;
                        return Container(
                          margin: EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(category),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                selectedCategory = selected ? category : null;
                              });
                            },
                            backgroundColor: _themeManager.isDarkMode 
                              ? Colors.grey[800]
                              : Colors.grey[100],
                            selectedColor: _themeManager.primaryColor.withValues(alpha: 0.2),
                            checkmarkColor: _themeManager.primaryColor,
                            labelStyle: TextStyle(
                              fontSize: 13,
                              color: isSelected 
                                ? _themeManager.primaryColor
                                : _themeManager.textSecondaryColor,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: isSelected 
                                  ? _themeManager.primaryColor
                                  : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            
            // Search Results or Empty State
            Expanded(
              child: loading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: _themeManager.primaryColor,
                      ),
                    )
                  : searchQuery.isEmpty && selectedCategory == null
                      ? _buildEmptyState()
                      : _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Icon
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.search,
                  size: 64,
                  color: _themeManager.textSecondaryColor.withValues(alpha: 0.5),
                ),
                SizedBox(height: 16),
                Text(
                  'เริ่มค้นหา',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: _themeManager.textSecondaryColor,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'ค้นหาสถานที่ที่คุณสนใจ',
                  style: TextStyle(color: _themeManager.textSecondaryColor),
                ),
                SizedBox(height: 4),
                Text(
                  'พบ ${allPlaces.length} สถานที่ในระบบ',
                  style: TextStyle(
                    fontSize: 14,
                    color: _themeManager.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    // Filter results based on search query and category
    List<dynamic> filteredResults = allPlaces.where((place) {
      bool matchesSearch = true;
      bool matchesCategory = true;
      
      if (searchQuery.isNotEmpty) {
        final name = (place['name'] ?? '').toString().toLowerCase();
        final category = (place['category']['name'] ?? '').toString().toLowerCase();
        final district = (place['location']?['district']?['name'] ?? '').toString().toLowerCase();
        final query = searchQuery.toLowerCase();
        
        matchesSearch = name.contains(query) || 
                       category.contains(query) || 
                       district.contains(query);
      }
      
      if (selectedCategory != null) {
        matchesCategory = place['category']['name'] == selectedCategory;
      }
      
      return matchesSearch && matchesCategory;
    }).toList();

    if (filteredResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: _themeManager.textSecondaryColor.withValues(alpha: 0.5),
            ),
            SizedBox(height: 16),
            Text(
              'ไม่พบผลลัพธ์',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: _themeManager.textSecondaryColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'ลองค้นหาด้วยคำอื่น',
              style: TextStyle(color: _themeManager.textSecondaryColor),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Results count
        Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'พบ ${filteredResults.length} สถานที่',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _themeManager.textPrimaryColor,
                ),
              ),
              if (selectedCategory != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _themeManager.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    selectedCategory!,
                    style: TextStyle(
                      fontSize: 12,
                      color: _themeManager.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
        
        // Results list
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: filteredResults.length,
            itemBuilder: (context, index) {
              final place = filteredResults[index];
              return _buildPlaceCard(place);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceCard(dynamic place) {
    final thumbnailUrl = place['thumbnailUrl'] != null && 
                         (place['thumbnailUrl'] as List).isNotEmpty
        ? place['thumbnailUrl'][0]
        : null;
    final location = place['location'];
    final districtName = location?['district']?['name'] ?? '';
    final hasSHA = place['sha'] != null;

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
                color: _themeManager.isDarkMode 
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
                            color: _themeManager.textSecondaryColor,
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
                            color: _themeManager.primaryColor,
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Icon(
                        Icons.place,
                        size: 40,
                        color: _themeManager.textSecondaryColor,
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
                              color: _themeManager.textPrimaryColor,
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
                          color: _themeManager.textSecondaryColor,
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '$districtName • ${place['category']['name'] ?? ''}',
                            style: TextStyle(
                              fontSize: 12,
                              color: _themeManager.textSecondaryColor,
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
                          color: _themeManager.textSecondaryColor,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '${place['viewer'] ?? 0} ครั้ง',
                          style: TextStyle(
                            fontSize: 11,
                            color: _themeManager.textSecondaryColor,
                          ),
                        ),
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
}