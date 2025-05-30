plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.castlecorp.unolist"
    compileSdk = 35

    // Pode remover esta linha se não estiver usando recursos nativos via NDK
//    ndkVersion = "34.0.0"

    defaultConfig {
        // TODO: Substitua por um ID exclusivo se necessário (https://developer.android.com/studio/build/application-id)
        applicationId = "com.castlecorp.unolist"

        // Versões mínimas e alvo definidas pelo Flutter
        minSdk = 21
        targetSdk = 35
//        minSdk = flutter.minSdkVersion
//        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    buildTypes {
        release {
            // Desativa a minificação e a remoção de recursos não utilizados
            isMinifyEnabled = false
            isShrinkResources = false

            // TODO: Configure sua assinatura de release
            signingConfig = signingConfigs.getByName("debug")
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

// Indica a raiz do projeto Flutter
flutter {
    source = "../.."
}

dependencies {
    // Inclui a biblioteca padrão do Kotlin
    implementation("org.jetbrains.kotlin:kotlin-stdlib")
}
