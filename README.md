# แอปพลิเคชันท่องเที่ยวศรีสะเกษ (Si Sa Ket Travel App)

แอปพลิเคชัน Flutter สำหรับส่งเสริมการท่องเที่ยวในจังหวัดศรีสะเกษ พร้อมระบบแต้มสะสม กิจกรรม และฟีเจอร์โซเชียล

## ฟีเจอร์หลัก

### 🏠 หน้าหลัก (Home)
- แสดงหมวดหมู่สถานที่ท่องเที่ยว
- แสดงกิจกรรมล่าสุด
- แสดงสถานที่แนะนำแบบสุ่ม
- ระบบค้นหาแบบ Quick Access
- Drawer Menu พร้อมแสดงแต้มสะสม

### 🔍 ค้นหา (Search)
- ค้นหาสถานที่ท่องเที่ยวจากชื่อ หมวดหมู่ และรายละเอียด
- ระบบบันทึกประวัติการค้นหา (เก็บสูงสุด 10 รายการ)
- กรองตามหมวดหมู่ด้วย Filter Chips
- แสดงผลลัพธ์แบบเรียลไทม์

### 📍 สถานที่ท่องเที่ยว (Places)
- โหลดข้อมูลจาก JSON (response_1759296972786.json)
- แสดงรายละเอียดสถานที่พร้อมรูปภาพ
- ระบบรีวิว (ให้คะแนนดาว + ความคิดเห็น)
- เพิ่มเข้ารายการโปรด (Favorites)
- ระบบ SHA Badge
- Google Maps Integration (แสดงตำแหน่ง + นำทาง)

### 🎯 กิจกรรม (Activities)
- เพิ่มกิจกรรม/สถานที่ใหม่
- แยก Tab: ล่าสุด และ สถานที่
- อัพโหลดรูปภาพหลายรูป (Camera/Gallery)
- เลือกหมวดหมู่ 10 ประเภท
- กำหนดวันที่และเวลา (สำหรับอีเวนต์)

### ⭐ ระบบแต้มสะสม (Points)
- เก็บข้อมูลด้วย SharedPreferences
- รับแต้มจากกิจกรรมต่างๆ:
  - เข้าสู่ระบบรายวัน (+10)
  - เช็คอิน (+15)
  - เขียนรีวิว (+20)
  - เพิ่มสถานที่ (+25)
  - แชร์ (+5)
  - เข้าร่วมกิจกรรม (+30)
- แลกของรางวัล (ส่วนลดร้านอาหาร, ที่พัก, ของที่ระลึก)
- ประวัติการใช้แต้มแบบละเอียด

### 🔔 การแจ้งเตือน (Notifications)
- 5 ประเภท: อีเวนต์, เพื่อน, สถานที่, โปรโมชั่น, ระบบ
- ทำเครื่องหมายอ่าน/ยังไม่อ่าน
- ลบด้วย Swipe
- ล้างทั้งหมด/ทำเครื่องหมายอ่านทั้งหมด
- Pull to refresh

### 👤 โปรไฟล์ (Profile)
- แสดงข้อมูลผู้ใช้
- สถิติการใช้งาน
- จัดการบัญชี
- รีวิวของฉัน
- เช็คอินฟรีแต้ม (รายวัน)

### 🎨 ธีม (Theme)
- โหมดสว่าง/มด
- สลับสีหลัก (Orange/Blue)
- ThemeManager พร้อม Gradient

### 💬 กระทู้ (Forum)
- สร้างกระทู้ใหม่
- ตอบกลับ (Reply)
- ให้ Like กระทู้และคอมเมนต์
- แสดงจำนวน Likes และ Replies

## โครงสร้างโปรเจค

```
lib/
├── main.dart                          # Entry point + Splash Screen
├── screens/
│   ├── home_screen.dart              # หน้าหลัก
│   ├── search_screen.dart            # ค้นหา
│   ├── activities_screen.dart        # กิจกรรม
│   ├── add_activity_screen.dart      # เพิ่มกิจกรรม
│   ├── notifications_screen.dart     # การแจ้งเตือน
│   ├── profile_screen.dart           # โปรไฟล์
│   ├── places_screen.dart            # รายการสถานที่
│   ├── place_detail_screen.dart      # รายละเอียดสถานที่
│   ├── favorites_screen.dart         # รายการโปรด
│   ├── points_screen.dart            # แต้มสะสม
│   ├── checkin_screen.dart           # เช็คอิน
│   ├── my_reviews_screen.dart        # รีวิวของฉัน
│   ├── thread_list_screen.dart       # รายการกระทู้
│   ├── thread_detail_screen.dart     # รายละเอียดกระทู้
│   ├── create_thread_screen.dart     # สร้างกระทู้
│   ├── settings_screen.dart          # ตั้งค่า
│   ├── help_screen.dart              # ช่วยเหลือ
│   └── login_screen.dart             # เข้าสู่ระบบ
├── services/
│   └── notification_service.dart     # จัดการการแจ้งเตือน
├── points_manager.dart               # จัดการแต้มสะสม
├── theme_manager.dart                # จัดการธีม
└── favorites_manager.dart            # จัดการรายการโปรด

assets/
├── data/
│   └── response_1759296972786.json   # ข้อมูลสถานที่
└── images/
    └── sisaket_night.jpg             # Splash screen background
```

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.2.2        # เก็บข้อมูลแต้ม, รายการโปรด, ประวัติค้นหา
  google_maps_flutter: ^2.5.0       # แผนที่
  url_launcher: ^6.2.2               # เปิด Maps, โทร
  image_picker: ^1.0.5               # อัพโหลดรูป
```

## การติดตั้ง

1. Clone repository
```bash
git clone <repository-url>
cd sisaket_travel_app
```

2. ติดตั้ง dependencies
```bash
flutter pub get
```

3. เตรียม Google Maps API Key
   - สร้าง API Key ที่ [Google Cloud Console](https://console.cloud.google.com/)
   - เพิ่ม API Key ใน:
     - Android: `android/app/src/main/AndroidManifest.xml`
     - iOS: `ios/Runner/AppDelegate.swift`

4. รันแอป
```bash
flutter run
```

## ข้อมูลจำลอง

### JSON Structure (response_1759296972786.json)
```json
{
  "data": [
    {
      "placeId": "xxx",
      "name": "ชื่อสถานที่",
      "detail": "รายละเอียด",
      "introduction": "แนะนำ",
      "category": {
        "categoryId": "xxx",
        "name": "หมวดหมู่"
      },
      "location": {
        "lat": 0.0,
        "long": 0.0,
        "district": {
          "name": "ชื่ออำเภอ"
        }
      },
      "thumbnailUrl": ["url"],
      "viewer": 0,
      "sha": "SHA",
      "updatedAt": "2024-01-01T00:00:00.000Z"
    }
  ]
}
```

## ฟีเจอร์เด่น

### 1. ระบบจัดการสถานะ
- ใช้ ChangeNotifier pattern
- Listener system สำหรับ real-time updates
- SharedPreferences สำหรับ persistence

### 2. UI/UX
- Material Design 3
- Dark/Light mode
- Responsive layout
- Smooth animations
- Pull-to-refresh

### 3. ระบบ Points & Rewards
- สะสมแต้มจากกิจกรรมหลากหลาย
- แลกของรางวัล
- ประวัติการทำธุรกรรม

### 4. Social Features
- รีวิวและให้คะแนน
- กระทู้และคอมเมนต์
- ระบบ Like
- แชร์สถานที่

## การพัฒนาต่อ

### TODO
- [ ] เชื่อมต่อ Backend API จริง
- [ ] Authentication ด้วย Firebase/OAuth
- [ ] Push Notifications
- [ ] Offline mode
- [ ] การแชร์บน Social Media
- [ ] ระบบแชท
- [ ] AR Navigation
- [ ] Multi-language support

## License

MIT License

## ผู้พัฒนา

ทีมพัฒนาแอปพลิเคชันท่องเที่ยวศรีสะเกษ

---

**หมายเหตุ:** แอปนี้เป็น prototype และใช้ข้อมูลจำลอง (mock data) บางส่วนยังไม่ได้เชื่อมต่อกับ backend จริง
