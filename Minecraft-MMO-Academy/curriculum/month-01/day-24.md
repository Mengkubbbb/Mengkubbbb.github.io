# Day 24: Testing Workflow (Local Test Cycle)

> เป้าหมาย: สร้างวงจรทดสอบที่เร็วและซ้ำได้
> เวลาที่ใช้: ~1–2 ชั่วโมง | ระดับ: กลาง

## 1) วงจรแนะนำ
1. แก้โค้ดใน VS Code
2. `mvn clean package` → ได้ `.jar`
3. คัดลอกไป `plugins/` (หรือใช้ symlink)
4. รีโหลด/รีสตาร์ทเซิร์ฟเวอร์ทดสอบ
5. ทดสอบคำสั่ง + permission
6. ดู log ถ้ามีปัญหา

## 2) สคริปต์ copy ง่ายๆ
```bash
#!/usr/bin/env bash
JAR=$(ls target/*.jar | head -n1)
cp "$JAR" ~/mmo-test/plugins/
echo "Copied $JAR"
```

## 3) แบบฝึกหัด
- **ระดับ 1:** ทำตามวงจรครบ 1 รอบ
- **ระดับ 2:** ลดเวลาวงจรให้เหลือน้อยที่สุดเท่าที่เป็นไปได้
- **ระดับ 3:** บันทึก checklist การทดสอบของตัวเอง

## 4) Checklist
- [ ] วงจรทดสอบชัดเจน
- [ ] คัดลอก jar ถูกต้อง
- [ ] ทดสอบหลัง deploy ในเซิร์ฟเวอร์ทดสอบ

## สรุป
ทดสอบเร็ว = เรียนเร็วขึ้นมาก

## Progress Update
- [x] Day 24 เสร็จ: Test Workflow
