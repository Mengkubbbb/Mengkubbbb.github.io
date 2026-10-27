# เดือนที่ 08 — Player Data, Database, Items และ Character Progression

**ช่วงวัน:** Day 211–240 · **บทเรียนละเอียด:** ⏳

## เป้าหมายของเดือน
ข้อมูลผู้เล่นไม่หายแม้เซิร์ฟเวอร์ปิดผิดปกติ มีระบบไอเทม/ระดับ/ค่าสถานะที่เก็บในฐานข้อมูล
และรู้วิธีป้องกัน SQL injection ตั้งแต่ต้น

## สิ่งที่ต้องมีก่อนเริ่ม
- เซิร์ฟเวอร์ทดสอบ + ปลั๊กอิน v2 (Month 7)
- เข้าใจ OOP และ exception (Month 4)

## หัวข้อหลักในเดือนนี้
1. ออกแบบ Data Model: ผู้เล่น 1 คนมีอะไรบ้าง
2. SQL พื้นฐาน (SELECT/INSERT/UPDATE/DELETE) + ชนิดข้อมูล + index
3. SQLite/H2 สำหรับพัฒนา → MySQL/MariaDB สำหรับจริง
4. JDBC, PreparedStatement, การกัน SQL injection
5. Connection pool (HikariCP) และการวัดผล
6. Migration/เวอร์ชัน schema
7. โหลดตอนเข้าเกม, บันทึกตอนออกเกม, auto-save, save ตอนปิดเซิร์ฟเวอร์
8. Transaction/rollback และการทดสอบข้อมูลไม่หาย
9. Item Registry จาก config, rarity, lore, attribute
10. Equipment slot และการตรวจสิทธิ์/คลาส
11. Affix (ค่าสุ่ม), Item Set, ระบบอัปเกรด
12. Loot table + การบันทึกไอเทมลง DB (serialize) + ป้องกันไอเทมปลอม
13. Level/EXP และค่าสถานะ (STR/DEX/INT)

## โปรเจกต์ประจำเดือน
Character System v1: เลเวล, EXP, ค่าสถานะ, ไอเทมในกระเป๋า/สวมใส่ ที่บันทึกลงฐานข้อมูลทั้งหมด

## เกณฑ์ผ่านก่อนขึ้น Month 9
- [ ] ปิดเซิร์ฟเวอร์แบบไม่ปกติ (kill) แล้วข้อมูลผู้เล่นยังอยู่
- [ ] อธิบายได้ว่าทำไม `PreparedStatement` ปลอดภัยกว่า concatenate string
- [ ] อธิบายได้ว่าไอเทม 1 ชิ้นถูกเก็บใน DB อย่างไร (ตาราง/คอลัมน์อะไร)
- [ ] ไม่มี query ที่ทำงานใน main thread แบบไม่จำเป็น

## คำเตือนของเดือนนี้
> ⚠️ ระบบนี้คือ "หัวใจ" ของ MMO — ถ้าข้อมูลผู้เล่นหาย ผู้เล่นจะไม่กลับมา
> ต้องมี backup และทดสอบกู้คืนก่อนไป Month 9 เสมอ
