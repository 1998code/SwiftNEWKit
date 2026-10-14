package io.startway.swiftnew.data

/**
 * Play Store listing metadata (Android counterpart to iOS `SwiftNEWAppStoreListing`).
 * Play has no public JSON lookup like iTunes; URL is derived from package name.
 */
data class PlayStoreListing(
  val packageName: String,
  val url: String,
) {
  companion object {
    fun forPackage(packageName: String): PlayStoreListing? {
      val normalized = packageName.trim()
      if (normalized.isEmpty()) return null
      return PlayStoreListing(
        packageName = normalized,
        url = "https://play.google.com/store/apps/details?id=$normalized",
      )
    }
  }
}
