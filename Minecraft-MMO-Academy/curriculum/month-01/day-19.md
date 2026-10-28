# Day 19: Java Flags, G1GC & Performance เบื้องต้น

> เป้าหมาย: เข้าใจ JVM args ที่เหมาะกับ Paper เล็กๆ
> เวลาที่ใช้: ~1–2 ชั่วโมง | ระดับ: กลาง

## 1) แนวคิด
- **Xms/Xmx** = หน่วยความจำเริ่มต้น/สูงสุด
- **G1GC** = Garbage Collector ที่เหมาะกับ Minecraft ส่วนใหญ่
- **Aikar's flags** = ชุด flags ที่ใช้กันอย่างแพร่หลาย (ศึกษาเพื่อเข้าใจ ไม่ต้อง copy ทุกอย่างแบบไม่รู้เหตุผล)

## 2) ตัวอย่างเริ่มต้น (ปลอดภัย)
```bash
java -Xms1024M -Xmx1024M \
  -XX:+UseG1GC \
  -XX:+ParallelRefProcEnabled \
  -XX:MaxGCPauseMillis=200 \
  -XX:+UnlockExperimentalVMOptions \
  -XX:+DisableExplicitGC \
  -XX:+AlwaysPreTouch \
  -jar paper.jar nogui
```

## 3) กฎง่ายๆ
- ตั้ง Xms = Xmx เพื่อลดการขยาย heap
- อย่าให้ Xmx เกิน RAM ที่เหลือให้ OS ใช้
- ถ้า RAM < 4GB ให้ระวัง flags ซับซ้อนเกินไป

## 4) แบบฝึกหัด
- **ระดับ 1:** เปรียบเทียบ RAM 1GB vs 2GB
- **ระดับ 2:** ดู GC log แบบเบื้องต้น
- **ระดับ 3:** อธิบายทำไมควร `nogui`

## 5) Checklist
- [ ] เข้าใจ Xms/Xmx
- [ ] รู้เหตุผลใช้ G1GC
- [ ] ปรับ RAM ตามเครื่องจริงได้

## สรุป
"เร็วพอใช้" ดีกว่า "ปรับจนสับสน" สำหรับมือใหม่

## Progress Update
- [x] Day 19 เสร็จ: Java Flags & G1GC
