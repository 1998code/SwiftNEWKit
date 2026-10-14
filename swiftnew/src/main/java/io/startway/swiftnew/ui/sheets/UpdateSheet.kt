package io.startway.swiftnew.ui.sheets

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowForward
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import io.startway.swiftnew.model.ContentAlignment
import io.startway.swiftnew.model.FeatureItem
import io.startway.swiftnew.model.SwiftNewIconStyle
import io.startway.swiftnew.ui.components.IconBadge
import io.startway.swiftnew.ui.components.NotNowButton
import io.startway.swiftnew.ui.components.UpdateNowButton

data class UpdateCandidate(
  val version: String,
  val features: List<FeatureItem>,
  val storeUrl: String? = null,
)

@Composable
fun UpdateCheckingSheet(
  accent: Color,
  allowsSkipping: Boolean,
  onSkip: () -> Unit,
  modifier: Modifier = Modifier,
) {
  Column(
    modifier = modifier.fillMaxSize().padding(24.dp),
    verticalArrangement = Arrangement.Center,
    horizontalAlignment = Alignment.CenterHorizontally,
  ) {
    IconBadge(
      systemNames = listOf("arrow.triangle.2.circlepath"),
      accent = accent,
      size = 56.dp,
    )
    Spacer(modifier = Modifier.height(18.dp))
    Text(
      text = "Checking for Updates...",
      style = MaterialTheme.typography.titleLarge.copy(fontWeight = FontWeight.SemiBold),
      textAlign = TextAlign.Center,
    )
    Spacer(modifier = Modifier.height(16.dp))
    CircularProgressIndicator(color = accent)
    if (allowsSkipping) {
      Spacer(modifier = Modifier.height(16.dp))
      NotNowButton(onClick = onSkip)
    }
  }
}

@Composable
fun UpdateAvailableSheet(
  candidate: UpdateCandidate,
  currentVersion: String,
  accent: Color,
  alignment: ContentAlignment,
  showDescription: Boolean,
  iconStyle: SwiftNewIconStyle,
  updateButtonTitle: String,
  allowsSkipping: Boolean,
  onUpdate: () -> Unit,
  onSkip: () -> Unit,
  modifier: Modifier = Modifier,
) {
  Column(modifier = modifier.fillMaxSize()) {
    Column(
      modifier =
        Modifier.weight(1f)
          .fillMaxWidth()
          .verticalScroll(rememberScrollState())
          .padding(horizontal = 24.dp, vertical = 28.dp),
      horizontalAlignment = Alignment.CenterHorizontally,
      verticalArrangement = Arrangement.spacedBy(24.dp),
    ) {
      Column(horizontalAlignment = Alignment.CenterHorizontally) {
        IconBadge(
          systemNames = listOf("arrow.down.app.fill"),
          accent = accent,
          iconStyle = iconStyle,
          size = 56.dp,
        )
        Spacer(modifier = Modifier.height(10.dp))
        Text(
          text = "Update Available",
          style = MaterialTheme.typography.headlineMedium.copy(fontWeight = FontWeight.Bold),
        )
      }

      VersionSummary(currentVersion = currentVersion, latestVersion = candidate.version, accent = accent)

      candidate.features.forEach { feature ->
        UpdateFeatureCard(
          feature = feature,
          accent = accent,
          alignment = alignment,
          showDescription = showDescription,
          iconStyle = iconStyle,
        )
      }
    }

    Column(
      modifier = Modifier.fillMaxWidth().padding(horizontal = 24.dp, vertical = 14.dp),
      horizontalAlignment = Alignment.CenterHorizontally,
      verticalArrangement = Arrangement.spacedBy(10.dp),
    ) {
      UpdateNowButton(title = updateButtonTitle, onClick = onUpdate, accent = accent)
      if (allowsSkipping) {
        NotNowButton(onClick = onSkip)
      }
    }
  }
}

@Composable
private fun VersionSummary(
  currentVersion: String,
  latestVersion: String,
  accent: Color,
) {
  Row(
    modifier =
      Modifier.fillMaxWidth()
        .clip(RoundedCornerShape(16.dp))
        .background(MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.55f))
        .padding(12.dp),
    verticalAlignment = Alignment.CenterVertically,
    horizontalArrangement = Arrangement.spacedBy(10.dp),
  ) {
    VersionTile(
      title = "Current Version",
      version = currentVersion,
      highlighted = false,
      accent = accent,
      modifier = Modifier.weight(1f),
    )
    Icon(
      imageVector = Icons.AutoMirrored.Filled.ArrowForward,
      contentDescription = null,
      tint = accent,
    )
    VersionTile(
      title = "Latest Version",
      version = latestVersion,
      highlighted = true,
      accent = accent,
      modifier = Modifier.weight(1f),
    )
  }
}

@Composable
private fun VersionTile(
  title: String,
  version: String,
  highlighted: Boolean,
  accent: Color,
  modifier: Modifier = Modifier,
) {
  Column(
    modifier =
      modifier
        .clip(RoundedCornerShape(12.dp))
        .then(
          if (highlighted) {
            Modifier.background(accent.copy(alpha = 0.1f))
          } else {
            Modifier
          }
        )
        .padding(horizontal = 10.dp, vertical = 10.dp),
    horizontalAlignment = Alignment.CenterHorizontally,
    verticalArrangement = Arrangement.spacedBy(5.dp),
  ) {
    Text(
      text = title,
      style = MaterialTheme.typography.labelMedium,
      color = MaterialTheme.colorScheme.onSurfaceVariant,
      textAlign = TextAlign.Center,
    )
    Text(
      text = version,
      style = MaterialTheme.typography.titleMedium.copy(fontWeight = FontWeight.Bold),
      color = if (highlighted) accent else MaterialTheme.colorScheme.onSurface,
      maxLines = 1,
    )
  }
}

@Composable
private fun UpdateFeatureCard(
  feature: FeatureItem,
  accent: Color,
  alignment: ContentAlignment,
  showDescription: Boolean,
  iconStyle: SwiftNewIconStyle,
) {
  val textAlign =
    when (alignment) {
      ContentAlignment.Start, ContentAlignment.Center -> TextAlign.Start
      ContentAlignment.End -> TextAlign.End
    }
  val columnAlignment =
    when (alignment) {
      ContentAlignment.Start, ContentAlignment.Center -> Alignment.Start
      ContentAlignment.End -> Alignment.End
    }

  Row(
    modifier =
      Modifier.fillMaxWidth()
        .clip(RoundedCornerShape(18.dp))
        .background(MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.4f))
        .padding(16.dp),
    horizontalArrangement = Arrangement.spacedBy(14.dp),
  ) {
    if (alignment != ContentAlignment.End) {
      IconBadge(
        systemNames = feature.iconSequence,
        accent = accent,
        iconStyle = iconStyle,
        size = 48.dp,
        cornerRadius = 14.dp,
      )
    }
    Column(
      modifier = Modifier.weight(1f),
      horizontalAlignment = columnAlignment,
      verticalArrangement = Arrangement.spacedBy(4.dp),
    ) {
      Text(
        text = feature.title,
        style = MaterialTheme.typography.titleMedium.copy(fontWeight = FontWeight.SemiBold),
        textAlign = textAlign,
      )
      Text(
        text = feature.subtitle,
        style = MaterialTheme.typography.titleSmall.copy(fontWeight = FontWeight.Medium),
        color = MaterialTheme.colorScheme.onSurfaceVariant,
        textAlign = textAlign,
      )
      if (showDescription) {
        Text(
          text = feature.body,
          style = MaterialTheme.typography.bodyMedium,
          color = MaterialTheme.colorScheme.onSurfaceVariant,
          textAlign = textAlign,
        )
      }
    }
    if (alignment == ContentAlignment.End) {
      IconBadge(
        systemNames = feature.iconSequence,
        accent = accent,
        iconStyle = iconStyle,
        size = 48.dp,
        cornerRadius = 14.dp,
      )
    }
  }
}
