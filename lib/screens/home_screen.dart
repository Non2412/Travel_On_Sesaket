import 'my_reviews_screen.dart';
import 'package:flutter/material.dart';
import 'thread_list_screen.dart';
import 'dart:math';
import 'points_screen.dart';
import 'checkin_screen.dart';
import 'settings_screen.dart';
import 'help_screen.dart';
import 'places_screen.dart';
import 'place_detail_screen.dart';
import 'favorites_screen.dart';
import '../points_manager.dart';
import '../theme_manager.dart';
import '../favorites_manager.dart';
import '../services/api_service.dart';
import '../models/api_models.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  final Function(int)? onNavigateToTab;

  const HomeScreen({super.key, this.onNavigateToTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PointsManager _pointsManager;
  late ThemeManager _themeManager;
  late FavoritesManager _favoritesManager;
  final TextEditingController _searchController = TextEditingController();

  List<TouristAttraction> allPlaces = [];
  List<Map<String, dynamic>> categories = [];
  List<TouristAttraction> recommendedPlaces = [];
  Map<String, dynamic>? dashboardStats;
  bool loading = true;
  bool isUsingFallbackData = false;

  @override
  void initState() {
    super.initState();
    _pointsManager = PointsManager();
    _themeManager = ThemeManager();
    _favoritesManager = FavoritesManager();

    _pointsManager.addListener(_onPointsChanged);
    _themeManager.addListener(_onThemeChanged);
    _favoritesManager.addListener(_onFavoritesChanged);
    ActivityData.addListener(_refreshData);

    loadPlacesData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pointsManager.removeListener(_onPointsChanged);
    _themeManager.removeListener(_onThemeChanged);
    _favoritesManager.removeListener(_onFavoritesChanged);
    ActivityData.removeListener(_refreshData);
    super.dispose();
  }

  void _onPointsChanged() {
    if (mounted) setState(() {});
  }

  void _onThemeChanged() {
    if (mounted) setState(() {});
  }

  void _onFavoritesChanged() {
    if (mounted) setState(() {});
  }

  void _refreshData() {
    if (mounted) setState(() {});
  }

  Future<void> loadPlacesData() async {
    try {
      setState(() {
        loading = true;
      });

      debugPrint('Loading tourist attractions...');

      // โหลดสถานที่ท่องเที่ยว (ApiService จะจัดการ fallback เอง)
      final attractionsData = await ApiService.getTouristAttractions();
      debugPrint(
        'Attractions data received: ${attractionsData?.length ?? 0} items',
      );

      // โหลดสถิติ dashboard
      final statsData = await ApiService.getDashboardStats();
      debugPrint('Dashboard stats loaded: ${statsData != null}');

      if (attractionsData != null && attractionsData.isNotEmpty) {
        final attractions = attractionsData
            .map((data) => TouristAttraction.fromJson(data))
            .toList();

        setState(() {
          allPlaces = attractions;
          categories = _countCategories(attractions);
          recommendedPlaces = _getRandomPlaces(attractions, 2);
          dashboardStats = statsData;
          isUsingFallbackData = false; // ใช้ fallback data เสมอตอนนี้
          loading = false;
        });

        debugPrint('Successfully loaded ${attractions.length} attractions');
        debugPrint('Recommended places: ${recommendedPlaces.length}');
        debugPrint('Using fallback data: $isUsingFallbackData');
      } else {
        debugPrint('Failed to load attractions data - no data received');
        setState(() {
          loading = false;
          allPlaces = [];
          categories = [];
          recommendedPlaces = [];
          isUsingFallbackData = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading places: $e');
      setState(() {
        loading = false;
        allPlaces = [];
        categories = [];
        recommendedPlaces = [];
        isUsingFallbackData = false;
      });
    }
  }

  List<Map<String, dynamic>> _countCategories(
    List<TouristAttraction> placesData,
  ) {
    Map<String, Map<String, dynamic>> categoryMap = {};

    for (var place in placesData) {
      String catName = place.category;
      if (!categoryMap.containsKey(catName)) {
        categoryMap[catName] = {'id': place.id, 'name': catName, 'count': 0};
      }
      categoryMap[catName]!['count'] =
          (categoryMap[catName]!['count'] ?? 0) + 1;
    }

    return categoryMap.values.toList();
  }

  List<TouristAttraction> _getRandomPlaces(
    List<TouristAttraction> places,
    int count,
  ) {
    if (places.isEmpty) return [];
    final random = Random();
    final shuffled = List.from(places)..shuffle(random);
    return shuffled.take(count).cast<TouristAttraction>().toList();
  }

  @override
  Widget build(BuildContext context) {
    final allActivities = ActivityData.getActivities();

    if (loading) {
      return Scaffold(
        backgroundColor: _themeManager.backgroundColor,
        body: Center(
          child: CircularProgressIndicator(color: _themeManager.primaryColor),
        ),
      );
    }

    return Scaffold(
      backgroundColor: _themeManager.backgroundColor,
      drawer: _buildDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                decoration: BoxDecoration(
                  gradient: _themeManager.headerGradient,
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
                            Builder(
                              builder: (context) => GestureDetector(
                                onTap: () => Scaffold.of(context).openDrawer(),
                                child: Icon(Icons.menu, color: Colors.white),
                              ),
                            ),
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
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (widget.onNavigateToTab != null) {
                                  widget.onNavigateToTab!(3);
                                }
                              },
                              child: Icon(
                                Icons.notifications,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 12),
                            CircleAvatar(
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.2,
                              ),
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    // Search Bar
                    GestureDetector(
                      onTap: () {
                        if (widget.onNavigateToTab != null) {
                          widget.onNavigateToTab!(1);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: Colors.grey[600]),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'ค้นหาสถานที่ท่องเที่ยว...',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Categories
                    _buildSection(
                      'หมวดหมู่',
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.9,
                        ),
                        itemCount: categories.length > 6
                            ? 6
                            : categories.length,
                        itemBuilder: (context, index) {
                          final cat = categories[index];
                          final icons = ['🏛️', '🌳', '🍜', '🛍️', '🏨', '🎭'];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlacesScreen(
                                    initialCategory: cat['name'],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: _themeManager.cardColor,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: _themeManager.isDarkMode
                                        ? Colors.black.withValues(alpha: 0.3)
                                        : Colors.grey.withValues(alpha: 0.1),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    icons[index % icons.length],
                                    style: TextStyle(fontSize: 32),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    cat['name'],
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: _themeManager.textPrimaryColor,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '${cat['count']} แห่ง',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: _themeManager.textSecondaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 24),

                    // Events
                    _buildSection(
                      'กิจกรรม',
                      allActivities.isEmpty
                          ? _buildEmptyEventsState()
                          : Column(
                              children: allActivities
                                  .take(3)
                                  .map((event) => _buildEventCard(event))
                                  .toList(),
                            ),
                      showSeeAll: allActivities.isNotEmpty,
                      onSeeAllTap: () {
                        if (widget.onNavigateToTab != null) {
                          widget.onNavigateToTab!(2);
                        }
                      },
                    ),

                    SizedBox(height: 24),

                    // Places
                    _buildSection(
                      'สถานที่แนะนำ',
                      loading
                          ? Container(
                              padding: EdgeInsets.all(32),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: _themeManager.primaryColor,
                                ),
                              ),
                            )
                          : recommendedPlaces.isEmpty
                          ? _buildEmptyPlacesState()
                          : Column(
                              children: recommendedPlaces
                                  .map((place) => _buildPlaceCard(place))
                                  .toList(),
                            ),
                      showSeeAll: recommendedPlaces.isNotEmpty,
                      onSeeAllTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PlacesScreen(),
                          ),
                        );
                      },
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

  Widget _buildPlaceCard(TouristAttraction place) {
    final placeId = place.id.toString();
    final isFavorite = _favoritesManager.isFavorite(placeId);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaceDetailScreen(
              place: {
                'id': place.id,
                'name': place.name,
                'description': place.description,
                'category': {'name': place.category},
                'district': place.district,
                'address': place.address,
                'image_url': place.imageUrl,
                'average_rating': place.averageRating,
                'review_count': place.reviewCount,
                'latitude': place.latitude,
                'longitude': place.longitude,
                'opening_hours': place.openingHours,
                'contact_info': place.contactInfo,
                'website': place.website,
              },
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: _themeManager.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _themeManager.isDarkMode
                  ? Colors.black.withValues(alpha: 0.3)
                  : Colors.grey.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Container(
                width: double.infinity,
                height: 200,
                color: _themeManager.isDarkMode
                    ? Colors.grey[800]
                    : Colors.grey[200],
                child: place.imageUrl != null
                    ? Image.network(
                        place.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.image,
                              size: 48,
                              color: _themeManager.textSecondaryColor,
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Icon(
                          Icons.image,
                          size: 48,
                          color: _themeManager.textSecondaryColor,
                        ),
                      ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          place.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _themeManager.textPrimaryColor,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _favoritesManager.toggleFavorite(placeId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                _favoritesManager.isFavorite(placeId)
                                    ? 'เพิ่มลงรายการโปรดแล้ว'
                                    : 'ลบออกจากรายการโปรดแล้ว',
                              ),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor:
                                  _favoritesManager.isFavorite(placeId)
                                  ? Colors.green[600]
                                  : _themeManager.textSecondaryColor,
                            ),
                          );
                        },
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite
                              ? Colors.red
                              : _themeManager.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: _themeManager.textSecondaryColor,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${place.district} • ${place.category}',
                          style: TextStyle(
                            fontSize: 14,
                            color: _themeManager.textSecondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '${place.averageRating.toStringAsFixed(1)} (${place.reviewCount} รีวิว)',
                        style: TextStyle(
                          fontSize: 14,
                          color: _themeManager.textSecondaryColor,
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
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: _themeManager.cardColor,
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            decoration: BoxDecoration(gradient: _themeManager.headerGradient),
            padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 35,
                        color: _themeManager.primaryColor,
                      ),
                    ),
                    Spacer(),
                    // Points Display
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PointsScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.stars, color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text(
                              '${_pointsManager.currentPoints}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'แต้ม',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'โปรไฟล์',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'จัดการบัญชีและข้อมูลการท่องเที่ยว',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.event_available,
                  title: 'เช็คอินรับแต้มฟรี',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CheckInScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.favorite,
                  title: 'รายการโปรด',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FavoritesScreen(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.star,
                  title: 'รีวิวของฉัน',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyReviewsScreen(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.event,
                  title: 'กิจกรรม',
                  onTap: () {
                    Navigator.pop(context);
                    if (widget.onNavigateToTab != null) {
                      widget.onNavigateToTab!(2);
                    }
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.forum,
                  title: 'กระทู้',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ThreadListScreen(),
                      ),
                    );
                  },
                ),
                Divider(),
                Divider(
                  color: _themeManager.textSecondaryColor.withValues(
                    alpha: 0.3,
                  ),
                ),
                _buildDrawerItem(
                  icon: Icons.settings,
                  title: 'ตั้งค่า',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.help,
                  title: 'ช่วยเหลือ',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HelpScreen(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.logout,
                  title: 'ออกจากระบบ',
                  onTap: () {
                    Navigator.pop(context);
                    _showLogoutDialog();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: _themeManager.textSecondaryColor, size: 24),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, color: _themeManager.textPrimaryColor),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: _themeManager.cardColor,
          title: Text(
            'ออกจากระบบ',
            style: TextStyle(color: _themeManager.textPrimaryColor),
          ),
          content: Text(
            'คุณต้องการออกจากระบบหรือไม่?',
            style: TextStyle(color: _themeManager.textSecondaryColor),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('ออกจากระบบ', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyEventsState() {
    return Container(
      padding: EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.event_note,
            size: 48,
            color: _themeManager.textSecondaryColor,
          ),
          SizedBox(height: 12),
          Text(
            'ยังไม่มีกิจกรรม',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _themeManager.textSecondaryColor,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'เพิ่มกิจกรรมใหม่ได้ในแท็บกิจกรรม',
            style: TextStyle(
              fontSize: 14,
              color: _themeManager.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyPlacesState() {
    return Container(
      padding: EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: _themeManager.textSecondaryColor,
          ),
          SizedBox(height: 12),
          Text(
            'ไม่พบข้อมูลสถานที่ท่องเที่ยว',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _themeManager.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            'เกิดข้อผิดพลาดในการโหลดข้อมูล',
            style: TextStyle(
              fontSize: 14,
              color: _themeManager.textSecondaryColor,
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              loadPlacesData();
            },
            child: Text('ลองใหม่'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _themeManager.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _themeManager.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _themeManager.isDarkMode
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.grey.withValues(alpha: 0.1),
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
              color: _themeManager.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.event, color: _themeManager.primaryColor),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event['title'] as String,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: _themeManager.textPrimaryColor,
                  ),
                ),
                Text(
                  event['location'] as String,
                  style: TextStyle(
                    color: _themeManager.textSecondaryColor,
                    fontSize: 14,
                  ),
                ),
                if (event['date'] != null && event['time'] != null)
                  Text(
                    _formatEventDateTime(event),
                    style: TextStyle(
                      color: _themeManager.primaryColor,
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

  String _formatEventDateTime(Map<String, dynamic> event) {
    if (event['date'] != null && event['time'] != null) {
      final date = event['date'] as DateTime;
      final time = event['time'] as TimeOfDay;
      return '${date.day}/${date.month}/${date.year} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
    return '';
  }

  Widget _buildSection(
    String title,
    Widget content, {
    bool showSeeAll = false,
    VoidCallback? onSeeAllTap,
  }) {
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
                color: _themeManager.textPrimaryColor,
              ),
            ),
            if (showSeeAll)
              GestureDetector(
                onTap: onSeeAllTap,
                child: Text(
                  'ดูทั้งหมด',
                  style: TextStyle(
                    color: _themeManager.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 16),
        content,
      ],
    );
  }
}
