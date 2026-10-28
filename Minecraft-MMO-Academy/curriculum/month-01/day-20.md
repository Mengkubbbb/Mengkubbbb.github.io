# Day 20: server.properties, bukkit.yml, spigot.yml, paper.yml พื้นฐาน

> เป้าหมาย: อ่านและปรับ config หลักให้เหมาะกับเซิร์ฟเวอร์ทดสอบ
> เวลาที่ใช้: ~1–2 ชั่วโมง | ระดับ: เริ่มต้น–กลาง

## 1) ไฟล์สำคัญ
| ไฟล์ | ใช้เมื่อ |
| --- | --- |
| `server.properties` | Vanilla/Minecraft พื้นฐาน (gamemode, difficulty, motd, online-mode) |
| `bukkit.yml` | Spawn-limits, ticks-per, settings ทั่วไป |
| `spigot.yml` | View-distance, entity limits, ticks |
| `paper-global.yml` / `paper-world-defaults.yml` | Paper เฉพาะ (performance/features) |

## 2) ค่าที่ควรรู้สำหรับทดสอบ
- `online-mode=true` = ต้องมี Mojang/Microsoft auth (ปล่อยสาธารณะควรเป็น true)
- `motd` = ข้อความตอน ping
- `max-players` = จำกัดผู้เล่น
- `spawn-protection` = ป้องกัน spawn

## 3) แบบฝึกหัด
- **ระดับ 1:** แก้ `motd` และ `max-players`
- **ระดับ 2:** สำรวจแต่ละไฟล์หาคำที่ไม่เข้าใจแล้วค้นหาเหตุผล
- **ระดับ 3:** สร้าง `config-notes.md` สรุป 5 ค่าที่สำคัญที่สุด

## 4) Checklist
- [ ] อ่าน server.properties ได้
- [ ] เข้าใจความแตกต่างแต่ละไฟล์
- [ ] แก้ MOTD สำเร็จ

## สรุป
อ่าน config ดีกว่าคัดลอกทั้งก้อนโดยไม่เข้าใจ

## Progress Update
- [x] Day 20 เสร็จ: Core Server Config
