package com.mengkub.javalab;

/**
 * ไอเทม 1 ชิ้นในเกม (เวอร์ชันข้อความ ไม่ได้ผูกกับ Minecraft จริง)
 *
 * <p>หลักการ encapsulation:
 * ฟิลด์ทั้งหมดเป็น {@code private} เพื่อไม่ให้โค้ดที่อื่นแก้ค่าจนพัง
 * ทุกอย่างต้องผ่านเมธอด และเมธอดจะตรวจสอบค่าก่อนรับเสมอ
 */
public class Item {

    private final String name;
    private final Rarity rarity;
    private int baseDamage;
    private int upgradeLevel;   // 0 = ยังไม่ตีบวก, 1..n = ตีบวกแล้ว
    private static final int MAX_UPGRADE = 10;

    /**
     * สร้างไอเทมใหม่
     *
     * @param name       ชื่อไอเทม (ห้ามว่าง)
     * @param rarity     ระดับความหายาก
     * @param baseDamage ดาเมจพื้นฐาน (ต้องไม่ติดลบ)
     * @throws IllegalArgumentException เมื่อข้อมูลไม่ถูกต้อง
     */
    public Item(String name, Rarity rarity, int baseDamage) {
        if (name == null || name.isBlank()) {
            throw new IllegalArgumentException("ชื่อไอเทมต้องไม่ว่าง");
        }
        if (baseDamage < 0) {
            throw new IllegalArgumentException("ดาเมจพื้นฐานต้องไม่ติดลบ (ได้รับ: " + baseDamage + ")");
        }
        this.name = name;
        this.rarity = rarity;
        this.baseDamage = baseDamage;
        this.upgradeLevel = 0;
    }

    public String name() {
        return name;
    }

    public Rarity rarity() {
        return rarity;
    }

    public int upgradeLevel() {
        return upgradeLevel;
    }

    /** ดาเมจจริง = ดาเมจพื้นฐาน + โบนัสจากการตีบวก (+10% ต่อระดับ) */
    public int damage() {
        double multiplier = 1.0 + (upgradeLevel * 0.10);
        return (int) Math.round(baseDamage * multiplier);
    }

    /** ราคาขาย = ดาเมจจริง × ตัวคูณของระดับความหายาก */
    public int sellPrice() {
        return (int) Math.round(damage() * rarity.priceMultiplier());
    }

    /** ตีบวก 1 ระดับ — คืนค่า true ถ้าสำเร็จ, false ถ้าถึงขีดจำกัดแล้ว */
    public boolean upgrade() {
        if (upgradeLevel >= MAX_UPGRADE) {
            return false;
        }
        upgradeLevel++;
        return true;
    }

    /** ข้อความแสดงไอเทมสำหรับพิมพ์ในคอนโซล */
    public String describe() {
        return String.format("%s [%s] ดาเมจ %d (ตีบวก +%d) ราคาขาย %d",
                name, rarity.displayName(), damage(), upgradeLevel, sellPrice());
    }

    @Override
    public String toString() {
        return describe();
    }
}
