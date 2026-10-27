package com.mengkub.javalab;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * ตัวละครของผู้เล่น (เวอร์ชันข้อความ)
 *
 * <p>สอน: ฟิลด์หลายชนิด, List, การคำนวณเลเวล, การตรวจสอบค่าก่อนบันทึก
 */
public class Player {

    private final String name;
    private int level;
    private int exp;
    private int maxHp;
    private int hp;
    private int maxMana;
    private int mana;
    private final List<Item> inventory = new ArrayList<>();

    public Player(String name) {
        if (name == null || name.isBlank()) {
            throw new IllegalArgumentException("ชื่อผู้เล่นต้องไม่ว่าง");
        }
        this.name = name;
        this.level = 1;
        this.exp = 0;
        recalculateStats();
        this.hp = maxHp;
        this.mana = maxMana;
    }

    public String name() {
        return name;
    }

    public int level() {
        return level;
    }

    public int exp() {
        return exp;
    }

    public int hp() {
        return hp;
    }

    public int maxHp() {
        return maxHp;
    }

    public int mana() {
        return mana;
    }

    public int maxMana() {
        return maxMana;
    }

    /**
     * EXP ที่ต้องใช้เพื่อขึ้นเลเวลถัดไป
     * สูตร: 100 × level^1.5 (ทวีคูณ) — เลเวลสูงจะใช้เวลามากขึ้นแบบไม่ใช่เส้นตรง
     */
    public int expToNextLevel() {
        return (int) Math.round(100 * Math.pow(level, 1.5));
    }

    /** เพิ่ม EXP และขึ้นเลเวลอัตโนมัติถ้าเพียงพอ — คืนจำนวนครั้งที่ขึ้นเลเวล */
    public int addExp(int amount) {
        if (amount < 0) {
            throw new IllegalArgumentException("EXP ที่เพิ่มต้องไม่ติดลบ");
        }
        exp += amount;
        int levelsGained = 0;
        while (exp >= expToNextLevel()) {
            exp -= expToNextLevel();
            level++;
            recalculateStats();
            hp = maxHp;          // ขึ้นเลเวลแล้วเลือด/มานาเต็ม
            mana = maxMana;
            levelsGained++;
        }
        return levelsGained;
    }

    /** รับดาเมจ — เลือดต่ำสุดคือ 0 (ไม่ให้ติดลบ) */
    public void takeDamage(int amount) {
        if (amount < 0) {
            throw new IllegalArgumentException("ดาเมจต้องไม่ติดลบ");
        }
        hp = Math.max(0, hp - amount);
    }

    /** รักษา — ไม่ให้เกินเลือดสูงสุด */
    public void heal(int amount) {
        if (amount < 0) {
            throw new IllegalArgumentException("การรักษาต้องไม่ติดลบ");
        }
        hp = Math.min(maxHp, hp + amount);
    }

    public boolean isAlive() {
        return hp > 0;
    }

    /** ใช้มานา — คืนค่า true ถ้ามีพอ */
    public boolean useMana(int amount) {
        if (amount < 0) {
            throw new IllegalArgumentException("มานาที่ใช้ต้องไม่ติดลบ");
        }
        if (mana < amount) {
            return false;
        }
        mana -= amount;
        return true;
    }

    /** คำนวณค่าสถานะใหม่ตามเลเวล (เรียกทุกครั้งที่เลเวลเปลี่ยน) */
    private void recalculateStats() {
        maxHp = 100 + (level - 1) * 20;
        maxMana = 50 + (level - 1) * 10;
    }

    /** เพิ่มไอเทมเข้ากระเป๋า — จำกัด 20 ช่อง */
    public boolean addItem(Item item) {
        if (inventory.size() >= 20) {
            return false;
        }
        inventory.add(item);
        return true;
    }

    /** กระเป๋าแบบอ่านได้อย่างเดียว (ห้ามแก้จากภายนอก — ต้องผ่าน addItem) */
    public List<Item> inventory() {
        return Collections.unmodifiableList(inventory);
    }

    /** ดาเมจรวมของไอเทมดีที่สุดในกระเป๋า (ใช้คำนวณการต่อสู้) */
    public int bestWeaponDamage() {
        int best = 5;    // มือเปล่า
        for (Item item : inventory) {
            if (item.damage() > best) {
                best = item.damage();
            }
        }
        return best;
    }

    /** ข้อมูลสรุปสำหรับพิมพ์ */
    public String describe() {
        return String.format("%s เลเวล %d | HP %d/%d | มานา %d/%d | EXP %d/%d | ไอเทม %d ชิ้น",
                name, level, hp, maxHp, mana, maxMana, exp, expToNextLevel(), inventory.size());
    }
}
