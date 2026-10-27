# 06-eclipse-core — สถาปัตยกรรมปลั๊กอินหลัก (แผนงาน)

> 🎯 **เป้าหมาย:** ปลั๊กอินเดียวที่รวมระบบ MMO ทั้งหมด ทำงานแบบ "โมดูล" ที่เพิ่ม/ถอดได้
> 📅 ใช้ใน: Month 06–11 (ต่อจาก [04-first-plugin](../04-first-plugin/README.md))
> ⏳ **สถานะ: ยังไม่เริ่ม** — ไฟล์นี้คือแผนและกติกาสถาปัตยกรรม (บทเรียนจะเขียนเมื่อถึงเดือนนั้น)

---

## 1. ทำไมต้องมีสถาปัตยกรรมตั้งแต่ต้น

ถ้าเขียนทุกอย่างในคลาสเดียว (`EclipseCorePlugin.java` ยาว 5,000 บรรทัด):
- เพิ่มระบบใหม่ = เสี่ยงทำให้ของเดิมพัง
- หาบั๊กยาก (ไม่รู้ว่าส่วนไหนผิด)
- ทดสอบไม่ได้ (ทุกอย่างผูกกับเซิร์ฟเวอร์)
- ทำงานร่วมกับคนอื่นไม่ได้

**กติกา:** ทุกระบบต้องเป็น "โมดูล" ที่มี 3 ส่วนแยกกันชัดเจน

```text
ระบบหนึ่ง ๆ =
  [ Model ]      โครงสร้างข้อมูล (data)
  [ Service ]    ตรรกะว่าทำงานอย่างไร ← ที่เดียวที่แก้กติกาเกม
  [ Interface ]  ส่วนที่ผู้เล่นเห็น (คำสั่ง/เมนู/ข้อความ)
```

ตัวอย่างระบบสกิล:
```text
Model     : Skill, SkillType, SkillLevel
Service   : SkillService (ตรวจคูลดาวน์, หักมานา, คำนวณดาเมจ)
Interface : SkillCommand, SkillMenu (GUI), SkillListener
```

**ประโยชน์ที่จะเห็นชัดใน Month 9–11:** แก้สมดุลดาเมจ = แก้ที่ `DamageService` ที่เดียว
ไม่ต้องแก้ในคำสั่ง ไม่ต้องแก้ใน GUI

---

## 2. แผนผังแพ็กเกจ (เป้าหมายปลายทาง)

```text
com.mengkub.eclipse
├── EclipseCorePlugin.java      ← คลาสหลัก (สั้น! ทำแค่ประกอบทุกอย่างเข้าด้วยกัน)
├── config/                     ← อ่าน/ตรวจค่าตั้งค่า
├── data/                       ← ชั้นฐานข้อมูล (database, repository, migration)
├── model/                      ← โครงสร้างข้อมูล (PlayerProfile, ItemData, Skill)
├── service/                    ← ตรรกะของเกม
│   ├── CombatService
│   ├── SkillService
│   ├── ItemService
│   ├── EconomyService
│   └── QuestService
├── command/                    ← คำสั่งทั้งหมด (ผอมบาง เรียก service เท่านั้น)
├── listener/                   ← event ทั้งหมด
├── ui/                         ← GUI/เมนู/HUD
├── util/                       ← เครื่องมือช่วย (ข้อความ, เวลา, คณิตศาสตร์)
└── integration/                ← เชื่อมกับปลั๊กอินอื่น (LuckPerms, MythicMobs)
```

**กฎ 5 ข้อที่ห้ามละเมิด:**

| # | กฎ | เพราะอะไร |
| --- | --- | --- |
| 1 | `command/` และ `ui/` ห้ามมีตรรกะเกม | ทำให้แก้กติกาเกมได้ที่เดียว |
| 2 | `service/` ห้ามส่งข้อความหาผู้เล่นโดยตรง | ควรคืนค่ากลับให้ชั้นบนแสดงผล (ทดสอบง่ายกว่า) |
| 3 | `model/` ควรไม่มี dependency ของ Paper ถ้าทำได้ | ทำให้เขียน unit test ได้โดยไม่ต้องมีเซิร์ฟเวอร์ |
| 4 | ทุก query ฐานข้อมูลต้องอยู่ใน `data/` | เปลี่ยนฐานข้อมูลทีเดียว ไม่ต้องแก้ทั้งโปรเจกต์ |
| 5 | ระบบใหม่ต้องมีไฟล์ของตัวเอง ไม่แก้ไฟล์ระบบอื่น | ลดการพังข้ามระบบ |

---

## 3. ลำดับการสร้าง (Stage) — ตรงกับ [PROJECT-STATUS.md](../../PROJECT-STATUS.md)

| Stage | ระบบ | เดือน | ต้องมีก่อน |
| --- | --- | --- | --- |
| 1 | Core: config, command, permission, profile, DB, logging | 5–6, 8 | ปลั๊กอิน v1 |
| 2 | Character: level, EXP, stats, class, persistence | 8 | Stage 1 |
| 3 | Items: registry, rarity, affix, set, upgrade, loot | 8 | Stage 1–2 |
| 4 | Combat: damage, cooldown, status effect, skill | 9 | Stage 2–3 |
| 5 | Magic: spell, element, reaction, mana | 9 | Stage 4 |
| 6 | World: quest, NPC, jobs, crafting, dungeon, party, guild | 10 | Stage 2–5 |
| 7 | UI & Animation: HUD, menu, models, emote | 7, 9 | Stage 4 |
| 8 | Operations: economy, auction, security, monitoring | 11 | Stage 3–6 |

> ⚠️ **ห้ามข้าม Stage** — ถ้า Stage 4 ยังไม่นิ่ง การสร้าง Stage 6 จะทำให้หาบั๊กไม่เจอ

---

## 4. กติกาการทดสอบของโปรเจกต์นี้

| ระบบ | ต้องมีเทสต์แบบไหน |
| --- | --- |
| สูตรคำนวณ (ดาเมจ/EXP/ราคา) | Unit test (JUnit) — ต้องไม่ต้องใช้เซิร์ฟเวอร์ |
| ข้อมูลผู้เล่น (save/load) | Integration test + [persistence checklist](../../tests/checklists/data-persistence.md) |
| คำสั่ง/สิทธิ์ | Manual test + ทดสอบผู้เล่นที่ไม่มีสิทธิ์ |
| รางวัล/เศรษฐกิจ | Duplication test (กดรัว, ออกกลางคัน, รีสตาร์ทกลางรายการ) |
| ประสิทธิภาพ | วัด TPS/MSPT ก่อน–หลัง |

---

## 5. เริ่มสร้างเมื่อไร

จะเริ่มจริงเมื่อทำครบ:
1. Month 5 จบ (ปลั๊กอิน v1 รันบนเซิร์ฟเวอร์ได้)
2. Month 6 จบ (event/command/config/GUI เป็น)
3. Month 8 มีแผนข้อมูลผู้เล่น (data model) ผ่านการทบทวนแล้ว

**งานแรกของโปรเจกต์นี้ (Month 8):** สร้าง `data/Database` + `model/PlayerProfile`
พร้อม `data/PlayerRepository` ที่โหลด/บันทึกข้อมูลผู้เล่นได้ และมี migration เวอร์ชันแรก
