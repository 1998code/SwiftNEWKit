package io.startway.swiftnew.ui.effects

import androidx.compose.animation.core.LinearEasing
import androidx.compose.animation.core.RepeatMode
import androidx.compose.animation.core.animateFloat
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.tween
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import io.startway.swiftnew.model.SwiftNewMeshStyle
import io.startway.swiftnew.model.SwiftNewSpecialEffect
import kotlin.math.cos
import kotlin.math.sin

@Composable
fun SwiftNewBackdrop(
  accent: Color,
  meshStyle: SwiftNewMeshStyle = SwiftNewMeshStyle.Still,
  specialEffect: SwiftNewSpecialEffect = SwiftNewSpecialEffect.None,
  modifier: Modifier = Modifier,
) {
  Box(modifier = modifier.fillMaxSize()) {
    MeshView(accent = accent, style = meshStyle, modifier = Modifier.fillMaxSize())
    when (specialEffect) {
      SwiftNewSpecialEffect.Particles -> FloatingParticlesView(modifier = Modifier.fillMaxSize())
      SwiftNewSpecialEffect.Christmas -> SnowfallView(modifier = Modifier.fillMaxSize())
      SwiftNewSpecialEffect.None -> Unit
    }
  }
}

@Composable
fun MeshView(
  accent: Color,
  style: SwiftNewMeshStyle,
  modifier: Modifier = Modifier,
) {
  val phase =
    if (style == SwiftNewMeshStyle.Liquid) {
      val transition = rememberInfiniteTransition(label = "meshLiquid")
      val animated by
        transition.animateFloat(
          initialValue = 0f,
          targetValue = (Math.PI * 2).toFloat(),
          animationSpec =
            infiniteRepeatable(
              animation = tween(durationMillis = 12_000, easing = LinearEasing),
              repeatMode = RepeatMode.Restart,
            ),
          label = "meshPhase",
        )
      animated
    } else {
      0f
    }

  val wash = MaterialTheme.colorScheme.surface

  Box(
    modifier =
      modifier
        .background(wash)
        .background(
          Brush.verticalGradient(
            colorStops =
              arrayOf(
                0.0f to accent.copy(alpha = 0.46f),
                0.32f to accent.copy(alpha = 0.22f),
                0.72f to accent.copy(alpha = 0.05f),
                1.0f to accent.copy(alpha = 0.03f),
              )
          )
        )
  ) {
    Canvas(modifier = Modifier.fillMaxSize()) {
      val width = size.width
      val height = size.height
      val midX = width * (0.5f + sin(phase) * 0.12f)
      val midY = height * (0.5f + cos(phase * 0.9f) * 0.10f)

      drawCircle(
        brush =
          Brush.radialGradient(
            colors = listOf(accent.copy(alpha = 0.24f), Color.Transparent),
            center = Offset(width * 0.8f, height * 0.12f),
            radius = width * 0.55f,
          ),
        radius = width * 0.55f,
        center = Offset(width * 0.8f, height * 0.12f),
      )
      drawCircle(
        brush =
          Brush.radialGradient(
            colors = listOf(accent.copy(alpha = 0.16f), Color.Transparent),
            center = Offset(midX, midY),
            radius = width * 0.45f,
          ),
        radius = width * 0.45f,
        center = Offset(midX, midY),
      )
      drawCircle(
        brush =
          Brush.radialGradient(
            colors = listOf(accent.copy(alpha = 0.12f), Color.Transparent),
            center = Offset(width * 0.2f, height * 0.88f),
            radius = width * 0.65f,
          ),
        radius = width * 0.65f,
        center = Offset(width * 0.2f, height * 0.88f),
      )
    }

    Box(
      modifier =
        Modifier.fillMaxSize()
          .background(
            Brush.verticalGradient(
              colorStops =
                arrayOf(
                  0.0f to wash.copy(alpha = 0.22f),
                  0.45f to wash.copy(alpha = 0.12f),
                  0.78f to wash.copy(alpha = 0.06f),
                  1.0f to wash.copy(alpha = 0.02f),
                )
            )
          )
    )
  }
}
