# 04-first-plugin — ปลั๊กอิน Paper ตัวแรก (`EclipseCore` v1)

> 🎯 **เป้าหมาย:** ปลั๊กอินที่ build ได้เป็น `.jar`, ติดตั้งบนเซิร์ฟเวอร์ได้ และมีคำสั่ง + event + ไฟล์ตั้งค่า
> 📅 ใช้ใน: Month 05 (Day 136–150) → ต่อยอดใน Month 06 (v2)
> ✅ **สถานะ: build ผ่านจริง** — ครูคอมไพล์ด้วย JDK 25 + Gradle 9.8.2 โดยดึง `paper-api` จาก repo.papermc.io

---

## 1. ข้อมูลเวอร์ชันที่ใช้ (ตรวจสอบแล้ว)

| องค์ประกอบ | ค่า | ที่มา |
| --- | --- | --- |
| เซิร์ฟเวอร์ | Paper **26.3** (build STABLE) | https://fill.papermc.io/v3/projects/paper/versions/26.3/builds |
| Java | **25** | https://docs.papermc.io/paper/getting-started/ |
| ไลบรารี | `io.papermc.paper:paper-api` (compileOnly) | https://docs.papermc.io/paper/dev/project-setup/ |
| `api-version` | `'26.3'` | https://docs.papermc.io/paper/dev/plugin-yml/ |
| ตัว build | Gradle + Gradle Wrapper | แนะนำโดยเอกสาร Paper |

> ⚠️ เวอร์ชันเปลี่ยนได้ตลอด — ก่อนเริ่ม Month 5 ให้เปิด 2 ลิงก์ด้านบนอีกครั้ง แล้วปรับเลขใน `build.gradle.kts` / `plugin.yml`

---

## 2. โครงสร้างโปรเจกต์

```text
04-first-plugin/
├── README.md
├── settings.gradle.kts          ← ชื่อโปรเจกต์
├── build.gradle.kts             ← ตั้งค่า build + dependency paper-api
├── gradlew / gradlew.bat        ← Gradle Wrapper (สร้างด้วย `gradle wrapper`)
├── gradle/wrapper/              ← ไฟล์ของ wrapper
└── src/main/
    ├── java/com/mengkub/eclipse/
    │   ├── EclipseCorePlugin.java        ← คลาสหลัก (onEnable/onDisable)
    │   ├── config/Settings.java          ← อ่าน+ตรวจค่าจาก config.yml
    │   ├── listener/PlayerJoinListener.java  ← event ผู้เล่นเข้าเกม
    │   └── command/EclipseCommand.java   ← คำสั่ง /eclipse + permission
    └── resources/
        ├── plugin.yml                    ← บัตรประชาชนของปลั๊กอิน
        └── config.yml                    ← ค่าเริ่มต้นของไฟล์ตั้งค่า
```

---

## 3. วิธี build (คัดลอกได้เลย)

```bash
# 0) ต้องมี JDK 25 และรัน Gradle ด้วย JDK 25
java -version          # ต้องขึ้น 25.x
export JAVA_HOME=/path/to/jdk-25    # ถ้ายังไม่ตั้ง

cd Minecraft-MMO-Academy/projects/04-first-plugin

# 1) build ครั้งแรก (จะดาวน์โหลด paper-api ครั้งเดียว)
./gradlew build

# 2) ดูผลลัพธ์
ls -l build/libs/      # ต้องเห็น EclipseCore-1.0.0.jar

# 3) ล้างผลลัพธ์เมื่อต้องการ build ใหม่ทั้งหมด
./gradlew clean build
```

**ถ้า `./gradlew` ยังไม่มี** (โฟลเดอร์นี้มีมาให้แล้ว ถ้าถูกคัดลอกครบ) ให้สร้างใหม่ด้วย:
```bash
gradle wrapper --gradle-version 9.8.2
```

---

## 4. วิธีติดตั้งและทดสอบ (Month 5–6)

```bash
# คัดลอก .jar ไปโฟลเดอร์ plugins ของเซิร์ฟเวอร์ทดสอบ
cp build/libs/EclipseCore-1.0.0.jar ~/minecraft-mmo-dev/server/plugins/

# เปิดเซิร์ฟเวอร์ทดสอบ (ดู projects/05-paper-server)
cd ~/minecraft-mmo-dev/server && ./start.sh
```

**สิ่งที่ต้องเห็นใน log:**
```text
[Server] [EclipseCore] เปิด EclipseCore v1.0.0 บน Paper 26.3 / Java 25
[Server] Enabling EclipseCore v1.0.0
```

**ทดสอบคำสั่งในเกม (หรือในคอนโซล):**
| คำสั่ง | ผลที่คาดหวัง |
| --- | --- |
| `/eclipse` | ข้อความยินดีต้อนรับ + เวอร์ชันปลั๊กอิน |
| `/eclipse stats` | แสดงข้อมูลสถานะปลั๊กอิน (จำนวนผู้เล่น ฯลฯ) |
| `/eclipse admin` (ไม่มีสิทธิ์) | ถูกปฏิเสธพร้อมข้อความ |
| `/ec` | ทำงานเหมือน `/eclipse` (alias) |
| ผู้เล่นเข้าเซิร์ฟเวอร์ | มีข้อความต้อนรับตามที่ตั้งใน `config.yml` |

---

## 5. อธิบายโค้ดสำคัญ (อ่านให้เข้าใจ ก่อนแก้)

### 5.1 `plugin.yml` — บัตรประชาชนของปลั๊กอิน
```yaml
name: EclipseCore
version: 1.0.0
main: com.mengkub.eclipse.EclipseCorePlugin
api-version: '26.3'      # ถ้าไม่ใส่ Paper จะโหลดแบบ legacy + เตือน
permissions:
  eclipse.admin: { description: "ใช้คำสั่งแอดมินของ EclipseCore", default: op }
```
> 📌 เรา **ไม่** ประกาศ `commands:` ในไฟล์นี้ เพราะใช้วิธีใหม่ (Brigadier) ลงทะเบียนในโค้ด
> ถ้าประกาศทั้งสองที่จะทำให้เกิดคำสั่งซ้ำ

### 5.2 `EclipseCorePlugin.java` — วงจรชีวิต
- `onEnable()`: เรียกเมื่อปลั๊กอินถูกเปิด → โหลด config, ตรวจเวอร์ชัน Java, ลงทะเบียน event/command
- `onDisable()`: เรียกเมื่อปิดเซิร์ฟเวอร์ → ใช้บันทึกข้อมูล ยกเลิก task (ห้ามทำงานหนัก)

### 5.3 `Settings.java` — อ่าน config อย่างปลอดภัย
- อ่านค่าจาก `config.yml` ด้วยวิธีที่มีค่าเริ่มต้น
- **ตรวจค่า** ถ้าผิดให้ใช้ค่าเริ่มต้น + เขียน `WARNING` ลง log (ไม่ทำให้ปลั๊กอินพัง)

### 5.4 `PlayerJoinListener.java` — event
- `@EventHandler` = ลงทะเบียนเมธอดให้ถูกเรียกเมื่อเหตุการณ์เกิด
- ส่งข้อความด้วย Adventure `Component` (ไม่ใช้ตัวจัดสีแบบเก่า)

### 5.5 `EclipseCommand.java` — คำสั่ง + สิทธิ์
- ลงทะเบียนผ่าน `LifecycleEvents.COMMANDS` (วิธีใหม่ของ Paper)
- `.requires(src -> src.getSender().hasPermission("eclipse.admin"))` = ตรวจสิทธิ์ที่ชั้นคำสั่ง

---

## 6. แบบฝึกหัด

| # | งาน | เกณฑ์ผ่าน |
| --- | --- | --- |
| 1 | เพิ่มคำสั่ง `/eclipse hello <ชื่อ>` ที่ทักทายชื่อที่ใส่ | Tab-completion ทำงาน + ใส่ชื่อว่างไม่ได้ |
| 2 | เพิ่มการตั้งค่า `welcome: false` ใน config เพื่อปิดข้อความต้อนรับ | แก้ config แล้วรีสตาร์ท เห็นผลจริง |
| 3 | เพิ่มข้อความ farewell เมื่อผู้เล่นออก (`PlayerQuitEvent`) | ทดสอบออก-เข้า 1 รอบ |
| 4 | ทำให้ `/eclipse stats` แสดงจำนวนผู้เล่นออนไลน์ + uptime ของปลั๊กอิน | ค่าตรงกับความจริง |

---

## 7. Troubleshooting

| อาการ | สาเหตุ | วิธีแก้ |
| --- | --- | --- |
| `Could not resolve io.papermc.paper:paper-api:...` | ไม่ได้ใส่ repository หรือเลขเวอร์ชันไม่มีจริง | ตรวจ `build.gradle.kts` ว่ามี `repo.papermc.io/...` และเลขเวอร์ชันถูก (ดู metadata) |
| `invalid source release: 25` | รัน Gradle ด้วย JDK เก่ากว่า 25 | ตั้ง `JAVA_HOME` เป็น JDK 25 แล้วรันใหม่ |
| ปลั๊กอินไม่โหลด, log บอก `Unsupported API version` | `api-version` สูงกว่าเวอร์ชันเซิร์ฟเวอร์ | ปรับให้ตรงกับเซิร์ฟเวอร์ที่ใช้ |
| คำสั่งไม่ทำงาน | ลงทะเบียนผิด lifecycle หรือ permission ไม่ผ่าน | ดู log + ตรวจ `.requires(...)` |
| แก้โค้ดแล้วไม่มีอะไรเปลี่ยน | ยังใช้ `.jar` เก่าใน `plugins/` | build ใหม่ + คัดลอกทับ + รีสตาร์ท (อย่าใช้ `/reload`) |

---

## 8. ต่อไป

- **Month 6:** เพิ่ม GUI, ไอเทมกำหนดเอง (PersistentDataContainer), ไฟล์ภาษา, subcommand
- **Month 8:** ย้ายข้อมูลผู้เล่นเข้า MySQL + ระบบไอเทมจริง
