// build.gradle.kts — ไฟล์บอก Gradle ว่าต้อง build โปรเจกต์นี้อย่างไร
// เอกสารอ้างอิง: https://docs.papermc.io/paper/dev/project-setup/

plugins {
    java
}

group = "com.mengkub"
version = "1.0.0"
description = "ปลั๊กอินหลักของ Eclipse MMO RPG (หลักสูตร Minecraft MMO RPG Academy)"

repositories {
    mavenCentral()
    maven {
        name = "papermc"
        url = uri("https://repo.papermc.io/repository/maven-public/")
    }
}

dependencies {
    // compileOnly = ใช้เฉพาะตอนคอมไพล์ (ตัวเซิร์ฟเวอร์มีให้อยู่แล้วตอนรัน จึงไม่ต้องรวมมาในไฟล์ .jar)
    // เวอร์ชันตรวจสอบจาก Maven metadata ของ Paper (2026-10-27)
    compileOnly("io.papermc.paper:paper-api:26.3.build.226-stable")
}

java {
    // หมายเหตุ: ไม่ใช้ toolchain เพื่อความชัดเจนว่า "ต้องรัน Gradle ด้วย JDK 25"
    // ถ้ารันด้วย JDK 21 จะได้ error: invalid source release: 25
}

tasks.withType<JavaCompile>().configureEach {
    options.encoding = "UTF-8"       // สำคัญ: ให้ข้อความภาษาไทยในโค้ดไม่เพี้ยน
    options.release.set(25)          // ต้องใช้ JDK 25 (Paper 26.x)
}

tasks.processResources {
    filteringCharset = "UTF-8"       // ให้ plugin.yml อ่านภาษาไทยได้ถูกต้อง
}

tasks.jar {
    archiveFileName.set("EclipseCore-${version}.jar")
}

// แสดง path ของไฟล์ .jar หลัง build เสร็จ เพื่อคัดลอกง่าย ๆ
tasks.build {
    doLast {
        println("✅ build เสร็จ — ไฟล์ปลั๊กอินอยู่ที่: build/libs/EclipseCore-${version}.jar")
        println("   คัดลอกไปติดตั้ง: cp build/libs/EclipseCore-${version}.jar <เซิร์ฟเวอร์>/plugins/")
    }
}
