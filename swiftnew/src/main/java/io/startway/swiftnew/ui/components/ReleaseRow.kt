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
import androidx.compose.ui.text.PlatformTextStyle
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.LineHeightStyle
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.TextUnit
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import io.startway.swiftnew.model.ContentAlignment
import io.startway.swiftnew.model.FeatureItem
import io.startway.swiftnew.model.SwiftNewIconStyle

/** Matches iOS `.headline.weight(.semibold)`. */
private val ReleaseTitleStyle =
  TextStyle(
    fontSize = 17.sp,
    lineHeight = 20.sp,
    fontWeight = FontWeight.SemiBold,
    platformStyle = PlatformTextStyle(includeFontPadding = false),
    lineHeightStyle =
      LineHeightStyle(
        alignment = LineHeightStyle.Alignment.Center,
        trim = LineHeightStyle.Trim.Both,
      ),
  )

/** Matches iOS `.subheadline.weight(.medium)`. */
private val ReleaseSubtitleStyle =
  TextStyle(
    fontSize = 15.sp,
    lineHeight = 18.sp,
    fontWeight = FontWeight.Medium,
    platformStyle = PlatformTextStyle(includeFontPadding = false),
    lineHeightStyle =
      LineHeightStyle(
        alignment = LineHeightStyle.Alignment.Center,
        trim = LineHeightStyle.Trim.Both,
      ),
  )

/** Matches iOS `.body` (current sheet). */
private val ReleaseBodyStyle =
  TextStyle(
    fontSize = 15.sp,
    lineHeight = 20.sp,
    fontWeight = FontWeight.Normal,
    platformStyle = PlatformTextStyle(includeFontPadding = false),
    lineHeightStyle =
      LineHeightStyle(
        alignment = LineHeightStyle.Alignment.Center,
        trim = LineHeightStyle.Trim.Both,
      ),
  )

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

    // iOS VStack spacing is 3pt between title / subtitle / body.
    Column(
      modifier = Modifier.weight(1f).padding(horizontal = 12.dp),
      horizontalAlignment = columnAlignment,
      verticalArrangement = Arrangement.spacedBy(3.dp),
    ) {
      Text(
        text = item.title,
        style = ReleaseTitleStyle,
        color = MaterialTheme.colorScheme.onSurface,
        textAlign = textAlign,
        maxLines = 1,
      )
      Text(
        text = item.subtitle,
        style = ReleaseSubtitleStyle,
        color = MaterialTheme.colorScheme.onSurfaceVariant,
        textAlign = textAlign,
        maxLines = 1,
        overflow = TextOverflow.Ellipsis,
      )
      if (showDescription && item.body.isNotBlank()) {
        Text(
          text = item.body,
          style =
            if (bodyFontSize != TextUnit.Unspecified) {
              ReleaseBodyStyle.copy(fontSize = bodyFontSize, lineHeight = (bodyFontSize.value + 4f).sp)
            } else {
              ReleaseBodyStyle
            },
          color = MaterialTheme.colorScheme.onSurfaceVariant,
          textAlign = textAlign,
          maxLines = 2,
          overflow = TextOverflow.Ellipsis,
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
