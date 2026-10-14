package io.startway.swiftnew.ui.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.SolidColor
import androidx.compose.ui.unit.dp
import io.startway.swiftnew.ui.icons.SfSymbolMapper

/**
 * iOS-parity search field: capsule glass, magnifyingglass + plain field + clear.
 */
@Composable
fun SearchField(
  value: String,
  onValueChange: (String) -> Unit,
  modifier: Modifier = Modifier,
  accent: Color = MaterialTheme.colorScheme.primary,
  placeholder: String = "Search",
) {
  val secondary = MaterialTheme.colorScheme.onSurfaceVariant
  Row(
    modifier =
      modifier
        .widthIn(max = 380.dp)
        .fillMaxWidth()
        .glassSurface(
          shape = RoundedCornerShape(50),
          accent = secondary.copy(alpha = 0.35f),
          elevation = 4.dp,
        )
        .padding(horizontal = 14.dp, vertical = 10.dp),
    verticalAlignment = Alignment.CenterVertically,
    horizontalArrangement = Arrangement.spacedBy(8.dp),
  ) {
    Icon(
      imageVector = SfSymbolMapper.map("magnifyingglass"),
      contentDescription = null,
      tint = secondary,
      modifier = Modifier.size(18.dp),
    )
    BasicTextField(
      value = value,
      onValueChange = onValueChange,
      singleLine = true,
      textStyle =
        MaterialTheme.typography.bodyLarge.copy(color = MaterialTheme.colorScheme.onSurface),
      cursorBrush = SolidColor(accent),
      modifier = Modifier.weight(1f),
      decorationBox = { innerTextField ->
        if (value.isEmpty()) {
          Text(
            text = placeholder,
            style = MaterialTheme.typography.bodyLarge,
            color = secondary,
          )
        }
        innerTextField()
      },
    )
    if (value.isNotEmpty()) {
      IconButton(
        onClick = { onValueChange("") },
        modifier = Modifier.size(28.dp),
      ) {
        Icon(
          imageVector = SfSymbolMapper.map("xmark.circle.fill"),
          contentDescription = "Clear",
          tint = secondary,
          modifier = Modifier.size(18.dp),
        )
      }
    }
  }
}
