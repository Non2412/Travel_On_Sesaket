import 'package:flutter/material.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'กิจกรรม',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue[600],
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue[600],
          tabs: const [
            Tab(text: 'ล่าสุด'),
            Tab(text: 'อีเว้นต์'),
            Tab(text: 'สถานที่'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRecentActivities(),
          _buildEventActivities(),
          _buildPlaceActivities(),
        ],
      ),
    );
  }

  Widget _buildRecentActivities() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) {
        return _buildActivityCard(
          icon: Icons.event,
          title: 'เข้าร่วมอีเว้นต์ "งานเทศกาลดนตรี"',
          subtitle: 'คุณได้เข้าร่วมอีเว้นต์ที่สวนลุมพินี',
          time: '${index + 1} ชั่วโมงที่แล้ว',
          color: Colors.blue,
        );
      },
    );
  }

  Widget _buildEventActivities() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 8,
      itemBuilder: (context, index) {
        final eventTypes = [
          {
            'icon': Icons.music_note,
            'title': 'เข้าร่วมคอนเสิร์ต',
            'subtitle': 'งานดนตรีกลางแจ้ง',
            'color': Colors.purple
          },
          {
            'icon': Icons.restaurant,
            'title': 'เข้าร่วมงานอาหาร',
            'subtitle': 'เทศกาลอาหารท้องถิ่น',
            'color': Colors.orange
          },
          {
            'icon': Icons.sports,
            'title': 'เข้าร่วมกิจกรรมกีฬา',
            'subtitle': 'การแข่งขันมาราธอน',
            'color': Colors.green
          },
        ];
        
        final event = eventTypes[index % eventTypes.length];
        
        return _buildActivityCard(
          icon: event['icon'] as IconData,
          title: event['title'] as String,
          subtitle: event['subtitle'] as String,
          time: '${(index + 1) * 2} ชั่วโมงที่แล้ว',
          color: event['color'] as Color,
        );
      },
    );
  }

  Widget _buildPlaceActivities() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (context, index) {
        final placeTypes = [
          {
            'icon': Icons.location_city,
            'title': 'เช็คอินที่ห้างสรรพสินค้า',
            'subtitle': 'สยามพารากอน',
            'color': Colors.red
          },
          {
            'icon': Icons.park,
            'title': 'เช็คอินที่สวนสาธารณะ',
            'subtitle': 'สวนจตุจักร',
            'color': Colors.green
          },
          {
            'icon': Icons.local_cafe,
            'title': 'เช็คอินที่คาเฟ่',
            'subtitle': 'คาเฟ่อมฤต',
            'color': Colors.brown
          },
        ];
        
        final place = placeTypes[index % placeTypes.length];
        
        return _buildActivityCard(
          icon: place['icon'] as IconData,
          title: place['title'] as String,
          subtitle: place['subtitle'] as String,
          time: '${(index + 1) * 3} ชั่วโมงที่แล้ว',
          color: place['color'] as Color,
        );
      },
    );
  }

  Widget _buildActivityCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          icon: const Icon(Icons.more_vert, color: Colors.grey),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'share',
              child: Row(
                children: [
                  Icon(Icons.share, size: 20),
                  SizedBox(width: 8),
                  Text('แชร์'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text('ลบ', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'share') {
              // Handle share
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('แชร์กิจกรรม')),
              );
            } else if (value == 'delete') {
              // Handle delete
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ลบกิจกรรมแล้ว')),
              );
            }
          },
        ),
      ),
    );
  }
}