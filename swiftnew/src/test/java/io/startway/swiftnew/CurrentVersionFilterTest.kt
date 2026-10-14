package io.startway.swiftnew

import io.startway.swiftnew.model.FeatureItem
import io.startway.swiftnew.model.VersionRelease
import io.startway.swiftnew.ui.sheets.currentVersionChanges
import io.startway.swiftnew.ui.sheets.visibleCurrentVersionChanges
import org.junit.Assert.assertEquals
import org.junit.Test

class CurrentVersionFilterTest {
  private val releases =
    listOf(
      VersionRelease(
        version = "27.4",
        subVersion = "27.4.0",
        new =
          listOf(
            FeatureItem(
              icon = "star.fill",
              title = "Welcome",
              subtitle = "Get Started",
              body = "Thanks for downloading our app!",
            ),
            FeatureItem(
              icons = listOf("lock.fill", "lock.open.fill"),
              title = "Secure",
              subtitle = "Protected",
              body = "Your data stays private.",
            ),
          ),
      ),
      VersionRelease(
        version = "27.3",
        new =
          listOf(
            FeatureItem(
              icon = "paintpalette",
              title = "Older",
              subtitle = "History",
              body = "Previous release",
            )
          ),
      ),
    )

  @Test
  fun matchesVersionAndSubVersion() {
    assertEquals(2, currentVersionChanges(releases, "27.4").size)
    assertEquals(2, currentVersionChanges(releases, "27.4.0").size)
    assertEquals(1, currentVersionChanges(releases, "27.3").size)
    assertEquals(0, currentVersionChanges(releases, "1.0").size)
  }

  @Test
  fun searchFiltersVisibleChanges() {
    val filtered = visibleCurrentVersionChanges(releases, "27.4", "secure")
    assertEquals(1, filtered.size)
    assertEquals("Secure", filtered.single().title)
  }
}
