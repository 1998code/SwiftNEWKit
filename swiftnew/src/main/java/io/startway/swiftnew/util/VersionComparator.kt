package io.startway.swiftnew.util

object VersionComparator {
  /** Returns true when [candidate] is newer than [current]. */
  fun isNewer(candidate: String, current: String): Boolean = compare(candidate, current) > 0

  fun compare(left: String, right: String): Int {
    val leftParts = left.split('.', '-', '_').mapNotNull { it.toIntOrNull() }
    val rightParts = right.split('.', '-', '_').mapNotNull { it.toIntOrNull() }
    val length = maxOf(leftParts.size, rightParts.size)
    for (index in 0 until length) {
      val leftValue = leftParts.getOrElse(index) { 0 }
      val rightValue = rightParts.getOrElse(index) { 0 }
      if (leftValue != rightValue) {
        return leftValue.compareTo(rightValue)
      }
    }
    return 0
  }
}
