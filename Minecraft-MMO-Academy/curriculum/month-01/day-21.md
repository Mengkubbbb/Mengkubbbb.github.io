# Day 21: Git พื้นฐานสำหรับโปรเจกต์ Plugin

> เป้าหมาย: ใช้ Git จัดการโค้ดปลั๊กอินอย่างเป็นระบบ
> เวลาที่ใช้: ~1–2 ชั่วโมง | ระดับ: เริ่มต้น

## 1) แนวคิด
- `git init` = เริ่ม repo
- `add/commit` = บันทึกเวอร์ชัน
- `.gitignore` = ไม่ commit ไฟล์ไม่จำเป็น
- `branch` = แยกงาน

## 2) ลงมือทำ

### 2.1 .gitignore สำหรับ Maven Plugin
ใน `projects/04-first-plugin/` สร้าง `.gitignore`:
```gitignore
target/
.idea/
*.iml
.vscode/
.DS_Store
```

### 2.2 คำสั่งพื้นฐาน
```bash
git init
git add .
git commit -m "feat: initial eclipse core plugin"
git log --oneline
```

## 3) แบบฝึกหัด
- **ระดับ 1:** init + commit โค้ดครั้งแรก
- **ระดับ 2:** แก้โค้ดแล้ว commit แยกตามคุณสมบัติ (feat/fix/chore)
- **ระดับ 3:** เขียน Conventional Commits สั้นๆ

## 4) Checklist
- [ ] ใช้ .gitignore ถูกต้อง
- [ ] commit มีข้อความมีความหมาย
- [ ] ดูประวัติได้

## สรุป
Git ช่วยให้ย้อนกลับได้เมื่อแก้พลาด

## Progress Update
- [x] Day 21 เสร็จ: Git พื้นฐาน
