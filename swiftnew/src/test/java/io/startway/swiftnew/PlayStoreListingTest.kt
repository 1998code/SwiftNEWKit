package io.startway.swiftnew

import io.startway.swiftnew.data.PlayStoreListing
import io.startway.swiftnew.data.PlayUpdateChecker
import io.startway.swiftnew.model.FeatureItem
import io.startway.swiftnew.model.VersionRelease
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

class PlayStoreListingTest {
  @Test
  fun buildsPlayStoreUrl() {
    val listing = PlayStoreListing.forPackage("io.startway.whatsnew")
    assertEquals("io.startway.whatsnew", listing!!.packageName)
    assertEquals(
      "https://play.google.com/store/apps/details?id=io.startway.whatsnew",
      listing.url,
    )
  }

  @Test
  fun rejectsBlankPackage() {
    assertNull(PlayStoreListing.forPackage("  "))
  }

  @Test
  fun updateFallbackFromReleaseNotes() {
    val releases =
      listOf(
        VersionRelease(
          version = "2.0",
          new = listOf(FeatureItem(icon = "star", title = "A", subtitle = "B", body = "C")),
        ),
        VersionRelease(version = "1.0", new = emptyList()),
      )
    val candidate =
      PlayUpdateChecker.fromReleaseNotes(
        releases = releases,
        currentVersion = "1.0",
        storeUrl = "https://play.google.com/store/apps/details?id=demo",
      )
    assertEquals("2.0", candidate!!.version)
    assertEquals(1, candidate.features.size)
  }
}
