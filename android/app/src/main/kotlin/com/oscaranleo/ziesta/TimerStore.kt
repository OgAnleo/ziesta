package com.oscaranleo.ziesta

import android.content.Context

object TimerStore {
    private const val FILE = "ziesta_timer"
    private const val KEY_END = "end_millis"

    private fun prefs(context: Context) =
        context.getSharedPreferences(FILE, Context.MODE_PRIVATE)

    fun saveEnd(context: Context, endMillis: Long) {
        prefs(context).edit().putLong(KEY_END, endMillis).apply()
    }

    fun getEnd(context: Context): Long? {
        val value = prefs(context).getLong(KEY_END, -1L)
        return if (value > 0) value else null
    }

    fun clear(context: Context) {
        prefs(context).edit().remove(KEY_END).apply()
    }
}