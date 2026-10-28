# PROJECT-STATUS.md — สถานะโปรเจกต์ (EclipseCore → MMO RPG)

> 📊 เอกสารนี้บอกว่า **ระบบไหนเสร็จแล้ว ระบบไหนกำลังทำ และอะไรยังไม่เริ่ม**
> อัปเดตล่าสุด: **28 ตุลาคม 2026** — หลักสูตร Month 1 Day 01–14 พร้อม + ปลั๊กอินตัวอย่างผ่านการรันบนเซิร์ฟเวอร์ Paper จริงแล้ว

---

## 1. ภาพรวมโปรเจกต์

| รายการ | ค่า |
| --- | --- |
| ชื่อโปรเจกต์เกม | **Eclipse MMO RPG** (ชื่อชั่วคราว) |
| แพลตฟอร์ม | Paper 26.3 (Java 25) — เป้าหมายไคลเอนต์ Vanilla เป็นหลัก |
| ระบบหลัก (plugin) | **EclipseCore** — ปลั๊กอินหลักที่รวมระบบทั้งหมดของเรา |
| สภาพแวดล้อม | Dev (เครื่องตัวเอง) → Staging (ทดสอบกับเพื่อน) → Production (เปิดจริง) · ปัจจุบัน: ยังไม่มี |
| แนวเกมอ้างอิง | Minecraft Dungeons / Action RPG / MMORPG |
| สถานะรวม | 🔴 ยังไม่เริ่ม (0%) |

---

## 2. Stage ของ EclipseCore

| Stage | ระบบ | เป้าหมายเดือน | สถานะ | หลักฐานการทดสอบ | หมายเหตุ |
| --- | --- | --- | --- | --- | --- |
| 1 | **EclipseCore** (lifecycle, config, command, permission, player profile, DB, logging, error handling) | 5–6, 8 | `NOT_STARTED` | — | ต้องมีก่อนทุกอย่าง |
| 2 | **Character System** (level, EXP, stats, classes, persistence) | 8 | `NOT_STARTED` | — | ต่อจาก Stage 1 |
| 3 | **Items** (registry, equipment, rarity, affix, set, upgrade, loot) | 8 | `NOT_STARTED` | — | ต้องมี DB ก่อน |
| 4 | **Combat** (damage, targeting, cooldown, status effect, skill registry, combo, boss) | 9 | `NOT_STARTED` | — | ต้องมี unit test |
| 5 | **Magic** (spell registry, elements, reactions, mana) | 9 | `NOT_STARTED` | — | ต่อจาก Combat |
| 6 | **World** (quest, NPC, jobs, crafting, gathering, dungeon, party, guild) | 10 | `NOT_STARTED` | — | งานเยอะสุด แบ่งเป็นรอบย่อย |
| 7 | **UI & Animation** (MCGUI/RP Engine, resource pack, Blockbench, HUD, animation, emote) | 7, 9 | `NOT_STARTED` | — | ข้อจำกัดไคลเอนต์ต้องทดสอบจริงก่อน |
| 8 | **MMO Operations** (economy, auction, trading, security, performance, monitoring, backup, support) | 11 | `NOT_STARTED` | — | ก่อนเปิดบริการเท่านั้น |

**สถานะที่ใช้:** `NOT_STARTED` · `DESIGNING` (ออกแบบ) · `DEVELOPING` · `TESTING` · `DONE` · `BLOCKED`

---

## 3. ระบบเป้าหมาย 20 ข้อ (จากใบสั่งงาน) และสถานะปัจจุบัน

| # | ระบบ | Stage ที่เกี่ยวข้อง | สถานะ | เดือนที่เรียน |
| --- | --- | --- | --- | --- |
| 1 | Isometric / RTS-style Camera | 7 | `NOT_STARTED` (ต้องทดลองก่อน) | 7, 9 |
| 2 | Custom Items & Equipment | 3 | `NOT_STARTED` | 8 |
| 3 | Combat & Skill System | 4 | `NOT_STARTED` | 9 |
| 4 | Magic & Elemental Reactions | 5 | `NOT_STARTED` | 9 |
| 5 | Character Animations & Emotes | 7 | `NOT_STARTED` | 9 |
| 6 | Jobs & Professions | 6 | `NOT_STARTED` | 10 |
| 7 | Classes & Progression | 2 | `NOT_STARTED` | 8–9 |
| 8 | Quest & NPC Dialogue | 6 | `NOT_STARTED` | 10 |
| 9 | Dungeon & Boss Mechanics | 6 | `NOT_STARTED` | 10 |
| 10 | Party & Guild | 6 | `NOT_STARTED` | 10 |
| 11 | Economy & Auction House | 8 | `NOT_STARTED` | 11 |
| 12 | Crafting & Item Upgrades | 3, 6 | `NOT_STARTED` | 8, 10 |
| 13 | Resource Pack & Custom Models | 7 | `NOT_STARTED` | 7 |
| 14 | UI & HUD | 7 | `NOT_STARTED` | 9 |
| 15 | Player Data Persistence | 1 | `NOT_STARTED` | 8 |
| 16 | Security & Anti-Exploit | 8 | `NOT_STARTED` | 11 |
| 17 | Performance Optimization | 8 | `NOT_STARTED` | 11 |
| 18 | Administration & Monitoring | 8 | `NOT_STARTED` | 11 |
| 19 | Website & Support System | 8 | `NOT_STARTED` | 11 |
| 20 | Business Model & Commercial Launch | 8 | `NOT_STARTED` | 12 |

> 📌 ระบบทั้งหมดนี้เป็น **เป้าหมายระยะยาว** ไม่จำเป็นต้องได้ครบใน 365 วัน และจะปรับขอบเขตตามความคืบหน้าจริง

---

## 4. งานที่กำลังทำอยู่ (อัปเดตทุกครั้งหลังจบบทเรียน)

| รายการ | รายละเอียด |
| --- | --- |
| งานปัจจุบัน | รอผู้เรียนตอบแบบประเมินความพร้อม → เริ่ม Day 01 |
| ไฟล์ที่แก้ล่าสุด | บทเรียนละเอียด Day 08–14 · ผลทดสอบปลั๊กอินบน Paper 26.3 จริง · ราคาโฮสติ้งจริง 28 ต.ค. 2026 |
| บล็อก/อุปสรรค | ยังไม่มี (ทดสอบด้วยไคลเอนต์เกมต้องรอผู้เรียน) |
| งานถัดไป 3 อย่าง | 1) Day 01 สร้างโฟลเดอร์ทำงาน 2) Day 02 script แรก 3) Day 03 PATH/alias |

---

## 5. สิ่งที่ยังไม่ยืนยัน (ต้องทดลองจริงก่อนสรุป)

| เรื่อง | สถานะความรู้ | แผนทดสอบ |
| --- | --- | --- |
| กล้อง Isometric บนไคลเอนต์ Vanilla | ❓ ยังไม่ยืนยัน — Paper/Resource Pack ไม่ได้เปลี่ยนระบบกล้องโดยตรง | ทดลอง Month 7 (Day 207) และ Month 9 (Day 269) + บันทึกใน `docs/camera-limits.md` |
| แอนิเมชันตัวละคร | ❓ ยังไม่ยืนยันว่าทำได้แค่ไหนบน Vanilla | ทดลอง Month 9 (Day 263–268) |
| MCGUI / RP Engine รองรับ Paper 26.3 หรือไม่ | ❓ ต้องตรวจจากเอกสารผู้พัฒนา ณ เวลานั้น | ตรวจก่อนใช้จริงใน Month 7 (Day 206–207) |
| รายได้–ต้นทุนจริง | ❓ ต้องใช้ตัวเลขจริงของผู้เรียน | Month 12 (Day 349–355) |

> ⚠️ ห้ามเขียนว่า "รองรับ" ในเอกสารนี้ถ้ายังไม่ได้ทดสอบกับเวอร์ชันที่ใช้อยู่จริง

---

## 6. ผลการตรวจสอบจริงของหลักสูตร (27 ตุลาคม 2026)

ตรวจโดยครูในเครื่อง Linux: Ubuntu 24.04, bash 5.2, **JDK 25.0.5 (Temurin)**, **Gradle 9.8.2**, 2 CPU / 3.8 GB RAM

| สิ่งที่ตรวจ | คำสั่ง | ผลจริง | สถานะ |
| --- | --- | --- | --- |
| สคริปต์ทั้ง 7 ไฟล์ไม่มี syntax error | `bash -n <ทุกไฟล์>` | ผ่านทุกไฟล์ | ✅ |
| 01-linux-lab ทำงานตามออกแบบ | `first-script.sh` / `server-check.sh` / `backup.sh` / `server-start.sh --test` | ผลถูกต้อง + exit code ตรงตามที่ออกแบบ | ✅ |
| 02-programming-lab ทำงานตามออกแบบ | `loot-table.sh 1000 --summary`, `damage-sim.sh --rounds 10`, `exp-curve.sh 1 5` | สัดส่วนการสุ่มใกล้ค่าออกแบบ; ผลซ้ำได้เมื่อใช้ seed | ✅ |
| 03-java-lab คอมไพล์และรันได้ | `javac -d out $(find src -name '*.java')` + `java -cp out ... Main` | คอมไพล์ผ่าน; เมนู 1–5 ทำงานครบ | ✅ |
| 04-first-plugin build ได้จริง | `gradle build` | `BUILD SUCCESSFUL` → `build/libs/EclipseCore-1.0.0.jar` (มี plugin.yml + config.yml + 4 คลาส) | ✅ |
| Gradle Wrapper ทำงาน | `./gradlew --version` | Gradle 9.8.2 บน JVM 25.0.5 | ✅ |
| หน้าเว็บโหลดไฟล์ Markdown ได้ | `curl` ผ่าน Host header พรีวิว 10 path (หน้าแรก, CSS, JS, README, ROADMAP, แผน 365 วัน, บทเรียน Day 01) | ทุก path ได้ **200** และ path ที่ไม่มีจริงได้ **404** | ✅ |
| ตัวแปลง Markdown ทำงานถูกต้องกับข้อมูลจริง | รัน `renderMarkdown()` กับ 4 ไฟล์ (365-DAY-PLAN, day-01, KNOWLEDGE-MAP, GLOSSARY) | ได้ heading/ตาราง/code/mermaid ครบ ไม่มี placeholder ค้าง | ✅ |
| ปลั๊กอินโหลดบนเซิร์ฟเวอร์ Paper จริง | รัน `paper-26.3-226.jar` (STABLE) + `EclipseCore-1.0.0.jar` แล้วส่งคำสั่งผ่านคอนโซล | บูต 16.1 วิ · `Enabling EclipseCore v1.0.0` · `/eclipse hello Somchai` และ `/eclipse stats` ตอบถูก · ปิดสะอาด | ✅ ผ่าน (10/12 ข้อของ checklist) |
| การเข้าเล่นด้วยไคลเอนต์ Minecraft | ต้องมีไคลเอนต์ 26.3 | ยังไม่ได้ทดสอบ — เครื่องทดสอบไม่มีไคลเอนต์ | ⏳ ผู้เรียนทำใน Month 5 ([tests/runs/2026-10-28-plugin-load.md](tests/runs/2026-10-28-plugin-load.md) ข้อ 6) |
| ดาวน์โหลด Paper ผ่าน API ปัจจุบัน | `curl fill.papermc.io/v3/.../builds/226` | v2 ตอบ `410 Gone`; fill v3 คืน URL จริง (55,255,255 ไบต์) | ✅ ผ่าน |

> 📌 หลักการที่ใช้: **เขียนเฉพาะสิ่งที่ทดสอบได้ และระบุสิ่งที่ยังไม่ได้ทดสอบให้ชัดเจน**
