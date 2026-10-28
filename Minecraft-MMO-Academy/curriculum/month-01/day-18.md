# Day 18: cron, tmux & รันเซิร์ฟเวอร์แบบ Background

> เป้าหมาย: รัน Paper แบบต่อเนื่อง + ทำ backup อัตโนมัติ
> เวลาที่ใช้: ~1–2 ชั่วโมง | ระดับ: เริ่มต้น–กลาง

## 1) แนวคิด
- **tmux/screen** = เปิด session ค้างไว้ แม้ปิด SSH
- **cron** = รันงานตามเวลา
- **crontab -e** = แก้ตารางงานของ user ปัจจุบัน

## 2) ลงมือทำ

### 2.1 tmux พื้นฐาน
```bash
tmux new -s mmo
# ภายใน tmux: รันเซิร์ฟเวอร์
# ถอยออก: Ctrl+b แล้ว d (detach)
tmux ls
tmux attach -t mmo
```

### 2.2 start.sh สำหรับ Paper
สร้าง `~/mmo-server/start.sh`:
```bash
#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
# ปรับ RAM ตามเครื่องจริง
java -Xms1G -Xmx1G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 \
  -jar paper.jar nogui
```
```bash
chmod +x start.sh
```

### 2.3 cron สำหรับ backup อัตโนมัติ
```bash
crontab -e
```
เพิ่มบรรทัด (ทุกวัน 03:00)
```cron
0 3 * * * /home/$USER/mmo-server/backup.sh >> /home/$USER/mmo-server/backup.log 2>&1
```

## 3) แบบฝึกหัด
- **ระดับ 1:** สร้าง tmux session และ attach กลับ
- **ระดับ 2:** เขียน cron รัน backup ทุก 6 ชั่วโมง
- **ระดับ 3:** อธิบายความต่าง tmux กับ nohup

## 4) Checklist
- [ ] รันเซิร์ฟเวอร์ใน tmux ได้
- [ ] start.sh ทำงาน
- [ ] cron ตั้งค่าได้และตรวจ log

## สรุป
tmux + cron คือพื้นฐาน DevOps สำหรับเกมเซิร์ฟเวอร์เล็ก

## Progress Update
- [x] Day 18 เสร็จ: cron + tmux + start.sh
