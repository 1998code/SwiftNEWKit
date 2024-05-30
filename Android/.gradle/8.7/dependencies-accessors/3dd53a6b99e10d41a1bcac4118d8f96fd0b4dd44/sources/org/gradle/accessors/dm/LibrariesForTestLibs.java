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
 * A catalog of dependencies accessible via the {@code testLibs} extension.
 */
@NonNullApi
public class LibrariesForTestLibs extends AbstractExternalDependencyFactory {

    private final AbstractExternalDependencyFactory owner = this;
    private final AndroidxLibraryAccessors laccForAndroidxLibraryAccessors = new AndroidxLibraryAccessors(owner);
    private final KotlinLibraryAccessors laccForKotlinLibraryAccessors = new KotlinLibraryAccessors(owner);
    private final KotlinxLibraryAccessors laccForKotlinxLibraryAccessors = new KotlinxLibraryAccessors(owner);
    private final VersionAccessors vaccForVersionAccessors = new VersionAccessors(providers, config);
    private final BundleAccessors baccForBundleAccessors = new BundleAccessors(objects, providers, config, attributesFactory, capabilityNotationParser);
    private final PluginAccessors paccForPluginAccessors = new PluginAccessors(providers, config);

    @Inject
    public LibrariesForTestLibs(DefaultVersionCatalog config, ProviderFactory providers, ObjectFactory objects, ImmutableAttributesFactory attributesFactory, CapabilityNotationParser capabilityNotationParser) {
        super(config, providers, objects, attributesFactory, capabilityNotationParser);
    }

    /**
     * Dependency provider for <b>json</b> with <b>org.json:json</b> coordinates and
     * with version <b>20231013</b>
     * <p>
     * This dependency was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
     */
    public Provider<MinimalExternalModuleDependency> getJson() {
        return create("json");
    }

    /**
     * Dependency provider for <b>robolectric</b> with <b>org.robolectric:robolectric</b> coordinates and
     * with version reference <b>robolectric</b>
     * <p>
     * This dependency was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
     */
    public Provider<MinimalExternalModuleDependency> getRobolectric() {
        return create("robolectric");
    }

    /**
     * Group of libraries at <b>androidx</b>
     */
    public AndroidxLibraryAccessors getAndroidx() {
        return laccForAndroidxLibraryAccessors;
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
        private final AndroidxTestLibraryAccessors laccForAndroidxTestLibraryAccessors = new AndroidxTestLibraryAccessors(owner);

        public AndroidxLibraryAccessors(AbstractExternalDependencyFactory owner) { super(owner); }

        /**
         * Group of libraries at <b>androidx.test</b>
         */
        public AndroidxTestLibraryAccessors getTest() {
            return laccForAndroidxTestLibraryAccessors;
        }

    }

    public static class AndroidxTestLibraryAccessors extends SubDependencyFactory {
        private final AndroidxTestExtLibraryAccessors laccForAndroidxTestExtLibraryAccessors = new AndroidxTestExtLibraryAccessors(owner);

        public AndroidxTestLibraryAccessors(AbstractExternalDependencyFactory owner) { super(owner); }

        /**
         * Dependency provider for <b>core</b> with <b>androidx.test:core</b> coordinates and
         * with version reference <b>androidx.test.core</b>
         * <p>
         * This dependency was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<MinimalExternalModuleDependency> getCore() {
            return create("androidx.test.core");
        }

        /**
         * Dependency provider for <b>rules</b> with <b>androidx.test:rules</b> coordinates and
         * with version reference <b>androidx.test.rules</b>
         * <p>
         * This dependency was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<MinimalExternalModuleDependency> getRules() {
            return create("androidx.test.rules");
        }

        /**
         * Dependency provider for <b>runner</b> with <b>androidx.test:runner</b> coordinates and
         * with version reference <b>androidx.test.runner</b>
         * <p>
         * This dependency was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<MinimalExternalModuleDependency> getRunner() {
            return create("androidx.test.runner");
        }

        /**
         * Group of libraries at <b>androidx.test.ext</b>
         */
        public AndroidxTestExtLibraryAccessors getExt() {
            return laccForAndroidxTestExtLibraryAccessors;
        }

    }

    public static class AndroidxTestExtLibraryAccessors extends SubDependencyFactory {

        public AndroidxTestExtLibraryAccessors(AbstractExternalDependencyFactory owner) { super(owner); }

        /**
         * Dependency provider for <b>junit</b> with <b>androidx.test.ext:junit</b> coordinates and
         * with version reference <b>androidx.test.ext.junit</b>
         * <p>
         * This dependency was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<MinimalExternalModuleDependency> getJunit() {
            return create("androidx.test.ext.junit");
        }

    }

    public static class KotlinLibraryAccessors extends SubDependencyFactory {
        private final KotlinTestLibraryAccessors laccForKotlinTestLibraryAccessors = new KotlinTestLibraryAccessors(owner);

        public KotlinLibraryAccessors(AbstractExternalDependencyFactory owner) { super(owner); }

        /**
         * Group of libraries at <b>kotlin.test</b>
         */
        public KotlinTestLibraryAccessors getTest() {
            return laccForKotlinTestLibraryAccessors;
        }

    }

    public static class KotlinTestLibraryAccessors extends SubDependencyFactory implements DependencyNotationSupplier {

        public KotlinTestLibraryAccessors(AbstractExternalDependencyFactory owner) { super(owner); }

        /**
         * Dependency provider for <b>test</b> with <b>org.jetbrains.kotlin:kotlin-test</b> coordinates and
         * with <b>no version specified</b>
         * <p>
         * This dependency was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<MinimalExternalModuleDependency> asProvider() {
            return create("kotlin.test");
        }

        /**
         * Dependency provider for <b>junit</b> with <b>org.jetbrains.kotlin:kotlin-test-junit</b> coordinates and
         * with <b>no version specified</b>
         * <p>
         * This dependency was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<MinimalExternalModuleDependency> getJunit() {
            return create("kotlin.test.junit");
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
         * Dependency provider for <b>test</b> with <b>org.jetbrains.kotlinx:kotlinx-coroutines-test</b> coordinates and
         * with version reference <b>kotlin.coroutines.test</b>
         * <p>
         * This dependency was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<MinimalExternalModuleDependency> getTest() {
            return create("kotlinx.coroutines.test");
        }

    }

    public static class VersionAccessors extends VersionFactory  {

        private final AndroidxVersionAccessors vaccForAndroidxVersionAccessors = new AndroidxVersionAccessors(providers, config);
        private final KotlinVersionAccessors vaccForKotlinVersionAccessors = new KotlinVersionAccessors(providers, config);
        public VersionAccessors(ProviderFactory providers, DefaultVersionCatalog config) { super(providers, config); }

        /**
         * Version alias <b>robolectric</b> with value <b>4.11.1</b>
         * <p>
         * If the version is a rich version and cannot be represented as a
         * single version string, an empty string is returned.
         * <p>
         * This version was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<String> getRobolectric() { return getVersion("robolectric"); }

        /**
         * Group of versions at <b>versions.androidx</b>
         */
        public AndroidxVersionAccessors getAndroidx() {
            return vaccForAndroidxVersionAccessors;
        }

        /**
         * Group of versions at <b>versions.kotlin</b>
         */
        public KotlinVersionAccessors getKotlin() {
            return vaccForKotlinVersionAccessors;
        }

    }

    public static class AndroidxVersionAccessors extends VersionFactory  {

        private final AndroidxTestVersionAccessors vaccForAndroidxTestVersionAccessors = new AndroidxTestVersionAccessors(providers, config);
        public AndroidxVersionAccessors(ProviderFactory providers, DefaultVersionCatalog config) { super(providers, config); }

        /**
         * Group of versions at <b>versions.androidx.test</b>
         */
        public AndroidxTestVersionAccessors getTest() {
            return vaccForAndroidxTestVersionAccessors;
        }

    }

    public static class AndroidxTestVersionAccessors extends VersionFactory  {

        private final AndroidxTestExtVersionAccessors vaccForAndroidxTestExtVersionAccessors = new AndroidxTestExtVersionAccessors(providers, config);
        public AndroidxTestVersionAccessors(ProviderFactory providers, DefaultVersionCatalog config) { super(providers, config); }

        /**
         * Version alias <b>androidx.test.core</b> with value <b>1.5.0</b>
         * <p>
         * If the version is a rich version and cannot be represented as a
         * single version string, an empty string is returned.
         * <p>
         * This version was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<String> getCore() { return getVersion("androidx.test.core"); }

        /**
         * Version alias <b>androidx.test.rules</b> with value <b>1.5.0</b>
         * <p>
         * If the version is a rich version and cannot be represented as a
         * single version string, an empty string is returned.
         * <p>
         * This version was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<String> getRules() { return getVersion("androidx.test.rules"); }

        /**
         * Version alias <b>androidx.test.runner</b> with value <b>1.5.2</b>
         * <p>
         * If the version is a rich version and cannot be represented as a
         * single version string, an empty string is returned.
         * <p>
         * This version was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<String> getRunner() { return getVersion("androidx.test.runner"); }

        /**
         * Group of versions at <b>versions.androidx.test.ext</b>
         */
        public AndroidxTestExtVersionAccessors getExt() {
            return vaccForAndroidxTestExtVersionAccessors;
        }

    }

    public static class AndroidxTestExtVersionAccessors extends VersionFactory  {

        public AndroidxTestExtVersionAccessors(ProviderFactory providers, DefaultVersionCatalog config) { super(providers, config); }

        /**
         * Version alias <b>androidx.test.ext.junit</b> with value <b>1.1.5</b>
         * <p>
         * If the version is a rich version and cannot be represented as a
         * single version string, an empty string is returned.
         * <p>
         * This version was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<String> getJunit() { return getVersion("androidx.test.ext.junit"); }

    }

    public static class KotlinVersionAccessors extends VersionFactory  {

        private final KotlinCoroutinesVersionAccessors vaccForKotlinCoroutinesVersionAccessors = new KotlinCoroutinesVersionAccessors(providers, config);
        public KotlinVersionAccessors(ProviderFactory providers, DefaultVersionCatalog config) { super(providers, config); }

        /**
         * Group of versions at <b>versions.kotlin.coroutines</b>
         */
        public KotlinCoroutinesVersionAccessors getCoroutines() {
            return vaccForKotlinCoroutinesVersionAccessors;
        }

    }

    public static class KotlinCoroutinesVersionAccessors extends VersionFactory  {

        public KotlinCoroutinesVersionAccessors(ProviderFactory providers, DefaultVersionCatalog config) { super(providers, config); }

        /**
         * Version alias <b>kotlin.coroutines.test</b> with value <b>1.8.1</b>
         * <p>
         * If the version is a rich version and cannot be represented as a
         * single version string, an empty string is returned.
         * <p>
         * This version was declared in script '/Users/ming/Library/Developer/Xcode/DerivedData/Universal-gwghfhsrmvrrjxgvunyxwndbrcty/SourcePackages/plugins/universal.output/Universal/skipstone/settings.gradle.kts'
         */
        public Provider<String> getTest() { return getVersion("kotlin.coroutines.test"); }

    }

    public static class BundleAccessors extends BundleFactory {

        public BundleAccessors(ObjectFactory objects, ProviderFactory providers, DefaultVersionCatalog config, ImmutableAttributesFactory attributesFactory, CapabilityNotationParser capabilityNotationParser) { super(objects, providers, config, attributesFactory, capabilityNotationParser); }

    }

    public static class PluginAccessors extends PluginFactory {

        public PluginAccessors(ProviderFactory providers, DefaultVersionCatalog config) { super(providers, config); }

    }

}
