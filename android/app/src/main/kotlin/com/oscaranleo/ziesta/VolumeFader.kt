package com.oscaranleo.ziesta

import android.content.Context
import android.media.AudioManager
import kotlin.math.roundToInt

object VolumeFader {
    private const val FILE = "ziesta_volume"
    private const val KEY_ORIGINAL = "original"
    private const val IGNORE_MILLIS = 1_500L

    /** Volume increases before this time come from our own restore, not the user. */
    @Volatile
    var ignoreIncreasesUntil = 0L
        private set

    private fun audio(context: Context) =
        context.getSystemService(Context.AUDIO_SERVICE) as AudioManager

    private fun prefs(context: Context) =
        context.getSharedPreferences(FILE, Context.MODE_PRIVATE)

    fun begin(context: Context) {
        val prefs = prefs(context)
        if (!prefs.contains(KEY_ORIGINAL)) {
            val current = audio(context).getStreamVolume(AudioManager.STREAM_MUSIC)
            prefs.edit().putInt(KEY_ORIGINAL, current).apply()
        }
    }

    fun setProgress(context: Context, progress: Float) {
        val original = prefs(context).getInt(KEY_ORIGINAL, -1)
        if (original < 0) return
        val target = (original * (1f - progress)).roundToInt()
        val audio = audio(context)
        if (audio.getStreamVolume(AudioManager.STREAM_MUSIC) != target) {
            audio.setStreamVolume(AudioManager.STREAM_MUSIC, target, 0)
        }
    }

    fun restore(context: Context) {
        val prefs = prefs(context)
        val original = prefs.getInt(KEY_ORIGINAL, -1)
        if (original >= 0) {
            ignoreIncreasesUntil = System.currentTimeMillis() + IGNORE_MILLIS
            audio(context).setStreamVolume(AudioManager.STREAM_MUSIC, original, 0)
            prefs.edit().remove(KEY_ORIGINAL).apply()
        }
    }
}