// screens/search_screen.dart
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> filters = ['ทั้งหมด', 'ใกล้ฉัน', 'ยอดนิยม'];
  int _selectedFilterIndex = 0;
  bool _isSearching = false;
  
  // Sample search results
  final List<Map<String, dynamic>> _allPlaces = [
    {
      'name': 'ปราสาทเขาพนมรุ้ง',
      'category': 'ประวัติศาสตร์',
      'rating': 4.8,
      'distance': '2.5 km',
      'price': 'ฟรี',
      'description': 'ปราสาทหินทรายสมัยอังกอร์'
    },
    {
      'name': 'อุทยานแห่งชาติเขาพระวิหาร',
      'category': 'ธรรมชาติ',
      'rating': 4.6,
      'distance': '15 km',
      'price': '฿40',
      'description': 'อุทยานแห่งชาติบนเทือกเขาดงพญาเย็น'
    },
    {
      'name': 'วัดเขาพนมรุ้ง',
      'category': 'วัด',
      'rating': 4.5,
      'distance': '3.2 km',
      'price': 'ฟรี',
      'description': 'วัดโบราณบนยอดเขา'
    },
    {
      'name': 'ตลาดโต้รุ่งศรีสะเกษ',
      'category': 'อาหาร',
      'rating': 4.2,
      'distance': '1.8 km',
      'price': '฿50-200',
      'description': 'ตลาดอาหารท้องถิ่นยามค่ำคืน'
    },
    {
      'name': 'เขื่อนสิรินธร',
      'category': 'ธรรมชาติ',
      'rating': 4.4,
      'distance': '25 km',
      'price': 'ฟรี',
      'description': 'เขื่อนขนาดใหญ่และทะเลสาบสวยงาม'
    },
  ];
  
  List<Map<String, dynamic>> _filteredPlaces = [];

  @override
  void initState() {
    super.initState();
    _filteredPlaces = _allPlaces;
  }

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
            _buildSearchHeader(),
            Expanded(
              child: _isSearching || _searchController.text.isNotEmpty
                  ? _buildSearchResults()
                  : _buildEmptyState(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Column(
        children: [
          _buildSearchBar(),
          SizedBox(height: 16),
          _buildFilters(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'ค้นหาสถานที่ท่องเที่ยว...',
          hintStyle: TextStyle(color: Colors.grey[600]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[600]),
                  onPressed: _clearSearch,
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: filters.asMap().entries.map((entry) {
        int index = entry.key;
        String filter = entry.value;
        bool isSelected = index == _selectedFilterIndex;
        
        return Container(
          margin: EdgeInsets.only(right: 8),
          child: ElevatedButton(
            onPressed: () => _onFilterSelected(index),
            style: ElevatedButton.styleFrom(
              backgroundColor: isSelected ? Colors.orange[500] : Colors.grey[100],
              foregroundColor: isSelected ? Colors.white : Colors.grey[600],
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(filter),
          ),
        );
      }).toList(),
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
    if (_filteredPlaces.isEmpty) {
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
              'ไม่พบผลการค้นหา',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'ลองเปลี่ยนคำค้นหาหรือฟิลเตอร์',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _filteredPlaces.length,
      itemBuilder: (context, index) {
        return _buildPlaceCard(_filteredPlaces[index]);
      },
    );
  }

  Widget _buildPlaceCard(Map<String, dynamic> place) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
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
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Navigate to place detail
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getCategoryIcon(place['category']),
                  size: 32,
                  color: Colors.grey[500],
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place['name'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      place['description'],
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        SizedBox(width: 4),
                        Text('${place['rating']}', 
                          style: TextStyle(fontWeight: FontWeight.w600)),
                        SizedBox(width: 16),
                        Icon(Icons.location_on, color: Colors.grey[500], size: 16),
                        SizedBox(width: 4),
                        Text(place['distance'],
                          style: TextStyle(color: Colors.grey[600])),
                        Spacer(),
                        Text(
                          place['price'],
                          style: TextStyle(
                            color: Colors.green[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSearchChanged(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      _filteredPlaces = _allPlaces.where((place) {
        return place['name'].toLowerCase().contains(query.toLowerCase()) ||
               place['category'].toLowerCase().contains(query.toLowerCase()) ||
               place['description'].toLowerCase().contains(query.toLowerCase());
      }).toList();
      
      // Apply filter
      if (_selectedFilterIndex != 0) {
        _applyFilter();
      }
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _isSearching = false;
      _filteredPlaces = _allPlaces;
      if (_selectedFilterIndex != 0) {
        _applyFilter();
      }
    });
  }

  void _onFilterSelected(int index) {
    setState(() {
      _selectedFilterIndex = index;
      _applyFilter();
    });
  }

  void _applyFilter() {
    List<Map<String, dynamic>> basePlaces = _searchController.text.isEmpty 
        ? _allPlaces 
        : _allPlaces.where((place) {
            return place['name'].toLowerCase().contains(_searchController.text.toLowerCase()) ||
                   place['category'].toLowerCase().contains(_searchController.text.toLowerCase()) ||
                   place['description'].toLowerCase().contains(_searchController.text.toLowerCase());
          }).toList();

    switch (_selectedFilterIndex) {
      case 0: // ทั้งหมด
        _filteredPlaces = basePlaces;
        break;
      case 1: // ใกล้ฉัน
        _filteredPlaces = basePlaces.where((place) {
          double distance = double.parse(place['distance'].replaceAll(' km', ''));
          return distance <= 5;
        }).toList();
        break;
      case 2: // ยอดนิยม
        _filteredPlaces = basePlaces.where((place) {
          return place['rating'] >= 4.5;
        }).toList();
        break;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'ประวัติศาสตร์':
        return Icons.account_balance;
      case 'ธรรมชาติ':
        return Icons.nature;
      case 'วัด':
        return Icons.temple_hindu;
      case 'อาหาร':
        return Icons.restaurant;
      case 'ช้อปปิ้ง':
        return Icons.shopping_bag;
      default:
        return Icons.place;
    }
  }
}