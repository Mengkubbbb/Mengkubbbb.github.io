# Day 04 — โปรเซส, ตัวจัดการแพ็กเกจ, Editor และ JDK

> 📅 Month 1 · Week 1 · ~150 นาที · **โหมด: Guided Practice → Independent Practice**

---

## A. เป้าหมาย

จบบทนี้คุณจะ:
- ดูและจัดการโปรเซสได้ (`ps`, `top`, `kill`) — ทักษะจำเป็นสำหรับดูแลเซิร์ฟเวอร์ที่ค้าง
- ติดตั้งโปรแกรมด้วยตัวจัดการแพ็กเกจของ CachyOS ได้ (และเข้าใจว่ามันทำงานอย่างไร)
- ติดตั้ง **VS Code** และส่วนขยายที่จำเป็น
- ติดตั้ง **JDK 25** และพิสูจน์ได้ว่า `java`/`javac` ใช้ได้จริง (แก้ปัญหา `PATH` ให้จบ)
- ตรวจสอบได้ว่าเวอร์ชัน Java **ตรงกับที่ Paper เวอร์ชันที่เราจะใช้ต้องการ**

**ผลงานที่ต้องได้:** ผลลัพธ์ `java -version` และ `javac -version` ที่เป็น Java 25 (บันทึกเป็นหลักฐาน) + VS Code ที่เปิดโฟลเดอร์โปรเจกต์ได้

---

## B. ความรู้ที่ต้องมี

- Day 01–03: `PATH`, `find`, `grep`, alias, การสำรองไฟล์ก่อนแก้

---

## C. แนวคิด

### C.1 โปรเซส (Process) คืออะไร

**โปรเซส = โปรแกรมที่กำลังทำงานอยู่** เหมือนมอนสเตอร์ที่กำลังเดินอยู่จริงในโลก เทียบกับคลาส `Zombie` ที่เป็นพิมพ์เขียว

เมื่อเราเปิดเซิร์ฟเวอร์ Minecraft เครื่องจะสร้างโปรเซสชื่อ (โดยทั่วไป) `java` ขึ้นมา 1 ตัว
ถ้าเซิร์ฟเวอร์ค้าง เราต้องหา "ตัวที่ค้าง" ให้เจอแล้วปิดอย่างถูกวิธี

คำสั่งที่ใช้บ่อย:

| คำสั่ง | ทำอะไร | ใช้เมื่อไร |
| --- | --- | --- |
| `ps aux` | แสดงโปรเซสทั้งหมด (มีรายละเอียดเยอะ) | หาโปรเซสที่กิน CPU/RAM เยอะ |
| `top` / `htop` | ดูแบบเรียลไทม์ (ออกด้วย `q`) | ดูว่าใครกิน RAM ตอนเซิร์ฟเวอร์กระตุก |
| `kill <PID>` | ขอให้โปรเซสหยุดอย่างสุภาพ (SIGTERM) | ปิดเซิร์ฟเวอร์ทดสอบที่ค้าง |
| `kill -9 <PID>` | บังคับปิดทันที (SIGKILL) | ⚠️ ทางเลือกสุดท้าย — ข้อมูลอาจไม่ถูกบันทึก |

> ⚠️ **กฎเหล็ก:** ก่อน `kill -9` เซิร์ฟเวอร์ ต้องใช้ `kill` (ไม่ใส่ -9) ก่อนเสมอ
> เพราะการบังคับปิดอาจทำให้โลกหรือฐานข้อมูลเสียหาย

### C.2 ตัวจัดการแพ็กเกจ (Package Manager) คือ "ร้านค้าแอปของ Linux"

- CachyOS ใช้ **pacman** (ฐานข้อมูลแพ็กเกจของ Arch)
- คำสั่งที่ต้องรู้:

| คำสั่ง | ทำอะไร |
| --- | --- |
| `pacman -Ss <คำค้น>` | ค้นหาแพ็กเกจในคลัง |
| `pacman -Qs <คำค้น>` | ค้นหาเฉพาะที่ติดตั้งแล้ว |
| `pacman -Q <ชื่อแพ็กเกจ>` | ถามว่าแพ็กเกจนี้ติดตั้งอยู่ไหม |
| `sudo pacman -S <ชื่อ>` | ติดตั้ง (**ต้องใช้ sudo** — หลักสูตรนี้จะเตือนทุกครั้ง) |
| `pacman -Qi <ชื่อ>` | ดูข้อมูลเวอร์ชันของแพ็กเกจที่ติดตั้ง |

> ⚠️ ในสภาพแวดล้อม Cloud ของครู **ไม่มี sudo** จึงติดตั้งระดับระบบไม่ได้ — ครูใช้วิธีดาวน์โหลด JDK/Gradle ไว้ใน `~/.local/opt`
> แต่ **บนเครื่อง CachyOS ของคุณ** ให้ใช้ pacman เป็นหลัก (สะอาดกว่าและอัปเดตง่าย)

### C.3 ทำไมต้อง JDK 25 (ไม่ใช่ 21)

**JDK** = Java Development Kit = ชุดเครื่องมือสำหรับ **เขียนและรัน** Java
(มี `javac` สำหรับคอมไพล์ และ `java` สำหรับรัน)

ความต้องการของ Paper (ตรวจเมื่อ 27 ตุลาคม 2026):

| Paper | Minecraft | Java ที่ต้องใช้ |
| --- | --- | --- |
| 26.1 ขึ้นไป | 26.x | **Java 25** |
| 1.20 – 1.21.11 | 1.20–1.21.11 | Java 21 |

เราจะใช้ **Paper 26.3** → ต้องใช้ **Java 25**
ถ้าใช้ Java 21 จะเจอ error ประมาณว่า `Unsupported Java version` ตอนเปิดเซิร์ฟเวอร์

> 📌 แหล่งอ้างอิง: https://docs.papermc.io/paper/getting-started/ (ต้องเปิดตรวจซ้ำเสมอ ก่อนสร้างเซิร์ฟเวอร์จริงใน Day 181)

### C.4 Editor: VS Code

**Editor** = โปรแกรมสำหรับเขียนโค้ด เราใช้ VS Code เพราะ:
- มีส่วนขยาย Java (ของ Microsoft) ที่ใช้ฟรี
- มี Terminal ในตัว + Debugger (ใช้จริงใน Day 133)
- ใช้ฟรีและใช้กับ Gradle ได้ดี

---

## D. ตัวอย่าง

### D.1 ดูโปรเซสที่ตัวเองเป็นเจ้าของ

```bash
ps -u "$USER" -o pid,pcpu,pmem,comm --sort=-pcpu | head -10
```

**อธิบาย:** `-u "$USER"` ดูแค่โปรเซสของเรา, `-o` เลือกคอลัมน์, `--sort=-pcpu` เรียงตามการใช้ CPU มาก→น้อย

### D.2 ค้นหาแพ็กเกจ JDK ในคลังของ CachyOS

```bash
pacman -Ss jdk | head -20
pacman -Ss openjdk | head -20
```

> ⚠️ ชื่อแพ็กเกจ Java ใน Arch-based อาจเป็น `jdk-openjdk` (เวอร์ชันล่าสุด) หรือแพ็กเกจระบุเวอร์ชัน เช่น `jdk25-openjdk`
> **ครูยังไม่ยืนยันชื่อแพ็กเกจ 25 ตัวจริงของคลัง CachyOS ณ วันที่เขียน** — ให้ผู้เรียนค้นด้วยคำสั่งข้างบนแล้วดูว่าในรายการมีเวอร์ชัน 25 หรือไม่
> ถ้าไม่มีเวอร์ชัน 25 ให้ใช้ทางเลือกที่ D.4 (ดาวน์โหลดจากผู้ผลิต)

### D.3 ทางเลือก A: ติดตั้งผ่าน pacman (ต้องมี sudo)

```bash
sudo pacman -S jdk-openjdk      # ⚠️ ตรวจก่อนว่าคือเวอร์ชัน 25 (ด้วย pacman -Qi หลังติดตั้ง)
java -version
javac -version
```

### D.4 ทางเลือก B: ดาวน์โหลดลงบ้านของผู้ใช้ (ไม่ต้อง sudo) — วิธีที่ครูทดสอบแล้ว

```bash
mkdir -p ~/.local/opt && cd ~/.local/opt
curl -sSL -o jdk25.tar.gz "https://api.adoptium.net/v3/binary/latest/25/ga/linux/x64/jdk/hotspot/normal/eclipse"
tar xzf jdk25.tar.gz && rm jdk25.tar.gz
ls -d jdk-25*
./jdk-25*/bin/java -version
```

**ผลลัพธ์ที่คาดหวัง (ครูทดสอบจริงในสภาพแวดล้อม Cloud):**
```text
openjdk version "25.0.5" 2026-10-20 LTS
OpenJDK Runtime Environment Temurin-25.0.5+8 (build 25.0.5+8-LTS)
OpenJDK 64-Bit Server VM Temurin-25.0.5+8 (build 25.0.5+8-LTS, mixed mode, sharing)
```

จากนั้นทำให้ใช้ได้ทุกที่ด้วยการชี้ `PATH`:

```bash
echo 'export JAVA_HOME="$HOME/.local/opt/jdk-25.0.5+9"' >> ~/.bashrc   # ← ปรับชื่อโฟลเดอร์ให้ตรงกับของคุณ
echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
java -version
which java
```

> 💡 การแทรก `$JAVA_HOME/bin` **ไว้ข้างหน้า** `$PATH` สำคัญ: ทำให้ Java 25 ถูกใช้ก่อนเวอร์ชันอื่นที่อาจมีอยู่

---

## E. ลงมือทำ

### ขั้นที่ 1: ตรวจว่ามี Java ติดตั้งอยู่แล้วหรือไม่

```bash
which java javac 2>/dev/null
java -version 2>&1 | head -3
pacman -Qs jdk 2>/dev/null | head -10
```

**ผลลัพธ์ที่คาดหวัง:** ยังไม่มีอะไร หรือมีแต่เวอร์ชันเก่า (เช่น 17/21) → ต้องติดตั้งใหม่

### ขั้นที่ 2: ติดตั้ง JDK 25

เลือกทางใดทางหนึ่งจาก D.3 (pacman) หรือ D.4 (ดาวน์โหลด)
**แนะนำ:** ถ้า pacman มีเวอร์ชัน 25 ก็ใช้ pacman; ถ้าไม่มี ให้ใช้ D.4

### ขั้นที่ 3: ตรวจว่าติดตั้งสำเร็จจริง (ต้องได้ทั้ง 2 คำสั่ง)

```bash
java -version
javac -version
echo "JAVA_HOME = $JAVA_HOME"
```

**เกณฑ์ผ่าน:** ทั้งสองคำสั่งต้องขึ้น `25.x` และ `JAVA_HOME` ต้องไม่ว่าง

**ถ้าไม่ผ่าน:** เปิด [TROUBLESHOOTING.md](../../TROUBLESHOOTING.md) หัวข้อ "ปัญหา Java / Gradle"

### ขั้นที่ 4: ติดตั้ง VS Code

```bash
pacman -Ss code | head -20        # หาชื่อแพ็กเกจจริงก่อนติดตั้ง
sudo pacman -S code              # (หรือ code-oss) — เลือกตัวที่ต้องการ
code --version
```

> 💡 ถ้าไม่ต้องการ sudo สามารถติดตั้งเป็น AppImage/tarball ลง `~/.local/opt` ได้เช่นกัน (ในหลักสูตรนี้ไม่บังคับวิธี)

### ขั้นที่ 5: ติดตั้งส่วนขยายที่จำเป็น

เปิด VS Code แล้วกด `Ctrl+Shift+X` ค้นหาและติดตั้ง:

| ส่วนขยาย | ใช้ทำอะไร |
| --- | --- |
| Extension Pack for Java | คอมไพล์/รัน/ดีบัก Java ในตัว |
| Gradle for Java | ทำงานกับ Gradle |
| YAML | ไฟล์ตั้งค่าปลั๊กอิน (Month 6) |
| Markdown All in One | เขียนเอกสารโปรเจกต์ |

หรือติดตั้งจาก Terminal:

```bash
code --install-extension vscjava.vscode-java-pack
code --install-extension vscjava.vscode-gradle
code --install-extension redhat.vscode-yaml
code --install-extension yzhang.markdown-all-in-one
```

### ขั้นที่ 6: เปิดโฟลเดอร์โปรเจกต์ใน VS Code

```bash
code ~/minecraft-mmo-dev
```

ตรวจว่าในแถบซ้ายเห็น `server/ scripts/ notes/ backups/ lab/ academy/` ครบ

### ขั้นที่ 7: บันทึกหลักฐานและทดสอบการจัดการโปรเซส

```bash
{
  echo "### Day 04 — เครื่องมือพร้อมใช้งาน"
  echo
  echo "Java version:"; java -version 2>&1
  echo "Javac version:"; javac -version 2>&1
  echo "JAVA_HOME: $JAVA_HOME"
  echo "which java: $(which java)"
  echo
  echo "โปรเซสที่ใช้ CPU สูงสุด 5 อันดับ:"; ps -u "$USER" -o pid,pcpu,pmem,comm --sort=-pcpu | head -6
} > ~/minecraft-mmo-dev/notes/day04-tools.txt
cat ~/minecraft-mmo-dev/notes/day04-tools.txt
```

ทดสอบ `kill` อย่างปลอดภัย (สร้างโปรเซสทดลองของตัวเอง):

```bash
sleep 300 &            # รันโปรแกรม sleep 300 วินาที แบบ background
JOBS_PID=$!            # $! = PID ของโปรเซสล่าสุดที่รันแบบ background
echo "PID = $JOBS_PID"
ps -p "$JOBS_PID" -o pid,etime,comm
kill "$JOBS_PID"       # ปิดอย่างสุภาพ
ps -p "$JOBS_PID" -o pid,comm || echo "ปิดสำเร็จ (ไม่พบโปรเซสแล้ว)"
```

---

## F. โค้ดตัวอย่าง

| พาธ | สถานะ | หน้าที่ |
| --- | --- | --- |
| `~/.bashrc` | แก้ไข | เพิ่ม `JAVA_HOME` + `PATH` |
| `~/minecraft-mmo-dev/notes/day04-tools.txt` | สร้างใหม่ | หลักฐานเวอร์ชันเครื่องมือ |
| `~/minecraft-mmo-dev/scripts/java-check.sh` | สร้างใหม่ (แบบฝึกหัด) | ตรวจว่า Java ในเครื่องตรงกับที่ Paper ต้องการ |

```bash
#!/usr/bin/env bash
# java-check.sh — ตรวจเวอร์ชัน Java ที่เครื่องนี้ใช้อยู่
# ใช้: ./java-check.sh
# หมายเหตุ: Paper 26.1+ ต้องใช้ Java 25 (ตรวจ 2026-10-27)

REQUIRED_MAJOR=25

if ! command -v java >/dev/null 2>&1; then
    echo "❌ ไม่พบคำสั่ง java ใน PATH"
    echo "   ตรวจ: which java / echo \$PATH"
    exit 1
fi

# ดึงเวอร์ชันหลัก เช่นคำว่า 'version "25.0.5"' → 25
RAW_VERSION=$(java -version 2>&1 | head -1)
MAJOR=$(echo "$RAW_VERSION" | sed -E 's/.*version "([0-9]+).*/\1/')

echo "Java ที่พบ: $RAW_VERSION"
echo "เวอร์ชันหลัก: $MAJOR"
echo "เวอร์ชันที่ต้องการสำหรับ Paper 26.x: $REQUIRED_MAJOR"

if [ "$MAJOR" = "$REQUIRED_MAJOR" ]; then
    echo "✅ ตรงกับที่กำหนด"
    exit 0
fi

echo "⚠️ ไม่ตรง — Paper 26.x อาจเปิดไม่ได้ ต้องติดตั้ง Java $REQUIRED_MAJOR"
exit 2
```

**ผลลัพธ์ที่คาดหวัง:** ได้ ✅ เมื่อใช้ Java 25; ได้ ⚠️ และ exit code 2 เมื่อใช้เวอร์ชันอื่น (ทดสอบด้วย `echo $?`)

---

## G. แบบฝึกหัด

### G.1 พื้นฐาน

1. ติดตั้ง JDK 25 ให้สำเร็จและรัน `java -version`, `javac -version` ได้ทั้งคู่
2. บันทึกผลลง `notes/day04-tools.txt` (รวม `which java` และ `JAVA_HOME`)
3. ทดสอบสร้าง/ปิดโปรเซส `sleep` ตามขั้นที่ 7 ให้สำเร็จ (ต้องเห็นว่าโปรเซสหายไปจริง)

### G.2 ประยุกต์

สร้าง `~/minecraft-mmo-dev/scripts/java-check.sh` จากโค้ดด้านบน แล้ว:
- รัน 3 ครั้ง: ครั้งแรกด้วย Java ปัจจุบัน, ครั้งที่สองทดสอบด้วย `PATH` ปลอม (`PATH=/usr/bin ./java-check.sh` จะได้ผลลัพธ์แบบ "ไม่พบ java"), ครั้งที่สามหลัง `unset JAVA_HOME`
- บันทึกผลทั้ง 3 ครั้งพร้อม `echo $?` ของแต่ละครั้งลง `notes/day04-java-check.txt`

**เป้าหมาย:** ให้คุณเห็นด้วยตาว่า script ที่ดีต้อง **ไม่พัง** เมื่อสภาพแวดล้อมผิด และต้องบอกทางแก้ให้ผู้ใช้ด้วย

### G.3 คำถามตรวจสอบความเข้าใจ 3 ข้อ

1. `kill` กับ `kill -9` ต่างกันอย่างไร และทำไมต้องลอง `kill` ก่อน?
2. `JAVA_HOME` คืออะไร และทำไมเราจึงวาง `$JAVA_HOME/bin` ไว้ **ข้างหน้า** `$PATH`?
3. ถ้า `pacman -Q` บอกว่าติดตั้ง `jdk-x` แล้ว แต่ `java -version` ขึ้นเวอร์ชันเก่า ให้ตรวจอะไรเป็นอันดับแรก?

---

## H. Challenge

เขียน script `~/minecraft-mmo-dev/scripts/which-java.sh` ที่:
1. แสดง **ทุก** `java` ที่อยู่ใน `PATH` ตามลำดับที่ shell จะเจอ (คำใบ้: วนอ่าน `$PATH` ด้วย `tr ':' '\n'`)
2. แสดงเวอร์ชันของแต่ละตัว (รันด้วยพาธเต็ม)
3. สรุปว่าตัวที่ shell จะใช้จริงคือตัวไหน

**ความหมายของโจทย์นี้:** ในเครื่องจริงมักมี Java หลายเวอร์ชัน และคนที่ดูแลเซิร์ฟเวอร์ต้องรู้ว่า "ตัวไหนถูกใช้จริง"
(ทักษะนี้จะกลับมาใช้อีกครั้งตอนติดตั้ง Gradle)

---

## I. Todo Checklist

- [ ] ตรวจว่ามี Java เวอร์ชันอะไรอยู่ก่อน
- [ ] ติดตั้ง JDK 25 (pacman หรือดาวน์โหลดลง `~/.local/opt`)
- [ ] ตั้ง `JAVA_HOME` + `PATH` และพิสูจน์ด้วย `which java`
- [ ] `java -version` และ `javac -version` ขึ้น 25.x
- [ ] ติดตั้ง VS Code + 4 ส่วนขยาย
- [ ] เปิด `~/minecraft-mmo-dev` ใน VS Code สำเร็จ
- [ ] สร้าง `scripts/java-check.sh` และทดสอบ 3 สถานการณ์
- [ ] บันทึก `notes/day04-tools.txt`, `notes/day04-java-check.txt`
- [ ] อัปเดต [PROGRESS.md](../../PROGRESS.md) ช่อง "Java (JDK)" + [TODO.md](../../TODO.md) (T-005, T-006)

---

## J. ผลลัพธ์

1. JDK 25 ที่ใช้งานได้จริง พร้อม `java`/`javac` ใน `PATH`
2. VS Code + ส่วนขยาย พร้อมเปิดโฟลเดอร์โปรเจกต์
3. `scripts/java-check.sh` + หลักฐานผลการทดสอบ 3 สถานการณ์
4. `notes/day04-tools.txt` เป็นหลักฐานที่ตรวจสอบย้อนหลังได้
5. เข้าใจโปรเซสและการปิดโปรเซสอย่างปลอดภัย (ใช้จริงเมื่อเซิร์ฟเวอร์ค้าง)

---

## K. Troubleshooting

| อาการ | สาเหตุ | วิธีตรวจสอบ | วิธีแก้ |
| --- | --- | --- | --- |
| `java: command not found` หลังติดตั้งแล้ว | ไม่อยู่ใน `PATH` | `echo $PATH`, `find ~/.local/opt -name java` | เพิ่ม `export PATH="$JAVA_HOME/bin:$PATH"` ใน `~/.bashrc` |
| `java -version` ขึ้น 21/17 | มี Java หลายตัว และตัวเก่ามาก่อนใน PATH | `which -a java`, `echo $JAVA_HOME` | วาง `$JAVA_HOME/bin` ไว้หน้าสุด + `source ~/.bashrc` |
| `javac: command not found` แต่ `java` ใช้ได้ | ติดตั้งแค่ JRE ไม่ใช่ JDK | `pacman -Qs jdk` | ติดตั้ง JDK (ไม่ใช่ jre) |
| เปิด VS Code ไม่ได้จาก terminal | ยังไม่มีคำสั่ง `code` (ยังไม่ติดตั้ง/ไม่ใน PATH) | `which code` | ติดตั้งใหม่ หรือเรียกด้วยพาธเต็ม |
| `sudo: command not found` | สภาพแวดล้อมไม่มี sudo (เช่น Cloud/คอนเทนเนอร์) | `whoami` | ใช้วิธี D.4 (ไม่ต้อง sudo) แทน |
| ดาวน์โหลด JDK แล้ว `tar: not in gzip format` | ดาวน์โหลดไม่ครบหรือได้หน้าเว็บ error | `ls -lh jdk25.tar.gz`, `file jdk25.tar.gz` | ลบแล้วดาวน์โหลดใหม่ (ตรวจว่ามีเน็ต) |
| `Architecture not supported` | ดาวน์โหลดแพ็กเกจผิดสถาปัตยกรรม | `uname -m` (x86_64 = ใช้ x64) | เลือกไฟล์ให้ตรงสถาปัตยกรรม |

---

## L. สรุป

- โปรเซสคือโปรแกรมที่กำลังรัน — `ps`/`top` ดู, `kill` ปิดอย่างสุภาพ, `kill -9` ใช้เป็นทางเลือกสุดท้าย
- pacman เป็นร้านค้าแอปของ CachyOS — ค้นก่อนติดตั้งเสมอ (`-Ss`) และตรวจหลังติดตั้ง (`-Qi`)
- **Paper 26.1+ ต้องใช้ Java 25** — ถ้าใช้ 21 จะเปิดเซิร์ฟเวอร์ไม่ผ่าน
- `JAVA_HOME` + `PATH` คือกุญแจที่ทำให้คำสั่ง `java`/`javac` ใช้งานได้จากทุกที่
- ตรวจเครื่องมือด้วย script เอง (`java-check.sh`) ดีกว่าเดา

**บทต่อไป (Day 05):** Git — เริ่มเก็บงานทุกวันอย่างเป็นระบบ เพื่อให้ย้อนดูได้ว่าอะไรพังเมื่อไร และเพื่อไม่ให้งานหาย

---

## M. Progress Update

```text
### Day 004 — วันที่ ____-__-__
- เรียน: โปรเซส (ps/top/kill), pacman, VS Code, JDK 25, JAVA_HOME/PATH
- ทำเสร็จ: JDK 25 ติดตั้งสำเร็จ, VS Code + 4 extensions, scripts/java-check.sh, notes/day04-tools.txt
- ทดสอบ: java -version → 25.0.x ✅ | javac -version → 25.0.x ✅ | java-check.sh 3 สถานการณ์ (exit 0/1/2) ✅
- ยังไม่เข้าใจ: ______
- Error ที่เจอ: ______ (แก้ด้วย ______)
- งานถัดไป: Day 05 — Git พื้นฐาน + commit แรก
- คะแนนตัวเอง: __/5
```
