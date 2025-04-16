plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "dreamteam.alter"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.dreamteam.alter"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// .env 파일 경로 설정
val dotenv = Properties()
val envFile = file("${rootProject.projectDir}/.env")
if (envFile.exists()) {
    envFile.inputStream().use { stream -> dotenv.load(stream) }
} else {
    throw FileNotFoundException(".env file not found at ${envFile.absolutePath}")
}
// manifestPaceholder 설정
val kakaoAppKey = dotenv.getProperty("KAKAO_APP_KEY")
    ?: throw GradleException("KAKAO_APP_KEY not found in .env file. Ensure the .env file contains 'KAKAO_APP_KEY=your_key'.")

manifestPlaceholders = mapOf("KAKAO_APP_KEY" to kakaoAppKey)
