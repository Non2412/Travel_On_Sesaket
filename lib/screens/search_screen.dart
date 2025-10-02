import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../theme_manager.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ThemeManager _themeManager = ThemeManager();
  final List<String> filters = const ['ทั้งหมด', 'ใกล้ฉัน', 'ยอดนิยม'];
  int selectedFilterIndex = 0;
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
                      decoration: InputDecoration(
                        hintText: 'ค้นหา...',
                        hintStyle: TextStyle(color: _themeManager.textSecondaryColor),
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search, 
                          color: _themeManager.textSecondaryColor
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Filters
                  Row(
                    children: filters.asMap().entries.map((entry) {
                      int index = entry.key;
                      String filter = entry.value;
                      bool isSelected = index == selectedFilterIndex;
                      return Container(
                        margin: EdgeInsets.only(right: 8),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedFilterIndex = index;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected 
                                ? _themeManager.primaryColor
                                : _themeManager.isDarkMode 
                                  ? Colors.grey[800]
                                  : Colors.grey[100],
                            foregroundColor: isSelected 
                                ? Colors.white 
                                : _themeManager.textSecondaryColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(filter),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            
            // Search Results or Empty State
            Expanded(
              child: searchQuery.isEmpty
                  ? _buildEmptyState()
                  : _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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