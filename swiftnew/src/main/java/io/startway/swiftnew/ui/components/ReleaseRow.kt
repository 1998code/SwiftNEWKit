package io.startway.swiftnew.ui.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.TextUnit
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import io.startway.swiftnew.model.ContentAlignment
import io.startway.swiftnew.model.FeatureItem
import io.startway.swiftnew.model.SwiftNewIconStyle

@Composable
fun ReleaseRow(
  item: FeatureItem,
  accent: Color,
  alignment: ContentAlignment = ContentAlignment.Start,
  showDescription: Boolean = true,
  iconStyle: SwiftNewIconStyle = SwiftNewIconStyle.Default,
  bodyFontSize: TextUnit = TextUnit.Unspecified,
  modifier: Modifier = Modifier,
) {
  val horizontal =
    when (alignment) {
      ContentAlignment.Start -> Arrangement.Start
      ContentAlignment.Center -> Arrangement.Start
      ContentAlignment.End -> Arrangement.End
    }
  val textAlign =
    when (alignment) {
      ContentAlignment.Start -> TextAlign.Start
      ContentAlignment.Center -> TextAlign.Start
      ContentAlignment.End -> TextAlign.End
    }
  val columnAlignment =
    when (alignment) {
      ContentAlignment.Start, ContentAlignment.Center -> Alignment.Start
      ContentAlignment.End -> Alignment.End
    }

  Row(
    modifier = modifier.fillMaxWidth().padding(start = 16.dp, bottom = 16.dp),
    verticalAlignment = Alignment.CenterVertically,
    horizontalArrangement = horizontal,
  ) {
    if (alignment != ContentAlignment.End) {
      IconBadge(
        systemNames = item.iconSequence,
        accent = accent,
        iconStyle = iconStyle,
        size = 64.dp,
      )
    }

    Column(
      modifier = Modifier.weight(1f).padding(horizontal = 12.dp),
      horizontalAlignment = columnAlignment,
      verticalArrangement = Arrangement.spacedBy(3.dp),
    ) {
      Text(
        text = item.title,
        style = MaterialTheme.typography.titleMedium.copy(fontWeight = FontWeight.SemiBold),
        color = MaterialTheme.colorScheme.onSurface,
        textAlign = textAlign,
        maxLines = 1,
      )
      Text(
        text = item.subtitle,
        style = MaterialTheme.typography.titleSmall.copy(fontWeight = FontWeight.Medium),
        color = MaterialTheme.colorScheme.onSurfaceVariant,
        textAlign = textAlign,
        maxLines = 1,
      )
      if (showDescription) {
        Text(
          text = item.body,
          style =
            if (bodyFontSize != TextUnit.Unspecified) {
              MaterialTheme.typography.bodySmall.copy(fontSize = bodyFontSize, lineHeight = 16.sp)
            } else {
              MaterialTheme.typography.bodySmall
            },
          color = MaterialTheme.colorScheme.onSurfaceVariant,
          textAlign = textAlign,
        )
      }
    }

    if (alignment == ContentAlignment.End) {
      IconBadge(
        systemNames = item.iconSequence,
        accent = accent,
        iconStyle = iconStyle,
        size = 64.dp,
      )
    }
  }
}
