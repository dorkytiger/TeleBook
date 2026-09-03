import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// ── 发布签名（upload keystore）─────────────────────────────────────────────
// CI（.github/workflows/dart.yml）会把密钥 base64 解码到 android/app/upload-keystore.jks，
// 并生成 android/key.properties。这里读取它给 release 构建签名，保证每次 CI 打包都
// 使用同一把稳定的 key → 新包才能覆盖安装旧包（否则每次 CI 都用随机生成的 debug key，
// 签名不一致导致 INSTALL_FAILED_UPDATE_INCOMPATIBLE，只能卸载后重装）。
//
// 密钥只在 CI 环境（GitHub Actions / GitLab CI 等都会设置 CI=true）才读取；
// 全新 clone 的项目本地没有 key.properties（已被 .gitignore 排除），构建自动回退
// debug 签名，不需要配置任何 key。本机若想用同一把 key 打 release，可显式
// `flutter build apk --release -PandroidReleaseSigning=true` 开启。
val inCi = System.getenv("CI")?.equals("true", ignoreCase = true) == true
val localSigningOptIn =
    (findProperty("androidReleaseSigning") as? String)
        ?.equals("true", ignoreCase = true) == true
val loadKeystore = inCi || localSigningOptIn

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (loadKeystore && keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

val ksStoreFile = keystoreProperties.getProperty("storeFile")?.takeIf { it.isNotBlank() }?.let { file(it) }
val ksStorePassword = keystoreProperties.getProperty("storePassword")?.takeIf { it.isNotBlank() }
val ksKeyAlias = keystoreProperties.getProperty("keyAlias")?.takeIf { it.isNotBlank() }
val ksKeyPassword = keystoreProperties.getProperty("keyPassword")?.takeIf { it.isNotBlank() }

// CI 且 key.properties / 密钥文件有效时才启用 release 签名，否则回退 debug
val hasReleaseSigning = loadKeystore &&
    keystorePropertiesFile.exists() &&
    ksStoreFile != null && ksStoreFile.isFile && ksStoreFile.length() > 0 &&
    ksStorePassword != null && ksKeyAlias != null && ksKeyPassword != null

android {
    namespace = "com.example.tele_book"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.tele_book"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasReleaseSigning) {
            create("release") {
                keyAlias = ksKeyAlias
                keyPassword = ksKeyPassword
                storeFile = ksStoreFile
                storePassword = ksStorePassword
            }
        }
    }

    buildTypes {
        release {
            // CI：统一 upload key 签名（密钥一致，可覆盖安装）；
            // 本地未配置 key.properties 时仍用 debug 签名，保证 flutter run --release 可用
            signingConfig = if (hasReleaseSigning) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
