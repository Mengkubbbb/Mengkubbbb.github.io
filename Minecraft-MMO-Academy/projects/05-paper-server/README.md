# 05-paper-server — เซิร์ฟเวอร์ทดสอบ (Paper)

> 🎯 **เป้าหมาย:** เซิร์ฟเวอร์ Paper ที่ตั้งค่าอย่างปลอดภัย เปิด-ปิดได้ถูกวิธี พร้อมใช้ทดสอบปลั๊กอิน
> 📅 ใช้ใน: Month 05 (Day 140) → Month 07 (Day 181–210)
> 🔧 **สถานะ: ไฟล์ตั้งค่าและสคริปต์พร้อมใช้** — ขั้นตอนติดตั้ง/เปิดเซิร์ฟเวอร์ด้านล่างนี้ **ผู้เรียนต้องทำเอง**
> แล้วบันทึกผลลง `docs/test-runs/` ตาม [tests/checklists/server-startup.md](../../tests/checklists/server-startup.md)

---

## 1. เวอร์ชันที่ต้องใช้ (ตรวจสอบแล้ว 2026-10-27)

| องค์ประกอบ | ค่า | ตรวจสอบจาก |
| --- | --- | --- |
| Paper | **26.3** — เลือก build ช่อง `STABLE` | https://fill.papermc.io/v3/projects/paper/versions/26.3/builds |
| Java | **25** (Paper 26.1+ ไม่รองรับ Java 21) | https://docs.papermc.io/paper/getting-started/ |
| ชื่อไฟล์ตัวอย่าง | `paper-26.3-<build>.jar` | Downloads service ของ Paper |

> ⚠️ **ห้ามใช้ build จากช่อง `EXPERIMENTAL` สำหรับเซิร์ฟเวอร์ที่ให้คนอื่นเล่น**

### 1.1 วิธีดาวน์โหลดที่ใช้ได้จริง (ตรวจ 28 ตุลาคม 2026)

> 🚨 **API v2 เลิกใช้แล้ว** — `https://api.papermc.io/v2/...` ตอบ **`410 Gone`**
> ต้องใช้ **fill v3** และดึง URL จาก metadata (ห้ามเดาชื่อไฟล์)

```bash
# ดึง metadata ของ build ที่ต้องการ (เลือก channel = STABLE)
curl -sS "https://fill.papermc.io/v3/projects/paper/versions/26.3/builds/226" -o meta.json

# ดูว่า build นี้เป็นช่องอะไร + วันที่เผยแพร่
python3 -c "import json;d=json.load(open('meta.json'));print(d['channel'], d['time'])"

# ดึง URL จริงแล้วดาวน์โหลด
URL=$(python3 -c "import json;print(json.load(open('meta.json'))['downloads']['server:default']['url'])")
curl -L -o paper-26.3-226.jar "$URL"     # ขนาดจริงที่ตรวจ: 55,255,255 ไบต์
unzip -t paper-26.3-226.jar | tail -1     # ต้องขึ้น "No errors detected"
```

**ผลจริงจากการทดสอบของครู (28 ต.ค. 2026):** `paper-26.3-226.jar` (ช่อง `STABLE`, เผยแพร่ 2026-10-26)
บูตบน Java 25.0.5 ใน **16.1 วินาที** (โลก flat, ไม่มีผู้เล่น) → ดู [tests/runs/2026-10-28-plugin-load.md](../../tests/runs/2026-10-28-plugin-load.md)

---

## 2. วิธีเตรียมเซิร์ฟเวอร์ (ทำตามลำดับ)

```bash
# 1) สร้างโฟลเดอร์เซิร์ฟเวอร์
mkdir -p ~/minecraft-mmo-dev/server/plugins
cd ~/minecraft-mmo-dev/server

# 2) ดาวน์โหลด Paper (เปิดหน้าเว็บก่อนเพื่อเอา build ที่เป็น STABLE และลิงก์จริง)
#    https://fill.papermc.io/v3/projects/paper/versions/26.3/builds
#    แล้วดาวน์โหลดไฟล์ paper-26.3-<build>.jar มาวางที่โฟลเดอร์นี้

# 3) ตรวจว่าไฟล์ไม่เสียหาย
unzip -t paper-26.3-<build>.jar | tail -1     # ต้องขึ้น "No errors detected"

# 4) ยอมรับ EULA — ต้องอ่านก่อน! (https://aka.ms/MinecraftEULA)
echo "eula=true" > eula.txt

# 5) คัดลอกไฟล์ตั้งค่าจากโปรเจกต์นี้ (ปรับพาธให้ตรงกับที่คุณวาง repo)
cp <repo>/Minecraft-MMO-Academy/projects/05-paper-server/server.properties .
cp <repo>/Minecraft-MMO-Academy/projects/05-paper-server/start.sh .
chmod 755 start.sh

# 6) ทดสอบว่าทุกอย่างพร้อม (ไม่เปิดเซิร์ฟเวอร์จริง)
./start.sh --test
```

> 💡 สิ่งสำคัญคือ **ชื่อไฟล์ต้องขึ้นต้นด้วย `paper-` และลงท้ายด้วย `.jar`** เพราะสคริปต์ใช้รูปแบบนี้หาไฟล์

---

## 3. เปิด-ปิดอย่างปลอดภัย

```bash
./start.sh                 # เปิดแบบเห็นข้อความสด ๆ (แนะนำครั้งแรก)
./start.sh --detach        # เปิดแบบเบื้องหลัง (งานจริงให้ใช้ tmux/screen แทน)
```

**การปิดที่ถูกต้อง (สำคัญมาก — ปิดผิดวิธีทำให้ข้อมูลเสียหาย):**

| วิธี | ทำอย่างไร | ผล |
| --- | --- | --- |
| ✅ ถูกที่สุด | พิมพ์ `stop` ในคอนโซลเซิร์ฟเวอร์ | บันทึกโลก + ปิดปลั๊กอินเรียบร้อย |
| ⚠️ พอใช้ | `Ctrl + C` | เซิร์ฟเวอร์หยุดตามลำดับ (ปกติ) |
| ❌ ห้าม | `kill -9 <PID>` | โลก/ข้อมูลอาจเสียหาย ต้องกู้จากสำรอง |

**คำสั่งคอนโซลที่ใช้บ่อย (พิมพ์ได้เลย ไม่ต้องมี `/`):**

| คำสั่ง | ทำอะไร |
| --- | --- |
| `list` | แสดงผู้เล่นออนไลน์ |
| `tps` | ดูค่า TPS (ควรใกล้ 20) |
| `plugins` | แสดงปลั๊กอินที่โหลดแล้ว (ต้องเห็น EclipseCore สีเขียว) |
| `whitelist add <ชื่อ>` | เพิ่มผู้เล่นเข้า whitelist |
| `save-all` | บันทึกโลกทันที |
| `version` | แสดงเวอร์ชันเซิร์ฟเวอร์ |

---

## 4. ไฟล์ในโปรเจกต์นี้

| ไฟล์ | หน้าที่ |
| --- | --- |
| `start.sh` | ตรวจสภาพแวดล้อมก่อนเปิด (Jar, Java 25, EULA, พอร์ต, พื้นที่) แล้วจึงเปิดเซิร์ฟเวอร์ |
| `server.properties` | ไฟล์ตั้งค่าตัวอย่างพร้อมคำอธิบาย — **ยึดไฟล์จริงที่ Paper สร้างเป็นหลัก** |
| `eula.txt.example` | ตัวอย่างการยอมรับ EULA (ห้ามใช้โดยไม่อ่านข้อตกลงจริง) |

> ⚠️ **อย่า commit ไฟล์ `server/`, `world/`, `eula.txt`, `logs/` ขึ้น Git** — `.gitignore` ของ repo กันไว้แล้ว
> ถ้าแก้ `.gitignore` ให้ตรวจซ้ำว่ายังกันไฟล์เหล่านี้อยู่

---

## 5. ปัญหาที่พบบ่อย

| อาการ | สาเหตุ | วิธีแก้ |
| --- | --- | --- |
| `You need to agree to the EULA` แล้วปิดตัวเอง | ยังไม่มี `eula.txt` หรือค่าผิด | อ่าน EULA แล้วตั้ง `eula=true` |
| `Unsupported Java version` | ใช้ Java 21 | เปลี่ยนเป็น Java 25 (`java -version` ต้องขึ้น 25) |
| `FAILED TO BIND TO PORT` | พอร์ตถูกใช้แล้ว | `ss -tulpn \| grep 25565` แล้วปิดตัวเก่า (อย่าเปิดซ้อน) |
| ปลั๊กอินไม่โหลด | ไฟล์ไม่ลงท้าย `.jar` หรือวางผิดที่ | ตรวจ `ls -l plugins/` และดู log |
| เซิร์ฟเวอร์ช้า/ถูกฆ่า (OOM) | RAM ไม่พอ | ลด `--ram` หรือปิดปลั๊กอินหนัก |

---

## 6. Checklist หลังตั้งเซิร์ฟเวอร์สำเร็จ

- [ ] เซิร์ฟเวอร์เริ่มทำงานโดยไม่มี ERROR ใน 60 วินาทีแรก
- [ ] `plugins` แสดง EclipseCore เป็นสีเขียว
- [ ] ผู้เล่น (บัญชีทดสอบ) เข้าได้ผ่าน whitelist
- [ ] `tps` ≈ 20
- [ ] ปิดด้วย `stop` แล้วเปิดใหม่ ข้อมูลโลกยังอยู่
- [ ] สำรองข้อมูลด้วย [01-linux-lab/scripts/backup.sh](../01-linux-lab/scripts/backup.sh) และทดสอบกู้คืน 1 ครั้ง
