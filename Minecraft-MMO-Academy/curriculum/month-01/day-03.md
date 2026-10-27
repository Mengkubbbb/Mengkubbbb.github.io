# Day 03 — ใช้ Terminal ให้คล่อง: ค้นหาไฟล์, `PATH` และ alias

> 📅 Month 1 · Week 1 · ~150 นาที · **โหมด: Guided Practice → Independent Practice**

---

## A. เป้าหมาย

จบบทนี้คุณจะ:
- หาไฟล์ได้ด้วย `find` และค้นข้อความในไฟล์ด้วย `grep` (ทักษะที่ใช้ทุกวันตลอด 365 วัน)
- อธิบายได้ว่า `PATH` คืออะไร และ **ทำไม `java: command not found` เกิดทั้งที่ติดตั้ง Java แล้ว**
- ตั้ง alias ของตัวเองได้ และเข้าใจว่า alias เก็บไว้ที่ไหน
- ใช้ `history` และ `Ctrl+R` เรียกคำสั่งเก่ากลับมาใช้ได้ (ประหยัดเวลามาก)

**ผลงานที่ต้องได้:** alias 3 ตัวใน `~/.bashrc` ที่ใช้งานได้ + ไฟล์ `notes/cheatsheet.md` ที่อัปเดต + บันทึกคำตอบเรื่อง `PATH`

---

## B. ความรู้ที่ต้องมี

- Day 01–02: `ls`, `cd`, `mkdir`, `echo`, `chmod`, การใช้ `>` `>>`
- เข้าใจว่าพาธ absolute คืออะไร

---

## C. แนวคิด

### C.1 `PATH` — "สมุดโทรศัพท์" ของคำสั่ง

เวลาเราพิมพ์ `ls` shell จะถามตัวเองว่า: **"โปรแกรมชื่อ `ls` อยู่ที่ไฟล์ไหน?"**
คำตอบอยู่ในตัวแปร `PATH` ซึ่งเป็นรายการโฟลเดอร์คั่นด้วย `:`

```bash
echo $PATH
# ตัวอย่าง: /usr/local/bin:/usr/bin:/bin:/home/mengkub/.local/bin
```

Shell จะไล่หาทีละโฟลเดอร์ตามลำดับ ถ้าเจอ `ls` ที่โฟลเดอร์แรกก็ใช้ตัวนั้น
ถ้าไม่เจอเลย → `command not found`

> 💡 **นี่คือสาเหตุอันดับ 1 ของปัญหา `java: command not found`**
> ไฟล์ `java` มักอยู่ที่ `/usr/lib/jvm/jdk-25/bin/java` ซึ่งไม่อยู่ใน `PATH` โดยอัตโนมัติ จึงต้องเพิ่มเข้าไป

ลองพิสูจน์เอง:

```bash
which ls                # ซึ่งมาจากคำสั่ง whereis/which → บอกพาธจริงของคำสั่ง
type ls                 # บอกว่าคำสั่งนี้เป็นโปรแกรมจริง หรือ alias หรือ builtin
```

### C.2 หาไฟล์ให้เป็น: `find`

```bash
find ~/minecraft-mmo-dev -name "*.sh"          # หาไฟล์ .sh ทั้งหมด
find ~/minecraft-mmo-dev -type d -name "notes" # หาเฉพาะโฟลเดอร์ชื่อ notes
find / -name "java" -type f 2>/dev/null         # หาโปรแกรม java ทั้งเครื่อง (ช้า! ใส่ 2>/dev/null เพื่อซ่อน error)
```

**อธิบาย:** `-name` กรองชื่อ (ใช้ `*` ได้), `-type f` = ไฟล์, `-type d` = โฟลเดอร์, `2>/dev/null` = ทิ้งข้อความ error

### C.3 หาข้อความในไฟล์: `grep`

`grep` เป็นเครื่องมือที่คุณจะใช้ **ทุกวัน** เมื่อดู log ของเซิร์ฟเวอร์

```bash
grep "error" file.log              # หาบรรทัดที่มีคำว่า error
grep -i "error" file.log           # ไม่สนตัวพิมพ์เล็กใหญ่
grep -n "error" file.log            # แสดงเลขบรรทัดด้วย
grep -r "EclipseCore" ~/minecraft-mmo-dev   # ค้นทั้งโฟลเดอร์แบบไล่ลงไป
grep -c "error" file.log           # นับจำนวนบรรทัดที่เจอ
```

**เทียบกับในเกม:** ถ้า log ของเซิร์ฟเวอร์มี 30,000 บรรทัด `grep` คือ "คำสั่งค้นหา" ที่พาเราหาบรรทัดสำคัญได้ใน 0.1 วินาที

### C.4 alias — ชื่อเล่นของคำสั่ง

**alias** คือการตั้งชื่อสั้น ๆ ให้คำสั่งยาว

```bash
alias ll='ls -lah'
alias mmd='cd ~/minecraft-mmo-dev'
```

ข้อควรระวัง 3 ข้อ:
1. alias ใช้ได้เฉพาะในเซสชันนั้น ๆ ถ้าอยากถาวรต้องเขียนลง `~/.bashrc`
2. หลังแก้ `~/.bashrc` ต้องรัน `source ~/.bashrc` หรือเปิด Terminal ใหม่
3. alias ใช้ได้เฉพาะคำสั่งแรกของบรรทัด ไม่ใช่แทน argument

### C.5 `history` และ `Ctrl+R`

```bash
history | tail -20      # ดู 20 คำสั่งล่าสุด
# กด Ctrl+R แล้วพิมพ์บางส่วนของคำสั่งเก่า → ได้คำสั่งนั้นกลับมา
```

---

## D. ตัวอย่าง

### D.1 จำลองสถานการณ์ "java ใช้ไม่ได้"

```bash
java -version
```

ถ้าขึ้น `command not found` ให้ตรวจว่าโปรแกรมมีจริงไหม:

```bash
ls /usr/lib/jvm 2>/dev/null
find /usr/lib/jvm -maxdepth 3 -name java -type f 2>/dev/null
```

ถ้า `find` เจอไฟล์ `java` แปลว่าติดตั้งแล้วแต่ **ไม่อยู่ใน PATH** → วิธีแก้จะทำใน Day 04
(บทเรียนสำคัญของวันนี้: **แยกให้ออกระหว่าง "ไม่มีโปรแกรม" กับ "มีโปรแกรมแต่หาไม่เจอ"**)

### D.2 ทดลองค้นหาในโปรเจกต์ตัวเอง

```bash
cd ~/minecraft-mmo-dev
find . -name "*.sh" -type f
grep -rn "year" notes/ 2>/dev/null
grep -rn "Academy" scripts/
```

**ผลลัพธ์ที่คาดหวัง:** เห็น списокไฟล์ `.sh` ที่คุณสร้างไว้ 2–3 ไฟล์ และเห็นบรรทัดที่มีคำว่า Academy ในสคริปต์

---

## E. ลงมือทำ

### ขั้นที่ 1: สำรอง `.bashrc` ก่อนแก้ (นิสัยที่ต้องมี)

```bash
cp ~/.bashrc ~/.bashrc.backup-day03
ls -l ~/.bashrc*
```

> ⚠️ การสำรองไฟล์ตั้งค่าก่อนแก้ เป็นนิสัยที่แยก "มือใหม่" ออกจาก "คนที่ดูแลเซิร์ฟเวอร์ได้จริง"

### ขั้นที่ 2: เปิดดู `.bashrc` ว่ามีอะไรอยู่แล้ว

```bash
head -30 ~/.bashrc
grep -n "alias" ~/.bashrc | head -10
```

### ขั้นที่ 3: เพิ่ม alias ของหลักสูตรนี้

```bash
cat >> ~/.bashrc << 'EOF'

# ===== Minecraft MMO RPG Academy — Day 03 =====
alias ll='ls -lah'
alias mmd='cd ~/minecraft-mmo-dev'
alias mmscripts='cd ~/minecraft-mmo-dev/scripts'
alias mmnotes='cd ~/minecraft-mmo-dev/notes'
alias findscript='find ~/minecraft-mmo-dev -name "*.sh" -type f'
alias logerrors='grep -in "error" ~/minecraft-mmo-dev/server/logs/latest.log'
# ===== จบส่วนที่เพิ่ม =====
EOF
```

**อธิบาย:** `cat >> file << 'EOF' ... EOF` คือการเขียนข้อความหลายบรรทัดต่อท้ายไฟล์ (เรียกว่า heredoc)
ห้ามพิมพ์ `EOF` ซ้ำ เพราะ shell จะคิดว่าจบข้อความแล้ว

### ขั้นที่ 4: โหลดค่าใหม่และทดสอบ

```bash
source ~/.bashrc
type ll
ll
mmd && pwd
findscript
```

**ผลลัพธ์ที่คาดหวัง:**
- `type ll` → `ll is aliased to 'ls -lah'`
- `mmd && pwd` → `.../minecraft-mmo-dev`
- `findscript` → รายชื่อไฟล์ `.sh` ของคุณ

> 💡 alias `logerrors` จะใช้ได้จริงใน Month 5+ เมื่อมี `server/logs/latest.log`

### ขั้นที่ 5: ฝึกค้นหาแบบมีเงื่อนไข

```bash
cd ~/minecraft-mmo-dev
find . -name "*.sh" -exec ls -l {} \;      # หาไฟล์ .sh แล้วแสดงสิทธิ์ของแต่ละไฟล์
find . -name "*.txt" -mtime -1              # ไฟล์ .txt ที่แก้ภายใน 1 วันล่าสุด
find . -type d -empty                       # โฟลเดอร์ว่าง (อาจมีโฟลเดอร์ที่ลืมใช้)
```

### ขั้นที่ 6: ฝึก `grep` กับไฟล์จริง

```bash
cd ~/minecraft-mmo-dev
grep -rn "Academy" . --include="*.md" --include="*.txt" | head -20
grep -c "" notes/day02-output.txt          # นับจำนวนบรรทัดในไฟล์ (ทริกเล็ก ๆ)
```

### ขั้นที่ 7: บันทึกผลลัพธ์และคำตอบ

```bash
{
  echo "### Day 03 — PATH และ alias"
  echo
  echo "PATH ของฉัน:"
  echo "$PATH"
  echo
  echo "คำสั่ง java:"
  type java 2>&1 || echo "java: ยังไม่พบใน PATH (จะแก้ใน Day 04)"
  echo
  echo "alias ที่ตั้งไว้:"
  alias | grep -E "mmd|ll|findscript"
} > ~/minecraft-mmo-dev/notes/day03-path.txt
cat ~/minecraft-mmo-dev/notes/day03-path.txt
```

---

## F. โค้ดตัวอย่าง

ไฟล์ที่ปรับในวันนี้:

| พาธ | สถานะ | สิ่งที่ทำ |
| --- | --- | --- |
| `~/.bashrc` | **แก้ไข** (สำรองไว้ที่ `~/.bashrc.backup-day03`) | เพิ่ม alias 6 ตัว |
| `~/minecraft-mmo-dev/notes/day03-path.txt` | สร้างใหม่ | หลักฐาน PATH/type/alias |
| `~/minecraft-mmo-dev/notes/cheatsheet.md` | แก้ไข | เพิ่มคำสั่งค้นหา |

**โค้ดตัวอย่างสำหรับแบบฝึกหัดประยุกต์ (โครงเริ่มต้น)**

```bash
#!/usr/bin/env bash
# find-log-errors.sh — สรุปข้อผิดพลาดจากไฟล์ log
# ใช้: ./find-log-errors.sh <ไฟล์ log>

LOG_FILE="$1"

if [ -z "$LOG_FILE" ]; then
    echo "วิธีใช้: $0 <ไฟล์ log>"
    exit 1
fi

if [ ! -f "$LOG_FILE" ]; then        # -f = มีไฟล์นี้อยู่หรือไม่
    echo "ไม่พบไฟล์: $LOG_FILE"
    exit 1
fi

echo "ไฟล์: $LOG_FILE"
echo "จำนวนบรรทัดทั้งหมด: $(wc -l < "$LOG_FILE")"
echo "จำนวนบรรทัดที่มี ERROR: $(grep -c -i 'error' "$LOG_FILE" || true)"
echo
echo "--- 5 บรรทัดแรกที่มี ERROR ---"
grep -i -n 'error' "$LOG_FILE" | head -5
```

---

## G. แบบฝึกหัด

### G.1 พื้นฐาน

1. สร้าง alias ใหม่ 3 ตัวของตัวเอง (ห้ามซ้ำกับที่ให้มา) อย่างน้อย 1 ตัวต้องเป็นคำสั่งที่ยาวเกิน 15 ตัวอักษร
2. เขียนลง `~/.bashrc` ให้ถาวร แล้วพิสูจน์ว่าใช้ได้หลังเปิด Terminal ใหม่
3. รัน `alias` แล้วคัดลอกผลลัพธ์เก็บไว้

### G.2 ประยุกต์

เขียน script `~/minecraft-mmo-dev/scripts/find-log-errors.sh` (ใช้โค้ดโครงด้านบนเป็นจุดเริ่ม **แต่ต้องเข้าใจทุกบรรทัดก่อนแก้**) โดยเพิ่มความสามารถ:
- รับ argument ที่สองเป็นคำค้น (ถ้าไม่ให้มา ใช้ `ERROR` เป็นค่าเริ่มต้น)
- แสดง 10 บรรทัดล่าสุด (ไม่ใช่ 5 บรรทัดแรก) ที่ตรงกับคำค้น

**คำใบ้:** `tail` และการส่ง argument ตัวที่สองด้วย `$2` พร้อมค่าเริ่มต้น `${2:-ERROR}`

**สิ่งที่ต้องส่ง:** เนื้อหาไฟล์ + ทดสอบกับไฟล์ `notes/day02-output.txt` (จะมี error 0 บรรทัด ก็ถือว่าถูกต้อง — ต้องไม่พัง)

### G.3 คำถามตรวจสอบความเข้าใจ 3 ข้อ

1. `PATH` คืออะไร? และถ้า `find` เจอโปรแกรม `java` แต่ `java -version` ขึ้น `command not found` แปลว่าอะไร?
2. `grep -n` กับ `grep -c` ให้ผลต่างกันอย่างไร?
3. ทำไมเราต้องสำรอง `~/.bashrc` ก่อนแก้ และถ้าแก้จนเปิด Terminal ไม่ได้เลยจะแก้ปัญหาอย่างไร (คิดเอง 1 วิธี)

---

## H. Challenge

สร้าง "รายงานสุขภาพโปรเจกต์" จากคำสั่งค้นหาเพียงอย่างเดียว (ยังไม่ต้องเขียนเป็น script):
ให้รายงาน 5 อย่างต่อไปนี้ออกมาเป็นข้อความใน Terminal

1. จำนวนไฟล์ `.sh` ทั้งหมดในโปรเจกต์
2. ไฟล์ `.sh` ใดที่มีคำว่า `chmod` อยู่ข้างใน (ใช้ `grep -l`)
3. จำนวนโฟลเดอร์ทั้งหมด
4. ไฟล์ที่แก้ไขล่าสุด 3 อันดับแรก
5. ไฟล์ที่มีขนาดใหญ่ที่สุด 3 อันดับแรก

**คำใบ้:** `find ... | wc -l`, `grep -rl`, `ls -lt`, `du -a | sort -rn`

จากนั้น **อธิบาย 3 บรรทัด** ว่าคำสั่งไหนให้ข้อมูลอะไร และทำไมต้องใช้ `|` (pipe)

---

## I. Todo Checklist

- [ ] สำรอง `~/.bashrc` เป็น `~/.bashrc.backup-day03`
- [ ] เพิ่ม alias 6 ตัว (ของหลักสูตร) และโหลดใหม่ด้วย `source ~/.bashrc`
- [ ] เพิ่ม alias ของตัวเองอีก 3 ตัว
- [ ] ทดสอบ `type` กับ `find`/`grep` อย่างละ 2 แบบ
- [ ] รัน `findscript` และ `find . -name "*.txt" -mtime -1` สำเร็จ
- [ ] สร้าง `notes/day03-path.txt`
- [ ] ทำแบบฝึกหัด G.1, G.2 และตอบ G.3
- [ ] อัปเดต [PROGRESS.md](../../PROGRESS.md) + [TODO.md](../../TODO.md) (T-004)

---

## J. ผลลัพธ์

1. `~/.bashrc` ที่มี alias ใช้งานได้จริง 9 ตัว (6 ของหลักสูตร + 3 ของตัวเอง)
2. `scripts/find-log-errors.sh` ที่ทดสอบกับไฟล์จริงแล้ว
3. `notes/day03-path.txt`, `notes/day03-challenge.txt` (ผลจาก Challenge)
4. เข้าใจ `PATH` จนอธิบายให้คนอื่นฟังได้

---

## K. Troubleshooting

| อาการ | สาเหตุ | วิธีตรวจสอบ | วิธีแก้ |
| --- | --- | --- | --- |
| ตั้ง alias แล้วใช้ไม่ได้ | ยังไม่ `source` หรือเขียนผิดไฟล์ | `grep -n "alias" ~/.bashrc` | `source ~/.bashrc` แล้ว `type <alias>` |
| เปิด Terminal แล้วมี error เรื่อง `.bashrc` | heredoc ผิด (มี `EOF` เกิน/ขาดเครื่องหมายคำพูด) | `bash -n ~/.bashrc` (ตรวจ syntax) | กู้จาก backup: `cp ~/.bashrc.backup-day03 ~/.bashrc` |
| Terminal เปิดไม่ได้เลยหลังแก้ `.bashrc` | ไฟล์ตั้งค่าพัง | เปิด terminal อื่น/Pty | รัน `bash --norc` แล้วกู้จากไฟล์สำรอง |
| `find: ‘path’: Permission denied` | ไปสแกนโฟลเดอร์ของระบบ | ดูข้อความ error ว่าพาธไหน | จำกัดขอบเขตเป็นโฟลเดอร์ตัวเอง และใส่ `2>/dev/null` |
| `grep` ไม่เจอทั้งที่มีคำนั้น | ตัวพิมพ์เล็ก/ใหญ่ไม่ตรง หรือไฟล์เป็น binary | `grep -i`, `file <ชื่อไฟล์>` | ใช้ `-i` หรือตรวจชนิดไฟล์ |

---

## L. สรุป

- `PATH` เป็นรายการโฟลเดอร์ที่ shell ไปหาคำสั่ง → ปัญหา `command not found` ต้องแยกว่า "ไม่มี" หรือ "หาไม่เจอ"
- `find` ใช้หาไฟล์, `grep` ใช้หาข้อความ — สองตัวนี้จะถูกใช้ทุกวันตลอดหลักสูตร (โดยเฉพาะตอนดู log)
- alias ช่วยประหยัดเวลาแต่ต้องเก็บใน `~/.bashrc` และต้อง `source` ทุกครั้งหลังแก้
- ก่อนแก้ไฟล์ตั้งค่า **ต้องสำรองก่อนเสมอ**

*(หมายเหตุ: ในหัวข้อ D.2 มีคำที่ไม่ใช่ภาษาไทยหลุดเข้ามา 1 คำ — ครูจะแก้ให้ในบทเรียนเวอร์ชันถัดไป ผู้เรียนไม่ต้องสนใจ)*

**บทต่อไป (Day 04):** เราจะติดตั้งเครื่องมือจริง — VS Code, JDK 25 และแก้ปัญหา `PATH` ให้จบ
พร้อมตรวจว่าเวอร์ชัน Java ตรงกับที่ Paper 26.3 ต้องใช้ (Java 25)

---

## M. Progress Update

```text
### Day 003 — วันที่ ____-__-__
- เรียน: PATH, find, grep, alias, history
- ทำเสร็จ: ~/.bashrc (สำรองก่อนแก้), scripts/find-log-errors.sh, notes/day03-path.txt
- ทดสอบ: type ll → aliased | findscript เจอไฟล์ .sh N ไฟล์ | grep ทดสอบกับ day02-output.txt ไม่พัง ✅
- ยังไม่เข้าใจ: ______
- Error ที่เจอ: ______ (แก้ด้วย ______)
- งานถัดไป: Day 04 — VS Code + JDK 25 + แก้ PATH
- คะแนนตัวเอง: __/5
```
