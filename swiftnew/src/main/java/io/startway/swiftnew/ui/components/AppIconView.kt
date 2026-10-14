package io.startway.swiftnew.ui.components

import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.graphics.painter.BitmapPainter
import androidx.compose.ui.graphics.painter.Painter
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.core.content.ContextCompat
import androidx.core.graphics.drawable.toBitmap

/** iOS `AppIconView` — 65pt rounded icon above / beside the What's New heading. */
@Composable
fun AppIconView(
  assetName: String? = null,
  alternateIconName: String? = null,
  modifier: Modifier = Modifier,
  size: Dp = 65.dp,
  cornerRadius: Dp = 19.dp,
) {
  val painter = rememberAppIconPainter(assetName = assetName, alternateIconName = alternateIconName)
  if (painter != null) {
    Image(
      painter = painter,
      contentDescription = null,
      modifier = modifier.size(size).clip(RoundedCornerShape(cornerRadius)),
    )
  }
}

@Composable
private fun rememberAppIconPainter(
  assetName: String?,
  alternateIconName: String?,
): Painter? {
  val context = LocalContext.current
  val density = LocalDensity.current
  val pixelSize = with(density) { 65.dp.roundToPx().coerceAtLeast(1) }

  return remember(assetName, alternateIconName, context.packageName, pixelSize) {
    val drawable =
      resolveAppIconDrawable(
        context = context,
        assetName = assetName,
        alternateIconName = alternateIconName,
      ) ?: return@remember null
    val bitmap =
      when (drawable) {
        is BitmapDrawable ->
          drawable.bitmap?.takeIf { !it.isRecycled }
            ?: drawable.toBitmap(pixelSize, pixelSize)
        else -> drawable.toBitmap(pixelSize, pixelSize)
      }
    BitmapPainter(bitmap.asImageBitmap())
  }
}

private fun resolveAppIconDrawable(
  context: android.content.Context,
  assetName: String?,
  alternateIconName: String?,
): Drawable? {
  val packageName = context.packageName
  val resources = context.resources

  val candidates =
    buildList {
      assetName?.trim()?.takeIf { it.isNotEmpty() }?.let { add(it) }
      alternateIconName?.trim()?.takeIf { it.isNotEmpty() }?.let { alt ->
        add("SwiftNEWAppIcon-$alt")
        add(alt)
      }
      add("SwiftNEWAppIcon")
      add("ic_launcher_playstore")
      add("ic_launcher")
      add("ic_launcher_round")
      add("ic_launcher_foreground")
    }

  for (name in candidates) {
    val resId =
      resources.getIdentifier(name, "mipmap", packageName).takeIf { it != 0 }
        ?: resources.getIdentifier(name, "drawable", packageName).takeIf { it != 0 }
    if (resId != null) {
      ContextCompat.getDrawable(context, resId)?.let {
        return it
      }
    }
  }

  return try {
    context.packageManager.getApplicationIcon(context.applicationInfo)
  } catch (_: Exception) {
    null
  }
}
