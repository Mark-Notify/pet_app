
---

Caring Daily Hub → ศูนย์กลางการดูแลสัตว์ทุกวัน
Cute Digital Habitat → บ้านดิจิทัลน่ารัก ๆ ของสัตว์
Community for Daily Happiness → คอมมูนิตี้สร้างความสุขทุกวัน
Care, Donate, Hug → สื่อถึงการดูแล, ส่งอาหารเป็นของขวัญ, และความรัก

## 📌 รายละเอียดแต่ละโฟลเดอร์

### **main.dart**
- จุดเริ่มต้นของแอป (`entry point`)  
- เรียกใช้งาน `App` ที่อยู่ใน `app.dart`

### **app.dart**
- กำหนด MaterialApp / Router  
- กำหนด `theme`, `routes`, และ `provider` หลักของแอป

---

### **core/**
- 🔹 `env.dart` : จัดการ Environment variables เช่น API base URL  
- 🔹 `theme.dart` : กำหนดธีมหลักของแอป เช่น สี ฟอนต์ และสไตล์

---

### **data/**
- 🔹 `api_client.dart` : จัดการเรียก API และ network request  
- **models/** : เก็บ data model ของแอป
  - `animal.dart` : ข้อมูลสัตว์  
  - `stream_session.dart` : ข้อมูล session การ live stream  
  - `wallet.dart` : ข้อมูลกระเป๋าเงิน
- **repos/** : Repository สำหรับเชื่อมต่อ Data Layer กับ UI Layer
  - `wallet_repo.dart` : จัดการข้อมูลกระเป๋าเงิน  
  - `feed_repo.dart` : จัดการข้อมูล feed / ฟีด  
  - `stream_repo.dart` : จัดการข้อมูลการ live stream

---

### **features/**
- แยกตามฟีเจอร์หลักของแอป
- 🔹 `home/home_screen.dart` : หน้า Home  
- 🔹 `live/live_screen.dart` : หน้า Live Streaming  
- 🔹 `live/widgets/feed_button.dart` : ปุ่ม feed สำหรับ Live  
- 🔹 `wallet/wallet_screen.dart` : หน้า Wallet  
- 🔹 `profile/profile_screen.dart` : หน้าโปรไฟล์สัตว์

---

### **state/**
- จัดการ state ของแอป (ใช้ Provider / Riverpod / StateNotifier ฯลฯ)  
- 🔹 `providers.dart` : รวม provider หลัก ๆ  
- 🔹 `wallet_notifier.dart` : จัดการ state ของ Wallet  
- 🔹 `live_notifier.dart` : จัดการ state ของ Live Streaming  

---

## 🚀 การใช้งาน

1. รันโปรเจกต์ด้วยคำสั่ง
   ```bash
   flutter run
