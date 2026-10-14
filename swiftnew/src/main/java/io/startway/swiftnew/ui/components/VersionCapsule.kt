package io.startway.swiftnew.ui.components

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp

/**
 * iOS history version chip: 96×32, cornerRadius 12, accent gradient + adapted text.
 */
@Composable
fun VersionCapsule(
  version: String,
  accent: Color,
  modifier: Modifier = Modifier,
) {
  val shape = RoundedCornerShape(12.dp)
  val textColor = adaptedTextColor(accent)
  val rim =
    Brush.linearGradient(
      listOf(
        Color.White.copy(alpha = 0.55f),
        accent.copy(alpha = 0.35f),
        accent.copy(alpha = 0.15f),
      )
    )
  Box(
    modifier =
      modifier
        .padding(bottom = 10.dp)
        .shadow(
          elevation = 6.dp,
          shape = shape,
          clip = false,
          ambientColor = Color.Black.copy(alpha = 0.10f),
          spotColor = accent.copy(alpha = 0.18f),
        )
        .size(width = 96.dp, height = 32.dp)
        .clip(shape)
        .background(Brush.linearGradient(listOf(accent, accent.copy(alpha = 0.6f))))
        .border(width = 1.dp, brush = rim, shape = shape),
    contentAlignment = Alignment.Center,
  ) {
    Text(
      text = version,
      style = MaterialTheme.typography.titleSmall.copy(fontWeight = FontWeight.Bold),
      color = textColor,
      maxLines = 1,
    )
  }
}

/** Matches iOS `Color.adaptedTextColor` (luminance threshold 0.5). */
fun adaptedTextColor(background: Color): Color {
  val luminance =
    0.299f * background.red + 0.587f * background.green + 0.114f * background.blue
  return if (luminance > 0.5f) Color.Black else Color.White
}
