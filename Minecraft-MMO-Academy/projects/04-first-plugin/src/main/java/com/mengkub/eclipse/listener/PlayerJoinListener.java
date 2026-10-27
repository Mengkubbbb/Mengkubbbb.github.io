package com.mengkub.eclipse.listener;

import com.mengkub.eclipse.config.Settings;
import net.kyori.adventure.text.Component;
import net.kyori.adventure.text.minimessage.MiniMessage;
import org.bukkit.entity.Player;
import org.bukkit.event.EventHandler;
import org.bukkit.event.EventPriority;
import org.bukkit.event.Listener;
import org.bukkit.event.player.PlayerJoinEvent;
import org.bukkit.event.player.PlayerQuitEvent;

/**
 * ดักฟังเหตุการณ์ที่เกี่ยวกับผู้เล่น (เข้า/ออกเซิร์ฟเวอร์)
 *
 * <p>แนวคิด Event:
 * <ul>
 *   <li>เซิร์ฟเวอร์ประกาศ "มีเหตุการณ์เกิดขึ้น" (เช่น ผู้เล่นเข้าเกม)</li>
 *   <li>ปลั๊กอินที่ลงทะเบียน {@link Listener} และมีเมธอด {@code @EventHandler} จะถูกเรียก</li>
 *   <li>{@code EventPriority} กำหนดลำดับการเรียก (MONITOR = ดูอย่างเดียว ไม่แก้ข้อมูล)</li>
 * </ul>
 */
public class PlayerJoinListener implements Listener {

    private static final MiniMessage MINI = MiniMessage.miniMessage();

    private final Settings settings;

    public PlayerJoinListener(Settings settings) {
        this.settings = settings;
    }

    /**
     * ทำงานเมื่อผู้เล่นเข้าเซิร์ฟเวอร์
     *
     * <p>ใช้ priority ปกติ (NORMAL) เพราะเราต้องการทำงานหลังปลั๊กอินอื่นเตรียมข้อมูลเสร็จ
     * และไม่ได้ใช้ {@code ignoreCancelled} เพราะเหตุการณ์นี้ไม่สามารถยกเลิกได้
     */
    @EventHandler(priority = EventPriority.NORMAL)
    public void onPlayerJoin(PlayerJoinEvent event) {
        if (!settings.welcomeEnabled()) {
            return;   // ปิดไว้ใน config → ไม่ทำอะไร
        }
        Player player = event.getPlayer();

        // แทนที่ตัวแปร <player> ในข้อความด้วยชื่อจริงของ
        String message = settings.welcomeMessage().replace("<player>", player.getName());
        player.sendMessage(render(message));

        if (settings.showTips()) {
            player.sendMessage(Component.text("พิมพ์ /eclipse เพื่อดูข้อมูลปลั๊กอิน").color(net.kyori.adventure.text.format.NamedTextColor.GRAY));
        }
    }

    /** ทำงานเมื่อผู้เล่นออกจากเซิร์ฟเวอร์ */
    @EventHandler(priority = EventPriority.NORMAL)
    public void onPlayerQuit(PlayerQuitEvent event) {
        if (!settings.farewellEnabled()) {
            return;
        }
        Player player = event.getPlayer();
        event.quitMessage(render(settings.farewellMessage().replace("<player>", player.getName())));
    }

    /**
     * แปลงข้อความ MiniMessage เป็น Component ที่ Minecraft เข้าใจ
     *
     * <p>ถ้าผู้ใช้เขียนรูปแบบ MiniMessage ผิด (เช่นลืมปิด tag) ให้ส่งข้อความดิบแทน
     * เพื่อไม่ให้ผู้เล่นไม่เห็นอะไรเลย
     */
    private Component render(String miniMessage) {
        try {
            return MINI.deserialize(miniMessage);
        } catch (RuntimeException ex) {
            return Component.text(miniMessage);
        }
    }
}
