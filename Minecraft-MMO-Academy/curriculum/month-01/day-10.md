# Day 10 — Shell Script: ลูป `for` / `while`

> 📅 Month 1 · Week 2 · ~150 นาที · **โหมด: Guided Practice → Independent Practice**
> 🎯 วันนี้ทำให้ script ทำงานซ้ำได้ — ทั้งกับรายการที่เรารู้ล่วงหน้า และกับข้อมูลที่เพิ่งอ่านเจอ

---

## A. เป้าหมาย

จบบทนี้คุณจะ:

- ใช้ `for` กับรายการค่า, กับ array และแบบนับจำนวน (`for (( ))`) ได้
- ใช้ `while` กับเงื่อนไข และ `while IFS= read -r` อ่านไฟล์ทีละบรรทัดอย่างปลอดภัย
- ใช้ `break` / `continue` ควบคุมจังหวะ
- เขียนลูปแบบ **idempotent** (รันซ้ำได้ผลเท่าเดิม) และมี `--dry-run`
- รู้จักลูปแบบ "ลองใหม่" (retry) ซึ่งใช้จริงเวลาเริ่มเซิร์ฟเวอร์

**ผลงานที่ต้องได้:** `~/minecraft-mmo-dev/scripts/create-worlds.sh` — สร้างโฟลเดอร์โลกหลายชุดตามรายชื่อ มี `--dry-run`, ไม่ทับของเดิม, สรุปผลท้ายงาน และ exit code ถูกต้อง

---

## B. ความรู้ที่ต้องมี

- Day 08–09: ตัวแปร, อาร์กิวเมนต์, `case`, ตรวจค่า
- Day 06: แนวคิดลูปในผังงาน

---

## C. แนวคิด

### C.1 `for` สามแบบที่ต้องใช้เป็น

```bash
# 1) วนกับรายการค่าคงที่
for world in survival skyblock creative; do
  echo "world: $world"
done

# 2) วนกับ array (แนะนำเมื่อรายการมาจากที่อื่น)
worlds=("survival" "skyblock" "creative")
for world in "${worlds[@]}"; do
  echo "world: $world"
done

# 3) นับจำนวน (C-style)
for (( i = 1; i <= 3; i++ )); do
  echo "รอบที่ $i"
done
```

**ทำไมต้อง `"${worlds[@]}"` (มี quote)?** ถ้าชื่อมีช่องว่าง (`"my world"`) การไม่ quote จะทำให้มันแตกเป็น 2 รอบ — เหมือนเรื่องใน Day 08

**ห้ามใช้ `for x in $(cat file)`** เพราะจะแตกคำตามช่องว่าง และถ้าไฟล์ใหญ่จะโหลดทั้งหมดเข้า memory (ดู C.3)

### C.2 `while` — ทำซ้ำตราบใดที่เงื่อนไขยังจริง

```bash
count=1
while (( count <= 3 )); do
  echo "นับ: $count"
  count=$((count + 1))      # อย่าลืม! ถ้าไม่เพิ่ม จะวนไม่จบ (infinite loop)
done

# วนจนกว่าจะสำเร็จ (สูงสุด 5 ครั้ง)
try=1
until some_command; do
  echo "ลองครั้งที่ $try ไม่สำเร็จ"
  (( try++ ))
  (( try > 5 )) && { echo "เลิกลองหลัง 5 ครั้ง" >&2; break; }
  sleep 2
done
```

> ⚠️ `while true; do ...; done` ต้องมี `break` เสมอ ไม่งั้นต้องกด Ctrl+C — และถ้ารันใน cron จะค้างทั้งระบบ

### C.3 อ่านไฟล์ทีละบรรทัดอย่างปลอดภัย

```bash
while IFS= read -r line || [[ -n "$line" ]]; do
  echo "บรรทัด: $line"
done < "$file"
```

อธิบายทีละส่วน:

| ส่วน | ทำอะไร |
| --- | --- |
| `IFS=` | ไม่ตัดช่องว่างหัว-ท้ายบรรทัดทิ้ง (คงข้อมูลเดิม) |
| `read -r` | ไม่ตีความ `\` (backslash) — กันเส้นทางไฟล์เพี้ยน |
| `line` | ตัวแปรรับค่าบรรทัด |
| `\|\| [[ -n "$line" ]]` | จัดการบรรทัดสุดท้ายที่ไม่มี newline ปิดท้าย |
| `< "$file"` | ป้อนไฟล์เข้าเป็น stdin ของ `while` (ไม่ใช่ของคำสั่งข้างใน) |

**ข้ามบรรทัดว่างและคอมเมนต์:**

```bash
while IFS= read -r line || [[ -n "$line" ]]; do
  [[ -z "$line" || "$line" == \#* ]] && continue
  echo "ใช้: $line"
done < "$file"
```

### C.4 `break` กับ `continue`

- `continue` = ข้ามรอบนี้ ไปรอบถัดไป
- `break` = ออกจากลูปทันที

```bash
for port in 25565 25566 25567; do
  if ss -ltn "sport = :$port" 2>/dev/null | grep -q LISTEN; then
    echo "พอร์ต $port ถูกใช้อยู่ — ข้าม"
    continue
  fi
  echo "พอร์ต $port ว่าง"
done
```

### C.5 Idempotent: คุณสมบัติที่ทำให้ script ใช้ซ้ำได้อย่างปลอดภัย

**Idempotent** = รัน 1 ครั้ง กับรัน 10 ครั้ง ได้ผลเหมือนกัน

```bash
mkdir -p "$dir"           # ✅ มีอยู่แล้วก็ไม่ error
rm -rf "$dir"             # ⚠️ รันซ้ำ = ลบของที่เพิ่งสร้าง (อันตราย)
[ -d "$dir" ] || mkdir "$dir"   # ✅ ชัดเจนที่สุด
```

หลักปฏิบัติ 3 ข้อ:
1. ก่อนสร้าง → ตรวจว่ามีอยู่แล้วไหม (`-d`, `-f`)
2. ก่อนลบ → ตรวจว่าเป็นสิ่งที่เราสร้างเอง (ดูพาธให้ดี)
3. มี `--dry-run` ให้ลองก่อนทำจริง **ทุกครั้ง** ที่ script เขียน/ลบข้อมูล

### C.6 ลูปแบบ retry (ใช้จริงตอนรอเซิร์ฟเวอร์บูต)

```bash
wait_for_port() {
  local port="$1" tries="${2:-30}" i
  for (( i = 0; i < tries; i++ )); do
    if ss -ltn "sport = :$port" 2>/dev/null | grep -q LISTEN; then
      return 0
    fi
    sleep 1
  done
  return 1
}
```

> 🔐 **Security note:** retry loop ต้องมี **เพดานจำนวนครั้ง** เสมอ ไม่ใช่ `while true` — ไม่งั้นถ้าบริการตาย script จะค้างตลอดกาล และกลายเป็นช่องโหว่แบบ DoS ต่อตัวเอง

---

## D. ลงมือทำ

### ขั้นที่ 1: โครง + help + ค่าเริ่มต้น

```bash
cd ~/minecraft-mmo-dev/scripts
cat > create-worlds.sh <<'EOF'
#!/usr/bin/env bash
set -uo pipefail

readonly SCRIPT_NAME="$(basename "$0")"
BASE_DIR="${HOME}/minecraft-mmo-dev/server/worlds"
DRY_RUN=0

usage() {
  cat <<HELP
วิธีใช้: $SCRIPT_NAME [--dry-run] [--base <โฟลเดอร์>] [ชื่อโลก...]

ตัวอย่าง:
  $SCRIPT_NAME survival skyblock creative
  $SCRIPT_NAME --dry-run survival
  $SCRIPT_NAME --base ~/test-worlds survival
HELP
}

worlds=()
while (( $# > 0 )); do
  case "$1" in
    -h|--help) usage; exit 0 ;;
    --dry-run) DRY_RUN=1 ;;
    --base)
      shift
      [[ $# -gt 0 ]] || { echo "ข้อผิดพลาด: --base ต้องมีค่า" >&2; exit 2; }
      BASE_DIR="$1" ;;
    -*) echo "ข้อผิดพลาด: ไม่รู้จักตัวเลือก $1" >&2; exit 2 ;;
    *) worlds+=("$1") ;;
  esac
  shift
done

(( ${#worlds[@]} > 0 )) || { echo "ข้อผิดพลาด: ต้องระบุชื่อโลกอย่างน้อย 1 ชื่อ" >&2; exit 2; }
EOF
chmod +x create-worlds.sh && bash -n create-worlds.sh && echo "syntax OK"
```

### ขั้นที่ 2: ตรวจชื่อโลกก่อนสร้าง (กัน path traversal)

```bash
cat >> create-worlds.sh <<'EOF'

# ชื่อโลกต้องเป็นตัวอักษร ตัวเลข _ - เท่านั้น
for w in "${worlds[@]}"; do
  if ! [[ "$w" =~ ^[a-zA-Z0-9_-]{1,32}$ ]]; then
    echo "ข้อผิดพลาด: ชื่อโลก '$w' ใช้ไม่ได้ (a-z 0-9 _ - เท่านั้น, ไม่เกิน 32 ตัว)" >&2
    exit 2
  fi
done
EOF
bash -n create-worlds.sh && echo "syntax OK"
```

> 🔐 **ทำไมต้องตรวจ?** ถ้าปล่อยให้ชื่อมี `../` ผู้ใช้จะสั่ง script ให้สร้าง (หรือลบ) โฟลเดอร์นอกขอบเขตได้ — นี่คือช่องโหว่ **path traversal** ที่เจอจริงในปลั๊กอินเกมหลายตัว

### ขั้นที่ 3: ลูปสร้างโฟลเดอร์ (idempotent)

```bash
cat >> create-worlds.sh <<'EOF'

[[ "$DRY_RUN" -eq 1 ]] && printf '[dry-run] จะสร้างโฟลเดอร์ใต้: %s\n' "$BASE_DIR"
[[ "$DRY_RUN" -eq 0 ]] && mkdir -p "$BASE_DIR"

created=0; existed=0; failed=0
for w in "${worlds[@]}"; do
  target="$BASE_DIR/$w"
  if [[ -d "$target" ]]; then
    printf '  = มีอยู่แล้ว  %s\n' "$target"
    existed=$((existed + 1))
    continue
  fi
  if [[ "$DRY_RUN" -eq 1 ]]; then
    printf '  + จะสร้าง    %s\n' "$target"
    created=$((created + 1))
    continue
  fi
  if mkdir -p "$target"; then
    printf '  + สร้างแล้ว   %s\n' "$target"
    created=$((created + 1))
  else
    printf '  ! ล้มเหลว     %s\n' "$target" >&2
    failed=$((failed + 1))
  fi
done
EOF
bash -n create-worlds.sh && echo "syntax OK"
```

### ขั้นที่ 4: สรุปผล + exit code

```bash
cat >> create-worlds.sh <<'EOF'

printf '\nสรุป: สร้างใหม่ %d | มีอยู่แล้ว %d | ล้มเหลว %d\n' "$created" "$existed" "$failed"
if (( failed > 0 )); then exit 1; fi
if (( DRY_RUN == 1 )); then printf 'หมายเหตุ: โหมด dry-run ไม่มีการเปลี่ยนแปลงจริง\n'; fi
exit 0
EOF
chmod +x create-worlds.sh && bash -n create-worlds.sh && echo "syntax OK"
```

### ขั้นที่ 5: ทดสอบ 6 กรณี

```bash
./create-worlds.sh --dry-run survival skyblock        ; echo "exit=$?"
./create-worlds.sh --base /tmp/wtest survival skyblock ; echo "exit=$?"
./create-worlds.sh --base /tmp/wtest survival          ; echo "exit=$?"   # ต้องขึ้น "มีอยู่แล้ว"
ls -1 /tmp/wtest
./create-worlds.sh "../etc"      ; echo "exit=$?"   # ต้องปฏิเสธ
./create-worlds.sh               ; echo "exit=$?"   # ต้องบอกวิธีใช้
./create-worlds.sh --base         ; echo "exit=$?"   # --base ไม่มีค่า
```

| กรณี | ผลที่คาด | exit |
| --- | --- | --- |
| `--dry-run survival skyblock` | แสดง "จะสร้าง" 2 บรรทัด ไม่มีไฟล์จริง | 0 |
| `--base /tmp/wtest survival skyblock` | สร้างจริง 2 โฟลเดอร์ | 0 |
| รันซ้ำคำสั่งเดิม | "มีอยู่แล้ว" 2 บรรทัด | 0 |
| `../etc` | error ชื่อโลกใช้ไม่ได้ | 2 |
| ไม่ใส่อะไร | วิธีใช้ | 2 |
| `--base` (ไม่มีค่า) | error | 2 |

### ขั้นที่ 6: commit

```bash
cd ~/minecraft-dev
git add scripts/create-worlds.sh
git commit -m "feat: create-worlds.sh สร้างโฟลเดอร์โลกแบบ idempotent พร้อม dry-run"
```

---

## E. ทดสอบ (Definition of Done)

- [ ] รัน 6 กรณีได้ผลตรงตาราง (โดยเฉพาะ "รันซ้ำแล้วไม่พัง")
- [ ] `--dry-run` ไม่สร้างโฟลเดอร์จริง (ตรวจด้วย `ls` ก่อน/หลัง)
- [ ] `bash -n` ผ่าน และไม่มีลูปที่ไม่มีวันจบ (`while true` ที่ไม่มี `break`)
- [ ] ชื่อที่มี `/` หรือ `..` ถูกปฏิเสธ
- [ ] สรุปผลท้ายงานแสดงตัวเลขตรงกับจำนวนโฟลเดอร์จริง

---

## F. โค้ดตัวอย่าง (ฉบับสมบูรณ์)

```bash
#!/usr/bin/env bash
# create-worlds.sh — สร้างโฟลเดอร์โลกหลายชุด (idempotent + dry-run) (Day 10)
set -uo pipefail

readonly SCRIPT_NAME="$(basename "$0")"
BASE_DIR="${HOME}/minecraft-mmo-dev/server/worlds"
DRY_RUN=0

usage() {
  cat <<HELP
วิธีใช้: $SCRIPT_NAME [--dry-run] [--base <โฟลเดอร์>] [ชื่อโลก...]
ตัวอย่าง:
  $SCRIPT_NAME survival skyblock creative
  $SCRIPT_NAME --dry-run survival
HELP
}

worlds=()
while (( $# > 0 )); do
  case "$1" in
    -h|--help) usage; exit 0 ;;
    --dry-run) DRY_RUN=1 ;;
    --base) shift; [[ $# -gt 0 ]] || { echo "ข้อผิดพลาด: --base ต้องมีค่า" >&2; exit 2; }; BASE_DIR="$1" ;;
    -*) echo "ข้อผิดพลาด: ไม่รู้จักตัวเลือก $1" >&2; exit 2 ;;
    *) worlds+=("$1") ;;
  esac
  shift
done

(( ${#worlds[@]} > 0 )) || { echo "ข้อผิดพลาด: ต้องระบุชื่อโลกอย่างน้อย 1 ชื่อ" >&2; exit 2; }

for w in "${worlds[@]}"; do
  [[ "$w" =~ ^[a-zA-Z0-9_-]{1,32}$ ]] || {
    echo "ข้อผิดพลาด: ชื่อโลก '$w' ใช้ไม่ได้ (a-z 0-9 _ - เท่านั้น, ไม่เกิน 32 ตัว)" >&2; exit 2; }
done

if (( DRY_RUN == 1 )); then printf '[dry-run] จะสร้างโฟลเดอร์ใต้: %s\n' "$BASE_DIR"
else mkdir -p "$BASE_DIR" || { echo "ข้อผิดพลาด: สร้าง $BASE_DIR ไม่ได้" >&2; exit 1; }; fi

created=0; existed=0; failed=0
for w in "${worlds[@]}"; do
  target="$BASE_DIR/$w"
  if [[ -d "$target" ]]; then
    printf '  = มีอยู่แล้ว  %s\n' "$target"; existed=$((existed+1)); continue
  fi
  if (( DRY_RUN == 1 )); then
    printf '  + จะสร้าง    %s\n' "$target"; created=$((created+1)); continue
  fi
  if mkdir -p "$target"; then
    printf '  + สร้างแล้ว   %s\n' "$target"; created=$((created+1))
  else
    printf '  ! ล้มเหลว     %s\n' "$target" >&2; failed=$((failed+1))
  fi
done

printf '\nสรุป: สร้างใหม่ %d | มีอยู่แล้ว %d | ล้มเหลว %d\n' "$created" "$existed" "$failed"
(( failed > 0 )) && exit 1
exit 0
```

**อธิบาย 4 จุด:** (1) ลูปเดียวจัดการทั้ง dry-run และทำจริง → โค้ดสั้นและไม่มีทาง "โหมดหนึ่งลืมแก้" (2) ตรวจชื่อด้วย regex ก่อนแตะระบบไฟล์ (3) `mkdir -p` + ตรวจ `-d` ทำให้ idempotent (4) สรุปผล + exit 1 เมื่อมีข้อล้มเหลว → เอาไปใช้ต่อใน CI/cron ได้

---

## G. แบบฝึกหัด

### G.1 พื้นฐาน

เขียน `scripts/count-players.sh` ที่อ่านไฟล์รายชื่อผู้เล่น (บรรทัดละชื่อ) แล้วรายงาน:
- จำนวนบรรทัดทั้งหมด, จำนวนที่ว่าง, จำนวนคอมเมนต์ (`#`), จำนวนชื่อจริง
- แสดงชื่อจริงพร้อมเลขลำดับ (`1. Somchai`)

ใช้ `while IFS= read -r` และ `continue` เท่านั้น (ห้ามใช้ `wc -l` สำหรับชื่อจริง)

### G.2 ประยุกต์

เขียน `scripts/wait-for-port.sh <port> [จำนวนครั้ง]` ที่:
1. ตรวจพอร์ตทุก 1 วินาที (ใช้ `ss -ltn` หรือ `nc -z` แล้วแต่มีอะไรในเครื่อง)
2. หยุดเมื่อพอร์ตเปิด (exit 0) หรือครบจำนวนครั้ง (exit 1)
3. แสดงเวลาที่รอไปแล้วทุก 5 ครั้ง
4. รับ `--quiet` ที่ไม่พิมพ์อะไรเลย (ใช้ใน script อื่น)

**ทำไมต้องทำ:** Day 26 จะใช้ตัวนี้ตอน start เซิร์ฟเวอร์ แล้วรอให้พร้อมก่อนแจ้งผู้เล่น

### G.3 คำถามตรวจสอบความเข้าใจ

1. ถ้า `while (( count <= 3 ))` แล้วลืม `count=$((count+1))` จะเกิดอะไร และจะหยุดได้อย่างไร
2. ทำไม `for line in $(cat file)` ถึงพังกับชื่อที่มีช่องว่าง แต่ `while IFS= read -r` ไม่พัง
3. `continue` กับ `break` ต่างกันอย่างไร และถ้าอยู่ในลูปซ้อน 2 ชั้น `break` ออกจากชั้นไหน

---

## H. Challenge — `backup-rotate.sh` ระบบสำรองข้อมูลแบบหมุนเวียน

สร้าง script ที่:

1. สำรองโฟลเดอร์ `worlds/` เป็นไฟล์ `backup-YYYY-MM-DD_HHMM.tar.gz` ใต้ `backups/`
2. เก็บย้อนหลังตามจำนวนที่กำหนด (`--keep 7` ค่าเริ่มต้น 7) — ลบไฟล์เก่าสุดที่เกินจำนวน **โดยตรวจชื่อไฟล์ให้ตรงรูปแบบก่อนลบเท่านั้น**
3. มี `--dry-run` แสดงว่าจะสร้าง/ลบอะไร
4. ถ้าไม่มีอะไรให้สำรอง → exit 1 พร้อมข้อความชัดเจน
5. แสดงตารางสรุป: ชื่อไฟล์, ขนาด (อ่านง่ายแบบ `du -h`), วันที่

**เกณฑ์ผ่าน:** รัน 3 ครั้งด้วย `--keep 2` แล้วต้องเหลือไฟล์ 2 ไฟล์ล่าสุด และ **ไม่มีไฟล์อื่นใน `backups/` หายไป** (ทดสอบโดยวางไฟล์ `important.txt` ไว้ในโฟลเดอร์นั้น)

> 🔐 บทเรียนความปลอดภัย: การลบด้วย wildcard (`rm backups/*`) คือต้นเหตุของหายนะที่พบบ่อยที่สุด — ต้องตรวจรูปแบบชื่อไฟล์และกัน `--` เสมอ: `rm -- "$file"`

---

## I. Todo Checklist

- [ ] เขียน `for` ได้ทั้ง 3 แบบโดยไม่เปิดเอกสาร
- [ ] อธิบาย `IFS= read -r` ทีละส่วนได้
- [ ] เข้าใจ idempotent และทำ `--dry-run` เป็นนิสัย
- [ ] `create-worlds.sh` ผ่าน 6 กรณี
- [ ] ทำ G.1, G.2 และตอบ G.3
- [ ] ทำ Challenge `backup-rotate.sh` (ทดสอบเคส "ไฟล์อื่นต้องไม่หาย")
- [ ] commit + อัปเดต PROGRESS/TODO

---

## J. ผลลัพธ์

1. `scripts/create-worlds.sh` — idempotent, มี dry-run, ตรวจชื่อโลก, สรุปผล
2. `scripts/count-players.sh` — รายงานไฟล์รายชื่อผู้เล่น
3. `scripts/wait-for-port.sh` — ใช้ซ้ำได้ใน Day 26
4. `scripts/backup-rotate.sh` — ระบบสำรองข้อมูลหมุนเวียน (พื้นฐานของ Day 18)

---

## K. Troubleshooting

| อาการ | สาเหตุ | วิธีแก้ |
| --- | --- | --- |
| script ค้างไม่จบ | `while` ไม่มีตัวเปลี่ยนเงื่อนไข หรือ `while true` ไม่มี `break` | เพิ่มตัวนับ/`break` + ทดสอบด้วย `timeout 10 ./script.sh` |
| ชื่อไฟล์ถูกตัดเป็นหลายชิ้น | `for x in $(...)` หรือไม่ quote array | `while IFS= read -r` หรือ `"${arr[@]}"` |
| บรรทัดสุดท้ายของไฟล์หาย | ไฟล์ไม่มี newline ปิดท้าย | เติม `\|\| [[ -n "$line" ]]` |
| ลูปในลูปใช้ตัวแปรทับกัน | ใช้ชื่อตัวแปรซ้ำ | ตั้งชื่อให้ต่าง หรือใช้ `local` ในฟังก์ชัน (Day 11) |
| `mkdir` ฟ้อง File exists | ไม่ได้ใช้ `-p` หรือไม่ได้ตรวจ `-d` ก่อน | `mkdir -p` + ตรวจก่อน |
| ไฟล์ backup หายหมด | ใช้ `rm backups/*` โดยไม่ตรวจรูปแบบ | ตรวจ regex ชื่อไฟล์ + `rm -- "$f"` |
| prompt ค้างตอน `read` ในลูป | `read` แย่ง stdin กับลูป | ใช้ `< /dev/null` หรือ `read ... < /dev/tty` |

---

## L. สรุป

- `for` มี 3 แบบ: รายการ, array (`"${arr[@]}"`), และนับจำนวน (`for (( ))`)
- `while IFS= read -r line` คือวิธีมาตรฐานอ่านไฟล์ทีละบรรทัด
- ลูปต้องมี **ทางออกเสมอ** (ตัวนับ/`break`) — นี่เป็นเรื่องความปลอดภัย ไม่ใช่แค่สไตล์
- Idempotent + `--dry-run` ทำให้ script ใช้ซ้ำได้โดยไม่ทำข้อมูลหาย
- ลูป retry ที่มีเพดานจำนวนครั้ง คือพื้นฐานของการรอเซิร์ฟเวอร์/Day 26

**บทต่อไป (Day 11):** ฟังก์ชันและการคืนค่า — เราจะแยกโค้ดซ้ำ ๆ เป็น `lib.sh` ที่เรียกใช้จาก script อื่นได้

---

## M. Progress Update

```text
### Day 010 — วันที่ ____-__-__
- เรียน: for 3 แบบ, while/until, IFS= read -r, break/continue, idempotent, dry-run, retry loop
- ทำเสร็จ: scripts/create-worlds.sh (6 กรณีผ่าน), G.1 count-players.sh, G.2 wait-for-port.sh, H backup-rotate.sh
- ทดสอบ: dry-run ไม่สร้างไฟล์จริง / รันซ้ำไม่พัง / ชื่อ ../ ถูกปฏิเสธ
- ยังไม่เข้าใจ: ______
- Error ที่เจอ: ______ (แก้ด้วย ______)
- งานถัดไป: Day 11 — ฟังก์ชัน, lib.sh, return vs exit
- คะแนนตัวเอง: __/5
```
