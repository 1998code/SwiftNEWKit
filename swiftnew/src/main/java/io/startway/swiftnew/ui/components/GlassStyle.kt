package io.startway.swiftnew.ui.components

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.RowScope
import androidx.compose.foundation.layout.defaultMinSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ripple
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Shape
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp

/**
 * Ultra-thin / web-glass chrome: translucent wash, specular rim, soft tinted depth.
 * Content is drawn above the glass layer so labels stay sharp.
 */
@Composable
fun Modifier.glassSurface(
  shape: Shape,
  accent: Color = MaterialTheme.colorScheme.primary,
  elevation: Dp = 12.dp,
): Modifier {
  val dark = isSystemInDarkTheme()
  val fill =
    Brush.verticalGradient(
      colors =
        listOf(
          if (dark) Color.White.copy(alpha = 0.22f) else Color.White.copy(alpha = 0.72f),
          if (dark) Color.White.copy(alpha = 0.10f) else Color.White.copy(alpha = 0.38f),
        )
    )
  val rim =
    Brush.linearGradient(
      colors =
        listOf(
          Color.White.copy(alpha = if (dark) 0.55f else 0.92f),
          Color.White.copy(alpha = if (dark) 0.20f else 0.55f),
          accent.copy(alpha = if (dark) 0.24f else 0.18f),
        )
    )

  return this
    .shadow(
      elevation = elevation,
      shape = shape,
      clip = false,
      ambientColor = Color.Black.copy(alpha = 0.10f),
      spotColor = accent.copy(alpha = 0.14f),
    )
    .clip(shape)
    .background(fill)
    .background(accent.copy(alpha = if (dark) 0.10f else 0.05f))
    .border(width = 1.1.dp, brush = rim, shape = shape)
}

@Composable
fun glassContentColor(accent: Color): Color {
  val dark = isSystemInDarkTheme()
  val luminance = 0.2126f * accent.red + 0.7152f * accent.green + 0.0722f * accent.blue
  return when {
    dark && luminance < 0.35f -> Color.White
    !dark && luminance > 0.75f -> MaterialTheme.colorScheme.onSurface
    else -> accent
  }
}

@Composable
fun GlassButton(
  onClick: () -> Unit,
  modifier: Modifier = Modifier,
  accent: Color = MaterialTheme.colorScheme.primary,
  enabled: Boolean = true,
  shape: Shape = RoundedCornerShape(25.dp),
  contentPadding: PaddingValues = PaddingValues(horizontal = 20.dp, vertical = 12.dp),
  minHeight: Dp = 50.dp,
  elevation: Dp = 12.dp,
  content: @Composable RowScope.() -> Unit,
) {
  val interactionSource = remember { MutableInteractionSource() }
  Box(
    modifier =
      modifier
        .pressScale(interactionSource)
        .defaultMinSize(minHeight = minHeight)
        .glassSurface(shape = shape, accent = accent, elevation = elevation)
        .clickable(
          interactionSource = interactionSource,
          indication = ripple(color = accent.copy(alpha = 0.25f)),
          enabled = enabled,
          role = Role.Button,
          onClick = onClick,
        )
        .padding(contentPadding),
    contentAlignment = Alignment.Center,
  ) {
    Row(
      horizontalArrangement = Arrangement.spacedBy(8.dp),
      verticalAlignment = Alignment.CenterVertically,
      content = content,
    )
  }
}

@Composable
fun GlassCapsuleButton(
  onClick: () -> Unit,
  modifier: Modifier = Modifier,
  accent: Color = MaterialTheme.colorScheme.primary,
  content: @Composable RowScope.() -> Unit,
) {
  GlassButton(
    onClick = onClick,
    modifier = modifier,
    accent = accent,
    shape = RoundedCornerShape(50),
    contentPadding = PaddingValues(horizontal = 14.dp, vertical = 8.dp),
    content = content,
  )
}
