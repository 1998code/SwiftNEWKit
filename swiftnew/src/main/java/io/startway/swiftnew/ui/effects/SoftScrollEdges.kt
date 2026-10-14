package io.startway.swiftnew.ui.effects

import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.drawWithContent
import androidx.compose.ui.graphics.BlendMode
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.CompositingStrategy
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import kotlin.math.max
import kotlin.math.min

/**
 * Soft top/bottom fade matching iOS `softScrollEdges` (~18pt).
 *
 * Apply on the **viewport** (e.g. a `Box` with a fixed height), not on a
 * `fillMaxSize` scroll `Column` — that oversized offscreen layer read as a slab.
 */
fun Modifier.softScrollEdges(
  top: Dp = 18.dp,
  bottom: Dp = 18.dp,
): Modifier =
  this
    .graphicsLayer { compositingStrategy = CompositingStrategy.Offscreen }
    .drawWithContent {
      drawContent()
      val height = size.height
      if (height <= 0f) return@drawWithContent
      val topPx = top.toPx()
      val bottomPx = bottom.toPx()
      val scale = min(1f, height / max(topPx + bottomPx, 1f))
      val topFraction = (topPx * scale) / height
      val bottomFraction = (bottomPx * scale) / height
      drawRect(
        brush =
          Brush.verticalGradient(
            colorStops =
              arrayOf(
                0f to Color.Transparent,
                topFraction to Color.Black,
                (1f - bottomFraction) to Color.Black,
                1f to Color.Transparent,
              )
          ),
        blendMode = BlendMode.DstIn,
      )
    }
