# Day 23: อ่าน Log, Debug แบบเป็นระบบ

> เป้าหมาย: แก้ปัญหาจาก `latest.log` ได้โดยไม่เดา
> เวลาที่ใช้: ~1–2 ชั่วโมง | ระดับ: กลาง

## 1) แนวคิด
- **Stack trace** = แสดงคลาส/ไฟล์/บรรทัดที่ error
- **Caused by** = สาเหตุจริง
- **Plugin enabled/disabled** = สถานะปลั๊กอิน

## 2) ฝึกด้วยเหตุการณ์จริง
ดู log ตอนปลั๊กอินเราโหลด:
```text
[PluginInitializerManager] Bukkit plugins (1): EclipseCore (1.0.0)
[EclipseCore] Enabling EclipseCore v1.0.0
[EclipseCore] เปิด EclipseCore v1.0.0 บน Paper 26.3 / Java 25
```

## 3) เทคนิคค้นหา
```bash
grep -n "EclipseCore\|ERROR\|Exception" logs/latest.log | tail -30
```

## 4) แบบฝึกหัด
- **ระดับ 1:** หา 5 บรรทัดแรกที่เกี่ยวกับปลั๊กอินตัวเอง
- **ระดับ 2:** แยก WARNING กับ ERROR
- **ระดับ 3:** สร้าง template "Bug Report" สั้นๆ

## 5) Checklist
- [ ] อ่าน stack trace เบื้องต้นได้
- [ ] ใช้ grep กรอง log ได้
- [ ] ไม่ panic เมื่อเห็น ERROR

## สรุป
"อ่าน log ก่อนถาม" คือทักษะที่มีค่าที่สุด

## Progress Update
- [x] Day 23 เสร็จ: Log Reading & Debug
