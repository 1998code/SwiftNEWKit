package io.startway.swiftnew.data

import android.content.Context
import com.android.billingclient.api.BillingClient
import com.android.billingclient.api.BillingClientStateListener
import com.android.billingclient.api.BillingResult
import com.android.billingclient.api.PendingPurchasesParams
import com.android.billingclient.api.Purchase
import com.android.billingclient.api.QueryPurchasesParams
import io.startway.swiftnew.model.SwiftNewPurchaseRequirement
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock
import kotlinx.coroutines.withContext

/**
 * Play Billing entitlement checks behind `purchaseRequirement`
 * (Android counterpart to iOS `SwiftNEWPurchaseVerifier`).
 */
class BillingPurchaseVerifier(context: Context) {
  private val appContext = context.applicationContext
  private val mutex = Mutex()
  private var client: BillingClient? = null

  suspend fun isSatisfied(requirement: SwiftNewPurchaseRequirement): Boolean =
    withContext(Dispatchers.IO) {
      when (requirement) {
        SwiftNewPurchaseRequirement.AppPurchase -> {
          val purchases = queryPurchases(BillingClient.ProductType.INAPP)
          purchases.any { it.purchaseState == Purchase.PurchaseState.PURCHASED }
        }
        is SwiftNewPurchaseRequirement.Subscription -> {
          val purchases = queryPurchases(BillingClient.ProductType.SUBS)
          purchases.any { purchase ->
            purchase.purchaseState == Purchase.PurchaseState.PURCHASED &&
              matchesProductIds(purchase, requirement.productIds)
          }
        }
        is SwiftNewPurchaseRequirement.AppPurchaseAndSubscription -> {
          isSatisfied(SwiftNewPurchaseRequirement.AppPurchase) &&
            isSatisfied(SwiftNewPurchaseRequirement.Subscription(requirement.productIds))
        }
      }
    }

  /** Re-queries Play (restore) then evaluates the requirement. */
  suspend fun restoreAndCheck(requirement: SwiftNewPurchaseRequirement): Boolean =
    isSatisfied(requirement)

  fun endConnection() {
    client?.endConnection()
    client = null
  }

  private fun matchesProductIds(purchase: Purchase, productIds: List<String>): Boolean {
    val designated =
      productIds.map { it.trim() }.filter { it.isNotEmpty() }
    if (designated.isEmpty()) return true
    return purchase.products.any { it in designated }
  }

  private suspend fun queryPurchases(productType: String): List<Purchase> {
    val billing = ensureConnected()
    return suspendCancellableCoroutine { continuation ->
      billing.queryPurchasesAsync(
        QueryPurchasesParams.newBuilder().setProductType(productType).build(),
      ) { result, purchases ->
        if (!continuation.isActive) return@queryPurchasesAsync
        if (result.responseCode != BillingClient.BillingResponseCode.OK) {
          continuation.resume(emptyList())
        } else {
          continuation.resume(purchases)
        }
      }
    }
  }

  private suspend fun ensureConnected(): BillingClient =
    mutex.withLock {
      val existing = client
      if (existing != null && existing.isReady) return@withLock existing

      existing?.endConnection()
      val created =
        BillingClient.newBuilder(appContext)
          .setListener { _, _ -> }
          .enablePendingPurchases(
            PendingPurchasesParams.newBuilder().enableOneTimeProducts().build()
          )
          .build()
      client = created

      suspendCancellableCoroutine { continuation ->
        created.startConnection(
          object : BillingClientStateListener {
            override fun onBillingSetupFinished(billingResult: BillingResult) {
              if (!continuation.isActive) return
              if (billingResult.responseCode == BillingClient.BillingResponseCode.OK) {
                continuation.resume(created)
              } else {
                continuation.resumeWithException(
                  IllegalStateException(
                    "Billing setup failed: ${billingResult.debugMessage}"
                  )
                )
              }
            }

            override fun onBillingServiceDisconnected() {
              // Next call reconnects.
            }
          }
        )
      }
    }
}
