package io.startway.swiftnew.ui.effects

import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.drawWithContent
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.BlendMode
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.CompositingStrategy
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp

/** Soft top/bottom fade matching iOS `softScrollEdges` (~18pt). */
fun Modifier.softScrollEdges(
  top: Dp = 18.dp,
  bottom: Dp = 18.dp,
): Modifier =
  this
    .graphicsLayer { compositingStrategy = CompositingStrategy.Offscreen }
    .drawWithContent {
      drawContent()
      val topPx = top.toPx()
      val bottomPx = bottom.toPx()
      if (topPx > 0f) {
        drawRect(
          brush =
            Brush.verticalGradient(
              colors = listOf(Color.Transparent, Color.Black),
              startY = 0f,
              endY = topPx,
            ),
          size = size.copy(height = topPx),
          blendMode = BlendMode.DstIn,
        )
      }
      if (bottomPx > 0f) {
        val topY = size.height - bottomPx
        drawRect(
          brush =
            Brush.verticalGradient(
              colors = listOf(Color.Black, Color.Transparent),
              startY = topY,
              endY = size.height,
            ),
          topLeft = Offset(0f, topY),
          size = size.copy(height = bottomPx),
          blendMode = BlendMode.DstIn,
        )
      }
    }
