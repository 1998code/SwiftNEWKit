package io.startway.swiftnew.ui.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import io.startway.swiftnew.model.ContentAlignment
import io.startway.swiftnew.model.SwiftNewHeadingStyle

@Composable
fun HeaderView(
  headingPrefix: String,
  headingStyle: SwiftNewHeadingStyle,
  versionName: String,
  versionCode: String?,
  appName: String,
  showBuild: Boolean,
  alignment: ContentAlignment,
  modifier: Modifier = Modifier,
) {
  val subtitle =
    when (headingStyle) {
      SwiftNewHeadingStyle.Version ->
        if (showBuild && !versionCode.isNullOrBlank()) {
          "Version $versionName ($versionCode)"
        } else {
          "Version $versionName"
        }
      SwiftNewHeadingStyle.VersionOnly ->
        if (showBuild && !versionCode.isNullOrBlank()) {
          "$versionName ($versionCode)"
        } else {
          versionName
        }
      SwiftNewHeadingStyle.AppName -> appName
    }

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
    modifier = modifier.fillMaxWidth().padding(bottom = 16.dp),
    horizontalAlignment = columnAlignment,
    verticalArrangement = Arrangement.spacedBy(4.dp),
  ) {
    Text(
      text = headingPrefix,
      style = MaterialTheme.typography.headlineLarge.copy(fontWeight = FontWeight.Bold),
      color = MaterialTheme.colorScheme.onSurface,
      textAlign = textAlign,
    )
    Text(
      text = subtitle,
      style = MaterialTheme.typography.headlineSmall.copy(fontWeight = FontWeight.Bold),
      color = MaterialTheme.colorScheme.onSurfaceVariant,
      textAlign = textAlign,
    )
  }
}
