# Test Run — Plugin Load บน Paper 26.3 (28 ตุลาคม 2026)

> 🧪 **การทดสอบจริงของครู** ไม่ใช่ตัวอย่าง — รันบน Linux VM (2 vCPU / 3.8 GB RAM) ด้วย JDK 25.0.5 Temurin
> 📄 อ้างอิง checklist: [../checklists/plugin-load.md](../checklists/plugin-load.md)

---

## 1. สภาพแวดล้อมที่ใช้

| รายการ | ค่า |
| --- | --- |
| ระบบ | Linux 6.1.102 (amd64), 2 vCPU / ~3.8 GB RAM |
| Java | OpenJDK 25.0.5+8-LTS (Temurin) |
| เซิร์ฟเวอร์ | **Paper 26.3-226-main@4f49049** (build 226, ช่อง `STABLE`, เผยแพร่ 2026-10-26) |
| ปลั๊กอิน | `EclipseCore-1.0.0.jar` (build จาก `projects/04-first-plugin`) |
| วิธีดาวน์โหลด | PaperMC **fill v3** API (v2 ตอบ `410 Gone` แล้ว) |
| โหมดทดสอบ | คอนโซลเท่านั้น (ไม่มีไคลเอนต์ Minecraft) · โลกแบบ flat, `view-distance=3` |

---

## 2. คำสั่งที่ใช้ (ทำซ้ำได้)

```bash
# 1) ดาวน์โหลด Paper 26.3 build 226 ผ่าน fill v3
curl -sS "https://fill.papermc.io/v3/projects/paper/versions/26.3/builds/226" -o meta.json
URL=$(python3 -c "import json;print(json.load(open('meta.json'))['downloads']['server:default']['url'])")
curl -L -o paper.jar "$URL"

# 2) เตรียมโฟลเดอร์ทดสอบ
mkdir -p plugins && cp <repo>/Minecraft-MMO-Academy/projects/04-first-plugin/build/libs/EclipseCore-1.0.0.jar plugins/
printf 'eula=true\n' > eula.txt     # ยอมรับ EULA สำหรับเซิร์ฟเวอร์ทดสอบส่วนตัว

# 3) เปิดเซิร์ฟเวอร์และยิงคำสั่งผ่านคอนโซล
mkfifo cmd.fifo
java -Xms512M -Xmx1024M -jar paper.jar --nogui < cmd.fifo > run.log 2>&1 &
exec 3> cmd.fifo
echo "eclipse" >&3; echo "eclipse hello Somchai" >&3; echo "eclipse stats" >&3; echo "plugins" >&3; echo "stop" >&3
```

---

## 3. ผลจริงจาก `run.log`

```text
[02:43:21 INFO]: [bootstrap] Running Java 25 (OpenJDK 64-Bit Server VM 25.0.5+8-LTS; Eclipse Adoptium Temurin-25.0.5+8) on Linux 6.1.102 (amd64)
[02:43:21 INFO]: [bootstrap] Loading Paper 26.3-226-main@4f49049 (2026-10-26T21:04:07Z) for Minecraft 26.3
[02:43:22 INFO]: [PluginInitializerManager] Bukkit plugins (1):
 - EclipseCore (1.0.0)
[02:43:30 ERROR]: No key layers in MapLike[{}]
[02:43:31 INFO]: Starting minecraft server version 26.3
[02:43:31 INFO]: This server is running Paper version 26.3-226-main@4f49049 (Implementing API version 26.3.build.226-stable)
[02:43:36 INFO]: [EclipseCore] Loading server plugin EclipseCore v1.0.0
[02:43:36 INFO]: [EclipseCore] Enabling EclipseCore v1.0.0
[02:43:36 INFO]: [EclipseCore] เปิด EclipseCore v1.0.0 บน Paper 26.3 / Java 25
[02:43:36 INFO]: [EclipseCore] ไม่พบ LuckPerms — ช่วงพัฒนาใช้สิทธิ์แบบ op ไปก่อน (จะติดตั้งใน Month 7)
[02:43:36 INFO]: Done (16.103s)! For help, type "help"
[02:43:37 INFO]: Eclipse MMO RPG v1.0.0
[02:43:37 INFO]: คำสั่ง: /eclipse stats | /eclipse hello <ชื่อ>
[02:43:39 INFO]: สวัสดี Somchai — ขอให้สนุกกับ Eclipse!
[02:43:41 INFO]: ผู้เล่นออนไลน์: 0
[02:43:43 INFO]: ℹ Server Plugins (1):
[02:43:43 INFO]: Bukkit Plugins:
[02:43:43 INFO]:  - EclipseCore
[02:43:45 INFO]: [EclipseCore] Disabling EclipseCore v1.0.0
[02:43:45 INFO]: [EclipseCore] ปิด EclipseCore — เก็บกวาดเรียบร้อย
[02:43:45 INFO]: All RegionFile I/O tasks to complete
```

**เวลาบูต:** 16.1 วินาที (โลก flat, ไม่มีผู้เล่น) · **เวลาปิด:** ~2 วินาที · หน่วยความจำที่ให้ JVM: 1 GB

**ไฟล์ที่ปลั๊กอินสร้างเอง:** `plugins/EclipseCore/config.yml` (จาก `saveDefaultConfig()`)

---

## 4. สรุปตาม checklist

| # | รายการตรวจ | ผล | หลักฐาน |
| --- | --- | --- | --- |
| 1 | `./gradlew build` ผ่าน | ✅ | `BUILD SUCCESSFUL` |
| 2 | ได้ `.jar` ใหม่ใน `build/libs/` | ✅ | `EclipseCore-1.0.0.jar` (11,159 ไบต์) |
| 3 | คัดลอก `.jar` ไปที่ `plugins/` | ✅ | `plugins/EclipseCore-1.0.0.jar` |
| 4 | รีสตาร์ทเซิร์ฟเวอร์ (ไม่ใช้ `/reload`) | ✅ | เปิดใหม่ทั้งโปรเซส |
| 5 | log แสดงว่า enabled พร้อมเวอร์ชันถูกต้อง | ✅ | `Enabling EclipseCore v1.0.0` |
| 6 | `/plugins` เห็นชื่อปลั๊กอิน | ✅ | `- EclipseCore` (คอนโซล `plugins`) |
| 7 | คำสั่งหลักทำงาน | ✅ | `/eclipse`, `/eclipse hello Somchai`, `/eclipse stats` ตอบถูก |
| 8 | ใช้คำสั่งผิดรูปแบบ → ข้อความช่วยเหลือ | ✅ | `/eclipse` แสดงรายการคำสั่ง |
| 9 | Tab-completion | ⏳ | **ทดสอบไม่ได้** — ต้องใช้ไคลเอนต์เกม |
| 10 | ผู้เล่นไม่มีสิทธิ์ → ถูกปฏิเสธ | ⏳ | **ทดสอบไม่ได้** — ต้องมีผู้เล่นจริง (คอนโซลเป็น op เสมอ) |
| 11 | ไม่มี `NullPointerException`/stack trace | ✅ | ไม่มีใน log (มีเพียง `No key layers` ที่อธิบายด้านล่าง) |
| 12 | ปิดเซิร์ฟเวอร์ไม่มี error ตอน `onDisable` | ✅ | `ปิด EclipseCore — เก็บกวาดเรียบร้อย` |

**ทดสอบกับผู้เล่นจริง:** ☐ 1 คน ☐ 2 คน ☑ **ยังไม่ได้ทดสอบ** (ไม่มีไคลเอนต์ Minecraft ในเครื่องทดสอบ)

**สรุปผล:** ☑ ผ่านบางส่วน (10/12 ข้อ — 2 ข้อต้องใช้ไคลเอนต์เกม)

---

## 5. สิ่งที่พบระหว่างทดสอบ (บทเรียนจริง)

| สิ่งที่พบ | สาเหตุ | การจัดการ |
| --- | --- | --- |
| `Download API v2` ตอบ **410 Gone** | PaperMC ย้ายไป **fill v3** (`fill.papermc.io/v3`) | ใช้ metadata v3 แล้วดึง `downloads["server:default"].url` — เอกสารใน `05-paper-server/README.md` อัปเดตแล้ว |
| `ERROR]: No key layers in MapLike[{}]` ตอนสร้างโลก | เกิดจาก `level-type=minecraft:flat` แต่ไม่ได้ระบุ generator settings ให้ครบ — เป็นของ **worldgen** ไม่ใช่ปลั๊กอิน | ไม่กระทบการโหลดปลั๊กอิน; ถ้าใช้โลกปกติจะไม่เกิด · บันทึกใน TROUBLESHOOTING แล้ว |
| ต้องใช้ `-Xmx1024M` บนเครื่อง RAM 3.8 GB | Paper 26.3 + โลก flat ใช้ ~700 MB | เครื่องจริงควรมี RAM ≥ 8 GB เพื่อรัน 4–6 GB heap + OS |
| ปลั๊กอินไม่พบ LuckPerms แล้วไม่พัง | โค้ดตรวจ `getPlugin("LuckPerms") == null` และแจ้งเตือนแทน crash | ยืนยันว่า defensive check ทำงานตามออกแบบ |

---

## 6. สิ่งที่ยังต้องทดสอบด้วยไคลเอนต์จริง (ผู้เรียนทำใน Month 5)

- [ ] เข้าเกมด้วยเวอร์ชัน 26.3 แล้วเห็นข้อความต้อนรับจาก `welcome-message` (MiniMessage)
- [ ] พิมพ์ `/ec` (alias) และ Tab-completion ของ `/eclipse hello <ชื่อ>`
- [ ] ผู้เล่นปกติ (ไม่ op) รัน `/eclipse admin` → ต้องถูกปฏิเสธ
- [ ] `/eclipse stats` แสดงจำนวนผู้เล่นออนไลน์ตรงจริง (เช่น 2 คน)
- [ ] ตรวจว่า `config.yml` ที่ถูกสร้างใช้ค่าเริ่มต้นถูกต้อง และแก้แล้วมีผลหลังรีสตาร์ท
