# Day 31: ทำความรู้จัก Java และโครงสร้างโปรเจกต์ Maven

> เป้าหมาย: เข้าใจว่า Java กับ Maven มีความสัมพันธ์อย่างไร
> เวลาที่ใช้: ~1–2 ชั่วโมง | ระดับ: เริ่มต้น

## 1) แนวคิด
- **JDK vs JRE** = JDK ใช้พัฒนา, JRE รัน
- **Maven** = จัดการ dependency + build
- **src/main/java** = โค้ดหลัก
- **pom.xml** = กำหนด dependency, version, Java version

## 2) ดู pom.xml ของ EclipseCore
เปิด `projects/04-first-plugin/pom.xml` สังเกต:
- `<maven.compiler.source>` / `<target>` (Java 21/25 ขึ้นกับการตั้งค่า)
- `paper-api` dependency scope `provided`

## 3) แบบฝึกหัด
- **ระดับ 1:** อธิบาย src/main/java vs src/main/resources
- **ระดับ 2:** หา Java version ที่ใช้
- **ระดับ 3:** อธิบายทำไม paper-api เป็น `provided`

## 4) Checklist
- [ ] เข้าใจโครงสร้าง Maven
- [ ] รู้ความแตกต่าง JDK/JRE
- [ ] อ่าน pom.xml ได้เบื้องต้น

## สรุป
Maven ช่วยให้เรารวม dependency ได้โดยไม่ต้องดาวน์โหลดไฟล์ jar เอง

## Progress Update
- [x] Day 31 เสร็จ: Java + Maven Intro
