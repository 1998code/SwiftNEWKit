package io.startway.swiftnew.util

import io.startway.swiftnew.model.FeatureItem

/** Matches iOS `SwiftNEWSearch.matches`. */
object SwiftNewSearch {
  fun matches(item: FeatureItem, query: String, isEnabled: Boolean): Boolean {
    val normalizedQuery = query.trim()
    if (!isEnabled || normalizedQuery.isEmpty()) return true
    return listOf(item.title, item.subtitle, item.body).any {
      it.contains(normalizedQuery, ignoreCase = true)
    }
  }
}
