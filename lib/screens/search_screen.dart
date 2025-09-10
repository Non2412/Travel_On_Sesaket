// screens/search_screen.dart
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<String> filters = ['ทั้งหมด', 'ใกล้ฉัน', 'ยอดนิยม'];
  int selectedFilterIndex = 0;
  final TextEditingController _searchController = TextEditingController();

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
            _buildHeader(),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Column(
        children: [
          _buildSearchRow(),
          const SizedBox(height: 16),
          _buildFilters(),
        ],
      ),
    );
  }

  Widget _buildSearchRow() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey[600]),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'ค้นหา...',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.orange[500],
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.camera_alt,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Row(
      children: filters.asMap().entries.map((entry) {
        int index = entry.key;
        String filter = entry.value;
        return Container(
          margin: const EdgeInsets.only(right: 8),
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
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: _searchController.text.isEmpty 
          ? _buildEmptyState() 
          : _buildSearchResults(),
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
          const SizedBox(height: 16),
          Text(
            'เริ่มค้นหา',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ค้นหาสถานที่ที่คุณสนใจ',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    // TODO: Implement search results
    return const Center(
      child: Text('Search Results will be displayed here'),
    );
  }
}