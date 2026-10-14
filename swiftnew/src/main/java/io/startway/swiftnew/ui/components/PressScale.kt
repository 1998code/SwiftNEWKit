package io.startway.swiftnew.ui.components

import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.spring
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.interaction.collectIsPressedAsState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.graphicsLayer

/** Subtle press scale used by glass / trigger buttons. */
@Composable
fun Modifier.pressScale(
  interactionSource: MutableInteractionSource,
  pressedScale: Float = 0.96f,
): Modifier {
  val pressed by interactionSource.collectIsPressedAsState()
  val scale by
    animateFloatAsState(
      targetValue = if (pressed) pressedScale else 1f,
      animationSpec = spring(dampingRatio = 0.72f, stiffness = 500f),
      label = "pressScale",
    )
  return this.graphicsLayer {
    scaleX = scale
    scaleY = scale
    alpha = if (pressed) 0.92f else 1f
  }
}
