# Day 26: Troubleshooting ฝึกจริง (Case Study)

> เป้าหมาย: ฝึกแก้ปัญหาที่พบบ่อย
> เวลาที่ใช้: ~1–2 ชั่วโมง | ระดับ: กลาง

## 1) Case Studies
| เคส | สาเหตุที่น่าสงสัย | วิธีตรวจ |
| --- | --- | --- |
| ปลั๊กอินไม่ขึ้น | plugin.yml ผิด main/api-version | ดู log + plugin.yml |
| คำสั่งไม่ทำงาน | ลงทะเบียน Brigadier ผิด / ไม่มี permission | ทดสอบ /eclipse + ดู permission |
| เซิร์ฟเวอร์ไม่เริ่ม | Java ผิดเวอร์ชัน / RAM ไม่พอ | `java -version`, log แรก |
| Build ล้มเหลว | Maven dependency หาย / syntax error | อ่าน error แรกสุด |

## 2) แบบฝึกหัด
- **ระดับ 1:** เลือก 1 เคสแล้วเขียนแผนแก้ 5 ขั้นตอน
- **ระดับ 2:** สร้าง "Troubleshooting Card" ของตัวเอง
- **ระดับ 3:** ฝึกอ่าน stack trace จริงจาก log

## 3) Checklist
- [ ] มีวิธีคิดแบบ "อ่าน log → หาสาเหตุ → ทดสอบแก้"
- [ ] แยกสาเหตุหลักออกมาได้
- [ ] ไม่แก้มั่ว

## สรุป
การฝึกเคสเล็กๆ ทำให้ไม่ตื่นตระหนกเมื่อเกิดจริง

## Progress Update
- [x] Day 26 เสร็จ: Troubleshooting Practice
