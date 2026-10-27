# TODO.md — รายการงานของหลักสูตร

> 📌 สถานะที่ใช้: `NOT_STARTED` · `IN_PROGRESS` · `BLOCKED` · `COMPLETED` · `NEEDS_REVIEW`
> **กติกา:** งานจะถูกทำเครื่องหมาย `COMPLETED` ได้เฉพาะเมื่อ **ทดสอบผลลัพธ์จริงแล้ว** และมีหลักฐานใน [PROGRESS.md](PROGRESS.md)
> ถ้างานเสร็จแต่ยังไม่ได้ทดสอบ ให้ใช้ `NEEDS_REVIEW`

---

## 1. งานติดตั้งและเตรียมเครื่อง (ทำก่อน/ระหว่าง Day 01–05)

| ID | Month | Week | Day | งาน | Priority | Status | Dependencies | Expected Output |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| T-001 | 1 | 1 | 1 | ตรวจว่าใช้ CachyOS เวอร์ชันอะไร และ Terminal ไหน | P0 | `NOT_STARTED` | — | ข้อมูลใน PROGRESS.md ข้อ 2 |
| T-002 | 1 | 1 | 1 | สร้างโฟลเดอร์ทำงาน `~/minecraft-mmo-dev/` ตามโครงที่กำหนด | P0 | `NOT_STARTED` | T-001 | โฟลเดอร์ 5 ชุด + ผล `tree` |
| T-003 | 1 | 1 | 2 | เขียน script แรกที่รันได้จริง พร้อม `chmod +x` | P0 | `NOT_STARTED` | T-002 | `scripts/first-script.sh` |
| T-004 | 1 | 1 | 3 | ตั้ง alias ประจำตัวอย่างน้อย 3 ตัว | P1 | `NOT_STARTED` | T-003 | `~/.bashrc` ที่แก้แล้ว + ทดสอบ |
| T-005 | 1 | 1 | 4 | ติดตั้ง VS Code + ส่วนขยายที่จำเป็น | P0 | `NOT_STARTED` | T-001 | VS Code เปิด Java ได้ |
| T-006 | 1 | 1 | 4 | ติดตั้ง JDK 21 (หรือใหม่กว่า) ผ่าน pacman/vendor | P0 | `NOT_STARTED` | T-005 | ผล `java -version` ที่บันทึกไว้ |
| T-007 | 1 | 1 | 5 | ติดตั้ง/ตรวจ Git และตั้ง `user.name`, `user.email` | P0 | `NOT_STARTED` | T-001 | ผล `git config --list` |
| T-008 | 1 | 1 | 5 | สร้าง repo สำหรับโปรเจกต์ + commit แรก | P0 | `NOT_STARTED` | T-007 | `git log --oneline` มี 1 commit |
| T-009 | 1 | 1 | 6 | วาดผังการทำงาน (flowchart) ระบบสุ่มของรางวัล | P1 | `NOT_STARTED` | T-003 | ไฟล์ `notes/loot-flow.md` |
| T-010 | 1 | 1 | 7 | 🔁 REVIEW สัปดาห์ 1 + ให้คะแนนตัวเอง | P0 | `NOT_STARTED` | T-001…T-009 | ตารางคะแนนใน PROGRESS.md |

---

## 2. งานที่ต้องเสร็จใน Month 1 (Day 01–30)

| ID | Week | Day | งาน | Priority | Status | Dependencies | Expected Output |
| --- | --- | --- | --- | --- | --- | --- | --- |
| T-100 | 2 | 8–14 | เรียน Shell script: ตัวแปร, เงื่อนไข, ลูป, ฟังก์ชัน | P0 | `NOT_STARTED` | T-003 | script 4–5 ไฟล์ที่รันได้ |
| T-101 | 3 | 15 | 😴 REST — พักตามแผน (อ่านเอกสาร Paper ได้ ไม่ต้องส่งงาน) | — | `NOT_STARTED` | — | ไม่มีงานที่ต้องส่ง |
| T-102 | 3 | 16–21 | ตั้งค่า VS Code ให้เป็น workspace จริง + จัดโครงโปรเจกต์ | P0 | `NOT_STARTED` | T-005 | `.vscode/` + `docs/` |
| T-103 | 4 | 22–27 | เขียน script `backup.sh` และ `server-check.sh` ที่ใช้งานได้จริง | P0 | `NOT_STARTED` | T-100 | script 2 ไฟล์ + ผลทดสอบ |
| T-104 | 4 | 28 | 🔁 REVIEW สัปดาห์ 4 | P0 | `NOT_STARTED` | T-102, T-103 | คะแนน + งานเข้า Git |
| T-105 | 4 | 29 | 🏁 โปรเจกต์เดือน 1: `linux-lab` ครบชุดตาม README | P0 | `NOT_STARTED` | T-103 | โฟลเดอร์ `projects/01-linux-lab` |
| T-106 | 4 | 30 | ประเมินความพร้อมขึ้น Month 2 (ประตูผ่าน 5 ข้อ) | P0 | `NOT_STARTED` | T-105 | ผลประเมินใน PROGRESS.md |

---

## 3. งานระดับยาว (ไม่ใช่งานรายวัน — ทำเมื่อถึงเวลา)

| ID | Month | งาน | Priority | Status | Dependencies | Expected Output |
| --- | --- | --- | --- | --- | --- | --- |
| T-200 | 5 | คอมไพล์ Plugin แรกด้วย Gradle/Maven ให้ผ่านจริง | P0 | `NOT_STARTED` | Month 3–4 จบ | ไฟล์ `.jar` ใน `build/libs` |
| T-201 | 6 | รัน Plugin บนเซิร์ฟเวอร์ Paper ในเครื่องตัวเอง | P0 | `NOT_STARTED` | T-200 | log แสดง plugin โหลดสำเร็จ |
| T-202 | 7 | ติดตั้ง Resource Pack ที่มีไอเทมของตัวเอง 1 ชิ้น | P1 | `NOT_STARTED` | Month 6 | เห็นไอเทมในเกม |
| T-203 | 8 | ฐานข้อมูลบันทึกเลเวล/เงินของผู้เล่น (ไม่หายหลังรีสตาร์ท) | P0 | `NOT_STARTED` | T-201 | ตาราง DB + ผลทดสอบรีสตาร์ท |
| T-204 | 9 | Damage Engine เวอร์ชัน 1 + ชุดทดสอบ (unit test) | P0 | `NOT_STARTED` | T-203 | คลาส + test ผ่าน |
| T-205 | 10 | Dungeon แรกที่มีบอส 1 ตัวและรางวัล | P0 | `NOT_STARTED` | T-204 | เล่นได้จริง 1 รอบ |
| T-206 | 11 | ระบบเศรษฐกิจ: ตรวจการทำรายการซ้ำ (dupe/race) | P0 | `NOT_STARTED` | T-203 | บันทึกผลทดสอบ 2 บัญชี |
| T-207 | 12 | Beta whitelist + Backup/Restore ที่กู้คืนได้จริง | P0 | `NOT_STARTED` | T-205 | บันทึกผล Restore 1 ครั้ง |
| T-208 | 12 | ตรวจ Commercial Usage Guidelines + EULA ก่อนเปิดขาย | P0 | `NOT_STARTED` | Month 11 | สรุปเป็นเอกสาร |

---

## 4. งานที่ถูกบล็อกอยู่ (BLOCKED) และเหตุผล

| ID | งาน | บล็อกเพราะ | ต้องทำอะไรก่อนจึงจะไปต่อได้ |
| --- | --- | --- | --- |
| — | ยังไม่มี | — | — |

---

## 5. งานที่รอตรวจ (NEEDS_REVIEW)

| ID | งาน | ทำเสร็จเมื่อ | ต้องตรวจอะไร |
| --- | --- | --- | --- |
| — | ยังไม่มี | — | — |

> 💡 เมื่อเริ่มเรียนจริง ให้สั่ง `TODO` เพื่อดูตารางนี้ และสั่ง `PAUSE` เพื่อบันทึกสถานะก่อนหยุดทุกครั้ง
