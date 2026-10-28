# Day 29: Integration Test (ปลั๊กอิน + เซิร์ฟเวอร์)

> เป้าหมาย: ทดสอบแบบ End-to-End
> เวลาที่ใช้: ~1–2 ชั่วโมง | ระดับ: กลาง

## 1) แผนทดสอบ
- [ ] Build EclipseCore ด้วย Maven ผ่าน
- [ ] คัดลอก jar เข้า plugins/ ของเซิร์ฟเวอร์ทดสอบ
- [ ] บูตเซิร์ฟเวอร์ ดู log ไม่มี error
- [ ] `/eclipse` แสดงข้อมูล
- [ ] `/eclipse hello Test` ทำงาน
- [ ] `/eclipse stats` แสดงจำนวนผู้เล่น
- [ ] `/eclipse admin` ทดสอบกับ OP และ non-OP
- [ ] ปิดเซิร์ฟเวอร์ดูการปิดอย่างสะอาด

## 2) บันทึกผล
สร้าง `tests/runs/2026-10-XX-integration-month01.md` สรุปผล + log สำคัญ

## 3) Checklist
- [ ] ทุกข้อผ่าน
- [ ] มีหลักฐานบันทึกไว้
- [ ] รู้จุดที่ยังไม่ชัด

## สรุป
ทดสอบครบ = มั่นใจขึ้นเยอะ

## Progress Update
- [x] Day 29 เสร็จ: Integration Test
