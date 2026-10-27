# KNOWLEDGE-MAP.md — แผนที่ความรู้

> 🧠 เอกสารนี้ตอบคำถามว่า **"ทักษะไหนต้องมาก่อน และทักษะไหนต่อยอดจากอะไร"**
> ใช้เมื่อสับสนว่าตอนนี้ควรเรียนอะไร หรือเมื่อเจอปัญหาที่ต้องใช้ความรู้หลายด้านพร้อมกัน

---

## 1. แผนที่หลัก (เส้นทางการพึ่งพาความรู้)

```mermaid
flowchart LR
    subgraph BASE["พื้นฐาน (Month 1-2)"]
        L[Linux / Terminal]
        F[ระบบไฟล์ & สิทธิ์]
        S[Shell script]
        LG[ตรรกะโปรแกรม]
    end
    subgraph JAVA["ภาษาและเครื่องมือ (Month 3-5)"]
        J[Java Fundamentals]
        OOP[OOP & Design]
        T[Testing / JUnit]
        G[Git]
        B[Gradle / Build]
    end
    subgraph MC["Minecraft (Month 5-7)"]
        P[Paper Plugin]
        EV[Event / Command / Config]
        ADM[Server Admin]
        RP[Resource Pack / Models]
    end
    subgraph MMO["ระบบเกม (Month 8-11)"]
        DB[(Database)]
        IT[Item System]
        CB[Combat / Skill]
        MG[Magic]
        WD[Dungeon / Quest / Party]
        EC[Economy]
        SEC[Security]
        OPS[Monitoring / Deploy]
    end
    L --> F --> S --> LG
    LG --> J --> OOP --> P
    J --> T
    G --> B --> P
    P --> EV --> IT
    P --> ADM
    ADM --> RP
    EV --> DB --> IT
    DB --> EC
    IT --> CB --> MG
    CB --> WD
    EC --> SEC
    ADM --> OPS

    style BASE fill:#0f2a1d,color:#d1fae5
    style JAVA fill:#1e1b4b,color:#e0e7ff
    style MC fill:#3f1d1d,color:#fee2e2
    style MMO fill:#3b2f07,color:#fef3c7
```

**อ่านแผนที่นี้อย่างไร:** ลูกศรหมายถึง "ต้องมีก่อน" เช่น `Paper Plugin → Event/Command` แปลว่า
ถ้ายังไม่เข้าใจวงจรชีวิตของปลั๊กอิน จะเขียน event ให้ทำงานถูกต้องไม่ได้

---

## 2. แต่ละสาขาเชื่อมกับโปรเจกต์จริงอย่างไร

| ความรู้ | ใช้ในโปรเจกต์ตรงไหน | ตัวอย่างงานจริง |
| --- | --- | --- |
| Linux / Terminal | รันเซิร์ฟเวอร์, ดู log, backup | `./gradlew build`, `tail -f logs/latest.log` |
| Shell script | ระบบเปิด-ปิด-สำรองเซิร์ฟเวอร์ | `scripts/server-start.sh`, `scripts/backup.sh` |
| ตรรกะโปรแกรม | สูตรดาเมจ, ตารางดรอป, เงื่อนไขเควส | `if (roll <= dropChance)` |
| Java | ทุกอย่างในปลั๊กอิน | คลาส `EclipseCore`, `PlayerProfile` |
| OOP & Design | แยกระบบให้ขยายได้ | `interface Skill`, `Registry<Item>` |
| Testing | กันบั๊กกลับมา | `DamageCalculatorTest` |
| Git | ย้อนดูว่าเมื่อไรพัง, ทำงานหลายสาขา | `git log`, `git revert` |
| Gradle | คอมไพล์ + แพ็ก `.jar` | `./gradlew shadowJar` |
| Paper Plugin | ตัวปลั๊กอินเอง | `plugin.yml`, `onEnable()` |
| Event/Command/Config | ทุกปฏิสัมพันธ์กับผู้เล่น | `PlayerJoinEvent`, `/eclipse stats` |
| Server Admin | ดูแลเซิร์ฟเวอร์จริง | `server.properties`, whitelist |
| Resource Pack | หน้าตาเกม | texture ไอเทม, HUD |
| Database | ข้อมูลไม่หาย | ตาราง `player_profile`, `player_item` |
| Item System | ไอเทม/อุปกรณ์ | rarity, affix, upgrade |
| Combat/Skill | ความสนุกหลักของเกม | cooldown, status effect |
| Magic | ความลึกเชิงกลยุทธ์ | ธาตุ + elemental reaction |
| Dungeon/Quest | เป้าหมายให้เล่นต่อ | เควส, บอส, รางวัล |
| Economy | ระบบเงินและตลาด | auction house, transaction |
| Security | กันการโกง/ Abuse | anti-dupe, permission check |
| Ops | เปิดบริการได้จริง | backup, monitoring, runbook |

---

## 3. ลำดับที่ห้ามสลับ (Hard dependencies)

```mermaid
flowchart TD
    A["Java คลาส/เมธอด"] --> B["Plugin lifecycle"]
    B --> C["Event listener"]
    C --> D["Command + permission"]
    D --> E["Config (YAML)"]
    E --> F["ไอเทมจาก config"]
    F --> G["บันทึกไอเทมลง DB"]
    G --> H["ระบบต่อสู้ที่ใช้ค่าจากไอเทม"]
    H --> I["ดันเจี้ยน/บอส"]
    I --> J["เศรษฐกิจ"]
    J --> K["Security audit + เปิด Beta"]
```

> ⚠️ ถ้าเจอปัญหาที่ Month 9 แต่พื้นฐาน Month 4 ยังไม่แน่น (เช่นไม่เข้าใจ interface)
> ให้ **ถอยไปทบทวน Month 4 ก่อน 1–2 วัน** — เร็วกว่าไล่แก้บั๊กที่เกิดจากความเข้าใจไม่พอ

---

## 4. แผนที่แบบ "สิ่งที่ต้องทำได้" (Skill Tree)

| ระดับ | ชื่อ | ทำอะไรได้ | ผ่านเมื่อ |
| --- | --- | --- | --- |
| 0 | Explorer | เปิด Terminal, หาไฟล์เป็น, รันคำสั่งพื้นฐานได้ | Day 30 |
| 1 | Script Writer | เขียน script ที่รับ input และทำงานซ้ำได้ | Day 30 |
| 2 | Programmer | เขียนลูป/เงื่อนไข/ฟังก์ชันแก้ปัญหาได้ | Day 60 |
| 3 | Java Beginner | เขียนคลาสและคอมไพล์ด้วย Gradle ได้ | Day 90 |
| 4 | Java Developer | ออกแบบคลาส, เขียนเทสต์, ใช้ collection ถูกงาน | Day 120 |
| 5 | Plugin Developer | เขียนปลั๊กอินที่มี event/command/config ได้ | Day 180 |
| 6 | Server Operator | ติดตั้ง+ดูแลเซิร์ฟเวอร์+กู้คืนข้อมูลได้ | Day 210 |
| 7 | Systems Developer | ระบบข้อมูล/ไอเทม/ต่อสู้ที่ทดสอบได้ | Day 240 |
| 8 | Game Systems Designer | ออกแบบและปรับสมดุลระบบเกมด้วยข้อมูล | Day 300 |
| 9 | MMO Operator | เปิด Beta, ดูแลผู้เล่น, วางแผนธุรกิจอย่างมีความรับผิดชอบ | Day 365 |

---

## 5. หัวข้อที่ "ดูเหมือนข้ามได้" แต่ไม่ควรข้าม

| หัวข้อ | ถ้าข้ามจะเป็นอย่างไร |
| --- | --- |
| สิทธิ์ไฟล์ (`chmod`) | script รันไม่ได้ หรือแก้ไฟล์ระบบจนพัง |
| `PATH` | คำสั่ง `java`/`gradle` ใช้ไม่ได้ ทั้งที่ติดตั้งแล้ว |
| Exception handling | ปลั๊กอินล่มทั้งเซิร์ฟเวอร์เพราะข้อมูลผิด 1 แถว |
| Transaction (DB) | เงิน/ไอเทมงอกหรือหายแบบสุ่ม หาสาเหตุไม่ได้ |
| Logging | หาสาเหตุ crash ไม่ได้เลย เพราะไม่มีข้อมูล |
| Backup + Restore test | คิดว่ามี backup แต่กู้คืนไม่ได้ตอนจำเป็น |
| Permission | ผู้เล่นธรรมดาใช้คำสั่งแอดมินได้ → หายนะ |
