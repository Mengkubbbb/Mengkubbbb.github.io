package com.mengkub.javalab;

import java.util.Random;

/**
 * สูตรและการจำลองการต่อสู้ (เวอร์ชันพื้นฐาน — จะกลายเป็น Damage Engine ใน Month 9)
 *
 * <p>หลักการ: แยก "สูตรคำนวณ" ออกจาก "การแสดงผล" เพื่อให้ทดสอบสูตรได้โดยไม่ต้องมีเซิร์ฟเวอร์
 */
public final class Combat {

    /** ผลลัพธ์ของการโจมตี 1 ครั้ง */
    public record AttackResult(int damage, boolean critical) {
    }

    private static final int MAX_ROUNDS = 100;

    private final Random random;

    public Combat() {
        this.random = new Random();
    }

    public Combat(long seed) {
        this.random = new Random(seed);
    }

    /**
     * คำนวณดาเมจ: (โจมตี − ป้องกัน/2) × คริติคอล, ต่ำสุด 1 เสมอ
     *
     * @param attack         ค่าโจมตีของผู้โจมตี
     * @param defense        ค่าป้องกันของเป้าหมาย
     * @param critChancePct  โอกาสคริติคอลเป็นเปอร์เซ็นต์ (0-100)
     */
    public AttackResult calculate(int attack, int defense, int critChancePct) {
        if (attack < 0 || defense < 0) {
            throw new IllegalArgumentException("ค่าโจมตี/ป้องกันต้องไม่ติดลบ");
        }
        int damage = (int) Math.max(1, Math.round(attack - defense / 2.0));
        boolean critical = random.nextInt(100) < critChancePct;
        if (critical) {
            damage *= 2;
        }
        return new AttackResult(damage, critical);
    }

    /**
     * จำลองการต่อสู้ระหว่างผู้เล่นกับมอนสเตอร์
     *
     * @return ข้อความสรุปผลการต่อสู้ (บรรทัดสุดท้ายบอกผู้ชนะ)
     */
    public String simulateDuel(Player player, String monsterName, int monsterHp, int monsterAttack,
                               int monsterDefense, int monsterCritPct) {
        if (player == null) {
            throw new IllegalArgumentException("ต้องมีผู้เล่น");
        }
        StringBuilder log = new StringBuilder();
        int pHp = player.hp();
        int pHpMax = player.maxHp();
        int mHp = monsterHp;

        log.append(String.format("=== %s (HP %d) ปะทะ %s (HP %d) ===%n", player.name(), pHp, monsterName, mHp));

        int round = 0;
        while (pHp > 0 && mHp > 0 && round < MAX_ROUNDS) {
            round++;

            AttackResult heroHit = calculate(player.bestWeaponDamage(), monsterDefense, 20);
            mHp = Math.max(0, mHp - heroHit.damage());
            log.append(String.format("เทิร์น %2d: %s ตีได้ %d%s → มอนเหลือ %d%n",
                    round, player.name(), heroHit.damage(), heroHit.critical() ? " (คริติคอล)" : "", mHp));
            if (mHp <= 0) {
                break;
            }

            AttackResult monsterHit = calculate(monsterAttack, 4, monsterCritPct);
            pHp = Math.max(0, pHp - monsterHit.damage());
            log.append(String.format("          %s ตีกลับ %d%s → เราเหลือ %d%n",
                    monsterName, monsterHit.damage(), monsterHit.critical() ? " (คริติคอล)" : "", pHp));
        }

        if (mHp <= 0) {
            log.append("ผลลัพธ์: ชนะ! (เหลือ HP ").append(pHp).append(")");
        } else if (pHp <= 0) {
            log.append("ผลลัพธ์: พ่ายแพ้ (HP หมดในเทิร์นที่ ").append(round).append(")");
        } else {
            log.append("ผลลัพธ์: ไม่จบใน ").append(MAX_ROUNDS).append(" เทิร์น — ควรปรับสมดุล");
        }
        return log.toString();
    }

    /** คำนวณและคืน "ค่าเฉลี่ยดาเมจ" จากหลายพันครั้ง — ใช้ตรวจสมดุลอย่างเป็นตัวเลข */
    public double averageDamage(int attack, int defense, int critChancePct, int samples) {
        if (samples <= 0) {
            throw new IllegalArgumentException("จำนวนตัวอย่างต้องมากกว่า 0");
        }
        long total = 0;
        for (int i = 0; i < samples; i++) {
            total += calculate(attack, defense, critChancePct).damage();
        }
        return (double) total / samples;
    }
}
