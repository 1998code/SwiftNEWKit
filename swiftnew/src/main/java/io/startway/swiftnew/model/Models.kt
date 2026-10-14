package io.startway.swiftnew.model

import kotlinx.serialization.Serializable
import kotlinx.serialization.Transient

@Serializable
data class VersionRelease(
  val version: String,
  val subVersion: String? = null,
  val new: List<FeatureItem> = emptyList(),
) {
  @Transient
  val id: String = listOfNotNull(version, subVersion).joinToString("|")
}

@Serializable
data class FeatureItem(
  val icon: String? = null,
  val toIcon: String? = null,
  val icons: List<String>? = null,
  val title: String,
  val subtitle: String,
  val body: String,
) {
  val iconSequence: List<String>
    get() {
      val sequenced = icons?.filter { it.isNotBlank() }
      if (!sequenced.isNullOrEmpty()) {
        return sequenced
      }
      val start = icon?.takeIf { it.isNotBlank() }
      val end = toIcon?.takeIf { it.isNotBlank() }
      return when {
        start != null && end != null -> listOf(start, end)
        start != null -> listOf(start)
        else -> listOf("questionmark")
      }
    }

  val displayedIcon: String
    get() = iconSequence.first()

  @Transient
  val id: String =
    listOf(iconSequence.joinToString(">"), title, subtitle, body).joinToString("|")
}

enum class SwiftNewPresentation {
  Sheet,
  FullScreen,
  Embed,
}

enum class SwiftNewHeadingStyle {
  Version,
  VersionOnly,
  AppName,
}

enum class SwiftNewIconStyle {
  Filled,
  Default,
  Plain,
}

enum class SwiftNewMeshStyle {
  Still,
  Liquid,
}

enum class SwiftNewSpecialEffect {
  None,
  Christmas,
  Particles,
}

enum class ContentAlignment {
  Start,
  Center,
  End,
}

sealed class SwiftNewPurchaseRequirement {
  data object AppPurchase : SwiftNewPurchaseRequirement()

  data class Subscription(val productIds: List<String> = emptyList()) : SwiftNewPurchaseRequirement()

  data class AppPurchaseAndSubscription(val productIds: List<String> = emptyList()) :
    SwiftNewPurchaseRequirement()
}

enum class SwiftNewPurchaseEnvironment {
  /** Play internal / testing tracks only (iOS equivalent: TestFlight). */
  InternalTesting,
  All,
}
