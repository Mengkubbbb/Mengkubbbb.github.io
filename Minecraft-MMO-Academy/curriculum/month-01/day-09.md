# Day 09 — Shell Script: เงื่อนไข `if` / `case` และการตรวจสอบค่า

> 📅 Month 1 · Week 2 · ~150 นาที · **โหมด: Guided Practice**
> 🎯 วันนี้เรียน "สมอง" ของ script: การตัดสินใจ — และวิธีตรวจข้อมูลที่ผู้ใช้พิมพ์เข้ามาโดยไม่ให้ระบบพัง

---

## A. เป้าหมาย

จบบทนี้คุณจะ:

- เขียน `if` / `elif` / `else` ได้คล่อง และเข้าใจว่า **exit status ของคำสั่ง** คือตัวตัดสิน
- ใช้ `[ ]` กับ `[[ ]]` ได้ถูกงาน และรู้ว่าเมื่อไรต้องใช้แบบไหน
- เปรียบเทียบ **ตัวเลข** และ **ข้อความ** ด้วยตัวดำเนินการที่ถูกต้อง (จุดพังอันดับ 1 ของมือใหม่)
- ใช้ `case` จัดหมวดค่าที่เป็นชุด ๆ (เช่น ระดับความหายากของไอเทม)
- คำนวณเลขทศนิยมด้วย `awk` (เพราะ bash คำนวณทศนิยมไม่ได้)

**ผลงานที่ต้องได้:** `~/minecraft-mmo-dev/scripts/check-price.sh` — ตรวจราคาไอเทมในร้านค้าเกม: ค่าไม่ใช่ตัวเลข / ติดลบ / แพงเกินงบ ต้องแจ้งชัดและ exit code ถูกต้อง และมี `case` แปลงระดับความหายากเป็นตัวคูณราคา

---

## B. ความรู้ที่ต้องมี

- Day 08: ตัวแปร, อาร์กิวเมนต์, `read`, exit code, `set -uo pipefail`
- Day 06: เงื่อนไขในผังงาน (diamond) — วันนี้คือการเขียนมันเป็นโค้ดจริง

---

## C. แนวคิด

### C.1 `if` ตัดสินจาก "exit status" ไม่ใช่จาก "ความจริง"

```bash
if [ "$level" -gt 50 ]; then
  echo "เลเวลสูง"
elif [ "$level" -gt 20 ]; then
  echo "เลเวลกลาง"
else
  echo "เลเวลต้นเกม"
fi
```

สิ่งที่เกิดขึ้นจริง: `[ "$level" -gt 50 ]` คือ **คำสั่ง** ที่คืน exit code 0 (จริง) หรือ 1 (เท็จ) แล้ว `if` ก็ดูแค่ตัวเลขนั้น

จึงเขียนแบบนี้ได้:

```bash
if grep -q "ERROR" server.log; then
  echo "พบ error ใน log"
fi          # ไม่ต้องมี [ ] เลย — เพราะ grep คืน exit code อยู่แล้ว

if ! ping -c1 -W1 1.1.1.1 >/dev/null 2>&1; then
  echo "ไม่มีอินเทอร์เน็ต"
fi
```

### C.2 `[ ]` กับ `[[ ]]` — ใช้ตัวไหน

| หัวข้อ | `[ ]` (POSIX test) | `[[ ]]` (bash keyword) |
| --- | --- | --- |
| ใช้ได้กับ shell ไหน | ทุก shell (sh, dash) | bash, zsh, ksh |
| ตัวแปรว่างไม่ใส่ quote | พัง (`unary operator expected`) | ปลอดภัย |
| regex `=~` | ไม่มี | มี |
| `&&` `\|\|` ในวงเล็บ | ต้องเขียนนอกวงเล็บ | เขียนในวงเล็บได้ |
| แนะนำเมื่อ | script ต้องรันบน sh ทั่วไป | script bash บน Linux ของคุณ |

**คำแนะนำของหลักสูตรนี้:** ใช้ `[[ ]]` เป็นหลัก (เราคุม environment เอง) และ **ยังคงใส่ quote** เพราะอ่านง่ายและป้องกันความผิดพลาดเมื่อย้ายโค้ด

### C.3 ตัวดำเนินการที่ต้องจำ

**ข้อความ:**

| ตัวดำเนินการ | ความหมาย | ตัวอย่าง |
| --- | --- | --- |
| `-z "$s"` | ว่าง (zero length) | `[[ -z "$name" ]]` |
| `-n "$s"` | ไม่ว่าง | `[[ -n "$name" ]]` |
| `=` / `==` | เท่ากัน (ใน `[[ ]]` ใช้ `==` ได้) | `[[ "$mode" == "hard" ]]` |
| `!=` | ไม่เท่า | `[[ "$a" != "$b" ]]` |
| `=~` | ตรง regex (bash เท่านั้น) | `[[ "$v" =~ ^[0-9]+$ ]]` |

**ตัวเลข (ห้ามใช้กับข้อความ):**

| ตัวดำเนินการ | ความหมาย |
| --- | --- |
| `-eq` / `-ne` | เท่ากัน / ไม่เท่ากัน |
| `-lt` / `-le` | น้อยกว่า / น้อยกว่าหรือเท่า |
| `-gt` / `-ge` | มากกว่า / มากกว่าหรือเท่า |

**ไฟล์:**

| ตัวดำเนินการ | ความหมาย |
| --- | --- |
| `-e` | มีอยู่ (ไฟล์หรือโฟลเดอร์) |
| `-f` | เป็นไฟล์ปกติ |
| `-d` | เป็นโฟลเดอร์ |
| `-r` / `-w` / `-x` | อ่าน / เขียน / รันได้ |
| `-s` | มีขนาดมากกว่า 0 ไบต์ (ไม่ว่าง) |

**ตรรกะ:** `&&` (และ) · `||` (หรือ) · `!` (ไม่)

```bash
if [[ -f "$jar" && -r "$jar" && -s "$jar" ]]; then
  echo "ไฟล์ jar พร้อมใช้"
fi
```

### C.4 `case` — เมื่อต้องเทียบหลายทางเลือก

```bash
case "$rarity" in
  common)            mult=1   ;;
  uncommon)          mult=2   ;;
  rare)              mult=5   ;;
  epic|legendary)    mult=10  ;;   # ใช้ | แทน "หรือ"
  *)                 echo "ไม่รู้จักระดับ: $rarity" >&2; exit 2 ;;
esac
```

- `*)` คือ "กรณีอื่นทั้งหมด" — ควรมีเสมอ เพื่อจับค่าที่ไม่คาดคิด
- pattern เป็น glob: `r*)` จับทุกอย่างที่ขึ้นต้นด้วย r
- `;;` = จบกรณี, `;&` = ทำกรณีถัดไปต่อ, `;;&` = ทดสอบ pattern ถัดไปต่อ (ไม่ต้องใช้ในเดือนนี้)

### C.5 กับดัก 6 ข้อที่ทำให้ script "ดูเหมือนทำงานได้" แต่ผิด

1. **ใช้ `-eq` กับข้อความ**: `[[ "$name" -eq 5 ]]` → ถ้า `$name` เป็น `abc` bash จะถือเป็น 0 (ไม่ error!)
2. **ไม่ quote**: `[[ $level -gt 50 ]]` → ถ้า `$level` ว่าง จะ error `unary operator expected`
3. **เลขศูนย์นำหน้า**: `(( 08 + 1 ))` → error เพราะ bash ตีความเป็นเลขฐาน 8 ใช้ `10#$v` แก้: `(( 10#$v + 1 ))`
4. **ทศนิยมกับ `-lt`**: `[[ 1.5 -lt 2 ]]` ใช้ไม่ได้ → ต้องใช้ `awk`
5. **เทียบค่าแบบสตริงกับตัวเลขปนกัน**: `[[ "10" < "9" ]]` เป็นจริง (เทียบตัวอักษร) — ต้องใช้ `-lt`
6. **ลืม `*)` ใน `case`** → ค่าที่ไม่รู้จักจะผ่านไปเงียบ ๆ

### C.6 คำนวณทศนิยม: ใช้ `awk` (bash ทำไม่ได้)

```bash
price=199.5
qty=3
total=$(awk -v p="$price" -v q="$qty" 'BEGIN { printf "%.2f", p*q }')
echo "รวม: $total"        # 598.50

# ตรวจว่าเป็นตัวเลขทศนิยม
if ! [[ "$price" =~ ^[0-9]+(\.[0-9]{1,2})?$ ]]; then
  echo "ราคาต้องเป็นตัวเลขทศนิยมไม่เกิน 2 ตำแหน่ง" >&2
  exit 2
fi
```

> 💡 หลักการเลือกเครื่องมือ: จำนวนเต็ม → `(( ))` · ทศนิยม → `awk` · ข้อความซับซ้อน → `[[ =~ ]]` · ค่าที่เป็นชุด → `case`

---

## D. ลงมือทำ

### ขั้นที่ 1: โครงและ help

```bash
cd ~/minecraft-mmo-dev/scripts
cat > check-price.sh <<'EOF'
#!/usr/bin/env bash
set -uo pipefail

readonly SCRIPT_NAME="$(basename "$0")"
readonly DEFAULT_BUDGET=500

usage() {
  cat <<HELP
วิธีใช้: $SCRIPT_NAME <ราคา> [งบประมาณ] [--rarity ระดับ]

ตัวอย่าง:
  $SCRIPT_NAME 199.50
  $SCRIPT_NAME 1299 500
  $SCRIPT_NAME 250 500 --rarity rare

ระดับความหายาก: common | uncommon | rare | epic | legendary
HELP
}
EOF
chmod +x check-price.sh && bash -n check-price.sh && echo "syntax OK"
```

### ขั้นที่ 2: อ่านอาร์กิวเมนต์ (รวมตัวเลือก `--rarity`)

```bash
cat >> check-price.sh <<'EOF'

price=""
budget="$DEFAULT_BUDGET"
rarity="common"

args=("$@")
i=0
while (( i < ${#args[@]} )); do
  case "${args[$i]}" in
    -h|--help) usage; exit 0 ;;
    --rarity)
      i=$((i+1))
      if (( i >= ${#args[@]} )); then
        echo "ข้อผิดพลาด: --rarity ต้องมีค่า" >&2; exit 2
      fi
      rarity="${args[$i]}"
      ;;
    --rarity=*) rarity="${args[$i]#--rarity=}" ;;
    *)
      if [[ -z "$price" ]]; then price="${args[$i]}"
      else budget="${args[$i]}"
      fi
      ;;
  esac
  i=$((i+1))
done
EOF
bash -n check-price.sh && echo "syntax OK"
```

**สิ่งที่เพิ่งเรียน:** `${args[$i]#--rarity=}` คือการตัด prefix ออก (เครื่องหมาย `#` = ตัดจากด้านหน้าแบบสั้นที่สุด)

### ขั้นที่ 3: ตรวจข้อมูล 3 ชั้น (guard clauses)

```bash
cat >> check-price.sh <<'EOF'

if [[ -z "$price" ]]; then
  echo "ข้อผิดพลาด: ต้องระบุราคา" >&2; usage >&2; exit 2
fi

if ! [[ "$price" =~ ^[0-9]+(\.[0-9]{1,2})?$ ]]; then
  echo "ข้อผิดพลาด: ราคาต้องเป็นตัวเลข 0 ขึ้นไป ทศนิยมไม่เกิน 2 ตำแหน่ง (ได้รับ: $price)" >&2
  exit 2
fi

if ! [[ "$budget" =~ ^[0-9]+$ ]]; then
  echo "ข้อผิดพลาด: งบประมาณต้องเป็นจำนวนเต็ม (ได้รับ: $budget)" >&2
  exit 2
fi
EOF
bash -n check-price.sh && echo "syntax OK"
```

**ทำไมต้องตรวจทีละชั้นแล้ว `exit` ทันที?** เพราะถ้าปล่อยค่าผิดไหลลงไปคำนวณ จะได้ผลลัพธ์ที่ดูปกติแต่ผิด — บั๊กแบบนี้แพงที่สุดในการแก้

### ขั้นที่ 4: แปลงระดับความหายากเป็นตัวคูณ

```bash
cat >> check-price.sh <<'EOF'

case "$rarity" in
  common)         mult=1  ; label="ธรรมดา" ;;
  uncommon)       mult=2  ; label="ไม่ธรรมดา" ;;
  rare)           mult=5  ; label="หายาก" ;;
  epic)           mult=10 ; label="มหากาพย์" ;;
  legendary)      mult=25 ; label="ในตำนาน" ;;
  *) echo "ข้อผิดพลาด: ไม่รู้จักระดับ '$rarity' (ใช้: common|uncommon|rare|epic|legendary)" >&2; exit 2 ;;
esac
EOF
bash -n check-price.sh && echo "syntax OK"
```

### ขั้นที่ 5: เทียบงบและสรุปผล

```bash
cat >> check-price.sh <<'EOF'

suggested=$(awk -v p="$price" -v m="$mult" 'BEGIN { printf "%.2f", p*m }')

printf 'ราคาที่กรอก : %s\n' "$price"
printf 'ระดับ       : %s (x%s)\n' "$label" "$mult"
printf 'ราคาแนะนำ   : %s\n' "$suggested"
printf 'งบประมาณ    : %s\n' "$budget"

if awk -v p="$suggested" -v b="$budget" 'BEGIN { exit !(p > b) }'; then
  printf 'ผล: แพงเกินงบ (เกิน %s)\n' "$(awk -v p="$suggested" -v b="$budget" 'BEGIN { printf "%.2f", p-b }')"
  exit 1
fi

printf 'ผล: อยู่ในงบ\n'
exit 0
EOF
chmod +x check-price.sh && bash -n check-price.sh && echo "syntax OK"
```

**จุดสำคัญ:** `awk ... 'BEGIN { exit !(p > b) }'` แปลงการเปรียบเทียบทศนิยมให้กลายเป็น **exit code** เพื่อให้ `if` ใช้ง่าย — เป็นแพตเทิร์นที่ใช้บ่อยมาก

### ขั้นที่ 6: ทดสอบ 7 กรณี

```bash
./check-price.sh 199.50 ; echo "exit=$?"
./check-price.sh 250 500 --rarity rare ; echo "exit=$?"
./check-price.sh 100 500 --rarity=legendary ; echo "exit=$?"
./check-price.sh abc ; echo "exit=$?"
./check-price.sh 10.999 ; echo "exit=$?"
./check-price.sh 100 500 --rarity mythic ; echo "exit=$?"
./check-price.sh --rarity ; echo "exit=$?"
```

| คำสั่ง | ผลที่คาด | exit |
| --- | --- | --- |
| `199.50` | อยู่ในงบ (199.50 ≤ 500) | 0 |
| `250 500 --rarity rare` | ราคาแนะนำ 1250 → แพงเกินงบ | 1 |
| `100 500 --rarity=legendary` | 2500 → แพงเกินงบ | 1 |
| `abc` | error ราคาต้องเป็นตัวเลข | 2 |
| `10.999` | error ทศนิยมเกิน 2 ตำแหน่ง | 2 |
| `--rarity mythic` | error ไม่รู้จักระดับ | 2 |
| `--rarity` (ไม่มีค่า) | error ต้องมีค่า | 2 |

### ขั้นที่ 7: commit

```bash
cd ~/minecraft-dev
git add scripts/check-price.sh
git commit -m "feat: check-price.sh ตรวจราคาไอเทมและระดับความหายาก"
```

---

## E. ทดสอบ (Definition of Done)

- [ ] `bash -n` ผ่าน และรัน 7 กรณีได้ exit code ตรงตาราง
- [ ] ข้อความ error ทั้งหมดออก stderr (`2>/dev/null` แล้วต้องเงียบ)
- [ ] `--rarity=epic` และ `--rarity epic` ให้ผลเหมือนกัน
- [ ] `./check-price.sh` ไม่ใส่ค่าอะไร → แสดงวิธีใช้ + exit 2
- [ ] มี `*)` ใน `case` และทดสอบว่าค่ามั่วถูกปฏิเสธ
- [ ] ไม่มี `[[ $var -eq ... ]]` ที่ตัวแปรอาจไม่ใช่ตัวเลขโดยไม่ตรวจก่อน

---

## F. โค้ดตัวอย่าง (ฉบับสมบูรณ์)

```bash
#!/usr/bin/env bash
# check-price.sh — ตรวจราคาไอเทมเทียบงบ และปรับตามระดับความหายาก (Day 09)
set -uo pipefail

readonly SCRIPT_NAME="$(basename "$0")"
readonly DEFAULT_BUDGET=500

usage() {
  cat <<HELP
วิธีใช้: $SCRIPT_NAME <ราคา> [งบประมาณ] [--rarity ระดับ]

ตัวอย่าง:
  $SCRIPT_NAME 199.50
  $SCRIPT_NAME 250 500 --rarity rare
HELP
}

price=""; budget="$DEFAULT_BUDGET"; rarity="common"

args=("$@"); i=0
while (( i < ${#args[@]} )); do
  case "${args[$i]}" in
    -h|--help) usage; exit 0 ;;
    --rarity)
      i=$((i+1))
      (( i < ${#args[@]} )) || { echo "ข้อผิดพลาด: --rarity ต้องมีค่า" >&2; exit 2; }
      rarity="${args[$i]}" ;;
    --rarity=*) rarity="${args[$i]#--rarity=}" ;;
    *) if [[ -z "$price" ]]; then price="${args[$i]}"; else budget="${args[$i]}"; fi ;;
  esac
  i=$((i+1))
done

[[ -n "$price" ]] || { echo "ข้อผิดพลาด: ต้องระบุราคา" >&2; usage >&2; exit 2; }

[[ "$price" =~ ^[0-9]+(\.[0-9]{1,2})?$ ]] || {
  echo "ข้อผิดพลาด: ราคาต้องเป็นตัวเลข 0 ขึ้นไป ทศนิยมไม่เกิน 2 ตำแหน่ง (ได้รับ: $price)" >&2; exit 2; }

[[ "$budget" =~ ^[0-9]+$ ]] || {
  echo "ข้อผิดพลาด: งบประมาณต้องเป็นจำนวนเต็ม (ได้รับ: $budget)" >&2; exit 2; }

case "$rarity" in
  common)    mult=1;  label="ธรรมดา" ;;
  uncommon)  mult=2;  label="ไม่ธรรมดา" ;;
  rare)      mult=5;  label="หายาก" ;;
  epic)      mult=10; label="มหากาพย์" ;;
  legendary) mult=25; label="ในตำนาน" ;;
  *) echo "ข้อผิดพลาด: ไม่รู้จักระดับ '$rarity'" >&2; exit 2 ;;
esac

suggested=$(awk -v p="$price" -v m="$mult" 'BEGIN { printf "%.2f", p*m }')
printf 'ราคาที่กรอก : %s\nระดับ       : %s (x%s)\nราคาแนะนำ   : %s\nงบประมาณ    : %s\n' \
  "$price" "$label" "$mult" "$suggested" "$budget"

if awk -v p="$suggested" -v b="$budget" 'BEGIN { exit !(p > b) }'; then
  over=$(awk -v p="$suggested" -v b="$budget" 'BEGIN { printf "%.2f", p-b }')
  printf 'ผล: แพงเกินงบ (เกิน %s)\n' "$over"
  exit 1
fi

printf 'ผล: อยู่ในงบ\n'
exit 0
```

**อธิบาย 4 จุด:** (1) ตรวจด้วย `=~` ก่อนคำนวณเสมอ (2) `case` มี `*)` กันค่ามั่ว (3) `awk` จัดการทศนิยมและแปลงการเปรียบเทียบเป็น exit code (4) error → stderr, ผลลัพธ์ → stdout, exit 1 = "ทำงานได้แต่ผลลัพธ์ไม่ผ่าน" ซึ่งต่างจาก exit 2 = "ใช้คำสั่งผิด"

---

## G. แบบฝึกหัด

### G.1 พื้นฐาน

เพิ่ม `--discount <เปอร์เซ็นต์>` ให้ `check-price.sh` ที่รับ 0–90 และคำนวณราคาหลังลด (ใช้ `awk`, ทศนิยม 2 ตำแหน่ง) พร้อมปฏิเสธค่าที่ไม่ใช่ตัวเลขหรือเกิน 90 ด้วย exit 2

### G.2 ประยุกต์

เขียน `scripts/validate-server-properties.sh` ที่:

1. รับพาธไฟล์ `server.properties` (ค่าเริ่มต้น `./server.properties`)
2. ตรวจว่าไฟล์มีอยู่จริง (`-f`) ถ้าไม่มี → exit 2
3. ตรวจว่ามี key จำเป็นครบ 5 ตัว: `server-port`, `level-name`, `online-mode`, `max-players`, `motd`
4. ตรวจค่า: `server-port` ต้องเป็น 1024–65535, `max-players` ต้องเป็น 1–200, `online-mode` ต้องเป็น `true` หรือ `false`
5. สรุปผลเป็นตาราง: `OK` / `MISSING` / `INVALID` พร้อม exit code (0 = ผ่านหมด, 1 = มีปัญหา)

> 💡 เคล็ดลับ: อ่านค่าด้วย `grep -E "^key=" file | cut -d= -f2-` — ระวังช่องว่างหลัง `=`

### G.3 คำถามตรวจสอบความเข้าใจ

1. ทำไม `[[ $x -eq 0 ]]` จึงไม่ error เมื่อ `$x` เป็น `abc` และผลลัพธ์เป็นอะไร — อันตรายอย่างไร?
2. `if command; then` ต่างจาก `if [ command ]; then` อย่างไร? (ลองทั้งสองแบบกับ `grep`)
3. ถ้าต้องรองรับค่าที่ไม่รู้จำนวนล่วงหน้า (เช่น ระดับไอเทมที่เพิ่มในอนาคต) ควรใช้ `case` หรือ `if/elif` เพราะอะไร

---

## H. Challenge — `loot-rules.sh` เครื่องตรวจกฎรางวัล

สร้าง script ที่รับ **ตาราง loot จากไฟล์** (`items.txt` รูปแบบ `ชื่อ|ระดับ|โอกาสดรอป`) และ:

1. ตรวจว่าระดับถูกต้อง (ใช้ `case`) และโอกาสเป็นตัวเลข 0–100
2. ตรวจว่าผลรวมโอกาสของไอเทมทั้งหมดไม่เกิน 100 (ใช้ `awk`) — ถ้าเกิน → exit 1 พร้อมบอกว่ามากไปเท่าไร
3. แสดงตารางที่จัดคอลัมน์ตรงกัน พร้อมช่อง `cumulative` (โอกาสสะสม) — เพราะ Day 06 สอนว่า weighted random ใช้ค่าสะสม
4. รองรับ `--strict` ที่ทำให้โอกาสรวมต้อง **เท่ากับ 100 พอดี**

**เกณฑ์ผ่าน:** ไฟล์ทดสอบ 3 ชุด (ถูกต้อง, รวมเกิน, ระดับผิด) ต้องให้ exit code ต่างกันตามที่ออกแบบ และตารางต้องอ่านง่ายในหน้าจอ 80 คอลัมน์

---

## I. Todo Checklist

- [ ] อธิบายได้ว่า `[ ]` กับ `[[ ]]` ต่างกันอย่างไร (พูดออกมาได้ ไม่เปิดเอกสาร)
- [ ] จำตัวดำเนินการ numeric vs string ได้ครบ
- [ ] เขียน `check-price.sh` ครบ 7 กรณีทดสอบ
- [ ] ทำ G.1 (`--discount`) และ G.2 (`validate-server-properties.sh`)
- [ ] ทำ Challenge `loot-rules.sh` + ไฟล์ทดสอบ 3 ชุด
- [ ] commit + อัปเดต PROGRESS/TODO

---

## J. ผลลัพธ์

1. `scripts/check-price.sh` — ผ่าน 7 กรณี มี help และ exit code สื่อความหมาย
2. `scripts/validate-server-properties.sh` — ตัวตรวจไฟล์ตั้งค่าเซิร์ฟเวอร์ (ใช้จริงตลอดหลักสูตร)
3. `scripts/loot-rules.sh` + `items.txt` 3 ชุด — Challenge
4. เข้าใจว่าเงื่อนไข = การตรวจ exit status และ "ตรวจข้อมูลก่อนใช้" คือเกราะป้องกันบั๊กที่ถูกที่สุด

---

## K. Troubleshooting

| อาการ | สาเหตุ | วิธีแก้ |
| --- | --- | --- |
| `[: unary operator expected` | ตัวแปรว่าง ไม่ได้ quote | ใช้ `[[ ... ]]` และใส่ `"$var"` |
| `integer expression expected` | ใช้ `-eq` กับค่าไม่ใช่ตัวเลข | ตรวจด้วย `=~ ^[0-9]+$` ก่อน |
| `(( 08 + 1 ))` error | bash ถือเลข 0 นำหน้าเป็นฐาน 8 | `(( 10#08 + 1 ))` |
| `[[ 1.5 -lt 2 ]]` ไม่ทำงาน | `-lt` รับจำนวนเต็มเท่านั้น | ใช้ `awk 'BEGIN{exit !(1.5<2)}'` |
| `case` ไม่จับค่าที่ควรจับ | ลืม `;;` ทำให้ตกไปกรณีถัดไป หรือ pattern สะกดผิด | ตรวจ pattern และปิดด้วย `;;` |
| `syntax error: unexpected end of file` | ลืม `fi` / `esac` / `done` | `bash -n` ชี้บรรทัดให้ |
| ทศนิยมแสดง `1.5000000000000002` | คำนวณทศนิยมใน bash | ใช้ `awk` + `printf "%.2f"` |

---

## L. สรุป

- `if` ดู **exit status** ไม่ใช่ "ความจริง" — คำสั่งใด ๆ จึงใช้เป็นเงื่อนไขได้
- `[[ ]]` ปลอดภัยกว่า `[ ]` และรองรับ regex; ยังต้อง quote เสมอ
- ตัวเลขใช้ `-eq -lt -gt`, ข้อความใช้ `= !=`, ไฟล์ใช้ `-e -f -d -r -w -x`
- `case` เหมาะกับค่าที่เป็นชุด (ระดับไอเทม, โหมดการทำงาน) และต้องมี `*)` เสมอ
- ทศนิยม → `awk`; จำนวนเต็ม → `(( ))`; ตรวจข้อมูลก่อนคำนวณทุกครั้ง

**บทต่อไป (Day 10):** ลูป `for` / `while` — ใช้สร้างโฟลเดอร์ world หลายชุด และวนอ่านไฟล์ทีละบรรทัดอย่างปลอดภัย

---

## M. Progress Update

```text
### Day 009 — วันที่ ____-__-__
- เรียน: if/elif/else, [[ ]] vs [ ], ตัวดำเนินการ numeric/string/file, case, awk สำหรับทศนิยม
- ทำเสร็จ: scripts/check-price.sh (7 กรณีผ่าน), G.1 --discount, G.2 validate-server-properties.sh, H loot-rules.sh
- ทดสอบ: exit code ตรงทุกกรณี / error ออก stderr
- ยังไม่เข้าใจ: ______
- Error ที่เจอ: ______ (แก้ด้วย ______)
- งานถัดไป: Day 10 — for/while และ create-worlds.sh
- คะแนนตัวเอง: __/5
```
