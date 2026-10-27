package com.mengkub.eclipse;

import com.mengkub.eclipse.command.EclipseCommand;
import com.mengkub.eclipse.config.Settings;
import com.mengkub.eclipse.listener.PlayerJoinListener;
import org.bukkit.plugin.java.JavaPlugin;

/**
 * คลาสหลักของปลั๊กอิน EclipseCore
 *
 * <p>วงจรชีวิตของปลั๊กอิน (plugin lifecycle):
 * <ol>
 *   <li>โหลดคลาส + อ่าน plugin.yml</li>
 *   <li>{@link #onEnable()} — เตรียมทุกอย่าง (โหลด config, ลงทะเบียน event/command)</li>
 *   <li>ทำงานตลอดที่เซิร์ฟเวอร์เปิดอยู่</li>
 *   <li>{@link #onDisable()} — เก็บกวาด (บันทึกข้อมูล, ยกเลิก task)</li>
 * </ol>
 *
 * <p>ข้อควรระวัง: อย่าทำงานหนักใน {@code onEnable()} (เช่น อ่านไฟล์ใหญ่, ต่อฐานข้อมูลนาน ๆ)
 * เพราะเซิร์ฟเวอร์จะค้างรอจนกว่าจะเสร็จ
 */
public final class EclipseCorePlugin extends JavaPlugin {

    /** เวอร์ชัน Java ที่ Paper 26.x ต้องการ — ตรวจ 2026-10-27 จากเอกสาร Paper */
    private static final int REQUIRED_JAVA = 25;

    private Settings settings;

    @Override
    public void onEnable() {
        // 1) สร้างไฟล์ config.yml ให้ผู้ใช้ ถ้ายังไม่มี
        saveDefaultConfig();

        // 2) อ่านและตรวจค่าตั้งค่า (ถ้าค่าผิด จะใช้ค่าเริ่มต้น + เตือนใน log)
        this.settings = Settings.from(getConfig(), getLogger());

        // 3) ลงทะเบียน event listener
        getServer().getPluginManager().registerEvents(new PlayerJoinListener(settings), this);

        // 4) ลงทะเบียนคำสั่ง (วิธีใหม่ของ Paper: Brigadier ผ่าน lifecycle event)
        EclipseCommand.register(this);

        // 5) ตรวจว่าสภาพแวดล้อมถูกต้อง แล้วแจ้งให้ชัดเจน
        getLogger().info("เปิด EclipseCore v" + getPluginMeta().getVersion()
                + " บน " + getServer().getName() + " " + getServer().getMinecraftVersion()
                + " / Java " + Runtime.version().feature());

        if (Runtime.version().feature() < REQUIRED_JAVA) {
            getLogger().warning("เครื่องนี้ใช้ Java " + Runtime.version().feature()
                    + " แต่ Paper 26.x ต้องการ Java " + REQUIRED_JAVA
                    + " — ควรอัปเกรดก่อนเปิดให้ผู้เล่นจริง");
        }
        if (getServer().getPluginManager().getPlugin("LuckPerms") == null) {
            getLogger().info("ไม่พบ LuckPerms — ช่วงพัฒนาใช้สิทธิ์แบบ op ไปก่อน (จะติดตั้งใน Month 7)");
        }
    }

    @Override
    public void onDisable() {
        // ไม่ควรทำงานหนักที่นี่ แต่ต้องแน่ใจว่าข้อมูลไม่หาย
        // (Month 8 จะมีการบันทึกข้อมูลทั้งหมดก่อนปิด)
        getLogger().info("ปิด EclipseCore — เก็บกวาดเรียบร้อย");
    }

    /** ให้คลาสอื่นเข้าถึงค่าตั้งค่าได้ (เช่น listener/command) */
    public Settings settings() {
        return settings;
    }
}
