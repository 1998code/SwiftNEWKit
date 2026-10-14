package io.startway.swiftnew.data

import android.content.Context
import com.google.android.play.core.appupdate.AppUpdateManagerFactory
import com.google.android.play.core.install.model.UpdateAvailability
import io.startway.swiftnew.model.FeatureItem
import io.startway.swiftnew.model.VersionRelease
import io.startway.swiftnew.ui.sheets.UpdateCandidate
import io.startway.swiftnew.util.VersionComparator
import kotlin.coroutines.resume
import kotlinx.coroutines.suspendCancellableCoroutine

/**
 * Resolves an update candidate via Play In-App Updates, falling back to release-notes JSON.
 */
object PlayUpdateChecker {
  suspend fun resolve(
    context: Context,
    releases: List<VersionRelease>,
    currentVersion: String,
    playStorePackageName: String?,
  ): UpdateCandidate? {
    val packageName =
      playStorePackageName?.trim()?.takeIf { it.isNotEmpty() } ?: context.packageName
    val listing = PlayStoreListing.forPackage(packageName)
    val storeUrl = listing?.url

    val playAvailable = queryPlayUpdateAvailable(context)
    val newest =
      releases.maxWithOrNull { left, right ->
        VersionComparator.compare(left.version, right.version)
      }

    return when {
      playAvailable ->
        UpdateCandidate(
          version = newest?.version ?: currentVersion,
          features = newest?.new.orEmpty(),
          storeUrl = storeUrl,
        )
      newest != null && VersionComparator.isNewer(newest.version, currentVersion) ->
        UpdateCandidate(
          version = newest.version,
          features = newest.new,
          storeUrl = storeUrl,
        )
      else -> null
    }
  }

  private suspend fun queryPlayUpdateAvailable(context: Context): Boolean =
    suspendCancellableCoroutine { continuation ->
      val manager = AppUpdateManagerFactory.create(context.applicationContext)
      manager.appUpdateInfo
        .addOnSuccessListener { info ->
          val available =
            info.updateAvailability() == UpdateAvailability.UPDATE_AVAILABLE ||
              info.updateAvailability() ==
                UpdateAvailability.DEVELOPER_TRIGGERED_UPDATE_IN_PROGRESS
          if (continuation.isActive) continuation.resume(available)
        }
        .addOnFailureListener {
          if (continuation.isActive) continuation.resume(false)
        }
    }

  /** Kept for tests / callers that only have feature rows. */
  fun fromReleaseNotes(
    releases: List<VersionRelease>,
    currentVersion: String,
    storeUrl: String?,
  ): UpdateCandidate? {
    val newest =
      releases.maxWithOrNull { left, right ->
        VersionComparator.compare(left.version, right.version)
      } ?: return null
    if (!VersionComparator.isNewer(newest.version, currentVersion)) return null
    return UpdateCandidate(version = newest.version, features = newest.new, storeUrl = storeUrl)
  }

  fun emptyFeatures(): List<FeatureItem> = emptyList()
}
