package io.startway.swiftnew.data

import android.content.Context
import io.startway.swiftnew.model.VersionRelease
import java.net.HttpURLConnection
import java.net.URL
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import kotlinx.serialization.json.Json

object ReleaseNotesLoader {
  private val json =
    Json {
      ignoreUnknownKeys = true
      isLenient = true
    }

  suspend fun load(
    context: Context,
    source: String = "data",
    assetFileName: String = "$source.json",
  ): List<VersionRelease> =
    withContext(Dispatchers.IO) {
      if (looksRemote(source)) {
        loadRemote(source)
      } else {
        loadAsset(context, assetFileName)
      }
    }

  fun decode(rawJson: String): List<VersionRelease> = json.decodeFromString(rawJson)

  private fun loadAsset(context: Context, assetFileName: String): List<VersionRelease> {
    context.assets.open(assetFileName).bufferedReader().use { reader ->
      return json.decodeFromString(reader.readText())
    }
  }

  private fun loadRemote(source: String): List<VersionRelease> {
    val url = URL(source)
    val connection = (url.openConnection() as HttpURLConnection).apply {
      connectTimeout = 15_000
      readTimeout = 15_000
      requestMethod = "GET"
    }

    try {
      val statusCode = connection.responseCode
      if (statusCode !in 200 until 300) {
        error("HTTP $statusCode loading release notes")
      }
      val body = connection.inputStream.bufferedReader().use { it.readText() }
      return json.decodeFromString(body)
    } finally {
      connection.disconnect()
    }
  }

  private fun looksRemote(source: String): Boolean {
    val normalized = source.trim().lowercase()
    return normalized.startsWith("http://") || normalized.startsWith("https://")
  }
}
