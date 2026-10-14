package io.startway.swiftnew.ui.icons

import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowForward
import androidx.compose.material.icons.automirrored.filled.FormatAlignLeft
import androidx.compose.material.icons.automirrored.filled.List
import androidx.compose.material.icons.automirrored.filled.OpenInNew
import androidx.compose.material.icons.automirrored.filled.Undo
import androidx.compose.material.icons.filled.ArrowCircleDown
import androidx.compose.material.icons.filled.ArrowCircleRight
import androidx.compose.material.icons.filled.ArrowCircleUp
import androidx.compose.material.icons.filled.ArrowUpward
import androidx.compose.material.icons.filled.AutoAwesome
import androidx.compose.material.icons.filled.Cancel
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.Cloud
import androidx.compose.material.icons.filled.Description
import androidx.compose.material.icons.filled.DirectionsCar
import androidx.compose.material.icons.filled.Download
import androidx.compose.material.icons.filled.FilterNone
import androidx.compose.material.icons.filled.Fullscreen
import androidx.compose.material.icons.filled.History
import androidx.compose.material.icons.filled.Inventory2
import androidx.compose.material.icons.filled.Lock
import androidx.compose.material.icons.filled.LockOpen
import androidx.compose.material.icons.filled.Palette
import androidx.compose.material.icons.filled.QuestionMark
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material.icons.filled.RoundedCorner
import androidx.compose.material.icons.filled.Search
import androidx.compose.material.icons.filled.Security
import androidx.compose.material.icons.filled.ShoppingBag
import androidx.compose.material.icons.filled.Star
import androidx.compose.material.icons.filled.SystemUpdate
import androidx.compose.material.icons.filled.TextFields
import androidx.compose.material.icons.filled.Tune
import androidx.compose.material.icons.filled.Unarchive
import androidx.compose.material.icons.filled.Verified
import androidx.compose.material.icons.filled.Visibility
import androidx.compose.material.icons.filled.VisibilityOff
import androidx.compose.material.icons.filled.Watch
import androidx.compose.material.icons.filled.Widgets
import androidx.compose.material.icons.outlined.Cancel
import androidx.compose.material.icons.outlined.Circle
import androidx.compose.ui.graphics.vector.ImageVector

/**
 * Maps common SF Symbol names used in SwiftNEW JSON / labels to Material Icons.
 * Unknown symbols fall back to a quiet outlined circle.
 */
object SfSymbolMapper {
  fun map(systemName: String): ImageVector {
    val key = systemName.trim().lowercase()
    return when (key) {
      "star.fill", "star", "sparkles" -> Icons.Filled.Star
      "bag", "bag.fill" -> Icons.Filled.ShoppingBag
      "lock.fill", "lock" -> Icons.Filled.Lock
      "lock.open.fill", "lock.open" -> Icons.Filled.LockOpen
      "lock.shield" -> Icons.Filled.Security
      "textformat" -> Icons.Filled.TextFields
      "paintpalette" -> Icons.Filled.Palette
      "clock.arrow.circlepath", "clock" -> Icons.Filled.History
      "checkmark.seal" -> Icons.Filled.Verified
      "checkmark.circle", "checkmark.circle.fill" -> Icons.Filled.CheckCircle
      "applewatch" -> Icons.Filled.Watch
      "car.fill" -> Icons.Filled.DirectionsCar
      "list.bullet.rectangle" -> Icons.AutoMirrored.Filled.List
      "doc.text", "doc.text.fill" -> Icons.Filled.Description
      "tray.and.arrow.down", "arrow.down.app.fill" -> Icons.Filled.Download
      "arrow.triangle.2.circlepath", "arrow.clockwise" -> Icons.Filled.SystemUpdate
      "arrow.clockwise.circle" -> Icons.Filled.Refresh
      "magnifyingglass" -> Icons.Filled.Search
      "xmark.circle" -> Icons.Outlined.Cancel
      "xmark.circle.fill", "xmark" -> Icons.Filled.Cancel
      "arrow.forward" -> Icons.AutoMirrored.Filled.ArrowForward
      "arrow.right.circle.fill" -> Icons.Filled.ArrowCircleRight
      "arrow.down.circle.fill", "arrow.down.circle" -> Icons.Filled.ArrowCircleDown
      "arrow.up" -> Icons.Filled.ArrowUpward
      "arrow.up.circle", "arrow.up.circle.fill" -> Icons.Filled.ArrowCircleUp
      "arrow.up.bin", "arrow.up.bin.fill" -> Icons.Filled.Unarchive
      "arrow.up.forward.app.fill", "arrow.up.forward.app" -> Icons.AutoMirrored.Filled.OpenInNew
      "rectangle.inset.filled" -> Icons.Filled.Fullscreen
      "circle.hexagongrid.fill", "wand.and.stars" -> Icons.Filled.AutoAwesome
      "icloud", "icloud.fill" -> Icons.Filled.Cloud
      "eye" -> Icons.Filled.Visibility
      "eye.slash" -> Icons.Filled.VisibilityOff
      "slider.horizontal.3" -> Icons.Filled.Tune
      "text.alignleft" -> Icons.AutoMirrored.Filled.FormatAlignLeft
      "rectangle.roundedtop" -> Icons.Filled.RoundedCorner
      "rectangle.on.rectangle.slash" -> Icons.Filled.FilterNone
      "sparkles.rectangle.stack" -> Icons.Filled.Widgets
      "shippingbox", "shippingbox.fill" -> Icons.Filled.Inventory2
      "arrow.uturn.backward" -> Icons.AutoMirrored.Filled.Undo
      "questionmark" -> Icons.Filled.QuestionMark
      else -> Icons.Outlined.Circle
    }
  }
}
