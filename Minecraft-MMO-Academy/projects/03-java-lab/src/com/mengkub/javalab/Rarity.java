package com.mengkub.javalab;

/**
 * ระดับความหายากของไอเทม
 *
 * <p>ทำไมใช้ enum แทน String?
 * <ul>
 *   <li>พิมพ์ผิดไม่ได้ (ถ้าใช้ String จะพิมพ์ "COMMON" ผิดเป็น "COMMONN" แล้วหาบั๊กยาก)</li>
 *   <li>เก็บข้อมูลเพิ่มไว้ข้าง ๆ ได้ (เช่น ตัวคูณราคา, รหัสสี)</li>
 *   <li>วนดูค่าทั้งหมดได้ด้วย {@code Rarity.values()}</li>
 * </ul>
 */
public enum Rarity {

    //            ชื่อแสดงผล     ตัวคูณราคา
    COMMON("ทั่วไป", 1.0),
    RARE("หายาก", 2.5),
    EPIC("มหากาพย์", 6.0),
    LEGENDARY("ตำนาน", 15.0);

    private final String displayName;
    private final double priceMultiplier;

    /** enum ก็มี constructor ได้ — แต่จะถูกเรียกครั้งเดียวต่อค่าหนึ่งค่า */
    Rarity(String displayName, double priceMultiplier) {
        this.displayName = displayName;
        this.priceMultiplier = priceMultiplier;
    }

    /** ชื่อภาษาไทยไว้แสดงผล */
    public String displayName() {
        return displayName;
    }

    /** ตัวคูณราคาเมื่อขายไอเทมในร้านค้า (จะใช้จริงใน Month 11) */
    public double priceMultiplier() {
        return priceMultiplier;
    }
}
