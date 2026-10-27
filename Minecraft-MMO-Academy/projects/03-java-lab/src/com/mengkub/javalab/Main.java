package com.mengkub.javalab;

import java.util.Scanner;

/**
 * จุดเริ่มต้นของโปรแกรม — เมนูแบบข้อความ (ไม่ต้องมีเซิร์ฟเวอร์ Minecraft)
 *
 * <p>รันด้วย:
 * <pre>
 *   javac -d out $(find src -name "*.java")
 *   java -cp out com.mengkub.javalab.Main
 * </pre>
 */
public class Main {

    private static final int MENU_LOOT_ROLLS = 10;

    public static void main(String[] args) {
        Player player = new Player("ผู้เรียน");
        LootTable lootTable = buildLootTable();
        Combat combat = new Combat(20261027L);   // seed คงที่ เพื่อให้ผลทดสอบซ้ำได้

        // ไอเทมตั้งต้น
        player.addItem(new Item("ดาบเหล็ก", Rarity.COMMON, 12));
        player.addItem(new Item("มีดสั้นทอง", Rarity.RARE, 20));

        System.out.println("===== Eclipse Java Lab =====");
        System.out.println("ตารางดรอปของมอนสเตอร์ตัวอย่าง:");
        System.out.print(lootTable.describeChances());

        try (Scanner scanner = new Scanner(System.in)) {
            boolean running = true;
            while (running) {
                printMenu();
                String choice = scanner.hasNextLine() ? scanner.nextLine().trim() : "0";
                switch (choice) {
                    case "1" -> System.out.println(player.describe());
                    case "2" -> rollLoot(player, lootTable);
                    case "3" -> System.out.println(combat.simulateDuel(player, "ซอมบี้", 60, 10, 2, 10));
                    case "4" -> addExp(player, scanner);
                    case "5" -> showInventory(player);
                    case "0" -> {
                        running = false;
                        System.out.println("จบโปรแกรม — ลองแก้โค้ดแล้วรันใหม่ได้เลย");
                    }
                    default -> System.out.println("⚠️ ไม่รู้จักตัวเลือก: " + choice);
                }
            }
        }
    }

    private static void printMenu() {
        System.out.println();
        System.out.println("1) แสดงข้อมูลตัวละคร");
        System.out.println("2) สุ่มของจากตารางดรอป (" + MENU_LOOT_ROLLS + " ครั้ง)");
        System.out.println("3) จำลองการต่อสู้ 1 รอบ");
        System.out.println("4) เพิ่ม EXP ให้ตัวละคร");
        System.out.println("5) แสดงไอเทมในกระเป๋า");
        System.out.println("0) ออก");
        System.out.print("เลือก: ");
    }

    private static LootTable buildLootTable() {
        LootTable table = new LootTable(42L);   // seed คงที่ → ผลซ้ำได้เวลาทดสอบ
        table.add(new Item("เศษเหล็ก", Rarity.COMMON, 4), 40);
        table.add(new Item("หินวิเศษ", Rarity.COMMON, 6), 30);
        table.add(new Item("ดาบเงิน", Rarity.RARE, 18), 18);
        table.add(new Item("คทาโบราณ", Rarity.EPIC, 30), 9);
        table.add(new Item("ดาบอีคลิปส์", Rarity.LEGENDARY, 55), 3);
        return table;
    }

    private static void rollLoot(Player player, LootTable table) {
        System.out.println("--- สุ่ม " + MENU_LOOT_ROLLS + " ครั้ง ---");
        for (int i = 1; i <= MENU_LOOT_ROLLS; i++) {
            Item item = table.roll();
            boolean added = player.addItem(item);
            System.out.printf("ครั้งที่ %2d: %s%s%n", i, item.describe(), added ? "" : "  (กระเป๋าเต็ม ของตกหาย!)");
        }
    }

    private static void addExp(Player player, Scanner scanner) {
        System.out.print("ใส่จำนวน EXP ที่จะเพิ่ม: ");
        String input = scanner.hasNextLine() ? scanner.nextLine().trim() : "";
        try {
            int amount = Integer.parseInt(input);
            int levelsGained = player.addExp(amount);
            System.out.printf("เพิ่ม %d EXP → ขึ้นเลเวล %d ครั้ง → %s%n", amount, levelsGained, player.describe());
        } catch (NumberFormatException e) {
            System.out.println("❌ ต้องใส่ตัวเลขเท่านั้น (ได้รับ: \"" + input + "\")");
        } catch (IllegalArgumentException e) {
            System.out.println("❌ " + e.getMessage());
        }
    }

    private static void showInventory(Player player) {
        if (player.inventory().isEmpty()) {
            System.out.println("กระเป๋าว่างเปล่า");
            return;
        }
        System.out.println("--- ไอเทมในกระเป๋า (" + player.inventory().size() + " ชิ้น) ---");
        for (Item item : player.inventory()) {
            System.out.println("  " + item.describe());
        }
    }
}
