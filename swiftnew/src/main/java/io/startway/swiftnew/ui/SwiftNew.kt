package io.startway.swiftnew.ui

import android.app.Activity
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.view.View
import android.view.ViewParent
import android.view.Window
import android.widget.Toast
import androidx.core.view.WindowCompat
import androidx.core.view.WindowInsetsCompat
import androidx.core.view.WindowInsetsControllerCompat
import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.slideInHorizontally
import androidx.compose.animation.slideOutHorizontally
import androidx.compose.animation.togetherWith
import androidx.compose.foundation.background
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.statusBarsPadding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.BottomSheetDefaults
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.SheetValue
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.SideEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalView
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.compose.ui.window.Dialog
import androidx.compose.ui.window.DialogProperties
import androidx.compose.ui.window.DialogWindowProvider
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import io.startway.swiftnew.data.BillingPurchaseVerifier
import io.startway.swiftnew.data.PlayStoreListing
import io.startway.swiftnew.data.PlayUpdateChecker
import io.startway.swiftnew.data.ReleaseNotesLoader
import io.startway.swiftnew.model.ContentAlignment
import io.startway.swiftnew.model.SwiftNewHeadingStyle
import io.startway.swiftnew.model.SwiftNewIconStyle
import io.startway.swiftnew.model.SwiftNewMeshStyle
import io.startway.swiftnew.model.SwiftNewPresentation
import io.startway.swiftnew.model.SwiftNewPurchaseEnvironment
import io.startway.swiftnew.model.SwiftNewPurchaseRequirement
import io.startway.swiftnew.model.SwiftNewSpecialEffect
import io.startway.swiftnew.model.VersionRelease
import io.startway.swiftnew.ui.components.GlassButton
import io.startway.swiftnew.ui.components.glassContentColor
import io.startway.swiftnew.ui.components.pressScale
import io.startway.swiftnew.ui.effects.SwiftNewBackdrop
import io.startway.swiftnew.ui.icons.SfSymbolMapper
import io.startway.swiftnew.ui.sheets.CurrentVersionSheet
import io.startway.swiftnew.ui.sheets.HistorySheet
import io.startway.swiftnew.ui.sheets.PurchaseCheckingSheet
import io.startway.swiftnew.ui.sheets.PurchaseRequiredSheet
import io.startway.swiftnew.ui.sheets.UpdateAvailableSheet
import io.startway.swiftnew.ui.sheets.UpdateCandidate
import io.startway.swiftnew.ui.sheets.UpdateCheckingSheet

/**
 * Android Compose port of SwiftNEW.
 *
 * Prop names and defaults mirror the iOS `SwiftNEW` initializer where practical.
 *
 * Presentation mapping:
 * - [SwiftNewPresentation.Sheet] → Material 3 [ModalBottomSheet] (native Android sheet)
 * - [SwiftNewPresentation.FullScreen] → edge-to-edge dialog (iOS fullScreenCover)
 * - [SwiftNewPresentation.Embed] → inline content, no chrome
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SwiftNew(
  show: Boolean,
  onShowChange: (Boolean) -> Unit,
  modifier: Modifier = Modifier,
  align: ContentAlignment = ContentAlignment.Center,
  color: Color = MaterialTheme.colorScheme.primary,
  size: String = "simple",
  label: String = "Show Release Note",
  labelImage: String = "arrow.up.circle.fill",
  history: Boolean = true,
  search: Boolean = true,
  data: String = "data",
  showDrop: Boolean = false,
  mesh: Boolean = true,
  meshStyle: SwiftNewMeshStyle = SwiftNewMeshStyle.Still,
  specialEffect: SwiftNewSpecialEffect = SwiftNewSpecialEffect.None,
  glass: Boolean = true,
  buttonCornerRadius: Dp = 20.dp,
  buttonTextColor: Color? = null,
  presentation: SwiftNewPresentation = SwiftNewPresentation.Sheet,
  showBuild: Boolean = true,
  showDescription: Boolean = true,
  headingStyle: SwiftNewHeadingStyle = SwiftNewHeadingStyle.Version,
  headingPrefix: String = "What's New in",
  iconStyle: SwiftNewIconStyle = SwiftNewIconStyle.Default,
  appIconName: String? = null,
  alternateAppIconName: String? = null,
  checkForUpdates: Boolean = false,
  allowsSkippingUpdate: Boolean = true,
  updateButtonTitle: String = "",
  /** Google Play package name used for update / purchase store links. */
  playStorePackageName: String? = null,
  purchaseRequirement: SwiftNewPurchaseRequirement? = null,
  purchaseEnvironment: SwiftNewPurchaseEnvironment = SwiftNewPurchaseEnvironment.InternalTesting,
  purchaseButtonTitle: String = "",
  purchaseAction: (suspend () -> Unit)? = null,
  appNameOverride: String? = null,
  versionNameOverride: String? = null,
  versionCodeOverride: String? = null,
) {
  val context = LocalContext.current
  val scope = rememberCoroutineScope()
  val accent = color
  val alignment = align
  val dataSource = data
  val resolvedTextColor = buttonTextColor ?: contrastingOnColor(accent)
  val resolvedCorner = buttonCornerRadius.coerceAtLeast(0.dp)
  val resolvedUpdateTitle = updateButtonTitle.trim().ifEmpty { "Download Now" }

  var releases by remember { mutableStateOf<List<VersionRelease>>(emptyList()) }
  var isLoading by remember { mutableStateOf(true) }
  var loadError by remember { mutableStateOf<String?>(null) }
  var showHistory by remember { mutableStateOf(false) }
  var showSearch by remember { mutableStateOf(false) }
  var searchText by remember { mutableStateOf("") }
  var debouncedSearchText by remember { mutableStateOf("") }
  var isCheckingUpdate by remember { mutableStateOf(false) }
  var updateCandidate by remember { mutableStateOf<UpdateCandidate?>(null) }
  var purchaseChecking by remember { mutableStateOf(false) }
  var purchaseError by remember { mutableStateOf<String?>(null) }
  var purchaseUnlocked by remember { mutableStateOf(false) }
  var purchaseStoreUrl by remember { mutableStateOf<String?>(null) }

  val billingVerifier = remember { BillingPurchaseVerifier(context) }
  DisposableEffect(Unit) { onDispose { billingVerifier.endConnection() } }

  val packageInfo =
    remember {
      val packageManager = context.packageManager
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
        packageManager.getPackageInfo(context.packageName, PackageManager.PackageInfoFlags.of(0))
      } else {
        @Suppress("DEPRECATION")
        packageManager.getPackageInfo(context.packageName, 0)
      }
    }

  val versionName = versionNameOverride ?: packageInfo.versionName.orEmpty()
  val versionCode =
    versionCodeOverride
      ?: if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
        packageInfo.longVersionCode.toString()
      } else {
        @Suppress("DEPRECATION")
        packageInfo.versionCode.toString()
      }
  val appName =
    appNameOverride
      ?: context.applicationInfo.loadLabel(context.packageManager).toString()

  val isInternalTestingBuild =
    remember(context) {
      (context.applicationInfo.flags and ApplicationInfo.FLAG_DEBUGGABLE) != 0
    }
  val activePurchaseRequirement: SwiftNewPurchaseRequirement? =
    when {
      purchaseRequirement == null -> null
      purchaseEnvironment == SwiftNewPurchaseEnvironment.All -> purchaseRequirement
      purchaseEnvironment == SwiftNewPurchaseEnvironment.InternalTesting &&
        isInternalTestingBuild -> purchaseRequirement
      else -> null
    }
  val purchaseGateActive = activePurchaseRequirement != null && !purchaseUnlocked

  fun resetSearch() {
    showSearch = false
    searchText = ""
    debouncedSearchText = ""
  }

  fun toggleSearch() {
    showSearch = !showSearch
    if (!showSearch) {
      searchText = ""
      debouncedSearchText = ""
    }
  }

  fun openPurchaseStore() {
    val url =
      purchaseStoreUrl
        ?: PlayStoreListing.forPackage(
            playStorePackageName?.trim()?.takeIf { it.isNotEmpty() } ?: context.packageName
          )
          ?.url
        ?: return
    context.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
  }

  fun runPurchase() {
    scope.launch {
      if (purchaseAction != null) {
        // Host-provided action (demo / custom Billing flow).
        purchaseAction.invoke()
        purchaseUnlocked = true
        purchaseError = null
      } else {
        openPurchaseStore()
      }
    }
  }

  fun runRestore() {
    scope.launch {
      val requirement = activePurchaseRequirement
      if (requirement == null) return@launch
      purchaseChecking = true
      purchaseError = null
      val verified =
        runCatching { billingVerifier.restoreAndCheck(requirement) }.getOrElse {
          purchaseError = "Unable to verify your purchase."
          false
        }
      purchaseChecking = false
      if (verified) {
        purchaseUnlocked = true
        purchaseError = null
      } else if (purchaseError == null) {
        purchaseError = "Unable to verify your purchase."
      }
    }
  }

  fun runRetryPurchase() {
    scope.launch {
      val requirement = activePurchaseRequirement ?: return@launch
      purchaseError = null
      purchaseChecking = true
      val verified =
        runCatching { billingVerifier.isSatisfied(requirement) }.getOrDefault(false)
      purchaseChecking = false
      if (verified) {
        purchaseUnlocked = true
      } else {
        purchaseError = "Unable to verify purchase yet."
      }
    }
  }

  fun reload() {
    scope.launch {
      isLoading = true
      loadError = null
      updateCandidate = null
      runCatching { ReleaseNotesLoader.load(context, dataSource) }
        .onSuccess { loaded ->
          releases = loaded
          if (checkForUpdates) {
            isCheckingUpdate = true
            updateCandidate =
              PlayUpdateChecker.resolve(
                context = context,
                releases = loaded,
                currentVersion = versionName,
                playStorePackageName = playStorePackageName,
              )
            isCheckingUpdate = false
          }
        }
        .onFailure {
          loadError = it.message ?: "Failed to load release notes"
          isCheckingUpdate = false
        }
      isLoading = false
    }
  }

  LaunchedEffect(dataSource, checkForUpdates, versionName) { reload() }

  LaunchedEffect(searchText) {
    delay(250)
    debouncedSearchText = searchText
  }

  LaunchedEffect(show, showDrop) {
    if (show && showDrop) {
      Toast.makeText(context, label, Toast.LENGTH_SHORT).show()
    }
  }

  LaunchedEffect(show, activePurchaseRequirement, purchaseUnlocked) {
    val requirement = activePurchaseRequirement
    if (!show || requirement == null || purchaseUnlocked) return@LaunchedEffect

    purchaseChecking = true
    purchaseError = null
    val packageName = playStorePackageName?.trim()?.takeIf { it.isNotEmpty() } ?: context.packageName
    purchaseStoreUrl = PlayStoreListing.forPackage(packageName)?.url

    val verified =
      runCatching { billingVerifier.isSatisfied(requirement) }.getOrDefault(false)
    if (verified) {
      purchaseUnlocked = true
      purchaseChecking = false
      return@LaunchedEffect
    }
    purchaseChecking = false
  }

  if (presentation == SwiftNewPresentation.Embed) {
    Box(modifier = modifier.fillMaxSize()) {
      if (mesh) {
        SwiftNewBackdrop(
          accent = accent,
          meshStyle = meshStyle,
          specialEffect = specialEffect,
          modifier = Modifier.fillMaxSize(),
        )
      }
      SwiftNewContent(
        onShowHistoryChange = { showHistory = it },
        releases = releases,
        versionName = versionName,
        versionCode = versionCode,
        appName = appName,
        accent = accent,
        alignment = alignment,
        headingStyle = headingStyle,
        headingPrefix = headingPrefix,
        showBuild = showBuild,
        showDescription = showDescription,
        iconStyle = iconStyle,
        appIconName = appIconName,
        alternateAppIconName = alternateAppIconName,
        history = history,
        search = search,
        showSearch = showSearch,
        searchText = searchText,
        isLoading = isLoading,
        loadError = loadError,
        checkForUpdates = checkForUpdates,
        isCheckingUpdate = isCheckingUpdate,
        updateCandidate = updateCandidate,
        allowsSkippingUpdate = allowsSkippingUpdate,
        updateButtonTitle = resolvedUpdateTitle,
        purchaseGateActive = purchaseGateActive,
        purchaseChecking = purchaseChecking,
        purchaseRequirement = activePurchaseRequirement,
        purchaseButtonTitle = purchaseButtonTitle,
        purchaseError = purchaseError,
        onSearchTextChange = { searchText = it },
        onToggleSearch = { toggleSearch() },
        onContinue = { onShowChange(false) },
        onRetry = { reload() },
        onOpenUpdate = { url ->
          context.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
        },
        onSkipUpdate = { onShowChange(false) },
        onPurchase = { runPurchase() },
        onRestore = { runRestore() },
        onRetryPurchase = { runRetryPurchase() },
        filterQuery = debouncedSearchText,
      )
      HistoryPresentation(
        visible = showHistory,
        presentation = presentation,
        accent = accent,
        mesh = mesh,
        meshStyle = meshStyle,
        specialEffect = specialEffect,
        releases = releases,
        alignment = alignment,
        showDescription = showDescription,
        iconStyle = iconStyle,
        search = search,
        showSearch = showSearch,
        searchText = searchText,
        filterQuery = debouncedSearchText,
        onSearchTextChange = { searchText = it },
        onToggleSearch = { toggleSearch() },
        onDismiss = {
          showHistory = false
          resetSearch()
        },
      )
    }
    return
  }

  if (size != "invisible") {
    ReleaseNoteTriggerButton(
      onClick = { onShowChange(true) },
      modifier = modifier,
      size = size,
      label = label,
      labelImage = labelImage,
      accent = accent,
      glass = glass,
      cornerRadius = resolvedCorner,
      textColor = resolvedTextColor,
    )
  }

  if (show) {
    val canDismiss =
      !purchaseGateActive && (allowsSkippingUpdate || updateCandidate == null || !checkForUpdates)

    // Always remembered so Continue can animate sheet hide (Compose: no conditional remember*).
    val sheetState =
      rememberModalBottomSheetState(
        skipPartiallyExpanded = true,
        confirmValueChange = { newValue ->
          canDismiss || newValue != SheetValue.Hidden
        },
      )

    fun finishDismiss() {
      onShowChange(false)
      showHistory = false
      resetSearch()
    }

    fun dismissPresentation() {
      if (!canDismiss) return
      // Scrim / swipe: sheet already animating or hidden — just drop state.
      finishDismiss()
    }

    fun dismissWithTransition() {
      if (!canDismiss) return
      when (presentation) {
        SwiftNewPresentation.Sheet ->
          scope.launch {
            sheetState.hide()
            finishDismiss()
          }
        SwiftNewPresentation.FullScreen, SwiftNewPresentation.Embed -> finishDismiss()
      }
    }

    @Composable
    fun PresentedBody(
      modifier: Modifier = Modifier,
      showDragHandle: Boolean = false,
      padStatusBars: Boolean = false,
    ) {
      Box(
        modifier =
          modifier
            // Opaque base so transparent ModalBottomSheet never reveals the host tab bar.
            .background(MaterialTheme.colorScheme.surface)
      ) {
        // Gradient draws edge-to-edge (under drag handle / status / nav bars).
        if (mesh) {
          SwiftNewBackdrop(
            accent = accent,
            meshStyle = meshStyle,
            specialEffect = specialEffect,
            modifier = Modifier.fillMaxSize(),
          )
        }

        Column(
          modifier =
            Modifier
              .fillMaxSize()
              .then(if (padStatusBars) Modifier.statusBarsPadding() else Modifier)
              // Nav-bar inset only — enough clearance under Continue without a second stacked gap.
              .navigationBarsPadding(),
        ) {
          if (showDragHandle) {
            Box(
              modifier = Modifier.fillMaxWidth(),
              contentAlignment = Alignment.Center,
            ) {
              BottomSheetDefaults.DragHandle()
            }
          }
          Box(modifier = Modifier.weight(1f).fillMaxWidth()) {
            SwiftNewContent(
              onShowHistoryChange = { showHistory = it },
              releases = releases,
              versionName = versionName,
              versionCode = versionCode,
              appName = appName,
              accent = accent,
              alignment = alignment,
              headingStyle = headingStyle,
              headingPrefix = headingPrefix,
              showBuild = showBuild,
              showDescription = showDescription,
              iconStyle = iconStyle,
              appIconName = appIconName,
              alternateAppIconName = alternateAppIconName,
              history = history,
              search = search,
              showSearch = showSearch,
              searchText = searchText,
              isLoading = isLoading,
              loadError = loadError,
              checkForUpdates = checkForUpdates,
              isCheckingUpdate = isCheckingUpdate,
              updateCandidate = updateCandidate,
              allowsSkippingUpdate = allowsSkippingUpdate,
              updateButtonTitle = resolvedUpdateTitle,
              purchaseGateActive = purchaseGateActive,
              purchaseChecking = purchaseChecking,
              purchaseRequirement = activePurchaseRequirement,
              purchaseButtonTitle = purchaseButtonTitle,
              purchaseError = purchaseError,
              onSearchTextChange = { searchText = it },
              onToggleSearch = { toggleSearch() },
              onContinue = { dismissWithTransition() },
              onRetry = { reload() },
              onOpenUpdate = { url ->
                context.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
              },
              onSkipUpdate = { dismissWithTransition() },
              onPurchase = { runPurchase() },
              onRestore = { runRestore() },
              onRetryPurchase = { runRetryPurchase() },
              filterQuery = debouncedSearchText,
            )
          }
        }
      }
    }

    when (presentation) {
      // Native Android sheet — Material 3 modal bottom sheet (not a centered Dialog popup).
      SwiftNewPresentation.Sheet -> {
        ModalBottomSheet(
          onDismissRequest = { dismissPresentation() },
          sheetState = sheetState,
          // Transparent chrome — PresentedBody mesh paints the full sheet so the
          // host UI (tab bar) never shows through a empty bottom band.
          containerColor = Color.Transparent,
          contentColor = MaterialTheme.colorScheme.onSurface,
          tonalElevation = 0.dp,
          dragHandle = null,
          contentWindowInsets = { WindowInsets(0, 0, 0, 0) },
        ) {
          HideStatusBarWhilePresented()
          PresentedBody(
            modifier = Modifier.fillMaxWidth().fillMaxHeight(fraction = 0.95f),
            showDragHandle = false,
            padStatusBars = false,
          )
        }
      }
      // iOS fullScreenCover equivalent.
      SwiftNewPresentation.FullScreen -> {
        Dialog(
          onDismissRequest = { dismissPresentation() },
          properties =
            DialogProperties(
              usePlatformDefaultWidth = false,
              dismissOnBackPress = canDismiss,
              dismissOnClickOutside = false,
              decorFitsSystemWindows = false,
            ),
        ) {
          HideStatusBarWhilePresented()
          Surface(
            modifier = Modifier.fillMaxSize(),
            shape = RoundedCornerShape(0.dp),
            color = Color.Transparent,
          ) {
            PresentedBody(
              modifier = Modifier.fillMaxSize(),
              showDragHandle = false,
              padStatusBars = true,
            )
          }
        }
      }
      SwiftNewPresentation.Embed -> Unit
    }

    // Nested history presentation (iOS HistoryPresentationModifier): Return dismisses
    // this layer with a real sheet/cover animation instead of swapping pages in-place.
    HistoryPresentation(
      visible = showHistory,
      presentation = presentation,
      accent = accent,
      mesh = mesh,
      meshStyle = meshStyle,
      specialEffect = specialEffect,
      releases = releases,
      alignment = alignment,
      showDescription = showDescription,
      iconStyle = iconStyle,
      search = search,
      showSearch = showSearch,
      searchText = searchText,
      filterQuery = debouncedSearchText,
      onSearchTextChange = { searchText = it },
      onToggleSearch = { toggleSearch() },
      onDismiss = {
        showHistory = false
        resetSearch()
      },
    )
  }
}

@Composable
private fun ReleaseNoteTriggerButton(
  onClick: () -> Unit,
  modifier: Modifier,
  size: String,
  label: String,
  labelImage: String,
  accent: Color,
  glass: Boolean,
  cornerRadius: Dp,
  textColor: Color,
) {
  val shape = RoundedCornerShape(cornerRadius)
  val buttonModifier =
    modifier.then(
      when (size) {
        "mini" -> Modifier
        else -> Modifier.widthIn(max = 300.dp).fillMaxWidth().height(50.dp)
      }
    )

  val interactionSource = remember { MutableInteractionSource() }
  when {
    size == "mini" -> {
      val contentColor = glassContentColor(accent)
      GlassButton(
        onClick = onClick,
        modifier = buttonModifier.size(40.dp),
        accent = accent,
        shape = CircleShape,
        contentPadding = PaddingValues(0.dp),
        minHeight = 0.dp,
        elevation = 6.dp,
      ) {
        Icon(
          imageVector = SfSymbolMapper.map(labelImage),
          contentDescription = label,
          tint = contentColor,
          modifier = Modifier.size(22.dp),
        )
      }
    }
    glass -> {
      val contentColor = glassContentColor(accent)
      GlassButton(
        onClick = onClick,
        modifier = buttonModifier,
        accent = accent,
        shape = shape,
      ) {
        TriggerLabel(label = label, labelImage = labelImage, contentColor = contentColor)
      }
    }
    else ->
      Button(
        onClick = onClick,
        modifier = buttonModifier.pressScale(interactionSource),
        interactionSource = interactionSource,
        shape = shape,
        colors =
          ButtonDefaults.buttonColors(containerColor = accent, contentColor = textColor),
      ) {
        TriggerLabel(label = label, labelImage = labelImage, contentColor = textColor)
      }
  }
}

@Composable
private fun TriggerLabel(label: String, labelImage: String, contentColor: Color) {
  Row(verticalAlignment = Alignment.CenterVertically) {
    Icon(
      imageVector = SfSymbolMapper.map(labelImage),
      contentDescription = null,
      tint = contentColor,
    )
    Spacer(modifier = Modifier.width(8.dp))
    Text(
      text = label,
      style = MaterialTheme.typography.titleMedium.copy(fontWeight = FontWeight.Bold),
      color = contentColor,
    )
  }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun HistoryPresentation(
  visible: Boolean,
  presentation: SwiftNewPresentation,
  accent: Color,
  mesh: Boolean,
  meshStyle: SwiftNewMeshStyle,
  specialEffect: SwiftNewSpecialEffect,
  releases: List<VersionRelease>,
  alignment: ContentAlignment,
  showDescription: Boolean,
  iconStyle: SwiftNewIconStyle,
  search: Boolean,
  showSearch: Boolean,
  searchText: String,
  filterQuery: String = searchText,
  onSearchTextChange: (String) -> Unit,
  onToggleSearch: () -> Unit,
  onDismiss: () -> Unit,
) {
  if (!visible) return

  val scope = rememberCoroutineScope()

  @Composable
  fun HistoryBody(
    modifier: Modifier = Modifier,
    showDragHandle: Boolean = false,
    padStatusBars: Boolean = false,
    onReturn: () -> Unit,
  ) {
    Box(modifier = modifier) {
      if (mesh) {
        SwiftNewBackdrop(
          accent = accent,
          meshStyle = meshStyle,
          specialEffect = specialEffect,
          modifier = Modifier.fillMaxSize(),
        )
      } else {
        Box(modifier = Modifier.fillMaxSize().background(MaterialTheme.colorScheme.surface))
      }
      Column(
        modifier =
          Modifier
            .fillMaxSize()
            .then(if (padStatusBars) Modifier.statusBarsPadding() else Modifier)
            .navigationBarsPadding(),
      ) {
        if (showDragHandle) {
          Box(
            modifier = Modifier.fillMaxWidth(),
            contentAlignment = Alignment.Center,
          ) {
            BottomSheetDefaults.DragHandle()
          }
        }
        HistorySheet(
          releases = releases,
          accent = accent,
          alignment = alignment,
          showDescription = showDescription,
          iconStyle = iconStyle,
          searchEnabled = search,
          showSearch = showSearch,
          searchText = searchText,
          filterQuery = filterQuery,
          onSearchTextChange = onSearchTextChange,
          onToggleSearch = onToggleSearch,
          onReturn = onReturn,
          modifier = Modifier.weight(1f).fillMaxWidth(),
        )
      }
    }
  }

  when (presentation) {
    SwiftNewPresentation.Sheet, SwiftNewPresentation.Embed -> {
      val historySheetState =
        rememberModalBottomSheetState(skipPartiallyExpanded = true)
      ModalBottomSheet(
        onDismissRequest = onDismiss,
        sheetState = historySheetState,
        containerColor = Color.Transparent,
        contentColor = MaterialTheme.colorScheme.onSurface,
        tonalElevation = 0.dp,
        dragHandle = null,
        contentWindowInsets = { WindowInsets(0, 0, 0, 0) },
      ) {
        HideStatusBarWhilePresented()
        HistoryBody(
          modifier =
            Modifier
              .fillMaxWidth()
              .fillMaxHeight(fraction = 0.95f)
              .background(MaterialTheme.colorScheme.surface),
          showDragHandle = false,
          onReturn = {
            scope.launch {
              historySheetState.hide()
              onDismiss()
            }
          },
        )
      }
    }
    SwiftNewPresentation.FullScreen -> {
      Dialog(
        onDismissRequest = onDismiss,
        properties =
          DialogProperties(
            usePlatformDefaultWidth = false,
            dismissOnBackPress = true,
            dismissOnClickOutside = false,
            decorFitsSystemWindows = false,
          ),
      ) {
        HideStatusBarWhilePresented()
        Surface(
          modifier = Modifier.fillMaxSize(),
          shape = RoundedCornerShape(0.dp),
          color = Color.Transparent,
        ) {
          HistoryBody(
            modifier = Modifier.fillMaxSize(),
            padStatusBars = true,
            onReturn = onDismiss,
          )
        }
      }
    }
  }
}

/** ModalBottomSheet / Dialog windows re-show the status bar — keep it hidden while presented. */
@Composable
private fun HideStatusBarWhilePresented() {
  val view = LocalView.current
  SideEffect {
    val windows = linkedSetOf<Window>()
    findDialogWindow(view)?.let { windows.add(it) }
    (view.context as? Activity)?.window?.let { windows.add(it) }
    for (window in windows) {
      WindowCompat.setDecorFitsSystemWindows(window, false)
      WindowInsetsControllerCompat(window, view).apply {
        hide(WindowInsetsCompat.Type.statusBars())
        systemBarsBehavior =
          WindowInsetsControllerCompat.BEHAVIOR_SHOW_TRANSIENT_BARS_BY_SWIPE
      }
    }
  }
}

private fun findDialogWindow(view: View): Window? {
  var parent: ViewParent? = view.parent
  while (parent != null) {
    if (parent is DialogWindowProvider) {
      return parent.window
    }
    parent = parent.parent
  }
  return null
}

@Composable
private fun SwiftNewContent(
  onShowHistoryChange: (Boolean) -> Unit,
  releases: List<VersionRelease>,
  versionName: String,
  versionCode: String?,
  appName: String,
  accent: Color,
  alignment: ContentAlignment,
  headingStyle: SwiftNewHeadingStyle,
  headingPrefix: String,
  showBuild: Boolean,
  showDescription: Boolean,
  iconStyle: SwiftNewIconStyle,
  appIconName: String? = null,
  alternateAppIconName: String? = null,
  history: Boolean,
  search: Boolean,
  showSearch: Boolean,
  searchText: String,
  isLoading: Boolean,
  loadError: String?,
  checkForUpdates: Boolean,
  isCheckingUpdate: Boolean,
  updateCandidate: UpdateCandidate?,
  allowsSkippingUpdate: Boolean,
  updateButtonTitle: String,
  purchaseGateActive: Boolean,
  purchaseChecking: Boolean,
  purchaseRequirement: SwiftNewPurchaseRequirement?,
  purchaseButtonTitle: String,
  purchaseError: String?,
  onSearchTextChange: (String) -> Unit,
  onToggleSearch: () -> Unit,
  onContinue: () -> Unit,
  onRetry: () -> Unit,
  onOpenUpdate: (String) -> Unit,
  onSkipUpdate: () -> Unit,
  onPurchase: () -> Unit,
  onRestore: () -> Unit,
  onRetryPurchase: () -> Unit,
  filterQuery: String = searchText,
) {
  // History is presented as a nested sheet/cover (see HistoryPresentation), not a page swap.
  val page =
    when {
      purchaseGateActive && purchaseChecking -> SheetPage.PurchaseChecking
      purchaseGateActive && purchaseRequirement != null -> SheetPage.PurchaseRequired
      checkForUpdates && isCheckingUpdate -> SheetPage.UpdateChecking
      checkForUpdates && updateCandidate != null -> SheetPage.UpdateAvailable
      else -> SheetPage.Current
    }

  AnimatedContent(
    targetState = page,
    transitionSpec = {
      val forward = targetState.ordinal >= initialState.ordinal
      val enterOffset = if (forward) 1 else -1
      val exitOffset = if (forward) -1 else 1
      (slideInHorizontally(tween(260)) { fullWidth -> enterOffset * fullWidth / 5 } +
          fadeIn(tween(200)))
        .togetherWith(
          slideOutHorizontally(tween(260)) { fullWidth -> exitOffset * fullWidth / 5 } +
            fadeOut(tween(160))
        )
    },
    label = "sheetPage",
    modifier = Modifier.fillMaxSize(),
  ) { currentPage ->
    when (currentPage) {
      SheetPage.PurchaseChecking -> PurchaseCheckingSheet()
      SheetPage.PurchaseRequired ->
        if (purchaseRequirement != null) {
          PurchaseRequiredSheet(
            requirement = purchaseRequirement,
            accent = accent,
            purchaseButtonTitle = purchaseButtonTitle,
            errorMessage = purchaseError,
            onPurchase = onPurchase,
            onRestore = onRestore,
            onRetry = onRetryPurchase,
          )
        }
      SheetPage.UpdateChecking ->
        UpdateCheckingSheet(
          accent = accent,
          allowsSkipping = allowsSkippingUpdate,
          onSkip = onSkipUpdate,
        )
      SheetPage.UpdateAvailable ->
        if (updateCandidate != null) {
          UpdateAvailableSheet(
            candidate = updateCandidate,
            currentVersion = versionName,
            accent = accent,
            alignment = alignment,
            showDescription = showDescription,
            iconStyle = iconStyle,
            updateButtonTitle = updateButtonTitle,
            allowsSkipping = allowsSkippingUpdate,
            onUpdate = {
              val url = updateCandidate.storeUrl
              if (!url.isNullOrBlank()) {
                onOpenUpdate(url)
              }
            },
            onSkip = onSkipUpdate,
          )
        }
      SheetPage.Current ->
        CurrentVersionSheet(
          releases = releases,
          currentVersion = versionName,
          appName = appName,
          versionCode = versionCode,
          accent = accent,
          alignment = alignment,
          headingStyle = headingStyle,
          headingPrefix = headingPrefix,
          showBuild = showBuild,
          showDescription = showDescription,
          iconStyle = iconStyle,
          appIconName = appIconName,
          alternateAppIconName = alternateAppIconName,
          historyEnabled = history,
          searchEnabled = search,
          showSearch = showSearch,
          searchText = searchText,
          isLoading = isLoading,
          loadErrorMessage = loadError,
          onSearchTextChange = onSearchTextChange,
          onToggleSearch = onToggleSearch,
          onShowHistory = { onShowHistoryChange(true) },
          onContinue = onContinue,
          onRetry = onRetry,
          filterQuery = filterQuery,
        )
    }
  }
}

private enum class SheetPage {
  Current,
  UpdateChecking,
  UpdateAvailable,
  PurchaseChecking,
  PurchaseRequired,
}

private fun contrastingOnColor(background: Color): Color {
  val luminance =
    0.2126f * background.red + 0.7152f * background.green + 0.0722f * background.blue
  return if (luminance > 0.55f) Color.Black else Color.White
}
