# ⚔️ Minecraft MMO RPG Academy — หลักสูตร 365 วันจากศูนย์สู่เซิร์ฟเวอร์จริง

> **สำหรับ:** ผู้เรียนที่เริ่มจากศูนย์ มีเวลาวันละ 2–3 ชั่วโมง ใช้ CachyOS/Linux
> **เป้าหมาย:** ออกแบบ พัฒนา ดูแล และต่อยอด Minecraft MMO RPG Server ที่เปิดให้ผู้เล่นจริงได้ พร้อมเข้าใจการทำธุรกิจอย่างถูกต้อง
> **สถานะหลักสูตร:** ✅ โครงสร้าง 365 วันครบ · ✅ บทเรียนละเอียด Day 01–07 · ⏳ บทเรียนวันอื่นจะถูกเขียนเมื่อเรียนถึงช่วงนั้น

---

## 🚦 เริ่มที่นี่ (3 ขั้นตอน)

1. อ่านไฟล์นี้ให้จบ (ใช้เวลา ~10 นาที)
2. ตอบ **แบบประเมินความพร้อม 6 ข้อ** ท้ายไฟล์ แล้วพิมพ์คำตอบให้ครูในแชท
3. พิมพ์คำสั่ง `START` เพื่อเริ่ม Day 01 — ถ้าต้องการข้ามไปดูแผนก่อน พิมพ์ `ROADMAP`

---

## 📚 ไฟล์ในหลักสูตรนี้ (แผนที่เอกสาร)

| ไฟล์ | ใช้ทำอะไร | เปิดเมื่อไร |
| --- | --- | --- |
| [ROADMAP.md](ROADMAP.md) | แผน 12 เดือน + เกณฑ์ผ่านแต่ละเดือน | ต้นเดือน / วางแผน |
| [curriculum/365-DAY-PLAN.md](curriculum/365-DAY-PLAN.md) | ตารางทุกวัน 365 วัน + ผลงานที่ต้องได้ | ทุกวัน |
| [KNOWLEDGE-MAP.md](KNOWLEDGE-MAP.md) | แผนที่ความสัมพันธ์ของทักษะทั้งหมด | เมื่อสับสนว่าต้องเรียนอะไรก่อน |
| [PROGRESS.md](PROGRESS.md) | บันทึกความก้าวหน้า (ความจำของหลักสูตร) | ทุกวันหลังเรียนจบ |
| [TODO.md](TODO.md) | รายการงาน + สถานะ + งานที่ติดอยู่ | ทุกวันก่อนเริ่ม |
| [DAILY-TRACKER.md](DAILY-TRACKER.md) | ตารางเวลา 150 นาที + บันทึกเวลาจริง | ทุกวัน |
| [PROJECT-STATUS.md](PROJECT-STATUS.md) | สถานะระบบเกม (EclipseCore → MMO) | ทุกสัปดาห์ |
| [GLOSSARY.md](GLOSSARY.md) | คำศัพท์เทคนิคพร้อมคำอธิบายภาษาไทย | เมื่อเจอคำใหม่ |
| [TROUBLESHOOTING.md](TROUBLESHOOTING.md) | รวม error ที่เจอ + วิธีแก้ที่ใช้ได้จริง | เมื่อเจอ error |
| [curriculum/month-XX/](curriculum/) | บทเรียนรายวันของแต่ละเดือน | ตามแผน |
| [projects/](projects/) | โค้ดตัวอย่างที่รันได้จริง | ระหว่างเรียน |
| [exercises/](exercises/) | วิธีส่งงานและแบบฝึกหัด | หลังบทเรียน |
| [tests/](tests/) | ชุดทดสอบและ checklist ก่อนถือว่างานเสร็จ | ก่อนบอกว่า "เสร็จ" |
| [business/](business/) | แผนธุรกิจ ต้นทุน รายได้ และการเปิดให้บริการ | Month 11–12 |

---

## 🎯 หลักการสอนของหลักสูตรนี้ (และสิ่งที่ครูจะไม่ทำ)

**ครูจะ:**
- อธิบายทุกคำศัพท์ใหม่เป็นภาษาไทย พร้อมตัวอย่างจาก Minecraft ก่อนใช้คำนั้น
- ให้โค้ดที่ **รันได้จริง** ระบุชื่อไฟล์และพาธชัดเจน พร้อมคำสั่ง build/ทดสอบ
- แยกงานเป็น 4 ระดับ: **Demonstration → Guided Practice → Independent Practice → Review**
- บอกตรง ๆ เมื่อยังไม่ได้ทดสอบอะไร หรือเมื่อข้อมูลใดยังไม่ยืนยัน

**ครูจะไม่:**
- ให้โค้ดก้อนใหญ่โดยไม่ธิบายว่าทำงานอย่างไร
- บอกว่า "ผ่านแล้ว" ถ้ายังไม่ได้รันคำสั่งทดสอบจริง
- เปิดเฉลยแบบฝึกหัดทันที (ต้องขอ `HINT` หรือ `SOLUTION` ก่อน)

> ⚠️ **กติกาสำคัญที่สุด:** หลักสูตรนี้ *ไม่แจกโปรเจกต์สำเร็จรูป* เป้าหมายคือให้คุณแก้โค้ดเองได้เมื่อไม่มี AI อยู่ข้าง ๆ

---

## 🧭 สถาปัตยกรรมหลักสูตร 12 เดือน

| เดือน | เรื่องหลัก | ผลงานที่ได้ |
| --- | --- | --- |
| 1 | Linux, Terminal, ระบบไฟล์, เครื่องมือ | ชุด script + โครงเซิร์ฟเวอร์ (`01-linux-lab`) |
| 2 | พื้นฐานการเขียนโปรแกรมและตรรกะ | ระบบสุ่มรางวัล/คำนวณดาเมจ (`02-programming-lab`) |
| 3 | Java Fundamentals | ระบบไอเทมข้อความ (`03-java-lab`) |
| 4 | OOP, Collections, Testing | โปรเจกต์ OOP + JUnit |
| 5 | Git, Gradle/Maven, Debugging, ปลั๊กอินแรก | ปลั๊กอิน v1 (`04-first-plugin`) |
| 6 | Paper API: Event/Command/Permission/Config/GUI | ปลั๊กอิน v2 + เซิร์ฟเวอร์ (`05-paper-server`) |
| 7 | บริหารเซิร์ฟเวอร์, Plugin, Resource Pack | เซิร์ฟเวอร์ + pack ที่มีไอเทมตัวเอง |
| 8 | Player Data, Database, Items, Progression | Character System v1 |
| 9 | Combat, Skills, Magic, Classes, Animation | Combat/Magic v1 |
| 10 | Mobs, Bosses, Quests, Dungeons, Party, Jobs | Dungeon + Quest + Party |
| 11 | Economy, Security, Website, Performance | Economy + Security Audit + เว็บ |
| 12 | Beta, Deployment, Operations, Business | เซิร์ฟเวอร์พร้อมเปิด + แผนธุรกิจ |

รายละเอียดทุกวันอยู่ใน [curriculum/365-DAY-PLAN.md](curriculum/365-DAY-PLAN.md)

---

## 🧪 สภาพแวดล้อมและเวอร์ชันที่ตรวจสอบแล้ว (ณ 27 ตุลาคม 2026)

| องค์ประกอบ | เวอร์ชันที่ใช้ในหลักสูตร | ที่มา/การตรวจสอบ |
| --- | --- | --- |
| Minecraft Java Edition | **26.3** (Mojang เปลี่ยนมาใช้เลขปี) | ประกาศ/เอกสาร PaperMC |
| Paper Server | **26.3 build 226 (STABLE)** → ไฟล์ `paper-26.3-226.jar` | [fill.papermc.io feed](https://fill.papermc.io/v3/projects/paper/versions/26.3/builds) |
| Java (JDK) | **Java 25** (Paper 26.1+ ต้องใช้ Java 25 — Java 21 ไม่พอ) | [docs.papermc.io — Getting started](https://docs.papermc.io/paper/getting-started/) |
| ตัว build ปลั๊กอิน | **Gradle** + `paper-api` (compileOnly) | [docs.papermc.io — Project setup](https://docs.papermc.io/paper/dev/project-setup/) |
| หมายเหตุเวอร์ชันเก่า | Paper 1.20–1.21.11 ใช้ **Java 21** | ตารางเดียวกัน |

> ⚠️ **ข้อมูลที่ต้องตรวจซ้ำก่อนใช้จริง:** เวอร์ชันซอฟต์แวร์เปลี่ยนเร็ว ให้ตรวจ 2 แหล่งนี้ทุกครั้งก่อนสร้างเซิร์ฟเวอร์หรืออัปเดต:
> 1. https://docs.papermc.io/paper/getting-started/ (ความต้องการของระบบ + วิธีติดตั้ง)
> 2. https://fill.papermc.io/v3/projects/paper/versions/ (build ที่เป็น STABLE)
> ถ้าเวอร์ชันใหม่กว่านี้ ให้ใช้เอกสารนั้นเป็นหลัก และแจ้งครูเพื่อปรับหลักสูตร

---

## ⏱️ ตารางเวลาแนะนำต่อวัน (150 นาที)

| เวลา | กิจกรรม |
| --- | --- |
| 20 นาที | ทบทวนของวันก่อน (รันคำสั่งเดิมซ้ำ) |
| 35 นาที | เรียนแนวคิดใหม่ |
| 45 นาที | ทำตามตัวอย่าง (พิมพ์เอง ห้ามก็อปวาง) |
| 35 นาที | ทำแบบฝึกหัดเอง |
| 15 นาที | ทดสอบ + อัปเดต PROGRESS.md |

รายละเอียด + ตารางบันทึกเวลาอยู่ที่ [DAILY-TRACKER.md](DAILY-TRACKER.md)

---

## 🗣️ คำสั่งควบคุมหลักสูตร (พิมพ์ในแชท)

| คำสั่ง | ผลลัพธ์ |
| --- | --- |
| `START` | เริ่ม/ประเมินความพร้อม แล้วเข้า Day 01 |
| `LESSON` | เริ่มบทเรียนถัดไปตาม PROGRESS.md |
| `REVIEW` | ทบทวนบทเรียนที่ผ่านมา + ชี้จุดที่ยังไม่เข้าใจ |
| `HINT` | คำใบ้แบบไม่เฉลย |
| `SOLUTION` | เฉลยพร้อมอธิบาย |
| `QUIZ` | ทดสอบความเข้าใจ |
| `DEBUG` | ช่วยหาสาเหตุ error (สอนวิธี ไม่ใช่ให้โค้ดใหม่) |
| `PROJECT` | สถานะโปรเจกต์ + งานถัดไป |
| `TODO` | รายการงานที่ยังไม่เสร็จ |
| `ROADMAP` | ความคืบหน้าตามแผน 365 วัน |
| `MAP` | Knowledge Map |
| `PLUGIN` | บทเรียนการเลือก/ติดตั้ง/ตั้งค่า Plugin |
| `SERVER` | บทเรียนการสร้างและดูแลเซิร์ฟเวอร์ |
| `CODE` | ฝึกเขียนโค้ด |
| `BUSINESS` | บทเรียนธุรกิจ |
| `PAUSE` | บันทึกสถานะก่อนหยุด |
| `RESUME` | อ่าน PROGRESS.md แล้วเรียนต่อ |

---

## 📝 แบบประเมินความพร้อม 6 ข้อ (ตอบสั้น ๆ ได้)

ตอบตามจริง ไม่ต้องกลัวตอบผิด — ใช้เพื่อจัดจังหวะการเรียนเท่านั้น

1. **ใช้ CachyOS เวอร์ชันอะไร** และเปิด Terminal ได้หรือยัง? (ลอง `cat /etc/os-release` และ `echo $SHELL`)
2. **สเปกเครื่อง**: RAM กี่ GB, CPU กี่คอร์, พื้นที่ว่างในดิสก์ (ลอง `free -h`, `nproc`, `df -h /`)
3. **เคยเขียนโปรแกรมหรือ script อะไรมาบ้างหรือยัง** (เช่น Python, JavaScript, Bash, หรือยังไม่เคยเลย)
4. **เคยรัน Minecraft Server ด้วยตัวเองไหม** และเคยติดตั้ง Java ไหม
5. **ใช้ VS Code เป็นหรือยัง** และถนัด Terminal แค่ไหน (1 = เริ่มจากศูนย์, 5 = คล่อง)
6. **เป้าหมายจริงจังแค่ไหน**: เรียนเพื่อเปิดเซิร์ฟเวอร์ให้คนเล่นจริง / เรียนเพื่อทำเป็นงานอดิเรก / เรียนเพื่อทำธุรกิจ

> 💡 ถ้ายังตอบข้อ 1–3 ไม่ได้ ไม่เป็นไร — Day 01 สอนวิธีหาคำตอบเหล่านี้ด้วยตัวเองอยู่แล้ว
> แต่ถ้าอยากเริ่มทันที ให้พิมพ์ `START` ครูจะเริ่ม Day 01 และเก็บข้อมูลไปพร้อมกัน

---

## 🔐 ข้อตกลงความปลอดภัย (อ่านก่อนลงมือ)

- ห้ามรันคำสั่งที่ลบข้อมูล (`rm -rf`) ในโฟลเดอร์ที่ไม่ใช่ของตัวเอง — หลักสูตรจะเตือนทุกครั้งก่อนใช้
- ห้ามวางรหัสผ่าน, API key, หรือ token ลงในไฟล์ที่ commit ขึ้น Git
- ก่อนเปิดเซิร์ฟเวอร์ให้คนนอกเข้า ต้องมี whitelist และไฟล์สำรองข้อมูลเสมอ
- การเปิดเซิร์ฟเวอร์เชิงพาณิชย์ต้องตรวจ [Minecraft Commercial Usage Guidelines](https://www.minecraft.net/en-us/usage-guidelines) และ EULA ก่อน — สรุปอยู่ใน [business/launch-checklist.md](business/launch-checklist.md)

---

## 🔗 ลิงก์ที่มีประโยชน์ (ใช้จริงในหลักสูตร)

| เรื่อง | ลิงก์ |
| --- | --- |
| เอกสาร Paper (ติดตั้ง) | https://docs.papermc.io/paper/getting-started/ |
| เอกสาร Paper (เขียนปลั๊กอิน) | https://docs.papermc.io/paper/dev/getting-started/ |
| Paper API (Javadoc) | https://jd.papermc.io/paper/ |
| ดาวน์โหลด Paper | https://papermc.io/downloads/paper |
| Gradle | https://docs.gradle.org/current/userguide/userguide.html |
| Git | https://git-scm.com/book/th/v2 |
| Blockbench (โมเดล) | https://www.blockbench.net/ |

---

**เริ่มเรียนเลย →** พิมพ์ `START` หรือเปิด [Day 01](curriculum/month-01/day-01.md)
