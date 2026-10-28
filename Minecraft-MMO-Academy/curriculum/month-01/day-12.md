# Day 12 — ท่อคำสั่ง: `|`, `grep`, `sed`, `awk` เบื้องต้น

> 📅 Month 1 · Week 2 · ~150 นาที · **โหมด: Guided Practice**
> 🎯 วันนี้เปลี่ยน "log ยาวเป็นร้อยบรรทัด" ให้เป็น "ข้อมูลที่ตอบคำถามได้" — ทักษะที่ใช้ทุกวันตลอดอาชีพ

---

## A. เป้าหมาย

จบบทนี้คุณจะ:

- ต่อคำสั่งด้วยท่อ (`|`) เพื่อส่งผลลัพธ์ของตัวหนึ่งเป็นอินพุตของอีกตัว
- ใช้ `grep` กรองบรรทัด (พร้อมตัวเลือกที่ใช้บ่อยจริง: `-i -v -c -n -E -F -A -B`)
- ใช้ `sed` แทนที่ข้อความ (`s/.../.../g`) และลบบรรทัดที่ไม่ต้องการ
- ใช้ `awk` ดึงคอลัมน์, กรองตามเงื่อนไข, บวกเลข, และจัดรูปแบบรายงาน
- แยก **stdout กับ stderr** ในท่อให้ถูก (และรู้ว่าทำไม `2>&1` ต้องอยู่ท้าย)

**ผลงานที่ต้องได้:** `~/minecraft-mmo-dev/scripts/scan-log.sh` — อ่าน log เซิร์ฟเวอร์ แล้วรายงาน: จำนวน ERROR/WARN, ข้อความ error ที่เกิดซ้ำมากที่สุด 5 อันดับ, ช่วงเวลาที่เกิด, และบันทึกสรุปเป็นไฟล์

---

## B. ความรู้ที่ต้องมี

- Day 10–11: ลูป, ฟังก์ชัน, `lib.sh`
- Day 03: การใช้ `grep` เบื้องต้น

---

## C. แนวคิด

### C.1 ท่อ (`|`) คือสายพาน

```bash
grep "ERROR" server.log | wc -l          # นับบรรทัดที่มี ERROR
ls -1 plugins/ | grep -c "\.jar$"        # นับจำนวนปลั๊กอิน (เฉพาะไฟล์ .jar)
```

**หลักคิด:** แต่ละคำสั่งควรทำ **หนึ่งอย่าง** ให้ดี แล้วต่อกัน — ไม่ต้องเขียน script ยาว ๆ เอง

**ตัวช่วยที่ใช้บ่อยในท่อ:**

| คำสั่ง | หน้าที่ |
| --- | --- |
| `head -n 20` / `tail -n 20` | ดูต้น/ท้าย |
| `tail -f` | ดู log แบบสด (กด Ctrl+C ออก) |
| `wc -l` | นับบรรทัด |
| `sort` | เรียง (`-n` ตัวเลข, `-r` ย้อนกลับ) |
| `uniq -c` | นับรายการซ้ำ (ต้อง `sort` ก่อน) |
| `cut -d: -f2` | ตัดคอลัมน์ตามตัวคั่น |
| `tee file` | แสดงผล **และ** เขียนลงไฟล์พร้อมกัน |

**ตัวอย่างที่ใช้จริงตลอดหลักสูตร:**

```bash
# 5 error ที่เกิดบ่อยที่สุด
grep "ERROR" server.log | sed 's/.*ERROR]://' | sort | uniq -c | sort -rn | head -5
```

### C.2 `grep` — กรองบรรทัด

```bash
grep "ERROR" server.log              # บรรทัดที่มีคำว่า ERROR
grep -i "error" server.log           # ไม่สนตัวพิมพ์
grep -v "^#" server.properties       # ตัดบรรทัดคอมเมนต์ออก (เอาที่ "ไม่" ตรง)
grep -c "WARN" server.log            # นับจำนวน (คืนแค่ตัวเลข)
grep -n "Done (" server.log          # แสดงเลขบรรทัดด้วย
grep -E "ERROR|WARN" server.log      # หลายรูปแบบ (extended regex)
grep -F "1.0.0" file.txt             # ค้นหาแบบข้อความตรงตัว (ไม่ตีความ regex)
grep -A 2 -B 1 "Exception" server.log # แสดงบรรทัดก่อน/หลังที่ตรง (ดู stack trace)
```

> ⚠️ **`grep` คืน exit code 1 เมื่อไม่พบอะไร** — ถ้า script ใช้ `set -e` แล้ว `grep` ไม่เจอ script จะหยุดกลางทาง ต้องเขียน `grep ... || true` หรือใช้ใน `if`

### C.3 `sed` — แก้ข้อความทีละบรรทัด

```bash
sed 's/ERROR/ผิดพลาด/g' file.log              # แทนที่ทุกจุดในบรรทัด (g)
sed -n '10,20p' file.log                      # แสดงเฉพาะบรรทัด 10-20
sed '/^$/d' file.log                          # ลบบรรทัดว่าง
sed 's/.*ERROR]://' file.log                  # ตัดทุกอย่างหน้าคำว่า ERROR] ออก
sed -E 's/[0-9]{2}:[0-9]{2}:[0-9]{2}/TIME/'   # แทนเวลาด้วยคำว่า TIME
```

**กับดัก:** `sed -i` (แก้ไฟล์จริง) ต่างกันระหว่าง GNU/Linux (`sed -i`) กับ macOS (`sed -i ''`) — ในสคริปต์ที่แจกคนอื่น ให้เขียนไฟล์ใหม่แทน:
```bash
sed 's/a/b/g' file > file.new && mv file.new file
```

### C.4 `awk` — ประมวลผลเป็นคอลัมน์

`awk` คิดแบบ "ทีละบรรทัด แต่ละบรรทัดแบ่งเป็นช่อง (`$1`, `$2`, …)":

```bash
awk '{print $1}' server.log                   # ช่องแรกของทุกบรรทัด
awk -F: '{print $2}' file                     # กำหนดตัวคั่นเอง
awk '$1 == "ERROR" {print $2}' file           # กรองตามเงื่อนไข
awk '/ERROR/ {count++} END {print count}' log # นับจำนวนที่ตรง
awk 'NR >= 10 && NR <= 20' file               # เฉพาะบรรทัด 10-20
awk '{sum += $3} END {print sum}' data        # บวกเลขทั้งคอลัมน์
awk '{printf "%-20s %5s\n", $1, $2}' data     # จัดคอลัมน์ให้ตรง
```

**ตัวแปรในตัว `awk`:** `NR` = เลขบรรทัด, `NF` = จำนวนช่อง, `$0` = ทั้งบรรทัด

**ส่งตัวแปรจาก bash เข้าไป:** ใช้ `-v` (วิธีที่ปลอดภัยที่สุด)
```bash
threshold=5
awk -v t="$threshold" '$3 > t {print $1}' data
```

> ⚠️ อย่าเอา `$var` ไปต่อในสตริง awk ตรง ๆ (`awk '{print '"$var"'}'`) เพราะจะเกิดปัญหา quoting และช่องโหว่ injection — ใช้ `-v` เสมอ

### C.5 stdout กับ stderr ในท่อ

```bash
# ❌ ผิดลำดับ: 2>&1 ก่อน | ทำให้ stderr ไปที่จอ ไม่เข้าท่อ
command 2>&1 | grep "error"

# ✅ ถูก: ส่ง stderr ไปรวมกับ stdout แล้วเข้าท่อทั้งคู่
command 2>&1 | grep "error"
```

(ทั้งสองบรรทัดหน้าตาเหมือนกัน แต่ความหมายขึ้นกับตำแหน่ง — กฎคือ `2>&1` ต้องอยู่ **ก่อน** `|` ถ้าอยากให้ error เข้าไปในท่อด้วย และอยู่ **หลัง** ถ้าไม่ต้องการ)

ทางที่ดีกว่าเมื่อต้องการแยก: เก็บ stdout กับ stderr คนละไฟล์
```bash
java -jar paper.jar --nogui > server.out 2> server.err
```

### C.6 รูปแบบบรรทัด log ของ Paper (อ่านให้เป็น)

```text
[02:43:36 INFO]: [EclipseCore] เปิด EclipseCore v1.0.0 บน Paper 26.3 / Java 25
 │          │       │            └─ ข้อความ
 │          │       └─ ชื่อผู้ส่ง (ปลั๊กอิน/ระบบ)
 │          └─ ระดับ (INFO/WARN/ERROR)
 └─ เวลา
```

- บรรทัดที่ไม่มีระดับ (เช่น stack trace) คือ **บรรทัดต่อเนื่อง** ของ error ก่อนหน้า — เวลานับ error ต้องนับเฉพาะบรรทัดที่มี `]: [`
- ระดับที่ต้องสนใจเป็นพิเศษ: `ERROR` (พัง), `WARN` (ควรดู), `SEVERE`

---

## D. ลงมือทำ

### ขั้นที่ 1: สร้างไฟล์ log ตัวอย่าง (ของจริงจากเซิร์ฟเวอร์ทดสอบ)

```bash
mkdir -p ~/minecraft-mmo-dev/server/logs
cat > ~/minecraft-mmo-dev/server/logs/sample.log <<'LOG'
[02:43:21 INFO]: [bootstrap] Running Java 25 (OpenJDK 64-Bit Server VM 25.0.5+8-LTS) on Linux
[02:43:21 INFO]: [bootstrap] Loading Paper 26.3-226-main@4f49049 for Minecraft 26.3
[02:43:22 INFO]: [PluginInitializerManager] Bukkit plugins (1): EclipseCore
[02:43:30 ERROR]: No key layers in MapLike[{}]
[02:43:36 INFO]: [EclipseCore] Enabling EclipseCore v1.0.0
[02:43:37 INFO]: [EclipseCore] เปิด EclipseCore v1.0.0 บน Paper 26.3 / Java 25
[02:43:39 WARN]: [EclipseCore] ไม่พบ LuckPerms — ใช้สิทธิ์แบบ op ไปก่อน
[02:43:41 ERROR]: Could not pass event PlayerJoinEvent to EclipseCore
java.lang.NullPointerException: Cannot invoke "String.length()" because "name" is null
	at com.mengkub.eclipse.listener.PlayerJoinListener.onJoin(PlayerJoinListener.java:42)
[02:43:43 WARN]: Can't keep up! Is the server overloaded? Running 2100ms behind
[02:43:45 INFO]: [EclipseCore] Disabling EclipseCore v1.0.0
LOG
echo "สร้างไฟล์ตัวอย่างแล้ว: $(wc -l < ~/minecraft-mmo-dev/server/logs/sample.log) บรรทัด"
```

> 💡 ไฟล์นี้จำลอง log ที่ **มีทั้งเคสปกติและเคสพังจริง** — ใช้ฝึกได้โดยไม่ต้องมีเซิร์ฟเวอร์รันอยู่

### ขั้นที่ 2: ฝึกคำสั่งในท่อ 8 แบบ

```bash
cd ~/minecraft-mmo-dev/server/logs
grep "ERROR" sample.log | wc -l
grep -c "WARN" sample.log
grep -E "ERROR|WARN" sample.log | sed 's/.*\]: //' | head -3
grep "ERROR" sample.log | sed 's/.*ERROR]://' | sort | uniq -c | sort -rn
awk '/WARN|ERROR/ {print $1}' sample.log | sort | uniq -c
awk '/at com\./ {print $2}' sample.log
awk '{printf "%-6s %-4s %s\n", $1, $3, $5}' sample.log | head -4
sed '/^$/d' sample.log | wc -l
```

**จดผลที่ได้ลง `notes/pipe-practice.md`** — ต้องตอบได้ว่าคำสั่งไหนให้เลขอะไร เพราะอะไร

### ขั้นที่ 3: เริ่ม `scan-log.sh`

```bash
cd ~/minecraft-mmo-dev/scripts
cat > scan-log.sh <<'EOF'
#!/usr/bin/env bash
set -uo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib.sh"

readonly SCRIPT_NAME="$(basename "$0")"
usage() {
  cat <<HELP
วิธีใช้: $SCRIPT_NAME <ไฟล์ log> [--out <ไฟล์สรุป>] [--top N]

ตัวอย่าง:
  $SCRIPT_NAME ~/minecraft-mmo-dev/server/logs/sample.log
  $SCRIPT_NAME logs/latest.log --top 10 --out reports/log-$(date +%F).txt
HELP
}

log_file=""; out_file=""; top=5
while (( $# > 0 )); do
  case "$1" in
    -h|--help) usage; exit 0 ;;
    --out) shift; [[ $# -gt 0 ]] || die "--out ต้องมีค่า" 2; out_file="$1" ;;
    --top) shift; [[ $# -gt 0 ]] || die "--top ต้องมีค่า" 2; top="$1" ;;
    -*) die "ไม่รู้จักตัวเลือก $1" 2 ;;
    *) log_file="$1" ;;
  esac
  shift
done

[[ -n "$log_file" ]] || { usage >&2; die "ต้องระบุไฟล์ log" 2; }
[[ -f "$log_file" ]] || die "ไม่พบไฟล์: $log_file" 2
is_number "$top" || die "--top ต้องเป็นตัวเลข" 2
EOF
chmod +x scan-log.sh && bash -n scan-log.sh && echo "syntax OK"
```

### ขั้นที่ 4: นับและจัดอันดับ error

```bash
cat >> scan-log.sh <<'EOF'

errors=$(grep -c "ERROR" "$log_file" || true)
warns=$(grep -c "WARN" "$log_file" || true)
total=$(wc -l < "$log_file")

{
  printf '=== รายงาน log ===\n'
  printf 'ไฟล์      : %s\n' "$log_file"
  printf 'บรรทัดรวม : %s\n' "$total"
  printf 'ERROR     : %s\n' "$errors"
  printf 'WARN      : %s\n' "$warns"
  printf '\n--- %s ข้อความ ERROR ที่เกิดบ่อยที่สุด ---\n' "$top"
  grep "ERROR" "$log_file" 2>/dev/null \
    | sed -E 's/^\[[^]]*\] *[A-Z]+]: *//' \
    | sort | uniq -c | sort -rn | head -n "$top" \
    || printf '(ไม่มี)\n'

  printf '\n--- ช่วงเวลาที่เกิดปัญหา ---\n'
  grep -E "ERROR|WARN" "$log_file" 2>/dev/null \
    | awk '{print $1}' | sort | uniq -c \
    || printf '(ไม่มี)\n'
} | tee ${out_file:+"$out_file"}
EOF
chmod +x scan-log.sh && bash -n scan-log.sh && echo "syntax OK"
```

### ขั้นที่ 5: ทดสอบ 4 กรณี

```bash
./scan-log.sh ~/minecraft-mmo-dev/server/logs/sample.log ; echo "exit=$?"
./scan-log.sh ~/minecraft-mmo-dev/server/logs/sample.log --top 2 --out /tmp/report.txt >/dev/null ; echo "exit=$?"; head -6 /tmp/report.txt
./scan-log.sh /tmp/ไม่มีไฟล์นี้.log ; echo "exit=$?"
./scan-log.sh ~/minecraft-mmo-dev/server/logs/sample.log --top abc ; echo "exit=$?"
```

| กรณี | ผลที่คาด | exit |
| --- | --- | --- |
| log ตัวอย่าง | ERROR 2, WARN 2 + ตารางอันดับ | 0 |
| `--top 2 --out` | ไฟล์ `/tmp/report.txt` มีเนื้อหาครบ | 0 |
| ไฟล์ไม่มีจริง | "ไม่พบไฟล์" + exit | 2 |
| `--top abc` | error | 2 |

### ขั้นที่ 6: commit

```bash
cd ~/minecraft-dev
git add scripts/scan-log.sh notes/pipe-practice.md
git commit -m "feat: scan-log.sh รายงานสรุป error/warn จาก log"
```

---

## E. ทดสอบ (Definition of Done)

- [ ] รัน 4 กรณีได้ผลตรงตาราง และ exit code ถูก
- [ ] `grep` ที่ไม่พบข้อมูลไม่ทำให้ script ตาย (ใช้ `|| true`)
- [ ] ไม่มี `--top` ที่ทำให้ `head -n` error (`head -n abc`)
- [ ] `--out` เขียนไฟล์ได้ และโฟลเดอร์ปลายทางไม่มี → บอก error ชัดเจน (ทดสอบ)
- [ ] ตอบได้ว่า `2>&1 | grep` ต่างจาก `| grep 2>&1` อย่างไร

---

## F. โค้ดตัวอย่าง (คำสั่งที่มีประโยชน์จริง — เก็บไว้ใช้)

```bash
# 1) ผู้เล่นเข้า-ออก
grep -E "joined the game|left the game" logs/latest.log | tail -20

# 2) error ที่มี stack trace ตามหลัง (แสดง 3 บรรทัดต่อจาก error)
grep -A 3 "Exception" logs/latest.log

# 3) นับ error แยกตามปลั๊กอิน
grep "ERROR" logs/latest.log | grep -oE "\[[A-Za-z0-9_]+\]" | sort | uniq -c | sort -rn

# 4) ดูว่า TPS ตกช่วงไหน
grep -E "Can't keep up|Overloaded" logs/latest.log | awk '{print $1}' | uniq -c

# 5) ดึงค่า config ทั้งหมดที่ไม่ใช่คอมเมนต์
grep -vE "^\s*(#|$)" server.properties | cut -d= -f1 | sort

# 6) สรุปขนาดไฟล์ในโฟลเดอร์ แบบอ่านง่าย
du -h --max-depth=1 . | sort -h
```

---

## G. แบบฝึกหัด

### G.1 พื้นฐาน

จาก `sample.log` ให้ตอบด้วยคำสั่ง **บรรทัดเดียว** (ห้ามเปิดไฟล์ด้วยตา):

1. มีบรรทัดระดับ ERROR กี่บรรทัด
2. บรรทัดแรกที่พูดถึง EclipseCore คือบรรทัดที่เท่าไร
3. มี error/warn เกิดในวินาทีใด (unique) บ้าง
4. ชื่อคลาสที่ทำให้เกิด exception คืออะไร (ดึงจากบรรทัด `at ...`)

### G.2 ประยุกต์

เขียน `scripts/server-report.sh` ที่อ่าน log แล้วสร้างรายงาน Markdown (`reports/YYYY-MM-DD.md`) ประกอบด้วย:

- ตารางสรุป: จำนวนบรรทัด / ERROR / WARN / จำนวน stack trace
- อันดับ 5 error
- รายชื่อปลั๊กอินที่ enable ใน log (จากบรรทัด `Enabling`)
- คำเตือนเรื่องประสิทธิภาพ (ถ้ามี `Can't keep up`) พร้อมจำนวนครั้ง

**เงื่อนไข:** ต้องทำงานได้กับ log ที่ **ไม่มี** error เลย (รายงานต้องบอก "ไม่พบ" ไม่ใช่พัง)

### G.3 คำถามตรวจสอบความเข้าใจ

1. ทำไมต้อง `sort` ก่อน `uniq -c` — ถ้าไม่ sort จะได้อะไร
2. `grep -c` กับ `grep | wc -l` ให้ผลต่างกันในกรณีใด
3. ทำไมควรใช้ `awk -v t="$x"` แทนการต่อสตริง bash เข้าไปในโปรแกรม awk

---

## H. Challenge — `tps-analyzer.sh` วิเคราะห์สุขภาพเซิร์ฟเวอร์จาก log

สร้าง script ที่:

1. อ่าน log ที่มีบรรทัด `/tps` หรือ `Can't keep up! ... Running Nms behind`
2. คำนวณ: จำนวนครั้งที่ TPS ตก, ค่าเฉลี่ย "ms behind", ค่าที่แย่ที่สุด, ช่วงเวลาที่เกิดถี่ที่สุด
3. แสดงกราฟแท่ง ASCII ของจำนวนครั้งต่อชั่วโมง (ใช้ `#` แทนแท่ง, ความกว้างสูงสุด 40 ตัวอักษร)
4. รองรับ `--since "HH:MM"` เพื่อดูเฉพาะช่วงเวลา
5. exit 1 ถ้าพบว่า TPS ตกเกิน 5 ครั้ง (ใช้ใน CI/ตรวจก่อนเปิดเซิร์ฟเวอร์)

**เกณฑ์ผ่าน:** สร้างไฟล์ log ปลอม 100 บรรทัดที่มี TPS ตก 12 ครั้ง แล้ว script ต้องรายงาน 12 ครั้ง, กราฟถูกสัดส่วน และ exit 1

---

## I. Todo Checklist

- [ ] ใช้ `grep -i -v -c -n -E -F -A -B` ได้โดยไม่เปิดเอกสาร
- [ ] เขียนท่อ 3 ขั้นที่ให้รายงานมีประโยชน์ได้
- [ ] ใช้ `awk` ดึงคอลัมน์/กรอง/บวกเลขได้
- [ ] เข้าใจกับดักของ `sed -i` และ `grep` + `set -e`
- [ ] `scan-log.sh` ผ่าน 4 กรณี
- [ ] ทำ G.1, G.2 และตอบ G.3
- [ ] ทำ Challenge `tps-analyzer.sh`
- [ ] commit + อัปเดต PROGRESS

---

## J. ผลลัพธ์

1. `scripts/scan-log.sh` — รายงานสรุป error/warn จาก log
2. `server/logs/sample.log` — ไฟล์ฝึกที่มีเคสจริง
3. `notes/pipe-practice.md` — บันทึกผลการฝึก 8 คำสั่ง
4. `scripts/server-report.sh` + `scripts/tps-analyzer.sh` — ผลงานจากโจทย์

---

## K. Troubleshooting

| อาการ | สาเหตุ | วิธีแก้ |
| --- | --- | --- |
| ท่อได้ผลว่างเปล่า | `grep` ไม่เจอ (exit 1) แล้วคำสั่งถัดไปได้ข้อมูลว่าง | ตรวจคำค้นหา, ใช้ `\|\| true` |
| error ไม่เข้าไปในท่อ | `2>&1` วางผิดที่ | `command 2>&1 \| grep ...` |
| `sed: -i may not be followed by...` | ต่างระบบ (GNU vs BSD) | ใช้ `sed ... > tmp && mv tmp file` |
| `awk: syntax error` | quoting ซ้อนกัน | ใช้ `-v` และ single quote ครอบโปรแกรม awk |
| ตัวเลขไทย/UTF-8 เพี้ยนในรายงาน | locale | `export LC_ALL=C.UTF-8` |
| `head -n abc` error | ไม่ตรวจ `--top` | ตรวจด้วย `is_number` ก่อน |
| บรรทัด stack trace ทำให้นับ error เกิน | นับทุกบรรทัดที่มีคำว่า error | นับเฉพาะบรรทัดรูปแบบ `]: [LEVEL]` |

---

## L. สรุป

- ท่อ = ประกอบคำสั่งเล็ก ๆ เป็นงานใหญ่; แต่ละตัวทำหน้าที่เดียว
- `grep` กรอง, `sed` แทนที่, `awk` ประมวลผลคอลัมน์, `sort|uniq -c` นับความถี่
- ระวัง `grep` + `set -e` (ต้องมี `|| true`) และ `sed -i` ที่ไม่เหมือนกันข้ามระบบ
- ส่งค่าจาก bash เข้า awk ด้วย `-v` เท่านั้น
- log ของ Paper มีรูปแบบคงที่ — อ่านให้เป็นแล้วจะdebugได้เร็วขึ้นหลายเท่า

**บทต่อไป (Day 13):** สิทธิ์ไฟล์เชิงลึก `chmod` / `chown` / `umask` — เรื่องที่แยก "เซิร์ฟเวอร์ที่ปลอดภัย" ออกจาก "เซิร์ฟเวอร์ที่ใครก็แก้ไฟล์ได้"

---

## M. Progress Update

```text
### Day 012 — วันที่ ____-__-__
- เรียน: pipe, grep (-i -v -c -n -E -F -A -B), sed แทนที่/ลบ, awk คอลัมน์/เงื่อนไข/บวกเลข, stdout vs stderr
- ทำเสร็จ: scripts/scan-log.sh, server/logs/sample.log, notes/pipe-practice.md, G.2 server-report.sh, H tps-analyzer.sh
- ทดสอบ: 4 กรณีผ่าน / report.txt มีเนื้อหาครบ / ไฟล์ไม่มีจริง exit 2
- ยังไม่เข้าใจ: ______
- Error ที่เจอ: ______ (แก้ด้วย ______)
- งานถัดไป: Day 13 — chmod/chown/umask และตารางทดลองสิทธิ์
- คะแนนตัวเอง: __/5
```
