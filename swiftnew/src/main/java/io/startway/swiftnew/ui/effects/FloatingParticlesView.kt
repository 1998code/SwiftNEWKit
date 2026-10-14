package io.startway.swiftnew.ui.effects

import androidx.compose.foundation.Canvas
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableFloatStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.runtime.withFrameNanos
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import kotlin.math.cos
import kotlin.math.sin

private val particleColors =
  listOf(
    Color.Red,
    Color(0xFFFF9800),
    Color.Yellow,
    Color(0xFF4CAF50),
    Color(0xFF00BCD4),
    Color(0xFF009688),
    Color.Cyan,
    Color.Blue,
    Color(0xFF3F51B5),
    Color(0xFF9C27B0),
    Color(0xFFE91E63),
  )

@Composable
fun FloatingParticlesView(modifier: Modifier = Modifier, particleCount: Int = 30) {
  val particles =
    remember(particleCount) {
      List(particleCount) { index ->
        val seed = index * 137.508
        Particle(
          seed = seed,
          radius = (3 + sin(seed) * 3).toFloat(),
          color = particleColors[index % particleColors.size],
        )
      }
    }

  var time by remember { mutableFloatStateOf(0f) }
  LaunchedEffect(Unit) {
    val start = withFrameNanos { it }
    while (true) {
      withFrameNanos { frame ->
        time = ((frame - start) / 1_000_000_000.0).toFloat()
      }
    }
  }

  Canvas(modifier = modifier.fillMaxSize()) {
    particles.forEach { particle ->
      val x = (sin(time * 0.3 + particle.seed) * 0.45 + 0.5).toFloat() * size.width
      val y = (cos(time * 0.2 + particle.seed * 0.7) * 0.45 + 0.5).toFloat() * size.height
      val opacity = (0.5 + sin(time * 0.5 + particle.seed) * 0.2).toFloat()
      drawCircle(
        color = particle.color.copy(alpha = opacity * 0.4f),
        radius = particle.radius,
        center = Offset(x, y),
      )
    }
  }
}

@Composable
fun SnowfallView(modifier: Modifier = Modifier, flakeCount: Int = 40) {
  val flakes =
    remember(flakeCount) {
      List(flakeCount) { index ->
        SnowFlake(
          seed = index * 91.7,
          radius = (2 + (index % 4)).toFloat(),
          speed = 0.15f + (index % 5) * 0.04f,
        )
      }
    }

  var time by remember { mutableFloatStateOf(0f) }
  LaunchedEffect(Unit) {
    val start = withFrameNanos { it }
    while (true) {
      withFrameNanos { frame ->
        time = ((frame - start) / 1_000_000_000.0).toFloat()
      }
    }
  }

  Canvas(modifier = modifier.fillMaxSize()) {
    flakes.forEach { flake ->
      val x =
        (
            ((sin(flake.seed) * 0.5 + 0.5) * size.width +
                sin(time * 0.4 + flake.seed) * size.width * 0.08)
              .toFloat() % size.width + size.width
          ) % size.width
      val y =
        ((time * flake.speed * size.height + flake.seed.toFloat() * 40f) % (size.height + 20f)) -
          10f
      drawCircle(
        color = Color.White.copy(alpha = 0.55f),
        radius = flake.radius,
        center = Offset(x, y),
      )
    }
  }
}

private data class Particle(val seed: Double, val radius: Float, val color: Color)

private data class SnowFlake(val seed: Double, val radius: Float, val speed: Float)
