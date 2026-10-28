# Day 11 — Shell Script: ฟังก์ชันและการคืนค่า

> 📅 Month 1 · Week 2 · ~150 นาที · **โหมด: Guided Practice**
> 🎯 เป้าหมายวันนี้: หยุดเขียนโค้ดซ้ำ — แยกเป็นฟังก์ชันที่ **ทดสอบแยกได้** และใช้ร่วมกันหลาย script

---

## A. เป้าหมาย

จบบทนี้คุณจะ:

- ประกาศและเรียกฟังก์ชันได้ พร้อมส่งอาร์กิวเมนต์และอ่านค่าที่คืนกลับ
- แยกความต่างของ `return` (exit code 0–255) กับ `echo` (ข้อมูลจริง) — จุดที่มือใหม่สับสนมากที่สุด
- ใช้ `local` ป้องกันตัวแปรทับกัน และเข้าใจ scope
- สร้างไฟล์ไลบรารี (`lib.sh`) ที่ `source` เข้าไปใช้จาก script อื่น
- เขียนฟังก์ชันที่ **ทดสอบได้** (เรียกทีละตัว ไม่ต้องรันทั้ง script)

**ผลงานที่ต้องได้:** `~/minecraft-mmo-dev/scripts/lib.sh` ที่มีฟังก์ชัน 5 ตัว (log, die, need_cmd, is_number, prompt_default) + script อย่างน้อย 1 ตัวที่ `source` ไลบรารีนี้แล้วเรียกใช้

---

## B. ความรู้ที่ต้องมี

- Day 08–10: ตัวแปร, เงื่อนไข, ลูป, exit code

---

## C. แนวคิด

### C.1 ฟังก์ชันคืออะไร (และทำไมต้องมี)

```bash
log() {
  printf '[%s] %s\n' "$(date '+%H:%M:%S')" "$*"
}

log "เริ่มสำรองข้อมูล"
```

**เหตุผลที่ต้องแยกฟังก์ชัน:**

| ถ้าไม่แยก | ถ้าแยก |
| --- | --- |
| แก้รูปแบบ log ต้องแก้ 30 ที่ | แก้ที่เดียว |
| ทดสอบทีละส่วนไม่ได้ | เรียกทดสอบได้ตรง ๆ |
| ชื่อซ้ำกันจนอ่านไม่รู้เรื่อง | ชื่อบอกหน้าที่ชัด |

### C.2 อาร์กิวเมนต์ของฟังก์ชัน — ใช้ `$1`, `$@` เหมือน script

```bash
greet_player() {
  local name="${1:-ผู้เล่นใหม่}"     # local = มีชีวิตแค่ในฟังก์ชัน
  local level="${2:-1}"
  printf 'สวัสดี %s (Lv.%s)\n' "$name" "$level"
}

greet_player "Somchai" 12
```

> ⚠️ `$1` ในฟังก์ชัน **ไม่ใช่** `$1` ของ script — ฟังก์ชันมีอาร์กิวเมนต์ของตัวเอง แต่ `$0` ยังเป็นชื่อ script

### C.3 `return` vs `echo` — หัวข้อที่คนพลาดมากที่สุด

```bash
# ผิด: พยายาม return ข้อความ
get_name() {
  return "Somchai"        # ❌ return รับได้แค่เลข 0-255
}

# ถูกแบบที่ 1: คืน "ข้อมูล" ทาง stdout
get_name() {
  echo "Somchai"          # ผู้เรียกจับด้วย $( )
}
name="$(get_name)"

# ถูกแบบที่ 2: คืน "สถานะ" ทาง exit code
is_number() {
  [[ "$1" =~ ^[0-9]+$ ]]  # 0 = ใช่, 1 = ไม่ใช่
}
if is_number "42"; then echo "เป็นตัวเลข"; fi
```

**กฎที่ต้องจำ:**

| อยากคืนอะไร | ใช้ |
| --- | --- |
| ข้อความ/ตัวเลขผลลัพธ์ | `echo` แล้วผู้เรียกจับด้วย `$(...)` |
| สำเร็จ/ล้มเหลว | `return 0` / `return 1` แล้วใช้ใน `if` |
| หยุดทั้ง script | `exit N` (ไม่ใช่ `return`) |

> 💡 ถ้าฟังก์ชัน `echo` ข้อความอื่นปนออกมา (เช่น debug) คนที่จับด้วย `$( )` จะได้ค่าปนกัน — ให้ log ทั้งหมดออก **stderr** (`>&2`) เพื่อแยกให้ชัด

### C.4 ไลบรารี: `source` และพาธที่ปลอดภัย

```bash
# ใน script ของคุณ (บรรทัดบน ๆ)
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "${SCRIPT_DIR}/lib.sh"
```

- `${BASH_SOURCE[0]}` = พาธของไฟล์ที่กำลังรัน (ดีกว่า `$0` เพราะถ้า script ถูก source จะได้พาธถูก)
- `cd ... && pwd` แปลงพาธเป็นแบบเต็ม (absolute) — ทำให้เรียกจากโฟลเดอร์ไหนก็ได้
- **ห้าม** hard-code `~/minecraft-mmo-dev/scripts/lib.sh` เพราะจะพังเมื่อย้ายโปรเจกต์

### C.5 `local` และกับดัก scope

```bash
count=10

bump() {
  count=99                 # ⚠️ ไม่มี local → แก้ตัวแปร global!
}
bump
echo "$count"              # 99 (อาจไม่ใช่สิ่งที่ต้องการ)

bump_safe() {
  local count=1            # ✅ แยกของตัวเอง
  count=$((count + 1))
  echo "$count"            # 2
}
```

**กฎ:** ตัวแปรทุกตัวในฟังก์ชัน ควรประกาศ `local` ยกเว้นตั้งใจแก้ค่าข้างนอกจริง ๆ

### C.6 ฟังก์ชันที่ควรมีในทุกโปรเจกต์ (และเราจะสร้างวันนี้)

| ฟังก์ชัน | หน้าที่ | คืนค่า |
| --- | --- | --- |
| `log "ข้อความ"` | พิมพ์ log พร้อมเวลา ไป stderr | — |
| `die "ข้อความ" [code]` | พิมพ์ error + `exit` | ไม่กลับมา |
| `need_cmd java` | ตรวจว่ามีคำสั่งนี้ในเครื่อง | 0/1 |
| `is_number "$v"` | ตรวจว่าเป็นจำนวนเต็ม | 0/1 |
| `prompt_default "ถาม" "ค่าเริ่มต้น"` | ถามผู้ใช้ คืนค่าที่ได้ | echo ค่า |

---

## D. ลงมือทำ

### ขั้นที่ 1: สร้าง `lib.sh` พร้อม header

```bash
cd ~/minecraft-mmo-dev/scripts
cat > lib.sh <<'EOF'
#!/usr/bin/env bash
# lib.sh — ไลบรารีฟังก์ชันที่ใช้ร่วมกันทั้งหลักสูตร (Day 11)
# วิธีใช้: source "${SCRIPT_DIR}/lib.sh"
# หมายเหตุ: ไฟล์นี้ไม่ควรถูกเรียกให้รันตรง ๆ (ไม่มี main)

# ป้องกันการถูก source ซ้ำ
[[ -n "${__LIB_SH_LOADED:-}" ]] && return 0
__LIB_SH_LOADED=1

readonly LOG_PREFIX="$(basename "${BASH_SOURCE[0]:-lib}")"
EOF
bash -n lib.sh && echo "syntax OK"
```

### ขั้นที่ 2: `log` และ `die`

```bash
cat >> lib.sh <<'EOF'

# log — พิมพ์ข้อความพร้อมเวลาไป stderr (ไม่ปนกับผลลัพธ์ของ script)
log() {
  printf '[%s] %s\n' "$(date '+%H:%M:%S')" "$*" >&2
}

# warn — คำเตือนสีเหลือง (ถ้า terminal รองรับ)
warn() {
  printf '[%s] ⚠ %s\n' "$(date '+%H:%M:%S')" "$*" >&2
}

# die — พิมพ์ error แล้วจบ script ด้วย exit code ที่กำหนด (ค่าเริ่มต้น 1)
die() {
  local message="${1:-เกิดข้อผิดพลาด}"
  local code="${2:-1}"
  printf '[%s] ✖ %s\n' "$(date '+%H:%M:%S')" "$message" >&2
  exit "$code"
}
EOF
bash -n lib.sh && echo "syntax OK"
```

### ขั้นที่ 3: ฟังก์ชันตรวจสอบ

```bash
cat >> lib.sh <<'EOF'

# need_cmd — ตรวจว่ามีคำสั่งอยู่ใน PATH (0 = มี, 1 = ไม่มี)
need_cmd() {
  command -v "$1" >/dev/null 2>&1
}

# is_number — จำนวนเต็ม (ติดลบได้)
is_number() {
  [[ "${1:-}" =~ ^-?[0-9]+$ ]]
}

# is_decimal — ทศนิยมไม่เกิน 2 ตำแหน่ง (ไม่ติดลบ)
is_decimal() {
  [[ "${1:-}" =~ ^[0-9]+(\.[0-9]{1,2})?$ ]]
}

# is_port — พอร์ตที่ผู้ใช้ทั่วไปเปิดได้
is_port() {
  local p="${1:-}"
  is_number "$p" || return 1
  (( p >= 1024 && p <= 65535 ))
}
EOF
bash -n lib.sh && echo "syntax OK"
```

### ขั้นที่ 4: ฟังก์ชันถามค่า (คืนค่าทาง stdout)

```bash
cat >> lib.sh <<'EOF'

# prompt_default "คำถาม" "ค่าเริ่มต้น" — ถามผู้ใช้ คืนค่าทาง stdout
# ถ้าไม่มี terminal (เช่นรันใน cron) จะคืนค่าเริ่มต้นทันที
prompt_default() {
  local question="$1"
  local default_value="${2:-}"
  local answer=""
  if [[ -t 0 ]]; then
    read -rp "${question} [${default_value}]: " answer || true
  fi
  printf '%s' "${answer:-$default_value}"
}
EOF
bash -n lib.sh && echo "syntax OK"
```

### ขั้นที่ 5: ทดสอบไลบรารีแยกทีละฟังก์ชัน

```bash
cat > /tmp/test-lib.sh <<'EOF'
#!/usr/bin/env bash
set -uo pipefail
source "$HOME/minecraft-mmo-dev/scripts/lib.sh"

log "ทดสอบ log"
warn "ทดสอบ warn"

if need_cmd java; then log "พบ java"; else warn "ไม่พบ java"; fi
is_number 42   && log "42 เป็นตัวเลข"     || warn "42 ไม่ใช่ตัวเลข"
is_number 4x2  && warn "ผิด: 4x2 ผ่าน"     || log "4x2 ไม่ใช่ตัวเลข (ถูก)"
is_decimal 10.5 && log "10.5 เป็นทศนิยม"   || warn "ผิด: 10.5 ไม่ผ่าน"
is_decimal 10.555 && warn "ผิด: 10.555 ผ่าน" || log "10.555 ไม่ผ่าน (ถูก)"
is_port 25565  && log "25565 เป็นพอร์ตที่ใช้ได้" || warn "ผิด"
is_port 80     && warn "ผิด: 80 ผ่าน"      || log "80 เป็น privileged port (ถูกที่ปฏิเสธ)"
name="$(prompt_default 'ชื่อเซิร์ฟเวอร์' 'Eclipse')"
log "prompt_default ได้: [$name]"
EOF
chmod +x /tmp/test-lib.sh && /tmp/test-lib.sh; echo "exit=$?"
```

**ผลที่ต้องได้:** ทุกบรรทัดขึ้นคำว่า "ถูก" ไม่มี "ผิด" และ `prompt_default` คืน `Eclipse` เมื่อไม่มี terminal

### ขั้นที่ 6: ใช้ `lib.sh` จาก script จริง

```bash
cat > server-info.sh <<'EOF'
#!/usr/bin/env bash
# server-info.sh — แสดงข้อมูลเครื่องที่จะรันเซิร์ฟเวอร์ (ใช้ lib.sh)
set -uo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib.sh"

need_cmd java || die "ไม่พบ java — ติดตั้ง JDK 25 ก่อน (Day 04)" 3

java_version="$(java -version 2>&1 | head -1)"

printf '=== ข้อมูลเครื่อง ===\n'
printf 'CPU cores : %s\n' "$(nproc)"
printf 'RAM รวม   : %s\n' "$(free -h | awk '/^Mem:/{print $2}')"
printf 'ดิสก์ว่าง : %s\n' "$(df -h / | awk 'NR==2{print $4}')"
printf 'Java      : %s\n' "$java_version"

log "ตรวจเครื่องเสร็จ"
EOF
chmod +x server-info.sh
bash -n server-info.sh && JAVA_HOME="$HOME/.local/opt/jdk-25.0.5+8" PATH="$HOME/.local/opt/jdk-25.0.5+8/bin:$PATH" ./server-info.sh; echo "exit=$?"
```

### ขั้นที่ 7: commit

```bash
cd ~/minecraft-dev
git add scripts/lib.sh scripts/server-info.sh
git commit -m "feat: lib.sh (log/die/need_cmd/validate/prompt) และ server-info.sh"
```

---

## E. ทดสอบ (Definition of Done)

- [ ] `bash -n lib.sh` ผ่าน และ `/tmp/test-lib.sh` ไม่มีบรรทัด "ผิด" เลย
- [ ] `log`/`warn`/`die` พิมพ์ไป stderr (ทดสอบ: `./server-info.sh 2>/dev/null` ต้องไม่เห็น log)
- [ ] `die` ทำให้ script จบด้วย exit code ที่กำหนด (ทดสอบด้วย `; echo $?`)
- [ ] `prompt_default` คืนค่าเริ่มต้นเมื่อไม่มี terminal (รันใน `| cat`)
- [ ] `source lib.sh` ซ้ำ 2 ครั้งไม่ error (guard ทำงาน)
- [ ] เรียก `server-info.sh` จากโฟลเดอร์อื่นได้ (`cd /tmp && ~/minecraft-mmo-dev/scripts/server-info.sh`)
- [ ] ไม่มีตัวแปร global ถูกแก้โดยไม่ตั้งใจ (ทุกตัวในฟังก์ชันเป็น `local`)

---

## F. โค้ดตัวอย่าง (lib.sh ฉบับสมบูรณ์)

```bash
#!/usr/bin/env bash
# lib.sh — ไลบรารีฟังก์ชันร่วม (Day 11)
[[ -n "${__LIB_SH_LOADED:-}" ]] && return 0
__LIB_SH_LOADED=1

log()  { printf '[%s] %s\n'   "$(date '+%H:%M:%S')" "$*" >&2; }
warn() { printf '[%s] ⚠ %s\n' "$(date '+%H:%M:%S')" "$*" >&2; }
die()  { printf '[%s] ✖ %s\n' "$(date '+%H:%M:%S')" "${1:-เกิดข้อผิดพลาด}" >&2; exit "${2:-1}"; }

need_cmd()   { command -v "$1" >/dev/null 2>&1; }
is_number()  { [[ "${1:-}" =~ ^-?[0-9]+$ ]]; }
is_decimal() { [[ "${1:-}" =~ ^[0-9]+(\.[0-9]{1,2})?$ ]]; }
is_port()    { local p="${1:-}"; is_number "$p" || return 1; (( p >= 1024 && p <= 65535 )); }

prompt_default() {
  local question="$1" default_value="${2:-}" answer=""
  if [[ -t 0 ]]; then read -rp "${question} [${default_value}]: " answer || true; fi
  printf '%s' "${answer:-$default_value}"
}
```

**อธิบาย 5 จุด:** (1) guard `__LIB_SH_LOADED` กันการประกาศซ้ำ (2) ทุก log ไป stderr → ผลลัพธ์ของ script สะอาด (3) `die` เป็นทางออกเดียวของการผิดพลาดร้ายแรง ทำให้แก้ที่เดียว (4) ฟังก์ชันตรวจสอบคืน **exit code** ไม่ใช่ข้อความ (5) `prompt_default` ตรวจ `-t 0` เพื่อไม่ค้างในโหมดอัตโนมัติ

---

## G. แบบฝึกหัด

### G.1 พื้นฐาน

เพิ่มเข้า `lib.sh`:

- `require_file "$path"` — ถ้าไฟล์ไม่มี → `die` พร้อมบอกพาธ
- `require_dir "$path"` — เหมือนกันแต่สำหรับโฟลเดอร์
- `confirm "คำถาม"` — ถาม yes/no คืน 0 = ใช่, 1 = ไม่ (ค่าเริ่มต้น = ไม่)

ทดสอบทั้งสามด้วย `/tmp/test-lib2.sh`

### G.2 ประยุกต์

เขียน `scripts/check-env.sh` ที่ใช้ `lib.sh` และตรวจ 7 อย่างก่อนเปิดเซิร์ฟเวอร์:

1. มี `java` + เวอร์ชัน ≥ 25 (อ่านจาก `java -version`)
2. มี RAM ว่าง ≥ 1.5 GB (`free -m`)
3. ดิสก์ว่าง ≥ 5 GB (`df -m`)
4. มีโฟลเดอร์ `server/` และไฟล์ `server/paper.jar`
5. พอร์ต 25565 ว่าง
6. ไฟล์ `server/eula.txt` มี `eula=true` (ถ้าไม่มี → เตือน ไม่ใช่ error)
7. `server.properties` มี key ครบ 5 ตัว

แสดงผลเป็นตาราง `OK / WARN / FAIL` และ exit 1 ถ้ามี FAIL

### G.3 คำถามตรวจสอบความเข้าใจ

1. ทำไม `return "ข้อความ"` ใช้ไม่ได้ และถ้าอยากคืนข้อความต้องทำอย่างไร
2. ถ้าฟังก์ชัน `echo` debug ออกมาปนกับค่าที่คืน แล้วผู้เรียกใช้ `$( )` จะเกิดอะไร — แก้อย่างไร
3. `local` ใน bash ต่างจากตัวแปรปกติอย่างไร และถ้าลืมใส่จะเกิดบั๊กแบบไหน

---

## H. Challenge — `lib.sh` เวอร์ชันใช้งานจริง + เทสต์

อัปเกรด `lib.sh` เป็นเวอร์ชันที่:

1. `log` รองรับระดับ: `log`, `info`, `warn`, `error` โดยใช้ `LOG_LEVEL` (0=เงียบ, 3=ทุกอย่าง) ควบคุม
2. `retry <จำนวนครั้ง> <คำสั่ง...>` — เรียกคำสั่งซ้ำจนสำเร็จหรือครบจำนวน พร้อมหน่วงเวลาเพิ่มขึ้น (1s, 2s, 4s)
3. `run_step "ชื่อขั้น" <คำสั่ง...>` — พิมพ์ขั้นที่กำลังทำ, จับเวลา, รายงานผลและเวลาที่ใช้
4. `summary` — เก็บสถิติขั้นที่ทำ (สำเร็จ/ล้มเหลว) แล้วพิมพ์สรุปท้าย script

และสร้าง `scripts/lib-self-test.sh` ที่ทดสอบทุกฟังก์ชันด้วยตัวเอง (ไม่ต้องพึ่งเครื่องมือภายนอก) พิมพ์ `PASS`/`FAIL` ต่อกรณี และ exit 1 ถ้ามี FAIL

**เกณฑ์ผ่าน:** มีอย่างน้อย 12 กรณีทดสอบ ผ่านทั้งหมด และเมื่อจงใจทำพัง 1 ฟังก์ชัน เทสต์ต้องจับได้ (FAIL + exit 1)

> 💡 นี่คือจุดเริ่มต้นของแนวคิด **unit test** ที่คุณจะเจอในภาษา Java (Day 109) — หลักการเดียวกัน: ทดสอบชิ้นเล็กที่สุดแยกจากกัน

---

## I. Todo Checklist

- [ ] อธิบาย `return` vs `echo` vs `exit` ได้ชัดเจน
- [ ] `lib.sh` มี 5 ฟังก์ชันขั้นต่ำและผ่าน `/tmp/test-lib.sh`
- [ ] guard การ source ซ้ำทำงาน
- [ ] `server-info.sh` เรียกใช้ lib ได้จากทุกโฟลเดอร์
- [ ] ทำ G.1, G.2 และตอบ G.3
- [ ] ทำ Challenge (lib เวอร์ชันจริง + self-test 12 กรณี)
- [ ] commit + อัปเดต PROGRESS/TODO

---

## J. ผลลัพธ์

1. `scripts/lib.sh` — ไลบรารีที่ใช้ต่อตลอดหลักสูตร (log/die/validate/prompt)
2. `scripts/server-info.sh` — รายงานข้อมูลเครื่อง
3. `scripts/check-env.sh` — ตรวจความพร้อม 7 ข้อก่อนเปิดเซิร์ฟเวอร์ (G.2)
4. `scripts/lib-self-test.sh` — เทสต์ไลบรารี (Challenge)
5. เข้าใจ scope, `local`, และการแยก "ข้อมูล" ออกจาก "สถานะ"

---

## K. Troubleshooting

| อาการ | สาเหตุ | วิธีแก้ |
| --- | --- | --- |
| `lib.sh: command not found` | ไม่ได้ `source` หรือพาธผิด | `source "${SCRIPT_DIR}/lib.sh"` และตรวจว่าไฟล์มีอยู่ |
| เรียกใช้ lib จากโฟลเดอร์อื่นแล้วพัง | ใช้พาธrelative/`~` แบบ hard-code | คำนวณ `SCRIPT_DIR` จาก `${BASH_SOURCE[0]}` |
| ค่าที่จับด้วย `$( )` มี log ปน | ฟังก์ชัน log ไป stdout | เปลี่ยน `>&2` ใน log ทุกตัว |
| `return: 1: numeric argument required` | `return` ข้อความ | ใช้ `echo` สำหรับข้อมูล, `return` เฉพาะเลข |
| ตัวแปรข้างนอกเปลี่ยนค่าเอง | ลืม `local` | เติม `local` ทุกตัวในฟังก์ชัน |
| source ซ้ำแล้วประกาศทับ/error | ไม่มี guard | `[[ -n "${__X_LOADED:-}" ]] && return 0` |
| `die` แล้ว script ไม่จบ | เรียกจาก subshell `( die ... )` | เรียก `die` ในเชลล์หลัก ไม่ใช่ใน `$( )` |
| ฟังก์ชันใช้ `$1` แล้วได้ค่าของ script | เรียกโดยไม่ส่งอาร์กิวเมนต์ | ส่งค่าให้ชัด: `f "$var"` |

---

## L. สรุป

- ฟังก์ชันลดโค้ดซ้ำและทำให้ทดสอบได้ทีละส่วน
- คืน **ข้อมูล** ด้วย `echo` + `$( )`; คืน **สถานะ** ด้วย `return`; หยุด script ด้วย `exit`
- ทุก log ไป stderr → ผลลัพธ์ของ script สะอาดและเอาไปใช้ต่อได้
- `local` ทุกตัวในฟังก์ชัน + `source` ด้วยพาธที่คำนวณเอง = โค้ดที่ย้ายที่ได้ไม่พัง
- `lib.sh` คือจุดเริ่มต้นของ "ไลบรารีโปรเจกต์" ที่ Day 26+ จะใช้อีกเยอะ

**บทต่อไป (Day 12):** ท่อคำสั่ง `|`, `grep`, `sed`, `awk` — เปลี่ยน log ดิบ ๆ เป็นรายงานที่อ่านรู้เรื่องในบรรทัดเดียว

---

## M. Progress Update

```text
### Day 011 — วันที่ ____-__-__
- เรียน: ฟังก์ชัน, อาร์กิวเมนต์ของฟังก์ชัน, return vs echo vs exit, local/scope, source library
- ทำเสร็จ: scripts/lib.sh (5 ฟังก์ชัน), server-info.sh, G.1 require_*/confirm, G.2 check-env.sh, H lib + self-test
- ทดสอบ: test-lib.sh ผ่านทุกกรณี, die ให้ exit code ถูก, source ซ้ำไม่พัง, เรียกจาก /tmp ได้
- ยังไม่เข้าใจ: ______
- Error ที่เจอ: ______ (แก้ด้วย ______)
- งานถัดไป: Day 12 — pipe/grep/sed/awk และรายงานจาก log
- คะแนนตัวเอง: __/5
```
