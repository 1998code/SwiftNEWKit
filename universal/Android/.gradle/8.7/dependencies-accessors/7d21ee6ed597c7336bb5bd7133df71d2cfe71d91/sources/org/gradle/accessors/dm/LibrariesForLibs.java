package org.gradle.accessors.dm;

import org.gradle.api.NonNullApi;
import org.gradle.api.artifacts.MinimalExternalModuleDependency;
import org.gradle.plugin.use.PluginDependency;
import org.gradle.api.artifacts.ExternalModuleDependencyBundle;
import org.gradle.api.artifacts.MutableVersionConstraint;
import org.gradle.api.provider.Provider;
import org.gradle.api.model.ObjectFactory;
import org.gradle.api.provider.ProviderFactory;
import org.gradle.api.internal.catalog.AbstractExternalDependencyFactory;
import org.gradle.api.internal.catalog.DefaultVersionCatalog;
import java.util.Map;
import org.gradle.api.internal.attributes.ImmutableAttributesFactory;
import org.gradle.api.internal.artifacts.dsl.CapabilityNotationParser;
import javax.inject.Inject;

/**
 * A catalog of dependencies accessible via the {@code libs} extension.
 */
@NonNullApi
public class LibrariesForLibs extends AbstractExternalDependencyFactory {

    private final AbstractExternalDependencyFactory owner = this;
    private final AndroidxLibraryAccessors laccForAndroidxLibraryAccessors = new AndroidxLibraryAccessors(owner);
    private final CoilLibraryAccessors laccForCoilLibraryAccessors = new CoilLibraryAccessors(owner);
    private final KotlinLibraryAccessors laccForKotlinLibraryAccessors = new KotlinLibraryAccessors(owner);
    private final KotlinxLibraryAccessors laccForKotlinxLibraryAccessors = new KotlinxLibraryAccessors(owner);
    private final VersionAccessors vaccForVersionAccessors = new VersionAccessors(providers, config);
    private final BundleAccessors baccForBundleAccessors = new BundleAccessors(objects, providers, config, attributesFactory, capabilityNotationParser);
    private final PluginAccessors paccForPluginAccessors = new PluginAccessors(providers, config);

    @Inject
    public LibrariesForLibs(DefaultVersionCatalog config, ProviderFactory providers, ObjectFactory objects, ImmutableAttributesFactory attributesFactory, CapabilityNotationParser capabilityNotationParser) {
        super(config, providers, objects, attributesFactory, capabilityNotationParser);
    }

    /**
     * Group of libraries at <b>androidx</b>
     */
    public AndroidxLibraryAccessors getAndroidx() {
        return laccForAndroidxLibraryAccessors;
    }

    /**
     * Group of libraries at <b>coil</b>
     */
    public CoilLibraryAccessors getCoil() {
        return laccForCoilLibraryAccessors;
    }

    /**
     * Group of libraries at <b>kotlin</b>
     */
    public KotlinLibraryAccessors getKotlin() {
        return laccForKotlinLibraryAccessors;
    }

    /**
     * Group of libraries at <b>kotlinx</b>
     */
    public KotlinxLibraryAccessors getKotlinx() {
        return laccForKotlinxLibraryAccessors;
    }

    /**
     * Group of versions at <b>versions</b>
     */
    public VersionAccessors getVersions() {
        return vaccForVersionAccessors;
    }

    /**
     * Group of bundles at <b>bundles</b>
     */
    public BundleAccessors getBundles() {
        return baccForBundleAccessors;
    }

    /**
     * Group of plugins at <b>plugins</b>
     */
    public PluginAccessors getPlugins() {
        return paccForPluginAccessors;
    }

    public static class AndroidxLibraryAccessors extends SubDependencyFactory {
        private final AndroidxActivityLibraryAccessors laccForAndroidxActivityLibraryAccessors = new AndroidxActivityLibraryAccessors(owner);
        private final AndroidxAppcompatLibraryAccessors laccForAndroidxAppcompatLibraryAccessors = new AndroidxAppcompatLibraryAccessors(owner);
        private final AndroidxComposeLibraryAccessors laccForAndroidxComposeLibraryAccessors = new AndroidxComposeLibraryAccessors(owner);
        private final AndroidxCoreLibraryAccessors laccForAndroidxCoreLibraryAccessors = new AndroidxCoreLibraryAccessors(owner);
        private final AndroidxNavigationLibraryAccessors laccForAndroidxNavigationLibraryAccessors = new AndroidxNavigationLibraryAccessors(owner);

        public AndroidxLibraryAccessors(AbstractExternalDependencyFactory owner) { super(owner); }

        /**
         * Group of libraries at <b>androidx.activity</b>
         */
        public AndroidxActivityLibraryAccessors getActivity() {
            return laccForAndroidxActivityLibraryAccessors;
        }

        /**
         * Group of libraries at <b>androidx.appcompat</b>
         */
        public AndroidxAppcompatLibraryAccessors getAppcompat() {
            return laccForAndroidxAppcompatLibraryAccessors;
        }

        /**
         * Group of libraries at <b>androidx.compose</b>
         */
        public AndroidxComposeLibraryAccessors getCompose() {
            return laccForAndroidxComposeLibraryAccessors;
        }

        /**
         * Group of libraries at <b>androidx.core</b>
         */
        public AndroidxCoreLibraryAccessors getCore() {
            return laccForAndroidxCoreLibraryAccessors;
        }

        /**
         * Group of libraries at <b>androidx.navigation</b>
         */
        public AndroidxNavigationLibraryAccessors getNavigation() {
            return laccForAndroidxNavigationLibraryAccessors;
        }

    }

    public static class AndroidxActivityLibraryAccessors extends SubDependencyFactory {

        public AndroidxActivityLibraryAccessors(AbstractExternalDependencyFactory owner) { super(owner); }

        /**
         * Dependency provider for <b>compose</b> with <b>androidx.activity:activity-compose</b> coordinates and
         * with version reference <b>androidx.activity</b>
         * <p>
         * This dependency was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<MinimalExternalModuleDependency> getCompose() {
            return create("androidx.activity.compose");
        }

    }

    public static class AndroidxAppcompatLibraryAccessors extends SubDependencyFactory implements DependencyNotationSupplier {

        public AndroidxAppcompatLibraryAccessors(AbstractExternalDependencyFactory owner) { super(owner); }

        /**
         * Dependency provider for <b>appcompat</b> with <b>androidx.appcompat:appcompat</b> coordinates and
         * with version reference <b>androidx.appcompat</b>
         * <p>
         * This dependency was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<MinimalExternalModuleDependency> asProvider() {
            return create("androidx.appcompat");
        }

        /**
         * Dependency provider for <b>resources</b> with <b>androidx.appcompat:appcompat-resources</b> coordinates and
         * with version reference <b>androidx.appcompat</b>
         * <p>
         * This dependency was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<MinimalExternalModuleDependency> getResources() {
            return create("androidx.appcompat.resources");
        }

    }

    public static class AndroidxComposeLibraryAccessors extends SubDependencyFactory {
        private final AndroidxComposeMaterialLibraryAccessors laccForAndroidxComposeMaterialLibraryAccessors = new AndroidxComposeMaterialLibraryAccessors(owner);
        private final AndroidxComposeUiLibraryAccessors laccForAndroidxComposeUiLibraryAccessors = new AndroidxComposeUiLibraryAccessors(owner);

        public AndroidxComposeLibraryAccessors(AbstractExternalDependencyFactory owner) { super(owner); }

        /**
         * Dependency provider for <b>animation</b> with <b>androidx.compose.animation:animation</b> coordinates and
         * with <b>no version specified</b>
         * <p>
         * This dependency was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<MinimalExternalModuleDependency> getAnimation() {
            return create("androidx.compose.animation");
        }

        /**
         * Dependency provider for <b>bom</b> with <b>androidx.compose:compose-bom</b> coordinates and
         * with version reference <b>androidx.compose.bom</b>
         * <p>
         * This dependency was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<MinimalExternalModuleDependency> getBom() {
            return create("androidx.compose.bom");
        }

        /**
         * Dependency provider for <b>foundation</b> with <b>androidx.compose.foundation:foundation</b> coordinates and
         * with <b>no version specified</b>
         * <p>
         * This dependency was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<MinimalExternalModuleDependency> getFoundation() {
            return create("androidx.compose.foundation");
        }

        /**
         * Dependency provider for <b>material3</b> with <b>androidx.compose.material3:material3</b> coordinates and
         * with <b>no version specified</b>
         * <p>
         * This dependency was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<MinimalExternalModuleDependency> getMaterial3() {
            return create("androidx.compose.material3");
        }

        /**
         * Dependency provider for <b>runtime</b> with <b>androidx.compose.runtime:runtime</b> coordinates and
         * with <b>no version specified</b>
         * <p>
         * This dependency was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<MinimalExternalModuleDependency> getRuntime() {
            return create("androidx.compose.runtime");
        }

        /**
         * Group of libraries at <b>androidx.compose.material</b>
         */
        public AndroidxComposeMaterialLibraryAccessors getMaterial() {
            return laccForAndroidxComposeMaterialLibraryAccessors;
        }

        /**
         * Group of libraries at <b>androidx.compose.ui</b>
         */
        public AndroidxComposeUiLibraryAccessors getUi() {
            return laccForAndroidxComposeUiLibraryAccessors;
        }

    }

    public static class AndroidxComposeMaterialLibraryAccessors extends SubDependencyFactory implements DependencyNotationSupplier {
        private final AndroidxComposeMaterialIconsLibraryAccessors laccForAndroidxComposeMaterialIconsLibraryAccessors = new AndroidxComposeMaterialIconsLibraryAccessors(owner);

        public AndroidxComposeMaterialLibraryAccessors(AbstractExternalDependencyFactory owner) { super(owner); }

        /**
         * Dependency provider for <b>material</b> with <b>androidx.compose.material:material</b> coordinates and
         * with <b>no version specified</b>
         * <p>
         * This dependency was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<MinimalExternalModuleDependency> asProvider() {
            return create("androidx.compose.material");
        }

        /**
         * Group of libraries at <b>androidx.compose.material.icons</b>
         */
        public AndroidxComposeMaterialIconsLibraryAccessors getIcons() {
            return laccForAndroidxComposeMaterialIconsLibraryAccessors;
        }

    }

    public static class AndroidxComposeMaterialIconsLibraryAccessors extends SubDependencyFactory {

        public AndroidxComposeMaterialIconsLibraryAccessors(AbstractExternalDependencyFactory owner) { super(owner); }

        /**
         * Dependency provider for <b>extended</b> with <b>androidx.compose.material:material-icons-extended</b> coordinates and
         * with <b>no version specified</b>
         * <p>
         * This dependency was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<MinimalExternalModuleDependency> getExtended() {
            return create("androidx.compose.material.icons.extended");
        }

    }

    public static class AndroidxComposeUiLibraryAccessors extends SubDependencyFactory implements DependencyNotationSupplier {
        private final AndroidxComposeUiTestLibraryAccessors laccForAndroidxComposeUiTestLibraryAccessors = new AndroidxComposeUiTestLibraryAccessors(owner);

        public AndroidxComposeUiLibraryAccessors(AbstractExternalDependencyFactory owner) { super(owner); }

        /**
         * Dependency provider for <b>ui</b> with <b>androidx.compose.ui:ui</b> coordinates and
         * with <b>no version specified</b>
         * <p>
         * This dependency was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<MinimalExternalModuleDependency> asProvider() {
            return create("androidx.compose.ui");
        }

        /**
         * Dependency provider for <b>tooling</b> with <b>androidx.compose.ui:ui-tooling</b> coordinates and
         * with <b>no version specified</b>
         * <p>
         * This dependency was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<MinimalExternalModuleDependency> getTooling() {
            return create("androidx.compose.ui.tooling");
        }

        /**
         * Group of libraries at <b>androidx.compose.ui.test</b>
         */
        public AndroidxComposeUiTestLibraryAccessors getTest() {
            return laccForAndroidxComposeUiTestLibraryAccessors;
        }

    }

    public static class AndroidxComposeUiTestLibraryAccessors extends SubDependencyFactory implements DependencyNotationSupplier {

        public AndroidxComposeUiTestLibraryAccessors(AbstractExternalDependencyFactory owner) { super(owner); }

        /**
         * Dependency provider for <b>test</b> with <b>androidx.compose.ui:ui-test</b> coordinates and
         * with <b>no version specified</b>
         * <p>
         * This dependency was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<MinimalExternalModuleDependency> asProvider() {
            return create("androidx.compose.ui.test");
        }

        /**
         * Dependency provider for <b>junit4</b> with <b>androidx.compose.ui:ui-test-junit4</b> coordinates and
         * with <b>no version specified</b>
         * <p>
         * This dependency was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<MinimalExternalModuleDependency> getJunit4() {
            return create("androidx.compose.ui.test.junit4");
        }

        /**
         * Dependency provider for <b>manifest</b> with <b>androidx.compose.ui:ui-test-manifest</b> coordinates and
         * with <b>no version specified</b>
         * <p>
         * This dependency was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<MinimalExternalModuleDependency> getManifest() {
            return create("androidx.compose.ui.test.manifest");
        }

    }

    public static class AndroidxCoreLibraryAccessors extends SubDependencyFactory {

        public AndroidxCoreLibraryAccessors(AbstractExternalDependencyFactory owner) { super(owner); }

        /**
         * Dependency provider for <b>ktx</b> with <b>androidx.core:core-ktx</b> coordinates and
         * with <b>no version specified</b>
         * <p>
         * This dependency was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<MinimalExternalModuleDependency> getKtx() {
            return create("androidx.core.ktx");
        }

    }

    public static class AndroidxNavigationLibraryAccessors extends SubDependencyFactory {

        public AndroidxNavigationLibraryAccessors(AbstractExternalDependencyFactory owner) { super(owner); }

        /**
         * Dependency provider for <b>compose</b> with <b>androidx.navigation:navigation-compose</b> coordinates and
         * with version reference <b>androidx.navigation</b>
         * <p>
         * This dependency was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<MinimalExternalModuleDependency> getCompose() {
            return create("androidx.navigation.compose");
        }

    }

    public static class CoilLibraryAccessors extends SubDependencyFactory {

        public CoilLibraryAccessors(AbstractExternalDependencyFactory owner) { super(owner); }

        /**
         * Dependency provider for <b>compose</b> with <b>io.coil-kt:coil-compose</b> coordinates and
         * with version reference <b>coil.compose</b>
         * <p>
         * This dependency was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<MinimalExternalModuleDependency> getCompose() {
            return create("coil.compose");
        }

    }

    public static class KotlinLibraryAccessors extends SubDependencyFactory {

        public KotlinLibraryAccessors(AbstractExternalDependencyFactory owner) { super(owner); }

        /**
         * Dependency provider for <b>bom</b> with <b>org.jetbrains.kotlin:kotlin-bom</b> coordinates and
         * with version reference <b>kotlin</b>
         * <p>
         * This dependency was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<MinimalExternalModuleDependency> getBom() {
            return create("kotlin.bom");
        }

        /**
         * Dependency provider for <b>reflect</b> with <b>org.jetbrains.kotlin:kotlin-reflect</b> coordinates and
         * with <b>no version specified</b>
         * <p>
         * This dependency was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<MinimalExternalModuleDependency> getReflect() {
            return create("kotlin.reflect");
        }

    }

    public static class KotlinxLibraryAccessors extends SubDependencyFactory {
        private final KotlinxCoroutinesLibraryAccessors laccForKotlinxCoroutinesLibraryAccessors = new KotlinxCoroutinesLibraryAccessors(owner);

        public KotlinxLibraryAccessors(AbstractExternalDependencyFactory owner) { super(owner); }

        /**
         * Group of libraries at <b>kotlinx.coroutines</b>
         */
        public KotlinxCoroutinesLibraryAccessors getCoroutines() {
            return laccForKotlinxCoroutinesLibraryAccessors;
        }

    }

    public static class KotlinxCoroutinesLibraryAccessors extends SubDependencyFactory {

        public KotlinxCoroutinesLibraryAccessors(AbstractExternalDependencyFactory owner) { super(owner); }

        /**
         * Dependency provider for <b>android</b> with <b>org.jetbrains.kotlinx:kotlinx-coroutines-android</b> coordinates and
         * with version reference <b>kotlin.coroutines</b>
         * <p>
         * This dependency was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<MinimalExternalModuleDependency> getAndroid() {
            return create("kotlinx.coroutines.android");
        }

        /**
         * Dependency provider for <b>core</b> with <b>org.jetbrains.kotlinx:kotlinx-coroutines-core</b> coordinates and
         * with version reference <b>kotlin.coroutines</b>
         * <p>
         * This dependency was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<MinimalExternalModuleDependency> getCore() {
            return create("kotlinx.coroutines.core");
        }

    }

    public static class VersionAccessors extends VersionFactory  {

        private final AndroidVersionAccessors vaccForAndroidVersionAccessors = new AndroidVersionAccessors(providers, config);
        private final AndroidxVersionAccessors vaccForAndroidxVersionAccessors = new AndroidxVersionAccessors(providers, config);
        private final CoilVersionAccessors vaccForCoilVersionAccessors = new CoilVersionAccessors(providers, config);
        private final KotlinVersionAccessors vaccForKotlinVersionAccessors = new KotlinVersionAccessors(providers, config);
        public VersionAccessors(ProviderFactory providers, DefaultVersionCatalog config) { super(providers, config); }

        /**
         * Version alias <b>jvm</b> with value <b>21</b>
         * <p>
         * If the version is a rich version and cannot be represented as a
         * single version string, an empty string is returned.
         * <p>
         * This version was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<String> getJvm() { return getVersion("jvm"); }

        /**
         * Group of versions at <b>versions.android</b>
         */
        public AndroidVersionAccessors getAndroid() {
            return vaccForAndroidVersionAccessors;
        }

        /**
         * Group of versions at <b>versions.androidx</b>
         */
        public AndroidxVersionAccessors getAndroidx() {
            return vaccForAndroidxVersionAccessors;
        }

        /**
         * Group of versions at <b>versions.coil</b>
         */
        public CoilVersionAccessors getCoil() {
            return vaccForCoilVersionAccessors;
        }

        /**
         * Group of versions at <b>versions.kotlin</b>
         */
        public KotlinVersionAccessors getKotlin() {
            return vaccForKotlinVersionAccessors;
        }

    }

    public static class AndroidVersionAccessors extends VersionFactory  {

        private final AndroidGradleVersionAccessors vaccForAndroidGradleVersionAccessors = new AndroidGradleVersionAccessors(providers, config);
        private final AndroidSdkVersionAccessors vaccForAndroidSdkVersionAccessors = new AndroidSdkVersionAccessors(providers, config);
        public AndroidVersionAccessors(ProviderFactory providers, DefaultVersionCatalog config) { super(providers, config); }

        /**
         * Group of versions at <b>versions.android.gradle</b>
         */
        public AndroidGradleVersionAccessors getGradle() {
            return vaccForAndroidGradleVersionAccessors;
        }

        /**
         * Group of versions at <b>versions.android.sdk</b>
         */
        public AndroidSdkVersionAccessors getSdk() {
            return vaccForAndroidSdkVersionAccessors;
        }

    }

    public static class AndroidGradleVersionAccessors extends VersionFactory  {

        public AndroidGradleVersionAccessors(ProviderFactory providers, DefaultVersionCatalog config) { super(providers, config); }

        /**
         * Version alias <b>android.gradle.plugin</b> with value <b>8.2.2</b>
         * <p>
         * If the version is a rich version and cannot be represented as a
         * single version string, an empty string is returned.
         * <p>
         * This version was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<String> getPlugin() { return getVersion("android.gradle.plugin"); }

    }

    public static class AndroidSdkVersionAccessors extends VersionFactory  {

        public AndroidSdkVersionAccessors(ProviderFactory providers, DefaultVersionCatalog config) { super(providers, config); }

        /**
         * Version alias <b>android.sdk.compile</b> with value <b>34</b>
         * <p>
         * If the version is a rich version and cannot be represented as a
         * single version string, an empty string is returned.
         * <p>
         * This version was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<String> getCompile() { return getVersion("android.sdk.compile"); }

        /**
         * Version alias <b>android.sdk.min</b> with value <b>29</b>
         * <p>
         * If the version is a rich version and cannot be represented as a
         * single version string, an empty string is returned.
         * <p>
         * This version was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<String> getMin() { return getVersion("android.sdk.min"); }

    }

    public static class AndroidxVersionAccessors extends VersionFactory  {

        private final AndroidxComposeVersionAccessors vaccForAndroidxComposeVersionAccessors = new AndroidxComposeVersionAccessors(providers, config);
        public AndroidxVersionAccessors(ProviderFactory providers, DefaultVersionCatalog config) { super(providers, config); }

        /**
         * Version alias <b>androidx.activity</b> with value <b>1.8.2</b>
         * <p>
         * If the version is a rich version and cannot be represented as a
         * single version string, an empty string is returned.
         * <p>
         * This version was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<String> getActivity() { return getVersion("androidx.activity"); }

        /**
         * Version alias <b>androidx.appcompat</b> with value <b>1.6.1</b>
         * <p>
         * If the version is a rich version and cannot be represented as a
         * single version string, an empty string is returned.
         * <p>
         * This version was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<String> getAppcompat() { return getVersion("androidx.appcompat"); }

        /**
         * Version alias <b>androidx.navigation</b> with value <b>2.7.6</b>
         * <p>
         * If the version is a rich version and cannot be represented as a
         * single version string, an empty string is returned.
         * <p>
         * This version was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<String> getNavigation() { return getVersion("androidx.navigation"); }

        /**
         * Group of versions at <b>versions.androidx.compose</b>
         */
        public AndroidxComposeVersionAccessors getCompose() {
            return vaccForAndroidxComposeVersionAccessors;
        }

    }

    public static class AndroidxComposeVersionAccessors extends VersionFactory  {

        public AndroidxComposeVersionAccessors(ProviderFactory providers, DefaultVersionCatalog config) { super(providers, config); }

        /**
         * Version alias <b>androidx.compose.bom</b> with value <b>2024.05.00</b>
         * <p>
         * If the version is a rich version and cannot be represented as a
         * single version string, an empty string is returned.
         * <p>
         * This version was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<String> getBom() { return getVersion("androidx.compose.bom"); }

    }

    public static class CoilVersionAccessors extends VersionFactory  {

        public CoilVersionAccessors(ProviderFactory providers, DefaultVersionCatalog config) { super(providers, config); }

        /**
         * Version alias <b>coil.compose</b> with value <b>2.5.0</b>
         * <p>
         * If the version is a rich version and cannot be represented as a
         * single version string, an empty string is returned.
         * <p>
         * This version was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<String> getCompose() { return getVersion("coil.compose"); }

    }

    public static class KotlinVersionAccessors extends VersionFactory  implements VersionNotationSupplier {

        private final KotlinComposeVersionAccessors vaccForKotlinComposeVersionAccessors = new KotlinComposeVersionAccessors(providers, config);
        public KotlinVersionAccessors(ProviderFactory providers, DefaultVersionCatalog config) { super(providers, config); }

        /**
         * Version alias <b>kotlin</b> with value <b>1.9.22</b>
         * <p>
         * If the version is a rich version and cannot be represented as a
         * single version string, an empty string is returned.
         * <p>
         * This version was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<String> asProvider() { return getVersion("kotlin"); }

        /**
         * Version alias <b>kotlin.coroutines</b> with value <b>1.8.1</b>
         * <p>
         * If the version is a rich version and cannot be represented as a
         * single version string, an empty string is returned.
         * <p>
         * This version was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<String> getCoroutines() { return getVersion("kotlin.coroutines"); }

        /**
         * Group of versions at <b>versions.kotlin.compose</b>
         */
        public KotlinComposeVersionAccessors getCompose() {
            return vaccForKotlinComposeVersionAccessors;
        }

    }

    public static class KotlinComposeVersionAccessors extends VersionFactory  {

        private final KotlinComposeCompilerVersionAccessors vaccForKotlinComposeCompilerVersionAccessors = new KotlinComposeCompilerVersionAccessors(providers, config);
        public KotlinComposeVersionAccessors(ProviderFactory providers, DefaultVersionCatalog config) { super(providers, config); }

        /**
         * Group of versions at <b>versions.kotlin.compose.compiler</b>
         */
        public KotlinComposeCompilerVersionAccessors getCompiler() {
            return vaccForKotlinComposeCompilerVersionAccessors;
        }

    }

    public static class KotlinComposeCompilerVersionAccessors extends VersionFactory  {

        public KotlinComposeCompilerVersionAccessors(ProviderFactory providers, DefaultVersionCatalog config) { super(providers, config); }

        /**
         * Version alias <b>kotlin.compose.compiler.extension</b> with value <b>1.5.8</b>
         * <p>
         * If the version is a rich version and cannot be represented as a
         * single version string, an empty string is returned.
         * <p>
         * This version was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<String> getExtension() { return getVersion("kotlin.compose.compiler.extension"); }

    }

    public static class BundleAccessors extends BundleFactory {

        public BundleAccessors(ObjectFactory objects, ProviderFactory providers, DefaultVersionCatalog config, ImmutableAttributesFactory attributesFactory, CapabilityNotationParser capabilityNotationParser) { super(objects, providers, config, attributesFactory, capabilityNotationParser); }

    }

    public static class PluginAccessors extends PluginFactory {
        private final AndroidPluginAccessors paccForAndroidPluginAccessors = new AndroidPluginAccessors(providers, config);
        private final KotlinPluginAccessors paccForKotlinPluginAccessors = new KotlinPluginAccessors(providers, config);

        public PluginAccessors(ProviderFactory providers, DefaultVersionCatalog config) { super(providers, config); }

        /**
         * Group of plugins at <b>plugins.android</b>
         */
        public AndroidPluginAccessors getAndroid() {
            return paccForAndroidPluginAccessors;
        }

        /**
         * Group of plugins at <b>plugins.kotlin</b>
         */
        public KotlinPluginAccessors getKotlin() {
            return paccForKotlinPluginAccessors;
        }

    }

    public static class AndroidPluginAccessors extends PluginFactory {

        public AndroidPluginAccessors(ProviderFactory providers, DefaultVersionCatalog config) { super(providers, config); }

        /**
         * Plugin provider for <b>android.application</b> with plugin id <b>com.android.application</b> and
         * with version reference <b>android.gradle.plugin</b>
         * <p>
         * This plugin was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<PluginDependency> getApplication() { return createPlugin("android.application"); }

        /**
         * Plugin provider for <b>android.library</b> with plugin id <b>com.android.library</b> and
         * with version reference <b>android.gradle.plugin</b>
         * <p>
         * This plugin was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<PluginDependency> getLibrary() { return createPlugin("android.library"); }

    }

    public static class KotlinPluginAccessors extends PluginFactory {

        public KotlinPluginAccessors(ProviderFactory providers, DefaultVersionCatalog config) { super(providers, config); }

        /**
         * Plugin provider for <b>kotlin.android</b> with plugin id <b>org.jetbrains.kotlin.android</b> and
         * with version reference <b>kotlin</b>
         * <p>
         * This plugin was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<PluginDependency> getAndroid() { return createPlugin("kotlin.android"); }

    }

}
