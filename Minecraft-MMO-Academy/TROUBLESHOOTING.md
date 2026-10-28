# TROUBLESHOOTING.md — รวมปัญหาและวิธีแก้ที่ใช้ได้จริง

> 🔧 หัวใจของไฟล์นี้ไม่ใช่ "คำตอบ" แต่คือ **วิธีหาสาเหตุ**
> หลักสูตรนี้จะให้คุณอ่าน error เองก่อน แล้วค่อยเทียบกับตารางนี้

---

## 1. วิธีดีบัก 7 ขั้น (ใช้ทุกครั้งที่เจอ error)

1. **อ่านข้อความ error ให้จบ** — บรรทัดสำคัญมักอยู่บรรทัดแรก (สาเหตุ) และบรรทัดที่มีชื่อไฟล์+เลขบรรทัดของเรา
2. **แยกสาเหตุที่เป็นไปได้** เขียนออกมา 2–3 ข้อ (เช่น ติดตั้งไม่ครบ / พาธผิด / สิทธิ์ไม่พอ)
3. **เก็บข้อมูลจริง** — รันคำสั่งซ้ำ, ดูเวอร์ชัน (`java -version`), ดูพาธ (`pwd`, `ls`)
4. **ทดสอบสมมติฐานทีละข้อ** — เปลี่ยนเพียงอย่างเดียวต่อครั้ง
5. **แก้** แล้วรันคำสั่งเดิมซ้ำเพื่อดูว่า error หายจริง
6. **ทดสอบว่าของยังทำงานปกติ** (ไม่ใช่แค่ error หาย)
7. **บันทึก** ลงไฟล์นี้ + [PROGRESS.md](PROGRESS.md) ว่าอะไรเป็นสาเหตุจริง

> ⚠️ ห้ามแก้โค้ดหลายส่วนพร้อมกันโดยไม่รู้สาเหตุ — ถ้าอาการเปลี่ยนเราจะไม่รู้ว่าอะไรทำให้เปลี่ยน

---

## 2. ปัญหาช่วง Day 01–07 (Terminal / เครื่องมือ)

| อาการ | สาเหตุที่เป็นไปได้ | วิธีตรวจสอบ | วิธีแก้ |
| --- | --- | --- | --- |
| `command not found: java` | ยังไม่ติดตั้ง JDK หรือติดตั้งแล้วแต่ไม่อยู่ใน `PATH` | `which java`, `echo $PATH`, `ls /usr/lib/jvm` | ติดตั้ง JDK 25 แล้วเพิ่มลง `PATH` หรือใช้ absolute path ชั่วคราว |
| `Permission denied` ตอนรัน `./script.sh` | ไฟล์ไม่มีสิทธิ์รัน | `ls -l script.sh` (ดูว่ามี `x` ไหม) | `chmod +x script.sh` แล้วรันใหม่ |
| `bash: ./script.sh: /bin/bash^M: bad interpreter` | ไฟล์ถูกบันทึกแบบ CRLF (Windows) | `file script.sh` | เปลี่ยนเป็น LF: `sed -i 's/\r$//' script.sh` |
| `No such file or directory` | พาธผิด หรือชื่อไฟล์พิมพ์ผิดตัวพิมพ์ | `pwd`, `ls -l` โฟลเดอร์นั้น | แก้พาธ; ระวังตัวพิมพ์เล็ก-ใหญ่ |
| ข้อความไทยแสดงเป็น `?????` | locale ไม่รองรับ UTF-8 | `locale` | ตั้ง `LANG=th_TH.UTF-8` หรือ `C.UTF-8` ใน `~/.bashrc` |
| `rm` ลบผิดโฟลเดอร์แล้ว | พิมพ์พาธผิด | `ls` ก่อนลบทุกครั้ง | กู้จาก Git (`git restore`) หรือ backup; บทเรียน: ใช้ `rm -i` |
| `No space left on device` | ดิสก์เต็ม | `df -h`, `du -sh *` | ลบไฟล์ build/log เก่า (`build/`, `logs/*.gz`) |
| แก้ `~/.bashrc` แล้วไม่มีผล | ยังไม่โหลดไฟล์ใหม่ | `echo $PATH` ยังไม่มีของใหม่ | `source ~/.bashrc` หรือเปิด Terminal ใหม่ |

---

## 2.1 ปัญหา Paper / ปลั๊กอิน (จากการทดสอบจริง 28 ตุลาคม 2026)

| อาการ | สาเหตุจริง | วิธีแก้ |
| --- | --- | --- |
| ดาวน์โหลด Paper ได้ HTTP **410 Gone** | PaperMC ปิด Downloads API v2 แล้ว | ใช้ fill v3: `https://fill.papermc.io/v3/projects/paper/versions/26.3/builds/226` แล้วดึง `downloads["server:default"].url` (ห้ามเดาชื่อไฟล์) |
| เปิดเซิร์ฟเวอร์แล้วขึ้น `You need to agree to the EULA` | ยังไม่มี `eula.txt` หรือค่าเป็น `false` | อ่าน EULA ที่ https://aka.ms/MinecraftEULA แล้ว `echo "eula=true" > eula.txt` (เฉพาะเซิร์ฟเวอร์ส่วนตัว/ทดสอบ) |
| `UnsupportedClassVersionError` หรือบูตไม่ขึ้น | ใช้ Java 21 กับ Paper 26.1+ | Paper 26.1+ ต้องการ **Java 25** — `java -version` ต้องเป็น 25.x |
| `ERROR]: No key layers in MapLike[{}]` | ตั้ง `level-type=minecraft:flat` แต่ไม่ระบุ generator settings — เป็นข้อความของ worldgen ไม่ใช่ปลั๊กอิน | ไม่กระทบการโหลดปลั๊กอิน; ใช้โลกปกติหรือระบุ `generator-settings` ให้ครบ |
| ปลั๊กอินไม่โหลด แต่ไม่มี error ชัด ๆ | `api-version` ใน `plugin.yml` ไม่ตรงกับเซิร์ฟเวอร์ หรือ `main:` ชี้คลาสผิด | ดู log ช่วง `Loading server plugin` → ต้องตรงกับ `api-version: '26.3'` และชื่อคลาสเต็ม |
| ปลั๊กอินโหลดแต่ build ไม่ได้ | เรียก `Commands.literal(...)` ผ่านตัวแปร (static method ของ interface) | เรียกผ่านชื่อ interface: `Commands.literal(...)` — เจอจริงและแก้แล้ว |
| `/eclipse` ใช้ไม่ได้ทั้งที่ปลั๊กอินโหลด | ลงทะเบียนคำสั่งใน `onEnable()` ไม่สำเร็จ หรือประกาศซ้ำใน `commands:` ของ `plugin.yml` | ใช้ Brigadier ผ่าน `LifecycleEvents.COMMANDS` ที่เดียว (อย่าประกาศทั้งสองที่) |
| เซิร์ฟเวอร์กิน RAM จนเครื่องค้าง | `-Xmx` ตั้งชิด RAM ทั้งเครื่อง | ให้ heap ~50–60% ของ RAM ทั้งหมด เช่นเครื่อง 8 GB → `-Xmx4G` |
| ปิดเซิร์ฟเวอร์ด้วย Ctrl+C แล้วโลกเสีย | ไม่ได้ใช้คำสั่ง `stop` | พิมพ์ `stop` ในคอนโซล (หรือ `screen`/`tmux` แล้วส่ง `stop`) เสมอ |

> 🔎 **อ่าน log ให้เป็น:** `Loading server plugin X` = โหลดคลาส, `Enabling X` = `onEnable()` ทำงาน,
> `Disabling X` = `onDisable()` ทำงาน — ถ้ามี Loading แต่ไม่มี Enabling แปลว่า `onEnable()` โยน exception

---

## 3. ปัญหา Git

| อาการ | สาเหตุ | วิธีแก้ |
| --- | --- | --- |
| `fatal: not a git repository` | รันในโฟลเดอร์ที่ยังไม่ `git init` หรืออยู่ผิดโฟลเดอร์ | `git rev-parse --show-toplevel`; `cd` ไปโฟลเดอร์ที่ถูก |
| `CONFLICT (content): Merge conflict in file` | แก้ไฟล์เดียวกันสองที่ | เปิดไฟล์ แก้ส่วน `<<<<<<< ======= >>>>>>>` แล้ว `git add` + `git commit` |
| `Please tell me who you are` | ยังไม่ตั้งชื่อ/อีเมล | `git config --global user.name "..."`, `user.email "..."` |
| commit แล้วมีไฟล์แปลก ๆ ติดไปด้วย | ไม่มี `.gitignore` | เพิ่ม `build/`, `*.jar`, `.env`, `logs/` |
| เผลอ commit รหัสผ่าน | ไฟล์ลับเข้า repo แล้ว | เปลี่ยนรหัสทันที + ลบไฟล์ + เพิ่ม `.gitignore` (ประวัติยังมีอยู่ ต้องแจ้งครู) |
| `remote: Support for password authentication was removed` | ใช้รหัสผ่านแทนโทเคน/คีย์ | ตั้ง SSH key (Day 17) หรือใช้โทเคน |

---

## 4. ปัญหา Java / Gradle

| อาการ | สาเหตุ | วิธีแก้ |
| --- | --- | --- |
| `error: cannot find symbol` | พิมพ์ชื่อคลาส/เมธอดผิด หรือไม่ได้ import | ดูบรรทัดที่ error ระบุ ตรวจ import |
| `class X is public, should be declared in a file named X.java` | ชื่อไฟล์ไม่ตรงชื่อคลาส public | เปลี่ยนชื่อไฟล์ให้ตรง |
| `Could not find or load main class` | คลาส `main` ผิดแพ็กเกจ/พาธ หรือ classpath ผิด | รันจากโฟลเดอร์ที่ถูก หรือใช้ `java -cp ...` |
| `Unsupported class file major version 69` | ใช้ Java เก่ากว่าที่ไลบรารีต้องการ | ต้องใช้ JDK 25: ตรวจ `java -version` และ `JAVA_HOME` |
| `Could not resolve io.papermc.paper:paper-api:...` | ยังไม่ประกาศ repository หรือเวอร์ชันไม่มีจริง | เพิ่ม `maven { url = uri("https://repo.papermc.io/repository/maven-public/") }` และตรวจชื่อเวอร์ชันจาก metadata |
| `./gradlew: command not found` | ยังไม่มี wrapper ในโปรเจกต์ | รัน `gradle wrapper` ด้วย Gradle ที่ติดตั้ง หรือก๊อปไฟล์ `gradlew` + `gradle/wrapper/` |
| `Deprecated Gradle features were used` | โค้ด build ใช้รูปแบบเก่า | เป็นคำเตือน ไม่ใช่ error — อ่านว่าอะไรเก่าแล้วค่อยปรับ |
| build ค้างนานผิดปกติ | ดาวน์โหลด dependency ครั้งแรก (ปกติ) | รอครั้งเดียว; ครั้งต่อไปเร็วขึ้น |

---

## 5. ปัญหาเซิร์ฟเวอร์ Paper

| อาการ | สาเหตุ | วิธีแก้ |
| --- | --- | --- |
| `You need to agree to the EULA` | ยังไม่ตั้ง `eula=true` | อ่าน EULA ก่อน แล้วแก้ `eula.txt` เป็น `eula=true` |
| `FAILED TO BIND TO PORT` | มีเซิร์ฟเวอร์รันอยู่แล้ว หรือพอร์ตถูกใช้ | `ss -tulpn \| grep 25565` แล้วปิดตัวเก่า หรือเปลี่ยนพอร์ต |
| `Unsupported Java version` | ใช้ Java 21 กับ Paper 26.x | เปลี่ยนเป็น Java 25 (`java -version` ต้องขึ้น 25) |
| เซิร์ฟเวอร์ถูกฆ่า (process ดับเอง) | RAM ไม่พอ (OOM) | ลด `-Xmx`, ปิดปลั๊กอินหนัก, เพิ่ม RAM เครื่อง |
| ปลั๊กอินไม่โหลด แต่ไม่มี error | ชื่อไฟล์ไม่ลงท้าย `.jar` หรือวางผิดโฟลเดอร์ | วางใน `plugins/` และดู log ว่าโหลดถึงบรรทัดไหน |
| `Could not load plugin ... Unsupported API version` | `api-version` ไม่ตรงกับเซิร์ฟเวอร์ | แก้ `plugin.yml` ให้ตรง หรืออัปเดตปลั๊กอิน |
| ผู้เล่นเข้าไม่ได้ แต่ log ปกติ | firewall/พอร์ตไม่ถูกเปิด หรือ IP ผิด | ตรวจ firewall + แชร์ IP ให้ถูก (`ip -4 a`) |
| `Kicked: You are not whitelisted` | whitelist เปิดอยู่ | เพิ่มชื่อใน `whitelist.json` หรือปิด whitelist เฉพาะช่วงทดสอบ |
| ข้อมูลในโลกหายหลังรีสตาร์ท | ปิดเซิร์ฟเวอร์แบบ `kill -9` หรือดิสก์เต็ม | ปิดด้วย `stop`; เตรียมแผน backup ใหม่ |
| TPS ต่ำกว่า 19 | entity เยอะ, chunk เยอะ, ปลั๊กอินหนัก | วัดด้วย spark/timings แล้วหาจุดหนัก |

---

## 6. ปัญหาฐานข้อมูล (Month 8+)

| อาการ | สาเหตุ | วิธีแก้ |
| --- | --- | --- |
| `Access denied for user` | ชื่อผู้ใช้/รหัสผ่าน/สิทธิ์ผิด | ตรวจไฟล์ตั้งค่า และสิทธิ์ผู้ใช้ใน DB |
| `Public Key Retrieval is not allowed` | ไดรเวอร์ MySQL ปฏิเสธการเชื่อมต่อแบบไม่เข้ารหัส | เพิ่ม `allowPublicKeyRetrieval=true` **เฉพาะเครื่องทดสอบ** |
| ข้อมูลหายหลังรีสตาร์ท | บันทึกแค่ใน memory หรือ transaction ไม่ commit | ตรวจว่ามี `INSERT/UPDATE` จริง และ commit แล้ว |
| เงินงอก/หาย | ไม่มี transaction หรือมี race condition | ห่อด้วย transaction + ตรวจยอดซ้ำ |
| ผู้เล่นแก้ข้อมูลในฐานข้อมูลได้เอง (หรือข้อมูลเพี้ยน) | ต่อสตริงจาก input ผู้เล่นเข้าไปในคำสั่ง SQL | ใช้ `PreparedStatement` เสมอ + ตรวจค่าในช่วงที่ถูกต้อง |

---

## 7. ปัญหา Resource Pack (Month 7+)

| อาการ | สาเหตุ | วิธีแก้ |
| --- | --- | --- |
| pack ไม่แสดงผล | โครงสร้างโฟลเดอร์ผิด หรือ `pack.mcmeta` เสีย | ตรวจว่า ZIP มี `pack.mcmeta` อยู่ชั้นบนสุด |
| pack ขึ้นว่าใช้ไม่ได้ (incompatible) | `pack_format` ไม่ตรงเวอร์ชันไคลเอนต์ | ตรวจค่า `pack_format` ที่ถูกต้องของเวอร์ชันนั้น แล้วแก้ |
| โมเดลไอเทมไม่เปลี่ยน | Custom Model Data ไม่ตรงกับที่ปลั๊กอินตั้ง | เทียบตัวเลขในปลั๊กอินกับ `custom_model_data` ในโมเดล |
| ผู้เล่นโหลด pack ไม่ได้ | URL ผิด / ไฟล์ใหญ่เกิน / SHA1 ไม่ตรง | ตรวจ URL ในเบราว์เซอร์ + เทียบ SHA1 (`sha1sum`) |

---

## 8. คลังของตัวเอง (เพิ่มทุกครั้งที่เจอปัญหาใหม่)

| วันที่ | Error / อาการ | สาเหตุจริงที่พบ | วิธีแก้ | เวลาที่ใช้ |
| --- | --- | --- | --- | --- |
|  |  |  |  |  |

---

## 9. เคสจริงที่เจอระหว่างพัฒนาหลักสูตรนี้ (บันทึกไว้เป็นบทเรียน)

> เคสเหล่านี้ **เกิดขึ้นจริง** ระหว่างทดสอบโปรเจกต์ในหลักสูตร และวิธีแก้ใช้ได้จริง

| Error / อาการ | สาเหตุจริง | วิธีหาสาเหตุ | วิธีแก้ |
| --- | --- | --- | --- |
| `error: illegal static interface method call` (5 จุด) | เรียก `Commands.literal(...)` ซึ่งเป็น **static method ของ interface** ผ่านตัวแปร `commands` | อ่านบรรทัดที่ error ระบุ แล้วดู declaration ของเมธอดนั้น | เรียกผ่านชื่อ interface: `Commands.literal(...)` ส่วน `commands.register(...)` (instance method) เรียกผ่านตัวแปรได้ |
| ไม่แน่ใจว่าเมธอดของ library เรียกอย่างไร | เดาจากตัวอย่างในอินเทอร์เน็ต (มักเป็นเวอร์ชันเก่า) | ดูลายเซ็นจริงจาก `.jar` ด้วย `javap -cp <jar> <คลาส>` | ใช้ `javap` เป็นเครื่องมือประจำตัว: ตรวจ API จริงก่อนเขียนโค้ด ไม่ต้องเดา |
| `bash: $1: unbound variable` | ใช้ `set -u` แล้วอ้าง `$1` ทั้งที่ผู้ใช้ไม่ได้ใส่อาร์กิวเมนต์ | รันโดยไม่ใส่อาร์กิวเมนต์ เพื่อจำลอง | ใช้ `${1:-}` (ค่าเริ่มต้น) หรือตรวจ `[ $# -ge 1 ]` ก่อนใช้ |
| `JAVA_HOME is set to an invalid directory` จาก Gradle | `JAVA_HOME` ชี้ไปที่โฟลเดอร์ที่ไม่มีอยู่ (เช่น หลังย้าย/อัปเดต JDK) | `echo $JAVA_HOME` แล้ว `ls $JAVA_HOME/bin/java` | แก้ `JAVA_HOME` ให้ตรงกับโฟลเดอร์ JDK จริง (อย่าลืม `source ~/.bashrc`) |
| `error: invalid source release: 25` ตอน build | Gradle รันด้วย JDK เก่ากว่า 25 | `gradle --version` → ดูบรรทัด `Launcher JVM` | ตั้ง `JAVA_HOME` เป็น JDK 25 แล้วรันใหม่ |
| สคริปต์จำลองเกมคืน `exit 1` เมื่อ “แพ้” | เอา “ผลลัพธ์ของเกม” ไปใช้เป็น “รหัสออก” | รันแล้วดู `echo $?` | ให้ exit code สื่อถึง “โปรแกรมสำเร็จ/ล้มเหลว” และเก็บผลเกมในตัวแปร/ไฟล์ log แยกกัน |

---

## 10. เมื่อหมดทางจริง ๆ ให้ทำแบบนี้

1. รวบรวม **3 อย่างนี้** ให้ครบก่อนถาม:
   - คำสั่งที่รัน (คัดลอกทั้งหมด)
   - ข้อความ error ทั้งก้อน (ตั้งแต่บรรทัดแรก)
   - สิ่งที่ทำไปก่อนหน้า และคาดหวังว่าผลจะเป็นอะไร
2. ลอง **ลดขนาดปัญหา**: ทำในโฟลเดอร์ใหม่ เพื่อดูว่าเกิดจากโปรเจกต์หรือจากเครื่อง
3. ค้นเอกสารทางการก่อน (docs.papermc.io, docs.gradle.org, docs.oracle.com) แล้วค่อยดูฟอรัม
4. ถามครูด้วยคำสั่ง `DEBUG` พร้อมข้อมูล 3 อย่างนั้น — จะได้คำตอบที่ตรงจุดกว่าเดิมมาก
