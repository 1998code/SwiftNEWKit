package io.startway.swiftnew

import io.startway.swiftnew.data.ReleaseNotesLoader
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class ReleaseNotesLoaderTest {
  @Test
  fun decodeSupportsIconAndIconsFields() {
    val json =
      """
      [
        {
          "version": "1.0",
          "new": [
            {
              "icon": "star.fill",
              "title": "Welcome",
              "subtitle": "Get Started",
              "body": "Thanks for downloading our app!"
            },
            {
              "icons": ["lock.fill", "lock.open.fill"],
              "title": "Secure",
              "subtitle": "Protected",
              "body": "Your data stays private."
            }
          ]
        }
      ]
      """
        .trimIndent()

    val releases = ReleaseNotesLoader.decode(json)
    assertEquals(1, releases.size)
    assertEquals("1.0", releases[0].version)
    assertEquals(listOf("star.fill"), releases[0].new[0].iconSequence)
    assertEquals(listOf("lock.fill", "lock.open.fill"), releases[0].new[1].iconSequence)
  }

  @Test
  fun decodeKeepsSubVersion() {
    val json =
      """
      [{"version":"27.4","subVersion":"27.4.0","new":[]}]
      """
        .trimIndent()

    val releases = ReleaseNotesLoader.decode(json)
    assertEquals("27.4.0", releases.single().subVersion)
    assertTrue(releases.single().new.isEmpty())
  }
}
