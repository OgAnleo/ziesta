package com.oscaranleo.ziesta

import android.content.Context

object TimerStore {
    private const val FILE = "ziesta_timer"
    private const val KEY_END = "end_millis"
    private const val KEY_EXTEND = "extend_minutes"
    private const val DEFAULT_EXTEND_MINUTES = 15
    private const val MIN_EXTEND_MINUTES = 1
    private const val MAX_EXTEND_MINUTES = 60
    private const val KEY_VOLUME_EXTEND = "volume_extend"
    private const val KEY_LOCK_ON_END = "lock_on_end"

    private fun prefs(context: Context) =
        context.getSharedPreferences(FILE, Context.MODE_PRIVATE)

    fun saveEnd(context: Context, endMillis: Long) {
        prefs(context).edit().putLong(KEY_END, endMillis).apply()
    }

    fun getEnd(context: Context): Long? {
        val value = prefs(context).getLong(KEY_END, -1L)
        return if (value > 0) value else null
    }

    fun getExtendMinutes(context: Context): Int =
        prefs(context)
            .getInt(KEY_EXTEND, DEFAULT_EXTEND_MINUTES)
            .coerceIn(MIN_EXTEND_MINUTES, MAX_EXTEND_MINUTES)

    fun saveExtendMinutes(context: Context, minutes: Int) {
        val value = minutes.coerceIn(MIN_EXTEND_MINUTES, MAX_EXTEND_MINUTES)
        prefs(context).edit().putInt(KEY_EXTEND, value).apply()
    }

    fun getVolumeExtend(context: Context): Boolean =
        prefs(context).getBoolean(KEY_VOLUME_EXTEND, true)

    fun saveVolumeExtend(context: Context, enabled: Boolean) {
        prefs(context).edit().putBoolean(KEY_VOLUME_EXTEND, enabled).apply()
    }

    fun getLockOnEnd(context: Context): Boolean =
        prefs(context).getBoolean(KEY_LOCK_ON_END, false)

    fun saveLockOnEnd(context: Context, enabled: Boolean) {
        prefs(context).edit().putBoolean(KEY_LOCK_ON_END, enabled).apply()
    }

    fun clear(context: Context) {
        prefs(context).edit().remove(KEY_END).apply()
    }
}