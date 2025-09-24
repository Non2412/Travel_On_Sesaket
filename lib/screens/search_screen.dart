import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> filters = const ['ทั้งหมด', 'ใกล้ฉัน', 'ยอดนิยม'];
  int selectedFilterIndex = 0;
  String searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Search Header
            Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                children: [
                  // Search Field (removed camera icon)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'ค้นหา...',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
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
                      return Container(
                        margin: EdgeInsets.only(right: 8),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedFilterIndex = index;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: index == selectedFilterIndex 
                                ? Colors.orange[500] 
                                : Colors.grey[100],
                            foregroundColor: index == selectedFilterIndex 
                                ? Colors.white 
                                : Colors.grey[600],
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
            color: Colors.grey[300],
          ),
          SizedBox(height: 16),
          Text(
            'เริ่มค้นหา',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'ค้นหาสถานที่ที่คุณสนใจ',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    // Sample search results - replace with actual search logic
    List<Map<String, dynamic>> sampleResults = [
      {
        'name': 'ปราสาทเขาพนมรุ้ง',
        'type': 'ประวัติศาสตร์',
        'rating': 4.8,
        'distance': '2.5 km',
        'price': 'ฟรี'
      },
      {
        'name': 'วัดมหาพุทธาราม',
        'type': 'วัด',
        'rating': 4.5,
        'distance': '1.2 km',
        'price': 'ฟรี'
      },
      {
        'name': 'ตลาดเก่าศรีสะเกษ',
        'type': 'ช้อปปิ้ง',
        'rating': 4.3,
        'distance': '0.8 km',
        'price': 'ฟรี'
      },
    ];

    // Filter results based on search query
    List<Map<String, dynamic>> filteredResults = sampleResults
        .where((result) => 
            result['name'].toString().toLowerCase().contains(searchQuery.toLowerCase()) ||
            result['type'].toString().toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    if (filteredResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[300],
            ),
            SizedBox(height: 16),
            Text(
              'ไม่พบผลลัพธ์',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'ลองค้นหาด้วยคำอื่น',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: filteredResults.length,
      itemBuilder: (context, index) {
        final result = filteredResults[index];
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
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
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getIconForType(result['type']),
                color: Colors.orange[600],
              ),
            ),
            title: Text(
              result['name'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Text(
                  result['type'],
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '${result['rating']}',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 16),
                    Icon(Icons.location_on, color: Colors.grey[500], size: 16),
                    SizedBox(width: 4),
                    Text(
                      result['distance'],
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Spacer(),
                    Text(
                      result['price'],
                      style: TextStyle(
                        color: Colors.green[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            onTap: () {
              // Handle tap on search result
              print('Tapped on ${result['name']}');
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