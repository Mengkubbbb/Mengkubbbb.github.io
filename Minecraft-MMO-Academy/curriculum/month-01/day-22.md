# Day 22: Permissions, OP, LuckPerms ภาพรวม

> เป้าหมาย: เข้าใจโมเดลสิทธิ์ใน Paper + แนวทางใช้งานจริง
> เวลาที่ใช้: ~1–2 ชั่วโมง | ระดับ: เริ่มต้น–กลาง

## 1) แนวคิด
- **OP** = สิทธิ์สูงสุด (ระวัง ใช้น้อยที่สุด)
- **Permission nodes** = เช่น `eclipse.admin`, `eclipse.stats`
- **Permission plugin** = จัดกลุ่ม role ได้ดีกว่า (LuckPerms นิยมมาก)

## 2) ทดสอบในปลั๊กอินของเรา
เรามีใน `plugin.yml`:
```yaml
permissions:
  eclipse.admin:
    description: เข้าถึงคำสั่งแอดมินของ EclipseCore
    default: op
  eclipse.stats:
    description: ดูสถิติของปลั๊กอิน
    default: true
```

ในโค้ดใช้ `.requires(source -> source.getSender().hasPermission(...))`

## 3) แบบฝึกหัด
- **ระดับ 1:** ทดสอบ `/eclipse admin` กับ OP และ non-OP
- **ระดับ 2:** เพิ่ม permission node ใหม่
- **ระดับ 3:** อธิบายทำไมไม่ควรให้ทุกคนเป็น OP

## 4) Checklist
- [ ] เข้าใจ default: op/true/false
- [ ] ทดสอบ requires() ได้
- [ ] รู้ความเสี่ยงของ OP

## สรุป
ออกแบบ permission ตั้งแต่แรกจะง่ายกว่าปรับทีหลังมาก

## Progress Update
- [x] Day 22 เสร็จ: Permissions Model
