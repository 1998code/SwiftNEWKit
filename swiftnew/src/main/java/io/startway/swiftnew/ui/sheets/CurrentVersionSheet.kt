package io.startway.swiftnew.ui.sheets

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import io.startway.swiftnew.model.ContentAlignment
import io.startway.swiftnew.model.FeatureItem
import io.startway.swiftnew.model.SwiftNewHeadingStyle
import io.startway.swiftnew.model.SwiftNewIconStyle
import io.startway.swiftnew.model.VersionRelease
import io.startway.swiftnew.ui.components.HeaderView
import io.startway.swiftnew.ui.components.IconBadge
import io.startway.swiftnew.ui.components.PrimaryActionButton
import io.startway.swiftnew.ui.components.ReleaseRow
import io.startway.swiftnew.ui.components.SearchField
import io.startway.swiftnew.ui.components.SearchToggleButton
import io.startway.swiftnew.ui.components.ShowHistoryButton
import io.startway.swiftnew.ui.effects.softScrollEdges
import io.startway.swiftnew.ui.icons.SfSymbolMapper

@Composable
fun CurrentVersionSheet(
  releases: List<VersionRelease>,
  currentVersion: String,
  appName: String,
  versionCode: String?,
  accent: Color,
  alignment: ContentAlignment,
  headingStyle: SwiftNewHeadingStyle,
  headingPrefix: String,
  showBuild: Boolean,
  showDescription: Boolean,
  iconStyle: SwiftNewIconStyle,
  historyEnabled: Boolean,
  searchEnabled: Boolean,
  showSearch: Boolean,
  searchText: String,
  isLoading: Boolean,
  loadErrorMessage: String?,
  onSearchTextChange: (String) -> Unit,
  onToggleSearch: () -> Unit,
  onShowHistory: () -> Unit,
  onContinue: () -> Unit,
  onRetry: () -> Unit,
  /** Debounced query used for filtering (iOS `debouncedSearchText`). */
  filterQuery: String = searchText,
  modifier: Modifier = Modifier,
) {
  val filterActive = searchEnabled && showSearch
  val currentChanges =
    visibleCurrentVersionChanges(releases, currentVersion, filterQuery, filterActive)
  val canSearch = searchEnabled && currentVersionChanges(releases, currentVersion).isNotEmpty()
  val canShowHistory = historyEnabled && releases.any { it.new.isNotEmpty() }
  val showingNoResults =
    filterActive && filterQuery.isNotBlank() && currentChanges.isEmpty()

  Column(
    modifier = modifier.fillMaxSize().padding(horizontal = 20.dp, vertical = 16.dp),
    horizontalAlignment =
      when (alignment) {
        ContentAlignment.Start -> Alignment.Start
        ContentAlignment.Center -> Alignment.CenterHorizontally
        ContentAlignment.End -> Alignment.End
      },
  ) {
    Spacer(modifier = Modifier.height(12.dp))
    HeaderView(
      headingPrefix = headingPrefix,
      headingStyle = headingStyle,
      versionName = currentVersion,
      versionCode = versionCode,
      appName = appName,
      showBuild = showBuild,
      alignment = alignment,
    )

    when {
      loadErrorMessage != null -> {
        Column(
          modifier = Modifier.fillMaxWidth().weight(1f),
          verticalArrangement = Arrangement.Center,
          horizontalAlignment = Alignment.CenterHorizontally,
        ) {
          Text(
            text = loadErrorMessage,
            style = MaterialTheme.typography.titleMedium,
            textAlign = TextAlign.Center,
          )
          TextButton(onClick = onRetry) { Text("Try Again") }
        }
      }
      isLoading -> {
        Column(
          modifier = Modifier.fillMaxWidth().weight(1f),
          verticalArrangement = Arrangement.Center,
          horizontalAlignment = Alignment.CenterHorizontally,
        ) {
          Text("Loading...", modifier = Modifier.padding(bottom = 12.dp))
          CircularProgressIndicator(color = accent)
        }
      }
      else -> {
        if (canSearch && showSearch) {
          SearchField(
            value = searchText,
            onValueChange = onSearchTextChange,
            accent = accent,
            modifier = Modifier.padding(bottom = 8.dp),
          )
        }

        Box(modifier = Modifier.weight(1f).fillMaxWidth()) {
          if (currentChanges.isEmpty()) {
            EmptyState(
              showingNoResults = showingNoResults,
              accent = accent,
              alignment = alignment,
              iconStyle = iconStyle,
              modifier = Modifier.align(Alignment.Center),
            )
          } else {
            Column(
              modifier =
                Modifier
                  .fillMaxSize()
                  .widthIn(max = 380.dp)
                  .align(Alignment.TopCenter)
                  .softScrollEdges(bottom = 0.dp)
                  .verticalScroll(rememberScrollState())
                  .padding(top = 10.dp, bottom = 196.dp),
            ) {
              currentChanges.forEach { item ->
                ReleaseRow(
                  item = item,
                  accent = accent,
                  alignment = alignment,
                  showDescription = showDescription,
                  iconStyle = iconStyle,
                )
              }
            }
          }

          val surface = MaterialTheme.colorScheme.surface
          Column(
            modifier =
              Modifier
                .align(Alignment.BottomCenter)
                .fillMaxWidth()
                .background(
                  Brush.verticalGradient(
                    listOf(
                      Color.Transparent,
                      surface.copy(alpha = 0.55f),
                      surface.copy(alpha = 0.78f),
                    )
                  )
                )
                .padding(top = 24.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
          ) {
            if (canShowHistory || canSearch) {
              Row(
                horizontalArrangement = Arrangement.spacedBy(12.dp),
                modifier = Modifier.padding(bottom = 12.dp),
              ) {
                if (canShowHistory) {
                  ShowHistoryButton(onClick = onShowHistory, accent = accent)
                }
                if (canSearch) {
                  SearchToggleButton(
                    isSearching = showSearch,
                    onClick = onToggleSearch,
                    accent = accent,
                  )
                }
              }
            }
            PrimaryActionButton(
              title = "Continue",
              onClick = onContinue,
              accent = accent,
              icon = SfSymbolMapper.map("arrow.right.circle.fill"),
            )
          }
        }
      }
    }
  }
}

@Composable
private fun EmptyState(
  showingNoResults: Boolean,
  accent: Color,
  alignment: ContentAlignment,
  iconStyle: SwiftNewIconStyle,
  modifier: Modifier = Modifier,
) {
  val columnAlignment =
    when (alignment) {
      ContentAlignment.Start -> Alignment.Start
      ContentAlignment.Center -> Alignment.CenterHorizontally
      ContentAlignment.End -> Alignment.End
    }
  val textAlign =
    when (alignment) {
      ContentAlignment.Start -> TextAlign.Start
      ContentAlignment.Center -> TextAlign.Center
      ContentAlignment.End -> TextAlign.End
    }

  Column(
    modifier = modifier.padding(24.dp),
    horizontalAlignment = columnAlignment,
    verticalArrangement = Arrangement.spacedBy(18.dp),
  ) {
    IconBadge(
      systemNames = listOf(if (showingNoResults) "magnifyingglass" else "doc.text"),
      accent = accent,
      iconStyle = iconStyle,
    )
    Text(
      text = if (showingNoResults) "No Results" else "No Release Notes Yet",
      style = MaterialTheme.typography.titleLarge.copy(fontWeight = FontWeight.SemiBold),
      textAlign = textAlign,
    )
    Text(
      text =
        if (showingNoResults) {
          "Try another search term."
        } else {
          "Release notes for this version will appear here when available."
        },
      style = MaterialTheme.typography.bodyMedium,
      color = MaterialTheme.colorScheme.onSurfaceVariant,
      textAlign = textAlign,
    )
  }
}

internal fun currentVersionChanges(
  releases: List<VersionRelease>,
  currentVersion: String,
): List<FeatureItem> =
  releases.flatMap { release ->
    if (release.version == currentVersion || release.subVersion == currentVersion) {
      release.new
    } else {
      emptyList()
    }
  }

internal fun visibleCurrentVersionChanges(
  releases: List<VersionRelease>,
  currentVersion: String,
  searchText: String,
  searchEnabled: Boolean = true,
): List<FeatureItem> =
  currentVersionChanges(releases, currentVersion).filter { item ->
    io.startway.swiftnew.util.SwiftNewSearch.matches(item, searchText, searchEnabled)
  }
