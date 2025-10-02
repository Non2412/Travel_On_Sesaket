import 'dart:convert';
import 'package:flutter/services.dart';
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
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _themeManager.addListener(_onThemeChanged);
    loadPlacesData();
  }

  Future<void> loadPlacesData() async {
    try {
      final String response = await rootBundle.loadString('assets/data/response_1759296972786.json');
      final data = json.decode(response);
      setState(() {
        allPlaces = data['data'] ?? [];
        loading = false;
      });
    } catch (e) {
      debugPrint('Error loading places: $e');
      setState(() => loading = false);
    }
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
    if (loading) {
      return Center(child: CircularProgressIndicator());
    }
    // Filter results based on search query
    List<dynamic> filteredResults = allPlaces.where((place) {
      final name = place['name']?.toString().toLowerCase() ?? '';
      final type = place['category']?['name']?.toString().toLowerCase() ?? '';
      return name.contains(searchQuery.toLowerCase()) || type.contains(searchQuery.toLowerCase());
    }).toList();

    if (filteredResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: _themeManager.textSecondaryColor.withOpacity(0.5),
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

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: filteredResults.length,
      itemBuilder: (context, index) {
        final place = filteredResults[index];
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: _themeManager.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _themeManager.isDarkMode
                  ? Colors.black.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.1),
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: _themeManager.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.place,
                color: _themeManager.primaryColor,
              ),
            ),
            title: Text(
              place['name'] ?? '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: _themeManager.textPrimaryColor,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Text(
                  place['category']?['name'] ?? '',
                  style: TextStyle(
                    color: _themeManager.textSecondaryColor,
                    fontSize: 14,
                  ),
                ),
                if (place['detail'] != null && place['detail'].toString().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0, bottom: 2.0),
                    child: Text(
                      place['detail'],
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 14,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                else if (place['introduction'] != null && place['introduction'].toString().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0, bottom: 2.0),
                    child: Text(
                      place['introduction'],
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 14,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
            onTap: () {
              // TODO: นำไปหน้ารายละเอียดสถานที่จริง
            },
          ),
        );
      },
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'ประวัติศาสตร์':
        return Icons.account_balance;
      case 'วัด':
        return Icons.temple_buddhist;
      case 'ช้อปปิ้ง':
        return Icons.shopping_bag;
      case 'ธรรมชาติ':
        return Icons.nature;
      case 'อาหาร':
        return Icons.restaurant;
      case 'วัฒนธรรม':
        return Icons.theater_comedy;
      default:
        return Icons.place;
    }
  }
}