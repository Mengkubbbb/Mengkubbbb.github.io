# Day 17: rsync, Backup Strategy & Folder Structure สำหรับ Paper

> เป้าหมาย: สร้างระบบ backup อย่างง่ายและปลอดภัย
> เวลาที่ใช้: ~1–2 ชั่วโมง | ระดับ: เริ่มต้น–กลาง

## 1) แนวคิด
- **world/** = แผนที่ผู้เล่น **ต้อง** สำรอง
- **plugins/** = ปลั๊กอิน + config ของปลั๊กอิน
- **server.properties, bukkit.yml, spigot.yml, paper-global.yml** = ค่าตั้งเซิร์ฟเวอร์
- **logs/** = มีประโยชน์แต่ใหญ่ — อาจไม่สำรองทุกครั้ง

## 2) ลงมือทำ

### 2.1 โครงสร้างแนะนำ
```text
~/mmo-server/
├── paper.jar
├── start.sh
├── plugins/
├── world/
├── world_nether/
├── world_the_end/
└── backups/
```

### 2.2 rsync เบื้องต้น
```bash
# สำรอง world + plugins + configs สำคัญ
rsync -avh --delete \
  world/ plugins/ server.properties bukkit.yml spigot.yml paper-global.yml paper-world-defaults.yml \
  backups/$(date +%Y%m%d-%H%M%S)/
```

> `--delete` ใช้ระวัง: มันจะลบไฟล์ในปลายทางที่ไม่มีในต้นทาง

### 2.3 สคริปต์ backup แบบปลอดภัย (dry-run)
สร้าง `backup.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail
SRC="$HOME/mmo-server"
DST="$HOME/mmo-server/backups/$(date +%F_%H-%M-%S)"
mkdir -p "$DST"
rsync -avh "$SRC/world" "$SRC/world_nether" "$SRC/world_the_end" "$SRC/plugins" "$SRC"/*.yml "$SRC"/*.properties "$DST/" 2>/dev/null || true
echo "[OK] Backup to $DST"
```

```bash
chmod +x backup.sh
./backup.sh
```

## 3) แบบฝึกหัด
- **ระดับ 1:** สร้างโฟลเดอร์ backups และรัน rsync
- **ระดับ 2:** เพิ่ม retention (ลบบีบีเก่ากว่า 7 วัน)
- **ระดับ 3:** เขียนเหตุผลทำไมไม่ควร backup `logs/` เต็มๆ ทุกชั่วโมง

## 4) Checklist
- [ ] แยกไฟล์สำคัญออกมาได้
- [ ] ใช้ rsync กับวันที่ได้
- [ ] เข้าใจ `--delete`

## สรุป
Backup ที่ใช้ได้จริงคือ backup ที่ **ทดสอบกู้คืน** ได้

## Progress Update
- [x] Day 17 เสร็จ: rsync + Backup Strategy
