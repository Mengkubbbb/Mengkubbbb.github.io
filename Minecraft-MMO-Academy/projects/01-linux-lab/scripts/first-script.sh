#!/usr/bin/env bash
# first-script.sh — script แรกของหลักสูตร Minecraft MMO RPG Academy
# ใช้: ./first-script.sh <ชื่อผู้เล่น>
# สอน: shebang, argument, การตรวจสอบข้อมูล, exit code

set -uo pipefail

PLAYER_NAME="${1:-}"

if [ -z "$PLAYER_NAME" ]; then
    echo "วิธีใช้: $0 <ชื่อผู้เล่น>"
    echo "ตัวอย่าง: $0 Somchai"
    exit 1
fi

echo "========================================"
echo " Eclipse MMO RPG Academy — ต้อนรับผู้เล่น"
echo "========================================"
echo "ผู้เล่น: $PLAYER_NAME"
echo "เข้าเล่นเมื่อ: $(date '+%Y-%m-%d %H:%M:%S')"
echo "เครื่อง: $(hostname)"
echo "ผู้ใช้ระบบ: $(whoami)"
echo "โฟลเดอร์ปัจจุบัน: $(pwd)"
echo "========================================"
