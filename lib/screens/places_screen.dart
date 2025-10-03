import 'package:flutter/material.dart';
import '../theme_manager.dart';
import '../services/api_service.dart';
import '../models/api_models.dart';
import '../widgets/place_card.dart';
import 'place_detail_screen.dart';

class PlacesScreen extends StatefulWidget {
  final String? initialCategory;
  
  const PlacesScreen({super.key, this.initialCategory});

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  late ThemeManager _themeManager;
  List<TouristAttraction> attractions = [];
  List<String> categories = [];
  List<String> districts = [];
  String? selectedCategory;
  String? selectedDistrict;
  bool loading = true;
  String? error;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _themeManager = ThemeManager();
    _themeManager.addListener(_onThemeChanged);
    selectedCategory = widget.initialCategory;
    _loadInitialData();
  }

  @override
  void dispose() {
    _themeManager.removeListener(_onThemeChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onThemeChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadInitialData() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      // Load categories and districts
      final categoriesData = await ApiService.getAttractionCategories();
      final districtsData = await ApiService.getDistricts();
      
      if (categoriesData != null) {
        categories = categoriesData.map((cat) => cat['name'].toString()).toList();
      }
      
      if (districtsData != null) {
        districts = districtsData.map((dist) => dist['name'].toString()).toList();
      }

      // Load attractions
      await _loadAttractions();
    } catch (e) {
      setState(() {
        error = 'เกิดข้อผิดพลาดในการโหลดข้อมูล: $e';
        loading = false;
      });
    }
  }

  Future<void> _loadAttractions() async {
    try {
      final attractionsData = await ApiService.getTouristAttractions();
      
      if (attractionsData != null) {
        setState(() {
          attractions = attractionsData
              .map((data) => TouristAttraction.fromJson(data))
              .toList();
          loading = false;
        });
      } else {
        setState(() {
          error = 'ไม่สามารถโหลดข้อมูลสถานที่ท่องเที่ยวได้';
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'เกิดข้อผิดพลาด: $e';
        loading = false;
      });
    }
  }

  Future<void> _searchAttractions() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final attractionsData = await ApiService.searchAttractions(
        query: searchController.text.isNotEmpty ? searchController.text : null,
        category: selectedCategory,
        district: selectedDistrict,
      );
      
      if (attractionsData != null) {
        setState(() {
          attractions = attractionsData
              .map((data) => TouristAttraction.fromJson(data))
              .toList();
          loading = false;
        });
      } else {
        setState(() {
          attractions = [];
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'เกิดข้อผิดพลาดในการค้นหา: $e';
        loading = false;
      });
    }
  }

  List<TouristAttraction> get filteredAttractions {
    var result = attractions;
    
    if (selectedCategory != null && selectedCategory!.isNotEmpty) {
      result = result.where((attraction) => 
        attraction.category == selectedCategory).toList();
    }
    
    if (selectedDistrict != null && selectedDistrict!.isNotEmpty) {
      result = result.where((attraction) => 
        attraction.district == selectedDistrict).toList();
    }
    
    return result;
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        backgroundColor: _themeManager.backgroundColor,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (error != null) {
      return Scaffold(
        backgroundColor: _themeManager.backgroundColor,
        appBar: AppBar(
          title: const Text('สถานที่ท่องเที่ยว'),
          backgroundColor: _themeManager.primaryColor,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[300],
              ),
              const SizedBox(height: 16),
              Text(
                error!,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadInitialData,
                child: const Text('ลองใหม่'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: _themeManager.backgroundColor,
      appBar: AppBar(
        title: Text(
          selectedCategory ?? 'สถานที่ท่องเที่ยว',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: _themeManager.headerGradient,
          ),
        ),
        backgroundColor: _themeManager.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSearchSection(),
          _buildFilterSection(),
          Expanded(
            child: _buildPlacesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      color: _themeManager.primaryColor.withValues(alpha: 0.1),
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: searchController,
        onSubmitted: (_) => _searchAttractions(),
        decoration: InputDecoration(
          hintText: 'ค้นหาสถานที่ท่องเที่ยว...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    _loadAttractions();
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      color: _themeManager.primaryColor.withValues(alpha: 0.05),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _buildCategoryFilter(),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildDistrictFilter(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return DropdownButtonFormField<String>(
      value: selectedCategory,
      hint: const Text('หมวดหมู่'),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      items: [
        const DropdownMenuItem(
          value: null,
          child: Text('ทั้งหมด'),
        ),
        ...categories.map((category) => DropdownMenuItem(
          value: category,
          child: Text(category),
        )),
      ],
      onChanged: (value) {
        setState(() {
          selectedCategory = value;
        });
        _searchAttractions();
      },
    );
  }

  Widget _buildDistrictFilter() {
    return DropdownButtonFormField<String>(
      value: selectedDistrict,
      hint: const Text('อำเภอ'),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      items: [
        const DropdownMenuItem(
          value: null,
          child: Text('ทั้งหมด'),
        ),
        ...districts.map((district) => DropdownMenuItem(
          value: district,
          child: Text(district),
        )),
      ],
      onChanged: (value) {
        setState(() {
          selectedDistrict = value;
        });
        _searchAttractions();
      },
    );
  }

  Widget _buildPlacesList() {
    final displayedAttractions = filteredAttractions;
    
    if (displayedAttractions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'ไม่พบสถานที่ท่องเที่ยว',
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ลองเปลี่ยนเงื่อนไขการค้นหา',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadAttractions,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: displayedAttractions.length,
        itemBuilder: (context, index) {
          final attraction = displayedAttractions[index];
          return PlaceCard(
            attraction: attraction,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlaceDetailScreen(
                    place: {
                      'id': attraction.id,
                      'name': attraction.name,
                      'description': attraction.description,
                      'category': {'name': attraction.category},
                      'district': attraction.district,
                      'address': attraction.address,
                      'image_url': attraction.imageUrl,
                      'average_rating': attraction.averageRating,
                      'review_count': attraction.reviewCount,
                      'latitude': attraction.latitude,
                      'longitude': attraction.longitude,
                      'opening_hours': attraction.openingHours,
                      'contact_info': attraction.contactInfo,
                      'website': attraction.website,
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}