package io.startway.whatsnew

import android.graphics.Color as AndroidColor
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.SystemBarStyle
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.slideInHorizontally
import androidx.compose.animation.slideOutHorizontally
import androidx.compose.animation.togetherWith
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.navigationBars
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.statusBars
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.layout.windowInsetsPadding
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.ripple
import androidx.compose.runtime.Composable
import androidx.compose.runtime.SideEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalView
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.core.view.WindowCompat
import androidx.core.view.WindowInsetsCompat
import androidx.core.view.WindowInsetsControllerCompat
import io.startway.swiftnew.model.SwiftNewPresentation
import io.startway.swiftnew.model.SwiftNewPurchaseEnvironment
import io.startway.swiftnew.model.SwiftNewPurchaseRequirement
import io.startway.swiftnew.model.SwiftNewSpecialEffect
import io.startway.swiftnew.ui.SwiftNew
import io.startway.swiftnew.ui.components.pressScale
import io.startway.swiftnew.ui.effects.SwiftNewBackdrop
import io.startway.swiftnew.ui.icons.SfSymbolMapper
import io.startway.whatsnew.theme.IndigoPrimary
import io.startway.whatsnew.theme.SwiftNEWTheme

/** Deep icon indigo — mesh / sheet chrome (unchanged in dark mode). */
private val DemoAccent = IndigoPrimary

/** Labels / selected chrome: white in dark mode, indigo in light. */
@Composable
private fun demoLabelColor(): Color =
  if (isSystemInDarkTheme()) MaterialTheme.colorScheme.onSurface else DemoAccent

private object DemoReleaseNotesSource {
  const val remoteURL =
    "https://raw.githubusercontent.com/1998code/SwiftNEWKit/refs/heads/main/Demo/What's%20New%3F/en.lproj/data.json"
  const val remoteUpdateURL =
    "https://raw.githubusercontent.com/1998code/SwiftNEWKit/refs/heads/main/Demo/remote-update-preview.json"
}

private enum class DemoTab(val title: String, val symbol: String) {
  Default("Default", "sparkles"),
  FullScreen("Full Screen", "rectangle.inset.filled"),
  Effects("Effects", "wand.and.stars"),
  Remote("Remote", "icloud"),
  Purchase("Purchase", "lock"),
}

private enum class DemoPurchaseMode(
  val title: String,
  val detail: String,
  val symbol: String,
  val requirement: SwiftNewPurchaseRequirement,
) {
  AppPurchase(
    title = "Play Store Purchase",
    detail = "One-time purchase of the app",
    symbol = "bag",
    requirement = SwiftNewPurchaseRequirement.AppPurchase,
  ),
  Subscription(
    title = "Subscription",
    detail = "An active Play Billing subscription",
    symbol = "arrow.triangle.2.circlepath",
    requirement = SwiftNewPurchaseRequirement.Subscription(listOf("com.example.pro")),
  ),
  Both(
    title = "Purchase + Subscription",
    detail = "Both are required",
    symbol = "checkmark.seal",
    requirement =
      SwiftNewPurchaseRequirement.AppPurchaseAndSubscription(listOf("com.example.pro")),
  ),
}

class MainActivity : ComponentActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)

    enableEdgeToEdge(
      statusBarStyle =
        SystemBarStyle.dark(AndroidColor.TRANSPARENT),
      navigationBarStyle =
        SystemBarStyle.light(AndroidColor.TRANSPARENT, AndroidColor.TRANSPARENT),
    )
    setContent {
      SwiftNEWTheme(dynamicColor = false) {
        val view = LocalView.current
        SideEffect {
          val window = window
          WindowCompat.setDecorFitsSystemWindows(window, false)
          WindowInsetsControllerCompat(window, view).apply {
            hide(WindowInsetsCompat.Type.statusBars())
            systemBarsBehavior =
              WindowInsetsControllerCompat.BEHAVIOR_SHOW_TRANSIENT_BARS_BY_SWIPE
          }
        }

        var selectedTab by rememberSaveable { mutableStateOf(DemoTab.Default.name) }
        val tab = DemoTab.valueOf(selectedTab)

        var showDefault by rememberSaveable { mutableStateOf(false) }
        var showMini by rememberSaveable { mutableStateOf(false) }
        var showFullScreen by rememberSaveable { mutableStateOf(false) }
        var showParticles by rememberSaveable { mutableStateOf(false) }
        var showRemote by rememberSaveable { mutableStateOf(false) }
        var showPurchase by rememberSaveable { mutableStateOf(false) }
        var purchaseModeName by rememberSaveable { mutableStateOf<String?>(null) }
        val purchaseMode =
          purchaseModeName?.let { name -> DemoPurchaseMode.entries.first { it.name == name } }

        Box(modifier = Modifier.fillMaxSize()) {
          SwiftNewBackdrop(accent = DemoAccent, modifier = Modifier.fillMaxSize())

          Scaffold(
            containerColor = Color.Transparent,
            contentWindowInsets = WindowInsets(0, 0, 0, 0),
            bottomBar = {
              TransparentBottomBar(
                selectedTab = tab,
                onSelect = { item ->
                  selectedTab = item.name
                  if (item != DemoTab.Purchase) {
                    purchaseModeName = null
                  }
                },
              )
            },
          ) { padding ->
            Box(modifier = Modifier.fillMaxSize().padding(padding)) {
              AnimatedContent(
                targetState = tab,
                transitionSpec = {
                  val forward = targetState.ordinal >= initialState.ordinal
                  val enterOffset = if (forward) 1 else -1
                  val exitOffset = if (forward) -1 else 1
                  (slideInHorizontally(tween(280)) { fullWidth -> enterOffset * fullWidth / 3 } +
                      fadeIn(tween(220)))
                    .togetherWith(
                      slideOutHorizontally(tween(280)) { fullWidth -> exitOffset * fullWidth / 3 } +
                        fadeOut(tween(180))
                    )
                },
                label = "demoTabSlide",
                modifier = Modifier.fillMaxSize(),
              ) { currentTab ->
                when (currentTab) {
                  DemoTab.Default ->
                    DefaultTab(
                      showDefault = showDefault,
                      onShowDefaultChange = { showDefault = it },
                      showMini = showMini,
                      onShowMiniChange = { showMini = it },
                    )
                  DemoTab.FullScreen ->
                    ExamplePage(
                      title = "Full Screen",
                      description = "Present release notes using a full-screen cover.",
                    ) {
                      SwiftNew(
                        show = showFullScreen,
                        onShowChange = { showFullScreen = it },
                        color = DemoAccent,
                        label = "Show Full Screen",
                        labelImage = "rectangle.inset.filled",
                        presentation = SwiftNewPresentation.FullScreen,
                      )
                    }
                  DemoTab.Effects ->
                    ExamplePage(
                      title = "Effects",
                      description = "A SwiftNEW sheet with floating particles.",
                    ) {
                      SwiftNew(
                        show = showParticles,
                        onShowChange = { showParticles = it },
                        color = DemoAccent,
                        label = "Show Particles",
                        labelImage = "circle.hexagongrid.fill",
                        specialEffect = SwiftNewSpecialEffect.Particles,
                      )
                    }
                  DemoTab.Remote ->
                    ExamplePage(
                      title = "Remote",
                      description = "Load release notes from a remote JSON file.",
                    ) {
                      SwiftNew(
                        show = showRemote,
                        onShowChange = { showRemote = it },
                        color = DemoAccent,
                        label = "Show Remote Notes",
                        labelImage = "icloud",
                        data = DemoReleaseNotesSource.remoteURL,
                      )
                    }
                  DemoTab.Purchase ->
                    ExamplePage(
                      title = "Purchase",
                      description =
                        if (purchaseMode == null) {
                          "Choose what must be verified before entering the app."
                        } else {
                          "Gate UI + Billing restore. Purchase uses demo unlock; Restore queries Play Billing."
                        },
                    ) {
                      if (purchaseMode == null) {
                        PurchaseModePicker(onSelect = { purchaseModeName = it.name })
                      } else {
                        Column(horizontalAlignment = Alignment.CenterHorizontally) {
                          Text(
                            text = purchaseMode.title,
                            style = MaterialTheme.typography.titleMedium,
                            color = MaterialTheme.colorScheme.onSurface,
                            modifier = Modifier.padding(bottom = 12.dp),
                          )
                          SwiftNew(
                            show = showPurchase,
                            onShowChange = { showPurchase = it },
                            color = DemoAccent,
                            label = "Show Purchase Gate",
                            labelImage = "lock",
                            presentation = SwiftNewPresentation.FullScreen,
                            playStorePackageName = "io.startway.whatsnew",
                            purchaseRequirement = purchaseMode.requirement,
                            purchaseEnvironment = SwiftNewPurchaseEnvironment.All,
                            // Demo unlock. Omit in production and rely on Play Billing / store.
                            purchaseAction = { },
                          )
                          Spacer(modifier = Modifier.height(12.dp))
                          PressableText(
                            text = "Change mode",
                            color = demoLabelColor(),
                            onClick = { purchaseModeName = null },
                          )
                        }
                      }
                    }
                }
              }
            }
          }
        }
      }
    }
  }
}

@Composable
private fun DefaultTab(
  showDefault: Boolean,
  onShowDefaultChange: (Boolean) -> Unit,
  showMini: Boolean,
  onShowMiniChange: (Boolean) -> Unit,
) {
  Box(modifier = Modifier.fillMaxSize()) {
    ExamplePage(
      title = "Default",
      description = "The standard SwiftNEW button and sheet presentation.",
    ) {
      SwiftNew(
        show = showDefault,
        onShowChange = onShowDefaultChange,
        color = DemoAccent,
      )
    }

    // Match iOS ContentView: toolbar-trailing mini + hint to the left (→).
    Row(
      modifier =
        Modifier
          .align(Alignment.TopEnd)
          .windowInsetsPadding(WindowInsets.statusBars)
          .padding(top = 4.dp, end = 8.dp),
      verticalAlignment = Alignment.CenterVertically,
    ) {
      Text(
        text = "Mini size fits a toolbar",
        style = MaterialTheme.typography.labelMedium.copy(fontWeight = FontWeight.Medium),
        color = MaterialTheme.colorScheme.onSurfaceVariant,
      )
      Icon(
        imageVector = SfSymbolMapper.map("arrow.forward"),
        contentDescription = null,
        tint = MaterialTheme.colorScheme.onSurfaceVariant,
        modifier = Modifier.size(14.dp).padding(horizontal = 4.dp),
      )
      SwiftNew(
        show = showMini,
        onShowChange = onShowMiniChange,
        color = DemoAccent,
        size = "mini",
        glass = true,
        labelImage = "arrow.up.circle.fill",
      )
    }
  }
}

@Composable
private fun TransparentBottomBar(
  selectedTab: DemoTab,
  onSelect: (DemoTab) -> Unit,
) {
  Row(
    modifier =
      Modifier
        .fillMaxWidth()
        .windowInsetsPadding(WindowInsets.navigationBars)
        .padding(horizontal = 4.dp, vertical = 8.dp),
    horizontalArrangement = Arrangement.SpaceEvenly,
    verticalAlignment = Alignment.CenterVertically,
  ) {
    DemoTab.entries.forEach { item ->
      val selected = selectedTab == item
      val interactionSource = remember { MutableInteractionSource() }
      Column(
        modifier =
          Modifier
            .weight(1f)
            .pressScale(interactionSource, pressedScale = 0.94f)
            .clip(RoundedCornerShape(16.dp))
            .clickable(
              interactionSource = interactionSource,
              indication = ripple(color = DemoAccent.copy(alpha = 0.2f)),
              role = Role.Button,
              onClick = { onSelect(item) },
            )
            .padding(vertical = 6.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
      ) {
        Box(
          modifier =
            Modifier
              .size(width = 56.dp, height = 28.dp)
              .clip(CircleShape)
              .background(if (selected) DemoAccent.copy(alpha = 0.16f) else Color.Transparent),
          contentAlignment = Alignment.Center,
        ) {
          Icon(
            imageVector = SfSymbolMapper.map(item.symbol),
            contentDescription = item.title,
            tint =
              if (selected) demoLabelColor() else MaterialTheme.colorScheme.onSurfaceVariant,
            modifier = Modifier.size(22.dp),
          )
        }
        Spacer(modifier = Modifier.height(4.dp))
        Text(
          text = item.title,
          fontSize = 11.sp,
          fontWeight = if (selected) FontWeight.SemiBold else FontWeight.Medium,
          color = if (selected) demoLabelColor() else MaterialTheme.colorScheme.onSurfaceVariant,
          textAlign = TextAlign.Center,
          maxLines = 1,
        )
      }
    }
  }
}

@Composable
private fun ExamplePage(
  title: String,
  description: String,
  content: @Composable () -> Unit,
) {
  Column(
    modifier = Modifier.fillMaxSize().padding(24.dp),
    verticalArrangement = Arrangement.Center,
    horizontalAlignment = Alignment.CenterHorizontally,
  ) {
    Text(
      text = title,
      style = MaterialTheme.typography.headlineLarge.copy(fontWeight = FontWeight.Bold),
      color = MaterialTheme.colorScheme.onSurface,
      textAlign = TextAlign.Center,
    )
    Spacer(modifier = Modifier.height(8.dp))
    Text(
      text = description,
      style = MaterialTheme.typography.bodyLarge,
      color = MaterialTheme.colorScheme.onSurfaceVariant,
      textAlign = TextAlign.Center,
      modifier = Modifier.padding(horizontal = 12.dp),
    )
    Spacer(modifier = Modifier.height(24.dp))
    content()
  }
}

@Composable
private fun PurchaseModePicker(onSelect: (DemoPurchaseMode) -> Unit) {
  Column(
    modifier =
      Modifier
        .fillMaxWidth()
        .clip(RoundedCornerShape(20.dp))
        .background(MaterialTheme.colorScheme.surface.copy(alpha = 0.88f))
        .padding(vertical = 4.dp),
  ) {
    DemoPurchaseMode.entries.forEachIndexed { index, mode ->
      val interactionSource = remember { MutableInteractionSource() }
      Row(
        modifier =
          Modifier
            .fillMaxWidth()
            .pressScale(interactionSource, pressedScale = 0.98f)
            .clickable(
              interactionSource = interactionSource,
              indication = ripple(color = DemoAccent.copy(alpha = 0.18f)),
              role = Role.Button,
              onClick = { onSelect(mode) },
            )
            .padding(horizontal = 16.dp, vertical = 12.dp),
        verticalAlignment = Alignment.CenterVertically,
      ) {
        Box(
          modifier =
            Modifier.size(38.dp)
              .clip(RoundedCornerShape(10.dp))
              .background(DemoAccent.copy(alpha = 0.14f)),
          contentAlignment = Alignment.Center,
        ) {
          Icon(
            imageVector = SfSymbolMapper.map(mode.symbol),
            contentDescription = null,
            tint = DemoAccent,
          )
        }
        Spacer(modifier = Modifier.width(14.dp))
        Column(modifier = Modifier.weight(1f)) {
          Text(
            text = mode.title,
            fontWeight = FontWeight.SemiBold,
            color = MaterialTheme.colorScheme.onSurface,
          )
          Text(
            text = mode.detail,
            style = MaterialTheme.typography.bodySmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
          )
        }
      }
      if (index != DemoPurchaseMode.entries.lastIndex) {
        HorizontalDivider(modifier = Modifier.padding(start = 68.dp))
      }
    }
  }
}

@Composable
private fun PressableText(
  text: String,
  color: Color,
  onClick: () -> Unit,
) {
  val interactionSource = remember { MutableInteractionSource() }
  Text(
    text = text,
    color = color,
    modifier =
      Modifier
        .pressScale(interactionSource)
        .clickable(
          interactionSource = interactionSource,
          indication = ripple(bounded = false, color = color.copy(alpha = 0.25f)),
          role = Role.Button,
          onClick = onClick,
        )
        .padding(8.dp),
  )
}
