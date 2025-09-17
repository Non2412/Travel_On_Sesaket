// screens/home_screen.dart
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  
  final List<Map<String, dynamic>> categories = [
    {'icon': '🏛️', 'name': 'ประวัติศาสตร์', 'count': 15},
    {'icon': '🌿', 'name': 'ธรรมชาติ', 'count': 23},
    {'icon': '🏛️', 'name': 'วัด', 'count': 18},
    {'icon': '🍜', 'name': 'อาหาร', 'count': 45},
    {'icon': '🛍️', 'name': 'ช้อปปิ้ง', 'count': 12},
    {'icon': '🎭', 'name': 'วัฒนธรรม', 'count': 8},
  ];

  final List<Map<String, dynamic>> events = [
    {
      'title': 'งานบุญบั้งไฟศรีสะเกษ',
      'date': '15-17 มี.ค.',
      'location': 'ศรีสะเกษ'
    },
    {
      'title': 'เทศกาลดอกคูณ', 
      'date': '20-22 เม.ย.',
      'location': 'อำเภอกันทรลักษ์'
    },
  ];

  final List<Map<String, dynamic>> places = [
    {
      'name': 'ปราสาทเขาพนมรุ้ง',
      'rating': 4.8,
      'distance': '2.5 km',
      'price': 'ฟรี'
    },
    {
      'name': 'อุทยานแห่งชาติเขาพระวิหาร',
      'rating': 4.6,
      'distance': '15 km', 
      'price': '฿40'
    },
  ];

  // Sample search data (same as search screen)
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              _isSearching ? _buildSearchResults() : _buildContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange[500]!, Colors.red[500]!],
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
      ),
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          // Top Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.menu, color: Colors.white),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'สวัสดีครับ! 👋',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'มาเที่ยวศรีสะเกษกัน',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.notifications, color: Colors.white),
                  SizedBox(width: 12),
                  CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
          
          SizedBox(height: 20),
          
          // Search Bar - Now functional
          _buildSearchBar(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
        style: TextStyle(color: Colors.grey[800]),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoriesSection(),
          SizedBox(height: 24),
          _buildEventsSection(),
          SizedBox(height: 24),
          _buildPlacesSection(),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_filteredPlaces.isEmpty) {
      return Container(
        height: 400,
        child: Center(
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
                'ลองเปลี่ยนคำค้นหา',
                style: TextStyle(color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ผลการค้นหา (${_filteredPlaces.length} รายการ)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _filteredPlaces.length,
            itemBuilder: (context, index) {
              return _buildSearchResultCard(_filteredPlaces[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultCard(Map<String, dynamic> place) {
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

  Widget _buildCategoriesSection() {
    return _buildSection(
      'หมวดหมู่',
      GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return _buildCategoryCard(cat);
        },
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(category['icon'], style: TextStyle(fontSize: 32)),
          SizedBox(height: 8),
          Text(
            category['name'],
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            '${category['count']} แห่ง',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsSection() {
    return _buildSection(
      'กิจกรรม',
      Column(
        children: events.map((event) => _buildEventCard(event)).toList(),
      ),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.orange[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.event,
              color: Colors.orange[600],
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event['title'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  event['location'],
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                Text(
                  event['date'],
                  style: TextStyle(
                    color: Colors.orange[500],
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlacesSection() {
    return _buildSection(
      'สถานที่แนะนำ',
      Column(
        children: places.map((place) => _buildPlaceCard(place)).toList(),
      ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPlaceImage(),
          _buildPlaceContent(place),
        ],
      ),
    );
  }

  Widget _buildPlaceImage() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image,
              size: 48,
              color: Colors.grey[400],
            ),
            SizedBox(height: 8),
            Text(
              'รูปภาพสถานที่',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceContent(Map<String, dynamic> place) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  place['name'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(
                Icons.favorite_border,
                color: Colors.grey[400],
              ),
            ],
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
                    style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(width: 16),
                  Icon(Icons.location_on, color: Colors.grey[500], size: 16),
                  SizedBox(width: 4),
                  Text(place['distance'],
                    style: TextStyle(color: Colors.grey[600])),
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
        ],
      ),
    );
  }
  
  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            Text(
              'ดูทั้งหมด',
              style: TextStyle(
                color: Colors.orange[500],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        content,
      ],
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
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _isSearching = false;
      _filteredPlaces = _allPlaces;
    });
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