allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Fija el objetivo JVM de Kotlin a 17 en TODOS los módulos (incluidos plugins).
// No configuramos Java aquí con afterEvaluate porque choca con el
// evaluationDependsOn(":app") de arriba ("Cannot run afterEvaluate when the
// project is already evaluated"). La convivencia de módulos con Java 11 y
// Kotlin 17 se permite vía kotlin.jvm.target.validation.mode=warning
// (ver android/gradle.properties) — es seguro para el APK (minSdk 24 + D8).
subprojects {
    tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
        compilerOptions {
            jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
