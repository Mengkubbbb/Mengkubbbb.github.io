# projects/ — โปรเจกต์ที่รันได้จริงของหลักสูตร

> 📦 ทุกโฟลเดอร์ในนี้คือ **ผลงานที่ต้องรันได้จริง** ไม่ใช่ตัวอย่างให้อ่าน
> โปรเจกต์ที่ทำเครื่องหมาย ✅ คือ **ครูรันทดสอบจริงแล้ว** ในสภาพแวดล้อม Linux (Ubuntu 24.04, bash 5.2, JDK 25.0.5 Temurin, Gradle 9.8.2)
> ผลการทดสอบโดยละเอียดอยู่ในหัวข้อ **“ผลการตรวจสอบของครู”** ท้ายไฟล์นี้ และใน [PROJECT-STATUS.md](../PROJECT-STATUS.md)

---

## ลำดับโปรเจกต์ตามหลักสูตร

| # | โปรเจกต์ | เดือนที่ใช้ | ต้องมีอะไรก่อน | สถานะปัจจุบัน |
| --- | --- | --- | --- | --- |
| 01 | [01-linux-lab](01-linux-lab/README.md) | Month 1 | Terminal พื้นฐาน | ✅ ใช้งานได้ (ทดสอบแล้ว) |
| 02 | [02-programming-lab](02-programming-lab/README.md) | Month 2 | shell script พื้นฐาน | ✅ ใช้งานได้ (ทดสอบแล้ว) |
| 03 | [03-java-lab](03-java-lab/README.md) | Month 3–4 | JDK 25 | ✅ คอมไพล์และรันได้ (ทดสอบแล้ว) |
| 04 | [04-first-plugin](04-first-plugin/README.md) | Month 5 | Java + Gradle | ✅ build ผ่าน ได้ไฟล์ .jar (ทดสอบแล้ว) |
| 05 | [05-paper-server](05-paper-server/README.md) | Month 5–7 | ปลั๊กอิน v1 | ✅ เปิดเซิร์ฟเวอร์ Paper 26.3 จริง + ปลั๊กอินโหลดได้ (ทดสอบ 28 ต.ค. 2026) |
| 06 | [06-eclipse-core](06-eclipse-core/README.md) | Month 6–11 | ปลั๊กอิน v1 รันได้ | ⏳ ยังไม่เริ่ม (จะสร้างตาม Stage) |
| 07 | [07-mmo-rpg](07-mmo-rpg/README.md) | Month 8–12 | EclipseCore Stage 1–4 | ⏳ ยังไม่เริ่ม (เป้าหมายระยะยาว) |

**สถานะที่ใช้:** ✅ ทำงานได้และทดสอบแล้ว · 🔧 พร้อมแต่ยังไม่ทดสอบ · ⏳ ยังไม่เริ่ม

---

## กติกาของทุกโปรเจกต์

1. **ต้องรันได้** — ถ้ารันไม่ได้ ให้ถือว่ายังไม่เสร็จ
2. **ต้องมี README** ที่บอกวิธีรัน + วิธีทดสอบ + ผลลัพธ์ที่คาดหวัง
3. **ห้ามใส่ข้อมูลลับ** (รหัสผ่าน/คีย์) ลงในโค้ด — ใช้ไฟล์ `.env` หรือ config ที่ไม่เข้า Git
4. **ต้องมีหลักฐานการทดสอบ** — คำสั่ง + ผลลัพธ์จริง (ไม่ใช่คำอธิบายว่า "น่าจะทำงานได้")
5. **ทุกครั้งที่แก้ต้องทดสอบซ้ำ** — แล้วอัปเดต [PROGRESS.md](../PROGRESS.md)

---

## วิธีใช้โปรเจกต์เหล่านี้ให้ได้ประโยชน์สูงสุด

| อย่าทำแบบนี้ | ให้ทำแบบนี้ |
| --- | --- |
| คัดลอกทั้งไฟล์แล้วรันทันที | อ่านโค้ดทีละบรรทัด พิมพ์เอง แล้วรัน |
| รันได้แล้วปิดไปเลย | ลองแก้ค่าให้ผลลัพธ์เปลี่ยน (เช่นเปลี่ยนเกณฑ์) |
| ทำไม่พังแล้วไม่รู้ว่าเมื่อไรพัง | ตั้งใจลองทำพัง (ลบ argument, ใส่ค่าแปลก) แล้วสังเกต error |
| เจอ error แล้วถอยหนี | บันทึก error + วิธีแก้ลง [TROUBLESHOOTING.md](../TROUBLESHOOTING.md) |

> 💡 เป้าหมายคือให้คุณ **ดัดแปลง** โปรเจกต์เหล่านี้ได้ ไม่ใช่แค่ "ใช้เป็น"

---

## ผลการตรวจสอบของครู (27 ตุลาคม 2026)

สภาพแวดล้อมที่ใช้ทดสอบ: Linux (Ubuntu 24.04, bash 5.2), JDK 25.0.5 (Temurin), Gradle 9.8.2, 2 CPU / 3.8 GB RAM

| โปรเจกต์ | คำสั่งที่ทดสอบ | ผลที่ได้จริง | สถานะ |
| --- | --- | --- | --- |
| 01-linux-lab | `./first-script.sh Somchai` | พิมพ์ข้อความต้อนรับ + ชื่อ/เวลา → exit 0 | ✅ ผ่าน |
| 01-linux-lab | `./first-script.sh` (ไม่ใส่ argument) | พิมพ์วิธีใช้ → exit 1 | ✅ ผ่าน |
| 01-linux-lab | `./server-check.sh` | รายงาน 7 หมวด + สรุป + exit 0/1 ตามที่ออกแบบ | ✅ ผ่าน |
| 01-linux-lab | `./backup.sh` (dry-run) | แสดงแผน 4 ขั้น ไม่คัดลอกไฟล์จริง | ✅ ผ่าน |
| 01-linux-lab | `./backup.sh --apply --keep 2` | สร้างชุดสำรอง + latest.txt สำเร็จ | ✅ ผ่าน |
| 01-linux-lab | `./server-start.sh --test` | ตรวจแล้วแจ้งว่าไม่พบ `paper-*.jar` → exit 1 (ถูกต้อง) | ✅ ผ่าน |
| 02-programming-lab | `./loot-table.sh 1000 --summary` | สัดส่วนที่ได้ใกล้ค่าออกแบบ (เหล็ก 38.8% vs 40%, Epic 4.4% vs 3%) | ✅ ผ่าน |
| 02-programming-lab | `./loot-table.sh --seed 42` (รัน 2 ครั้ง) | ได้ผลเหมือนกันทุกครั้ง (ตามที่ออกแบบ) | ✅ ผ่าน |
| 02-programming-lab | `./damage-sim.sh --rounds 10 --seed 7` | สรุปผลครบ 10 รอบ → exit 0 | ✅ ผ่าน |
| 02-programming-lab | `./damage-sim.sh --rounds 0` | แจ้ง error และ exit 2 | ✅ ผ่าน |
| 02-programming-lab | `./exp-curve.sh 1 5` | ตาราง EXP เพิ่มขึ้นตามเลเวล (ไม่มีค่าติดลบ) | ✅ ผ่าน |
| 03-java-lab | `javac -d out $(find src -name '*.java')` | คอมไพล์ผ่าน ไม่มี error | ✅ ผ่าน |
| 03-java-lab | `java -cp out com.mengkub.javalab.Main` (ป้อนเมนู 1–5, 0) | เมนูทำงานครบ ทุกคำสั่งให้ผลถูกต้อง | ✅ ผ่าน |
| 04-first-plugin | `gradle build` | `BUILD SUCCESSFUL` → ได้ `build/libs/EclipseCore-1.0.0.jar` | ✅ ผ่าน |
| 04-first-plugin | `unzip -l build/libs/EclipseCore-1.0.0.jar` | มี `plugin.yml`, `config.yml` และ `.class` ครบ 4 คลาส | ✅ ผ่าน |
| 04-first-plugin | `./gradlew --version` (Gradle Wrapper) | Gradle 9.8.2 บน JVM 25.0.5 | ✅ ผ่าน |
| 05-paper-server | `bash -n start.sh` + `./start.sh --test` | ไวยากรณ์ถูกต้อง; โหมด --test ตรวจจริงและคืน exit 1 เมื่อขาด Jar/Java | ✅ ผ่าน |
| 05-paper-server | ดาวน์โหลด Paper 26.3 build 226 (fill v3) แล้วเปิดเซิร์ฟเวอร์จริง | บูต 16.1 วินาที · `Paper 26.3-226-main@4f49049` · Java 25.0.5 | ✅ ผ่าน |
| 04-first-plugin | ติดตั้ง `.jar` ลง `plugins/` แล้วเปิดเซิร์ฟเวอร์ | `Enabling EclipseCore v1.0.0` · `สวัสดี Somchai` · `/eclipse stats` = 0 ผู้เล่น | ✅ ผ่าน |
| 05-paper-server | ปิดเซิร์ฟเวอร์ด้วยคำสั่ง `stop` ผ่านคอนโซล | `ปิด EclipseCore — เก็บกวาดเรียบร้อย` + RegionFile I/O halt สะอาด | ✅ ผ่าน |

> ✅ **อัปเดต 28 ตุลาคม 2026:** เปิดเซิร์ฟเวอร์ Paper 26.3 จริงแล้วและปลั๊กอินโหลดทำงาน (รายละเอียด: [tests/runs/2026-10-28-plugin-load.md](../tests/runs/2026-10-28-plugin-load.md))
> ⚠️ **สิ่งที่ยังไม่ได้ทดสอบ:** การเข้าเล่นด้วย **ไคลเอนต์ Minecraft** (ข้อความต้อนรับ, Tab-completion, การปฏิเสธสิทธิ์ของผู้เล่น non-op)
> เครื่องทดสอบของครูไม่มีไคลเอนต์เกม — **ผู้เรียนต้องทดสอบเอง** ตาม [tests/checklists/server-startup.md](../tests/checklists/server-startup.md) แล้วบันทึกผล

### ประวัติการแก้ที่พบระหว่างทดสอบ (บันทึกไว้เป็นบทเรียน)

| ปัญหาที่เจอ | สาเหตุจริง | วิธีแก้ |
| --- | --- | --- |
| `error: illegal static interface method call` 5 จุดใน `EclipseCommand.java` | เรียก `Commands.literal(...)` (static method ของ interface) ผ่านตัวแปร `commands` | เรียกผ่านชื่อ interface: `Commands.literal(...)` |
| `./damage-sim.sh --rounds 3` รายงาน “ไม่จบเทิร์น 3” | ใช้ตัวแปร `--rounds` เป็นทั้งจำนวนรอบและเพดานเทิร์น | แยกเป็น `--rounds` (จำนวนรอบ) และ `--max-turns` (เพดานเทิร์น) |
| สคริปต์จำลองการต่อสู้คืน `exit 1` เมื่อแพ้ | ใช้ exit code แทน “ผลลัพธ์ของเกม” | เก็บผลไว้ในตัวแปร `RESULT` และ exit 0 เมื่อจำลองสำเร็จ |
| ดาวน์โหลด Paper จาก API v2 ได้ `410 Gone` | PaperMC ย้าย Downloads API ไป **fill v3** | ดึง URL จาก `fill.papermc.io/v3/projects/paper/versions/26.3/builds/226` → `downloads["server:default"].url` |
| log มี `ERROR]: No key layers in MapLike[{}]` แต่ปลั๊กอินทำงานปกติ | มาจาก worldgen ของโลก flat ที่ไม่ได้ระบุ generator settings ไม่ใช่ปลั๊กอิน | ใช้โลกปกติหรือระบุ generator settings · เตือนไว้ใน TROUBLESHOOTING.md |
