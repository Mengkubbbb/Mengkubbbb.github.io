# Day 15: VS Code Workspace, Tasks & Extensions (สำหรับปลั๊กอิน Java)

> เป้าหมาย: จัดระเบียบ Workspace ให้พร้อมเขียนปลั๊กอิน Paper ด้วย VS Code + Java Extension Pack
> เวลาที่ใช้: ~1–2 ชั่วโมง | ระดับ: เริ่มต้น

## 1) สิ่งที่ต้องเตรียม
- [ ] ติดตั้ง VS Code
- [ ] ติดตั้ง Extension: `Extension Pack for Java` (Microsoft), `Debugger for Java`, `Maven for Java`, `Language Support for Java(TM) by Red Hat`
- [ ] มีโฟลเดอร์ `Minecraft-MMO-Academy/projects/04-first-plugin/` อยู่แล้ว

## 2) แนวคิด
- **Workspace** = โฟลเดอร์ที่ VS Code เปิดพร้อมการตั้งค่า
- **.vscode/settings.json** = ตั้งค่าท้องถิ่นสำหรับโปรเจกต์ (ไม่บังคับ commit ถ้ามีสิ่งเฉพาะเครื่อง)
- **tasks.json** = คำสั่ง build/run ที่กดปุ่มเดียวได้
- **Java Project View** = ดู dependencies, source, output ได้ง่าย

## 3) ลงมือทำ

### 3.1 สร้าง .vscode ในปลั๊กอินโปรเจกต์
สร้างโฟลเดอร์ `.vscode` ใน `projects/04-first-plugin/`

### 3.2 tasks.json (Build with Maven)
สร้างไฟล์ `.vscode/tasks.json`:

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "maven: package",
      "type": "shell",
      "command": "mvn",
      "args": ["-q", "clean", "package"],
      "group": {
        "kind": "build",
        "isDefault": true
      },
      "problemMatcher": ["$msCompile"]
    }
  ]
}
```

### 3.3 settings.json (เบื้องต้น)
สร้าง `.vscode/settings.json`:

```json
{
  "java.configuration.updateBuildConfiguration": "interactive",
  "files.exclude": {
    "**/target": true
  }
}
```

## 4) ทดสอบ
1. เปิด VS Code ที่ `projects/04-first-plugin/`
2. กด `Ctrl+Shift+B` (หรือ `Cmd+Shift+B`) → รัน `maven: package`
3. ดูไฟล์ `.jar` ใน `target/`

## 5) แบบฝึกหัด
- **ระดับ 1:** สร้าง tasks.json ให้ build ได้
- **ระดับ 2:** เพิ่ม task `mvn verify` แยกต่างหาก
- **ระดับ 3:** อธิบายเหตุผลที่ไม่ควร commit `.vscode/launch.json` ที่มีพาธเฉพาะเครื่อง

## 6) Checklist
- [ ] Extension Pack for Java ทำงาน
- [ ] Build ผ่านด้วย VS Code task
- [ ] Java Project View แสดงคลาสถูกต้อง

## สรุป
VS Code Workspace ช่วยให้ build/test ซ้ำได้เร็ว ลดความผิดพลาดจากการพิมพ์คำสั่ง

## Progress Update
- [x] Day 15 เสร็จ: จัด Workspace + Maven task
