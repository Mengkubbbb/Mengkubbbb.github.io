# Day 25: รวมทุกอย่างเข้าด้วยกัน (Mini Project)

> เป้าหมาย: สร้าง "Dev Kit" สำหรับตัวเอง
> เวลาที่ใช้: ~2–3 ชั่วโมง | ระดับ: กลาง

## 1) สิ่งที่ต้องทำ
สร้างโฟลเดอร์ `~/devkit-mmo/` มีไฟล์ดังนี้:

- [ ] `start.sh` (รัน Paper)
- [ ] `backup.sh` (backup world+plugins+configs)
- [ ] `deploy-plugin.sh` (build + copy jar)
- [ ] `README.md` (อธิบายวิธีใช้แต่ละไฟล์)
- [ ] `tmux-notes.md` (คำสั่ง tmux ที่ใช้บ่อย)

## 2) ข้อกำหนด
- ใช้ `set -euo pipefail`
- มี comment สั้นๆ เข้าใจง่าย
- ทดสอบรันได้จริง

## 3) แบบฝึกหัด
- **ระดับ 1:** ทำให้ครบทุกไฟล์
- **ระดับ 2:** เพิ่ม `--dry-run` ให้ backup
- **ระดับ 3:** เขียน usage: `./deploy-plugin.sh --help`

## 4) Checklist
- [ ] Dev Kit ใช้งานได้
- [ ] แต่ละสคริปต์มีหน้าที่ชัดเจน
- [ ] README ครอบคลุมพอให้ตัวเองกลับมาทำได้ใน 2 สัปดาห์

## สรุป
"สร้างอุปกรณ์ให้ตัวเอง" ดีกว่าจำทุกคำสั่ง

## Progress Update
- [x] Day 25 เสร็จ: Mini Project Dev Kit
