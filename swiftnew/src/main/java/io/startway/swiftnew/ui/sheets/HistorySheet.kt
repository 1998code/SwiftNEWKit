package io.startway.swiftnew.ui.sheets

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.expandVertically
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.shrinkVertically
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import io.startway.swiftnew.model.ContentAlignment
import io.startway.swiftnew.model.FeatureItem
import io.startway.swiftnew.model.SwiftNewIconStyle
import io.startway.swiftnew.model.VersionRelease
import io.startway.swiftnew.ui.components.PrimaryActionButton
import io.startway.swiftnew.ui.components.ReleaseRow
import io.startway.swiftnew.ui.components.SearchField
import io.startway.swiftnew.ui.components.SearchToggleButton
import io.startway.swiftnew.ui.components.VersionCapsule
import io.startway.swiftnew.ui.effects.softScrollEdges
import io.startway.swiftnew.ui.icons.SfSymbolMapper

@Composable
fun HistorySheet(
  releases: List<VersionRelease>,
  accent: Color,
  alignment: ContentAlignment,
  showDescription: Boolean,
  iconStyle: SwiftNewIconStyle,
  searchEnabled: Boolean,
  showSearch: Boolean,
  searchText: String,
  filterQuery: String = searchText,
  onSearchTextChange: (String) -> Unit,
  onToggleSearch: () -> Unit,
  onReturn: () -> Unit,
  modifier: Modifier = Modifier,
) {
  Column(
    modifier = modifier.fillMaxSize().padding(horizontal = 20.dp, vertical = 16.dp),
    horizontalAlignment = Alignment.CenterHorizontally,
  ) {
    Spacer(modifier = Modifier.height(12.dp))
    Text(
      text = "History",
      style = MaterialTheme.typography.headlineLarge.copy(fontWeight = FontWeight.Bold),
      modifier = Modifier.padding(bottom = 16.dp),
    )

    AnimatedVisibility(
      visible = searchEnabled && showSearch,
      enter = fadeIn() + expandVertically(expandFrom = Alignment.Top),
      exit = fadeOut() + shrinkVertically(shrinkTowards = Alignment.Top),
    ) {
      SearchField(
        value = searchText,
        onValueChange = onSearchTextChange,
        accent = accent,
        modifier = Modifier.padding(bottom = 8.dp),
      )
    }

    val sectionAlignment =
      when (alignment) {
        ContentAlignment.Start -> Alignment.Start
        ContentAlignment.Center -> Alignment.CenterHorizontally
        ContentAlignment.End -> Alignment.End
      }
    Box(
      modifier =
        Modifier.weight(1f)
          .fillMaxWidth()
          .softScrollEdges(top = 18.dp, bottom = 18.dp),
    ) {
      Column(
        modifier =
          Modifier
            .widthIn(max = 380.dp)
            .fillMaxWidth()
            .align(Alignment.TopCenter)
            .verticalScroll(rememberScrollState())
            .padding(bottom = 16.dp),
        horizontalAlignment = sectionAlignment,
        verticalArrangement = Arrangement.spacedBy(0.dp),
      ) {
        Spacer(modifier = Modifier.height(10.dp))
        releases.forEach { release ->
          val visibleItems =
            visibleHistoryItems(release.new, filterQuery, searchEnabled && showSearch)
          if (visibleItems.isNotEmpty()) {
            VersionCapsule(version = release.version, accent = accent)
            visibleItems.forEach { item ->
              ReleaseRow(
                item = item,
                accent = accent,
                alignment = alignment,
                showDescription = showDescription,
                iconStyle = iconStyle,
                bodyFontSize = 12.sp,
              )
            }
          }
        }
      }
    }

    if (searchEnabled) {
      SearchToggleButton(
        isSearching = showSearch,
        onClick = onToggleSearch,
        accent = accent,
        modifier = Modifier.padding(bottom = 12.dp),
      )
    }
    PrimaryActionButton(
      title = "Return",
      onClick = onReturn,
      accent = accent,
      icon = SfSymbolMapper.map("arrow.down.circle.fill"),
    )
  }
}

private fun visibleHistoryItems(
  items: List<FeatureItem>,
  searchText: String,
  searchEnabled: Boolean,
): List<FeatureItem> =
  items.filter { item ->
    io.startway.swiftnew.util.SwiftNewSearch.matches(item, searchText, searchEnabled)
  }
