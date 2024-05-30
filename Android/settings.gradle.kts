// This gradle project is part of a conventional Skip app project.
// It invokes the shared build skip plugin logic, which included as part of the skip-unit buildSrc
// When built from Xcode, it uses the BUILT_PRODUCTS_DIR folder to share the same build outputs as Xcode, otherwise it uses SwiftPM's .build/ folder
pluginManagement {
    // local override of BUILT_PRODUCTS_DIR
    if (System.getenv("BUILT_PRODUCTS_DIR") == null) {
        //System.setProperty("BUILT_PRODUCTS_DIR", "${System.getProperty("user.home")}/Library/Developer/Xcode/DerivedData/Skip-Everything-aqywrhrzhkbvfseiqgxuufbdwdft/Build/Products/Debug-iphonesimulator")
    }

    // the source for the plugin is linked as part of the SkipUnit transpilation
    val skipOutput = System.getenv("BUILT_PRODUCTS_DIR") ?: System.getProperty("BUILT_PRODUCTS_DIR")

    val outputExt = if (skipOutput != null) ".output" else "" // Xcode saves output in package-name.output; SPM has no suffix
    val skipOutputs: File = if (skipOutput != null) {
        // BUILT_PRODUCTS_DIR is set when building from Xcode, in which case we will use Xcode's DerivedData plugin output
        file(skipOutput).resolve("../../../SourcePackages/plugins/")
    } else {
        exec {
            // create transpiled Kotlin and generate Gradle projects from SwiftPM modules
            commandLine("swift", "build")
            workingDir = file("..")
        }
        // SPM output folder is a peer of the parent Package.swift
        rootDir.resolve("../.build/plugins/outputs/")
    }

    // load the Skip plugin (part of the skip-unit project), which handles configuring the Android project
    // because this path is a symlink, we need to use the canonical path or gradle will mis-interpret it as a different build source
    val pluginSource = skipOutputs.resolve("skip-unit${outputExt}/SkipUnit/skipstone/buildSrc/").canonicalFile
    if (!pluginSource.isDirectory) {
        throw GradleException("Missing expected Skip output folder: ${pluginSource}. Run `swift build` in the root folder to create, or specify Xcode environment BUILT_PRODUCTS_DIR.")
    }
    includeBuild(pluginSource.path) {
        name = "skip-plugins"
    }
}

plugins {
    id("skip-plugin") apply true
}

