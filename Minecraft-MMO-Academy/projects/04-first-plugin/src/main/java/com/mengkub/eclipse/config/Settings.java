package com.mengkub.eclipse.config;

import org.bukkit.configuration.file.FileConfiguration;

import java.util.logging.Logger;

/**
 * ค่าตั้งค่าของปลั๊กอินที่อ่านจาก config.yml พร้อมการตรวจสอบค่า
 *
 * <p>หลักการสำคัญ: <b>อย่าเชื่อค่าจากไฟล์ตั้งค่า</b> ผู้ใช้อาจแก้ผิดได้เสมอ
 * ถ้าค่าผิด ให้ใช้ค่าเริ่มต้น + เขียน WARNING ลง log (ไม่ทำให้ปลั๊กอินพัง)
 */
public record Settings(
        boolean welcomeEnabled,
        String welcomeMessage,
        boolean farewellEnabled,
        String farewellMessage,
        int maxLevel,
        boolean showTips
) {

    // ค่าเริ่มต้นที่ปลอดภัย (ใช้เมื่อ config หายหรือค่าไม่ถูกต้อง)
    private static final boolean DEFAULT_WELCOME_ENABLED = true;
    private static final String DEFAULT_WELCOME_MESSAGE =
            "<gold><bold>ยินดีต้อนรับ</bold></gold> <gray>เข้าสู่ <aqua>Eclipse MMO RPG</aqua>, <white><player></white>!";
    private static final boolean DEFAULT_FAREWELL_ENABLED = false;
    private static final String DEFAULT_FAREWELL_MESSAGE = "<gray>ลาก่อน <white><player></white>!";
    private static final int DEFAULT_MAX_LEVEL = 60;
    private static final boolean DEFAULT_SHOW_TIPS = true;

    /** ช่วงที่ยอมรับได้ของเลเวลสูงสุด (ใช้ตรวจสอบค่า) */
    private static final int MIN_MAX_LEVEL = 1;
    private static final int MAX_MAX_LEVEL = 1000;

    /**
     * สร้าง Settings จาก FileConfiguration พร้อมตรวจสอบทุกค่า
     *
     * @param config ไฟล์ตั้งค่าของปลั๊กอิน
     * @param logger ตัวเขียน log ของปลั๊กอิน
     */
    public static Settings from(FileConfiguration config, Logger logger) {
        if (config == null) {
            logger.warning("ไม่พบไฟล์ config — ใช้ค่าเริ่มต้นทั้งหมด");
            return defaults();
        }

        boolean welcomeEnabled = config.getBoolean("welcome-enabled", DEFAULT_WELCOME_ENABLED);
        String welcomeMessage = config.getString("welcome-message", DEFAULT_WELCOME_MESSAGE);
        if (welcomeMessage == null || welcomeMessage.isBlank()) {
            logger.warning("welcome-message ว่างเปล่า — ใช้ค่าเริ่มต้นแทน");
            welcomeMessage = DEFAULT_WELCOME_MESSAGE;
        }

        boolean farewellEnabled = config.getBoolean("farewell-enabled", DEFAULT_FAREWELL_ENABLED);
        String farewellMessage = config.getString("farewell-message", DEFAULT_FAREWELL_MESSAGE);
        if (farewellMessage == null || farewellMessage.isBlank()) {
            logger.warning("farewell-message ว่างเปล่า — ใช้ค่าเริ่มต้นแทน");
            farewellMessage = DEFAULT_FAREWELL_MESSAGE;
        }

        int maxLevel = config.getInt("max-level", DEFAULT_MAX_LEVEL);
        if (maxLevel < MIN_MAX_LEVEL || maxLevel > MAX_MAX_LEVEL) {
            logger.warning("max-level = " + maxLevel + " อยู่นอกช่วง " + MIN_MAX_LEVEL + "-"
                    + MAX_MAX_LEVEL + " — ใช้ค่าเริ่มต้น (" + DEFAULT_MAX_LEVEL + ") แทน");
            maxLevel = DEFAULT_MAX_LEVEL;
        }

        boolean showTips = config.getBoolean("show-tips", DEFAULT_SHOW_TIPS);

        return new Settings(welcomeEnabled, welcomeMessage, farewellEnabled, farewellMessage, maxLevel, showTips);
    }

    /** ชุดค่าเริ่มต้นทั้งหมด */
    public static Settings defaults() {
        return new Settings(DEFAULT_WELCOME_ENABLED, DEFAULT_WELCOME_MESSAGE,
                DEFAULT_FAREWELL_ENABLED, DEFAULT_FAREWELL_MESSAGE, DEFAULT_MAX_LEVEL, DEFAULT_SHOW_TIPS);
    }
}
