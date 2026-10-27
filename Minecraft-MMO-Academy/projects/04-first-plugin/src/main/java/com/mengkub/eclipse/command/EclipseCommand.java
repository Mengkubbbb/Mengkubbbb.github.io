package com.mengkub.eclipse.command;

import com.mojang.brigadier.arguments.StringArgumentType;
import com.mojang.brigadier.tree.LiteralCommandNode;
import io.papermc.paper.command.brigadier.CommandSourceStack;
import io.papermc.paper.command.brigadier.Commands;
import io.papermc.paper.plugin.lifecycle.event.types.LifecycleEvents;
import net.kyori.adventure.text.Component;
import net.kyori.adventure.text.format.NamedTextColor;
import org.bukkit.plugin.java.JavaPlugin;

import java.util.List;

/**
 * คำสั่งหลักของ EclipseCore: {@code /eclipse [stats|hello &lt;ชื่อ&gt;|admin]}
 *
 * <p>ทำไมใช้ Brigadier (วิธีใหม่) ไม่ใช้ {@code CommandExecutor} (วิธีเก่า)?
 * <ul>
 *   <li>Paper สนับสนุนวิธีนี้ และได้ tab-completion ที่ถูกต้องโดยอัตโนมัติ</li>
 *   <li>การตรวจสิทธิ์ทำได้ที่ชั้นคำสั่งด้วย {@code .requires(...)}</li>
 * </ul>
 *
 * <p>ต้องเรียก {@link #register(JavaPlugin)} ใน {@code onEnable()} เท่านั้น
 */
public final class EclipseCommand {

    private static final String PERM_STATS = "eclipse.stats";
    private static final String PERM_ADMIN = "eclipse.admin";

    private EclipseCommand() {
        // คลาสนี้มีแต่ static method — ไม่ต้องสร้างออบเจกต์
    }

    /**
     * ลงทะเบียนคำสั่งกับเซิร์ฟเวอร์ผ่าน lifecycle event
     *
     * @param plugin ปลั๊กอินหลัก (ใช้เข้าถึง lifecycle manager)
     */
    public static void register(JavaPlugin plugin) {
        plugin.getLifecycleManager().registerEventHandler(LifecycleEvents.COMMANDS, event -> {
            Commands commands = event.registrar();

            // หมายเหตุสำคัญ: Commands.literal(...) เป็น "static method" ของ interface
            // จึงต้องเรียกผ่านชื่อ interface (Commands.literal) ห้ามเรียกผ่านตัวแปร (commands.literal)
            LiteralCommandNode<CommandSourceStack> root = Commands
                    .literal("eclipse")
                    .executes(ctx -> {
                        // /eclipse — ใช้ได้กับทุกคน
                        ctx.getSource().getSender().sendMessage(Component.text()
                                .append(Component.text("Eclipse MMO RPG ", NamedTextColor.GOLD))
                                .append(Component.text("v" + plugin.getPluginMeta().getVersion(), NamedTextColor.WHITE))
                                .build());
                        ctx.getSource().getSender().sendMessage(Component.text(
                                "คำสั่ง: /eclipse stats | /eclipse hello <ชื่อ>", NamedTextColor.GRAY));
                        return 1;   // 1 = สำเร็จ
                    })
                    .then(Commands.literal("stats")
                            .requires(source -> source.getSender().hasPermission(PERM_STATS))
                            .executes(ctx -> {
                                int online = plugin.getServer().getOnlinePlayers().size();
                                ctx.getSource().getSender().sendMessage(Component.text()
                                        .append(Component.text("ผู้เล่นออนไลน์: ", NamedTextColor.GRAY))
                                        .append(Component.text(online, NamedTextColor.GREEN))
                                        .build());
                                return online;
                            }))
                    .then(Commands.literal("hello")
                            .then(Commands.argument("name", StringArgumentType.word())
                                    .executes(ctx -> {
                                        String name = StringArgumentType.getString(ctx, "name");
                                        ctx.getSource().getSender().sendMessage(Component.text()
                                                .append(Component.text("สวัสดี ", NamedTextColor.GRAY))
                                                .append(Component.text(name, NamedTextColor.AQUA))
                                                .append(Component.text(" — ขอให้สนุกกับ Eclipse!", NamedTextColor.GRAY))
                                                .build());
                                        return 1;
                                    })))
                    .then(Commands.literal("admin")
                            .requires(source -> source.getSender().hasPermission(PERM_ADMIN))
                            .executes(ctx -> {
                                ctx.getSource().getSender().sendMessage(Component.text(
                                        "โหมดแอดมิน (สิทธิ์ " + PERM_ADMIN + " ผ่าน)", NamedTextColor.RED));
                                return 1;
                            }))
                    .build();

            // "ec" = alias ให้พิมพ์สั้นลง
            commands.register(root, "คำสั่งหลักของ EclipseCore", List.of("ec"));
        });
    }
}
