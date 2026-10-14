package io.startway.swiftnew

import io.startway.swiftnew.model.FeatureItem
import io.startway.swiftnew.util.SwiftNewSearch
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class SwiftNewSearchTest {
  private val item =
    FeatureItem(
      icon = "star.fill",
      title = "Welcome",
      subtitle = "Get Started",
      body = "Thanks for downloading",
    )

  @Test
  fun disabledOrBlankPasses() {
    assertTrue(SwiftNewSearch.matches(item, "welcome", isEnabled = false))
    assertTrue(SwiftNewSearch.matches(item, "   ", isEnabled = true))
  }

  @Test
  fun matchesTitleSubtitleBody() {
    assertTrue(SwiftNewSearch.matches(item, "welcome", isEnabled = true))
    assertTrue(SwiftNewSearch.matches(item, "started", isEnabled = true))
    assertTrue(SwiftNewSearch.matches(item, "downloading", isEnabled = true))
    assertFalse(SwiftNewSearch.matches(item, "missing", isEnabled = true))
  }
}
