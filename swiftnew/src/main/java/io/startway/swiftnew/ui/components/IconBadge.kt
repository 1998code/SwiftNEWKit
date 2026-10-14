package io.startway.swiftnew.ui.components

import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.scaleIn
import androidx.compose.animation.scaleOut
import androidx.compose.animation.togetherWith
import androidx.compose.foundation.background
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Icon
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.drawWithCache
import androidx.compose.ui.graphics.BlendMode
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.CompositingStrategy
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import io.startway.swiftnew.model.SwiftNewIconStyle
import io.startway.swiftnew.ui.icons.SfSymbolMapper
import kotlinx.coroutines.delay

@Composable
fun IconBadge(
  systemNames: List<String>,
  accent: Color,
  iconStyle: SwiftNewIconStyle = SwiftNewIconStyle.Default,
  size: Dp = 64.dp,
  cornerRadius: Dp = 20.dp,
  modifier: Modifier = Modifier,
) {
  val normalized = remember(systemNames) {
    systemNames.filter { it.isNotBlank() }.distinct().ifEmpty { listOf("questionmark") }
  }
  var displayedIndex by remember(normalized) { mutableIntStateOf(0) }

  LaunchedEffect(normalized) {
    if (normalized.size <= 1) {
      displayedIndex = 0
      return@LaunchedEffect
    }
    displayedIndex = 0
    delay(350)
    var nextIndex = 1
    while (true) {
      displayedIndex = nextIndex
      nextIndex = (nextIndex + 1) % normalized.size
      delay(1_400)
    }
  }

  val shape = RoundedCornerShape(cornerRadius)
  val currentName = normalized[displayedIndex.coerceIn(0, normalized.lastIndex)]
  val dark = isSystemInDarkTheme()
  // iOS dark uses accent→white; on Material icons the accent end reads too dark, so
  // lift the accent toward white while keeping the same gradient direction.
  val darkGlyphAccent =
    Color(
      red = accent.red * 0.35f + 0.65f,
      green = accent.green * 0.35f + 0.65f,
      blue = accent.blue * 0.35f + 0.65f,
      alpha = 1f,
    )
  val glyphBrush =
    when (iconStyle) {
      SwiftNewIconStyle.Filled -> null
      else ->
        Brush.linearGradient(
          colors =
            if (dark) {
              listOf(darkGlyphAccent, Color.White)
            } else {
              listOf(accent, accent.copy(alpha = 0.6f))
            }
        )
    }
  val glyphTint =
    when (iconStyle) {
      SwiftNewIconStyle.Filled -> Color.White
      else -> Color.White // masked by glyphBrush via SrcIn
    }
  // Stronger than iOS's 0.14→0.035 plate so the badge stays readable on mesh.
  val defaultBackdrop =
    Brush.linearGradient(
      colors =
        if (dark) {
          listOf(Color.White.copy(alpha = 0.28f), Color.White.copy(alpha = 0.10f))
        } else {
          listOf(Color.White.copy(alpha = 0.92f), Color.Transparent)
        }
    )

  Box(
    modifier =
      when (iconStyle) {
        SwiftNewIconStyle.Filled ->
          modifier
            .size(size)
            .glassSurface(shape = shape, accent = accent, elevation = 8.dp)
            .background(Brush.linearGradient(listOf(accent, accent.copy(alpha = 0.6f))))
        SwiftNewIconStyle.Default ->
          modifier
            .size(size)
            .glassSurface(shape = shape, accent = accent, elevation = 8.dp)
            .background(defaultBackdrop)
        SwiftNewIconStyle.Plain -> modifier.size(size)
      },
    contentAlignment = Alignment.Center,
  ) {
    AnimatedContent(
      targetState = currentName,
      transitionSpec = {
        (fadeIn(tween(220)) + scaleIn(initialScale = 0.82f, animationSpec = tween(260)))
          .togetherWith(
            fadeOut(tween(160)) + scaleOut(targetScale = 0.88f, animationSpec = tween(200))
          )
      },
      label = "iconBadgeSymbol",
    ) { name ->
      val iconModifier =
        Modifier
          .size(size * 0.42f)
          .then(
            if (glyphBrush != null) {
              Modifier
                .graphicsLayer { compositingStrategy = CompositingStrategy.Offscreen }
                .drawWithCache {
                  onDrawWithContent {
                    drawContent()
                    drawRect(brush = glyphBrush, blendMode = BlendMode.SrcIn)
                  }
                }
            } else {
              Modifier
            }
          )
      Icon(
        imageVector = SfSymbolMapper.map(name),
        contentDescription = null,
        tint = glyphTint,
        modifier = iconModifier,
      )
    }
  }
}
