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

// Sube el Java source/target de TODOS los módulos (incluidos los plugins que
// aún compilan en Java 8) a 11, para eliminar los warnings del build de Android:
//   "warning: [options] source value 8 is obsolete...".
// Se hace a nivel de tarea (no con `compileOptions`/afterEvaluate) para no
// chocar con `evaluationDependsOn(":app")`. `-nowarn` silencia los avisos de
// API deprecada que emiten los propios plugins (código que no controlamos).
subprojects {
    tasks.withType<JavaCompile>().configureEach {
        sourceCompatibility = JavaVersion.VERSION_11.toString()
        targetCompatibility = JavaVersion.VERSION_11.toString()
        options.compilerArgs.add("-nowarn")
        options.isDeprecation = false
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
