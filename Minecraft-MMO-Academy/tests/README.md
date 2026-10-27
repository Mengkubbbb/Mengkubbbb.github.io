# tests/ — ชุดทดสอบและ checklist

> 🧪 **กติกาสูงสุดของโฟลเดอร์นี้:** "โค้ดคอมไพล์ผ่าน" **ไม่เท่ากับ** "ระบบทำงานได้"
> ห้ามทำเครื่องหมาย `COMPLETED` ใน [TODO.md](../TODO.md) ถ้ายังไม่ได้ทำ checklist ที่ตรงกับงานนั้น

---

## 1. ประเภทการทดสอบที่หลักสูตรนี้สอน

| ประเภท | คืออะไร | ใช้เมื่อไร | เครื่องมือ |
| --- | --- | --- | --- |
| **Unit test** | ทดสอบโค้ดชิ้นเล็ก (สูตรคำนวณ) | ทุกครั้งที่แก้สูตร | JUnit 5 (`./gradlew test`) |
| **Integration test** | ทดสอบหลายส่วนทำงานร่วมกัน (ปลั๊กอิน + ฐานข้อมูล) | ก่อน merge เข้า `main` | รันเซิร์ฟเวอร์ทดสอบ + JUnit |
| **Manual test** | ทดสอบด้วยมือตาม checklist | ทุกฟีเจอร์ใหม่ | checklist ด้านล่าง |
| **Server startup test** | เช็กว่าเซิร์ฟเวอร์เริ่มได้สะอาด | ทุกครั้งที่เปลี่ยนปลั๊กอิน/ค่าเซิร์ฟเวอร์ | [checklists/server-startup.md](checklists/server-startup.md) |
| **Plugin load test** | เช็กว่าปลั๊กอินโหลดและคำสั่งทำงาน | ทุกครั้งที่อัปเดตปลั๊กอิน | [checklists/plugin-load.md](checklists/plugin-load.md) |
| **Persistence test** | ข้อมูลไม่หายหลังรีสตาร์ท | ทุกครั้งที่แตะระบบข้อมูล | [checklists/data-persistence.md](checklists/data-persistence.md) |
| **Backup/Restore test** | กู้คืนข้อมูลได้จริง | เดือนละ 1 ครั้ง + ก่อนเปิด Beta | [checklists/backup-restore.md](checklists/backup-restore.md) |
| **Cooldown/Skill test** | สกิลใช้ซ้ำไม่ได้ตามเวลาที่กำหนด | ทุกครั้งที่แตะระบบสกิล | checklist เฉพาะ Month 9 |
| **Loot duplication test** | ไม่มีของงอกจากกดรัว/ออกกลางคัน | ทุกครั้งที่แตะรางวัล | checklist เฉพาะ Month 10–11 |
| **Economy transaction test** | เงินไม่หาย/ไม่งอก | ทุกครั้งที่แตะเศรษฐกิจ | checklist เฉพาะ Month 11 |
| **Resource pack test** | pack แสดงผลถูกต้อง | ทุกครั้งที่แก้ pack | checklist เฉพาะ Month 7 |
| **Plugin compatibility test** | ปลั๊กอินหลายตัวไม่ตีกัน | ก่อนอัปเดตเวอร์ชัน | checklist เฉพาะ Month 7 |
| **Performance test** | TPS/MSPT อยู่ในเกณฑ์ | ก่อนเปิด Beta และหลังเปลี่ยนระบบหนัก | spark/timings |
| **Security test** | สิทธิ์และการโจมตีพื้นฐาน | Month 11 + ก่อนเปิด Beta | checklist เฉพาะ Month 11 |

---

## 2. checklist ที่มีให้ใช้ตอนนี้

- [server-startup.md](checklists/server-startup.md) — เซิร์ฟเวอร์เริ่มทำงานสะอาด
- [plugin-load.md](checklists/plugin-load.md) — ปลั๊กอินโหลดและคำสั่งทำงาน
- [data-persistence.md](checklists/data-persistence.md) — ข้อมูลไม่หาย
- [backup-restore.md](checklists/backup-restore.md) — สำรองและกู้คืนได้จริง

> checklist อื่น ๆ (combat, dungeon, economy, security) จะถูกเพิ่มเมื่อเรียนถึง Month 9–11

---

## 3. วิธีใช้ checklist (มาตรฐานเดียวกันทุกอัน)

1. คัดลอก checklist ไปไว้ที่ `docs/test-runs/YYYY-MM-DD-<เรื่อง>.md`
2. กรอกทีละข้อ: **ผ่าน / ไม่ผ่าน / ยังไม่ได้ทดสอบ** (ห้ามเว้นว่าง)
3. แนบหลักฐาน: คำสั่งที่ใช้ + ผลลัพธ์ (คัดลอกข้อความจริง)
4. ถ้ามีข้อไม่ผ่าน → เปิดงานใหม่ใน [TODO.md](../TODO.md) สถานะ `BLOCKED` หรือ `IN_PROGRESS`
5. สรุปผลลง [PROGRESS.md](../PROGRESS.md) ข้อ 4

---

## 4. เกณฑ์ผ่านสำหรับงานแต่ละประเภท

| งาน | ต้องผ่าน |
| --- | --- |
| ฟีเจอร์ใหม่เล็ก ๆ | unit test (ถ้ามีสูตร) + manual test กรณีปกติ |
| ระบบเกี่ยวกับข้อมูล | persistence test ครบ 1 รอบ (ปิด-เปิดเซิร์ฟเวอร์) |
| ระบบเกี่ยวกับรางวัล/เศรษฐกิจ | Loot/Economy duplication test + บันทึกผล |
| ก่อนให้เพื่อนเข้าทดสอบ | server-startup + plugin-load + backup-restore |
| ก่อนเปิด Beta | ทุก checklist ที่มี + security checklist + performance test |

---

## 5. ความเข้าใจผิดที่พบบ่อย (และคำตอบที่ถูก)

| ความเชื่อผิด | ความจริง |
| --- | --- |
| "คอมไพล์ผ่าน = เสร็จ" | คอมไพล์ผ่านแค่แปลภาษาได้ ต้องรันและทดสอบพฤติกรรม |
| "ฉันทดสอบในเครื่องตัวเองแล้ว" | ต้องทดสอบกับข้อมูลจริง (เช่น ข้อมูลผู้เล่นเก่าที่มีอยู่แล้ว) |
| "ไม่มี error ใน log = ทำงานถูก" | ต้องตรวจผลลัพธ์จริง (ค่าเงิน เวลา คูลดาวน์) |
| "แก้บั๊กแล้วมันหายไป" | ต้องพิสูจน์ว่าอาการเดิมไม่กลับมา (รันซ้ำ + ทดสอบกรณีใกล้เคียง) |
