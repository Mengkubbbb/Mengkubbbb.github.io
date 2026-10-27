package com.mengkub.javalab;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

/**
 * ตารางดรอปแบบมีน้ำหนัก (weighted random table)
 *
 * <p>เวอร์ชันนี้เขียนด้วย Java 25 และรับ seed ได้ เพื่อให้ทดสอบซ้ำได้ (deterministic test)
 */
public class LootTable {

    /** 1 รายการในตาราง: ไอเทม + น้ำหนัก */
    public record Entry(Item item, int weight) {
    }

    private final List<Entry> entries = new ArrayList<>();
    private final Random random;

    /** สร้างตารางแบบสุ่มจริง (ผลไม่ซ้ำ) */
    public LootTable() {
        this.random = new Random();
    }

    /** สร้างตารางแบบกำหนด seed (ผลซ้ำได้ทุกครั้ง — ใช้เขียนเทสต์) */
    public LootTable(long seed) {
        this.random = new Random(seed);
    }

    /**
     * เพิ่มไอเทมลงตาราง
     *
     * @param item   ไอเทม
     * @param weight น้ำหนัก (ต้องมากกว่า 0)
     * @throws IllegalArgumentException เมื่อน้ำหนักไม่ถูกต้อง
     */
    public void add(Item item, int weight) {
        if (weight <= 0) {
            throw new IllegalArgumentException("น้ำหนักต้องมากกว่า 0 (ได้รับ: " + weight + ")");
        }
        entries.add(new Entry(item, weight));
    }

    /** ผลรวมน้ำหนักทั้งหมด — มีประโยชน์ทั้งตอนสุ่มและตอนแสดงผล */
    public int totalWeight() {
        int total = 0;
        for (Entry entry : entries) {
            total += entry.weight();
        }
        return total;
    }

    /** แสดงโอกาสของแต่ละไอเทม (ใช้ตรวจสมดุล) */
    public String describeChances() {
        StringBuilder sb = new StringBuilder();
        int total = totalWeight();
        for (Entry entry : entries) {
            double chance = 100.0 * entry.weight() / total;
            sb.append(String.format("  - %-20s %5.1f%%%n", entry.item().name(), chance));
        }
        return sb.toString();
    }

    /**
     * สุ่มไอเทม 1 ชิ้น
     *
     * @return ไอเทมที่สุ่มได้
     * @throws IllegalStateException ถ้าตารางว่าง (ต้องตรวจก่อนใช้!)
     */
    public Item roll() {
        if (entries.isEmpty()) {
            throw new IllegalStateException("ตารางดรอปว่างเปล่า — ต้องเพิ่มไอเทมก่อนสุ่ม");
        }
        int total = totalWeight();          // การันตีว่า > 0 เพราะ add() ตรวจแล้ว
        int roll = random.nextInt(total) + 1;   // 1..total
        int cumulative = 0;
        for (Entry entry : entries) {
            cumulative += entry.weight();
            if (roll <= cumulative) {
                return entry.item();
            }
        }
        // ไม่ควรเกิดขึ้น แต่ต้องมีทางออกเสมอ (เผื่อโค้ดถูกแก้ในอนาคต)
        return entries.get(entries.size() - 1).item();
    }

    public int size() {
        return entries.size();
    }
}
