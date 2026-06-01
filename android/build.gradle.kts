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

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// Fix: Align Kotlin JVM target with each plugin's existing Java sourceCompatibility.
// KGP 2.x sets Kotlin JVM target to 21 by default, but plugins may use Java 1.8 or 11.
// We read each project's JavaCompile sourceCompatibility and force Kotlin to match.
gradle.projectsEvaluated {
    subprojects {
        if (name == "app") return@subprojects
        val javaTarget = tasks.withType<JavaCompile>()
            .firstOrNull()?.sourceCompatibility ?: return@subprojects
        tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
            compilerOptions {
                jvmTarget.set(
                    org.jetbrains.kotlin.gradle.dsl.JvmTarget.fromTarget(javaTarget)
                )
            }
        }
    }
}
