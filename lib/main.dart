import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/activities_screen.dart';
import 'screens/my_reviews_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/profile_screen.dart';
import 'points_manager.dart';
import 'theme_manager.dart';
import 'review_manager.dart';
import 'favorites_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all managers before starting the app
  await PointsManager().initialize();
  await ReviewManager().initialize();

  runApp(SiSaKetTravelApp());
}

class SiSaKetTravelApp extends StatefulWidget {
  const SiSaKetTravelApp({super.key});

  @override
  State<SiSaKetTravelApp> createState() => _SiSaKetTravelAppState();
}

class _SiSaKetTravelAppState extends State<SiSaKetTravelApp> {
  final ThemeManager _themeManager = ThemeManager();

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

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeManager>.value(value: _themeManager),
        ChangeNotifierProvider<PointsManager>.value(value: PointsManager()),
        ChangeNotifierProvider<ReviewManager>.value(value: ReviewManager()),
        ChangeNotifierProvider<FavoritesManager>.value(
          value: FavoritesManager(),
        ),
      ],
      child: Consumer<ThemeManager>(
        builder: (context, themeManager, child) {
          return MaterialApp(
            title: 'ท่องเที่ยวศรีสะเกษ',
            theme: ThemeData(
              primarySwatch: Colors.orange,
              fontFamily: 'Kanit',
              useMaterial3: true,
            ),
            home: SplashScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Wait for initialization to complete
      await Future.delayed(const Duration(milliseconds: 2500));

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      }
    } catch (e) {
      debugPrint('Error during app initialization: $e');
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/sisaket_night.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.3),
                Colors.black.withValues(alpha: 0.6),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(flex: 2),
              // ข้อความหลัก
              Text(
                'เที่ยวศรีสะเกษ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 52,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 15,
                      color: Colors.black87,
                      offset: Offset(3, 3),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              // ข้อความรอง
              Text(
                'สัมผัสเสน่ห์แห่งอีสาน',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  shadows: [
                    Shadow(
                      blurRadius: 8,
                      color: Colors.black54,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              Spacer(flex: 3),
              // Loading indicator
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                strokeWidth: 3,
              ),
              SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

// Global state for activities
class ActivityData {
  static final List<Map<String, dynamic>> activities = [];
  static final List<VoidCallback> _listeners = [];

  static void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  static void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  static void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  static void addActivity(Map<String, dynamic> activity) {
    activities.insert(0, activity);
    _notifyListeners();
  }

  static List<Map<String, dynamic>> getActivities() {
    return List.from(
      activities,
    ); // Return copy to prevent external modification
  }

  static List<Map<String, dynamic>> getEvents() {
    return activities.where((activity) => activity['type'] == 'event').toList();
  }

  static List<Map<String, dynamic>> getPlaces() {
    return activities.where((activity) => activity['type'] == 'place').toList();
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(onNavigateToTab: _navigateToTab),
      const SearchScreen(),
      const ActivitiesScreen(),
      MyReviewsScreen(),
      const NotificationsScreen(),
      const ProfileScreen(),
    ];
  }

  void _navigateToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return Scaffold(
          backgroundColor: themeManager.backgroundColor,
          body: IndexedStack(index: _currentIndex, children: _screens),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: themeManager.primaryColor,
            unselectedItemColor: themeManager.textSecondaryColor,
            backgroundColor: themeManager.cardColor,
            elevation: 8,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'หน้าหลัก',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search_outlined),
                activeIcon: Icon(Icons.search),
                label: 'ค้นหา',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_activity_outlined),
                activeIcon: Icon(Icons.local_activity),
                label: 'กิจกรรม',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.rate_review_outlined),
                activeIcon: Icon(Icons.rate_review),
                label: 'รีวิว',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications_outlined),
                activeIcon: Icon(Icons.notifications),
                label: 'แจ้งเตือน',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'โปรไฟล์',
              ),
            ],
          ),
        );
      },
    );
  }
}
