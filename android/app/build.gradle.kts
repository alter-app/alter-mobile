plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// .env 파일 읽기
import java.util.Properties
import java.io.FileNotFoundException

// .env 파일 경로 설정
val dotenv = Properties()
val envFile = file("${rootProject.projectDir}/../.env")
if (envFile.exists()) {
    envFile.inputStream().use { stream -> dotenv.load(stream) }
} else {
    throw FileNotFoundException(".env file not found at ${envFile.absolutePath}")
}

// KAKAO_APP_KEY 설정
val kakaoAppKey: String = dotenv.getProperty("KAKAO_NATIVE_APP_KEY")
    ?: throw GradleException("KAKAO_NATIVE_APP_KEY not found in .env file. Ensure the .env file contains 'KAKAO_APP_KEY=your_key'.")

android {
    namespace = "com.dreamteam.alter"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
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
        manifestPlaceholders["KAKAO_APP_KEY"] = kakaoAppKey
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
