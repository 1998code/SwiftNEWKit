package io.startway.swiftnew.ui.components

import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import io.startway.swiftnew.ui.icons.SfSymbolMapper

@Composable
fun PrimaryActionButton(
  title: String,
  onClick: () -> Unit,
  accent: Color,
  icon: ImageVector = SfSymbolMapper.map("arrow.right.circle.fill"),
  modifier: Modifier = Modifier,
  usesGlass: Boolean = true,
) {
  if (usesGlass) {
    val contentColor = glassContentColor(accent)
    GlassButton(
      onClick = onClick,
      modifier = modifier.widthIn(max = 300.dp).fillMaxWidth().height(50.dp),
      accent = accent,
      shape = RoundedCornerShape(25.dp),
      minHeight = 50.dp,
    ) {
      Text(
        text = title,
        style = MaterialTheme.typography.bodyLarge.copy(fontWeight = FontWeight.Bold),
        color = contentColor,
      )
      Icon(imageVector = icon, contentDescription = null, tint = contentColor)
    }
  } else {
    val interactionSource = remember { MutableInteractionSource() }
    Button(
      onClick = onClick,
      modifier =
        modifier
          .widthIn(max = 300.dp)
          .fillMaxWidth()
          .height(50.dp)
          .pressScale(interactionSource),
      interactionSource = interactionSource,
      shape = RoundedCornerShape(25.dp),
      colors =
        ButtonDefaults.buttonColors(
          containerColor = accent,
          contentColor = adaptedTextColor(accent),
        ),
    ) {
      Row(
        horizontalArrangement = Arrangement.spacedBy(8.dp),
        verticalAlignment = Alignment.CenterVertically,
      ) {
        Text(text = title, style = MaterialTheme.typography.bodyLarge)
        Icon(imageVector = icon, contentDescription = null)
      }
    }
  }
}

@Composable
fun CapsuleSecondaryButton(
  title: String,
  onClick: () -> Unit,
  icon: ImageVector,
  modifier: Modifier = Modifier,
  accent: Color = MaterialTheme.colorScheme.primary,
) {
  val secondary = MaterialTheme.colorScheme.onSurfaceVariant
  GlassCapsuleButton(
    onClick = onClick,
    modifier = modifier,
    accent = secondary.copy(alpha = 0.45f),
  ) {
    Text(
      text = title,
      style = MaterialTheme.typography.labelMedium.copy(fontWeight = FontWeight.Medium),
      color = secondary,
      modifier = Modifier.padding(horizontal = 2.dp),
    )
    Icon(imageVector = icon, contentDescription = null, tint = secondary)
  }
}

@Composable
fun ShowHistoryButton(
  onClick: () -> Unit,
  modifier: Modifier = Modifier,
  accent: Color = MaterialTheme.colorScheme.primary,
) {
  CapsuleSecondaryButton(
    title = "Show History",
    onClick = onClick,
    icon = SfSymbolMapper.map("arrow.up.bin"),
    modifier = modifier,
    accent = accent,
  )
}

@Composable
fun SearchToggleButton(
  isSearching: Boolean,
  onClick: () -> Unit,
  modifier: Modifier = Modifier,
  accent: Color = MaterialTheme.colorScheme.primary,
) {
  CapsuleSecondaryButton(
    title = "Search",
    onClick = onClick,
    icon =
      SfSymbolMapper.map(if (isSearching) "xmark.circle" else "magnifyingglass"),
    modifier = modifier,
    accent = accent,
  )
}

@Composable
fun UpdateNowButton(
  title: String,
  onClick: () -> Unit,
  accent: Color,
  modifier: Modifier = Modifier,
) {
  PrimaryActionButton(
    title = title,
    onClick = onClick,
    accent = accent,
    icon = SfSymbolMapper.map("arrow.up.forward.app.fill"),
    modifier = modifier,
  )
}

@Composable
fun NotNowButton(onClick: () -> Unit, modifier: Modifier = Modifier) {
  val interactionSource = remember { MutableInteractionSource() }
  TextButton(
    onClick = onClick,
    modifier = modifier.pressScale(interactionSource, pressedScale = 0.97f),
    interactionSource = interactionSource,
  ) {
    Text("Not Now")
  }
}
