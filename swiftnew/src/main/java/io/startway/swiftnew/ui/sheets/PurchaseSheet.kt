package io.startway.swiftnew.ui.sheets

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import io.startway.swiftnew.model.SwiftNewPurchaseRequirement
import io.startway.swiftnew.ui.components.CapsuleSecondaryButton
import io.startway.swiftnew.ui.components.PrimaryActionButton
import io.startway.swiftnew.ui.icons.SfSymbolMapper

@Composable
fun PurchaseCheckingSheet(modifier: Modifier = Modifier) {
  Column(
    modifier = modifier.fillMaxSize().padding(24.dp),
    verticalArrangement = Arrangement.Center,
    horizontalAlignment = Alignment.CenterHorizontally,
  ) {
    Icon(
      imageVector = SfSymbolMapper.map("lock.shield"),
      contentDescription = null,
      tint = MaterialTheme.colorScheme.onSurfaceVariant,
      modifier = Modifier.size(40.dp),
    )
    Spacer(modifier = Modifier.height(18.dp))
    Text(
      text = "Verifying Purchase...",
      style = MaterialTheme.typography.titleLarge.copy(fontWeight = FontWeight.SemiBold),
      textAlign = TextAlign.Center,
    )
    Spacer(modifier = Modifier.height(16.dp))
    CircularProgressIndicator()
  }
}

@Composable
fun PurchaseRequiredSheet(
  requirement: SwiftNewPurchaseRequirement,
  accent: Color,
  purchaseButtonTitle: String,
  errorMessage: String?,
  onPurchase: () -> Unit,
  onRestore: () -> Unit,
  onRetry: () -> Unit,
  modifier: Modifier = Modifier,
) {
  val title =
    when (requirement) {
      SwiftNewPurchaseRequirement.AppPurchase -> "Purchase Required"
      is SwiftNewPurchaseRequirement.Subscription -> "Subscription Required"
      is SwiftNewPurchaseRequirement.AppPurchaseAndSubscription -> "Purchase Required"
    }
  val message =
    when (requirement) {
      SwiftNewPurchaseRequirement.AppPurchase ->
        "Buy this app on Google Play to continue. Restore if you already purchased it."
      is SwiftNewPurchaseRequirement.Subscription ->
        "An active Play subscription is required before entering the app."
      is SwiftNewPurchaseRequirement.AppPurchaseAndSubscription ->
        "Both a Play purchase and an active subscription are required."
    }
  val actionTitle =
    purchaseButtonTitle.trim().ifEmpty {
      when (requirement) {
        SwiftNewPurchaseRequirement.AppPurchase -> "Purchase"
        is SwiftNewPurchaseRequirement.Subscription -> "Subscribe"
        is SwiftNewPurchaseRequirement.AppPurchaseAndSubscription -> "Continue in Play Store"
      }
    }

  Column(modifier = modifier.fillMaxSize().padding(horizontal = 32.dp, vertical = 28.dp)) {
    CapsuleSecondaryButton(
      title = "Restore Purchases",
      onClick = onRestore,
      icon = SfSymbolMapper.map("arrow.clockwise.circle"),
      modifier = Modifier.align(Alignment.CenterHorizontally),
    )

    Spacer(modifier = Modifier.weight(1f))

    Column(
      modifier = Modifier.fillMaxWidth(),
      horizontalAlignment = Alignment.CenterHorizontally,
      verticalArrangement = Arrangement.spacedBy(10.dp),
    ) {
      Icon(
        imageVector = SfSymbolMapper.map("lock.fill"),
        contentDescription = null,
        tint = accent,
        modifier = Modifier.size(64.dp),
      )
      Text(
        text = title,
        style = MaterialTheme.typography.headlineLarge.copy(fontWeight = FontWeight.Bold),
        textAlign = TextAlign.Center,
      )
      Text(
        text = message,
        style = MaterialTheme.typography.titleMedium,
        color = MaterialTheme.colorScheme.onSurfaceVariant,
        textAlign = TextAlign.Center,
      )
      if (!errorMessage.isNullOrBlank()) {
        Text(
          text = errorMessage,
          style = MaterialTheme.typography.bodyMedium,
          color = MaterialTheme.colorScheme.onSurfaceVariant,
          textAlign = TextAlign.Center,
        )
      }
    }

    Spacer(modifier = Modifier.weight(1f))

    Column(
      modifier = Modifier.fillMaxWidth(),
      horizontalAlignment = Alignment.CenterHorizontally,
      verticalArrangement = Arrangement.spacedBy(10.dp),
    ) {
      PrimaryActionButton(title = actionTitle, onClick = onPurchase, accent = accent)
      if (!errorMessage.isNullOrBlank()) {
        PrimaryActionButton(title = "Try Again", onClick = onRetry, accent = accent)
      }
    }
  }
}
