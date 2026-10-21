package com.oscaranleo.ziesta

import android.app.Activity
import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent

// Optional "lock the screen when the timer ends" feature. Self-contained: to remove it, delete
// this file, LockAdminReceiver, res/xml/device_admin.xml, the manifest <receiver>, the
// lock_admin_explanation strings and the lock calls in MainActivity, TimerReceiver and TimerStore.
object LockController {
    private fun policyManager(context: Context) =
        context.getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager

    private fun admin(context: Context) = ComponentName(context, LockAdminReceiver::class.java)

    fun isActive(context: Context): Boolean =
        policyManager(context).isAdminActive(admin(context))

    fun requestActivation(activity: Activity, requestCode: Int) {
        val intent = Intent(DevicePolicyManager.ACTION_ADD_DEVICE_ADMIN).apply {
            putExtra(DevicePolicyManager.EXTRA_DEVICE_ADMIN, admin(activity))
            putExtra(
                DevicePolicyManager.EXTRA_ADD_EXPLANATION,
                activity.getString(R.string.lock_admin_explanation)
            )
        }
        @Suppress("DEPRECATION")
        activity.startActivityForResult(intent, requestCode)
    }

    fun remove(context: Context) {
        if (isActive(context)) {
            policyManager(context).removeActiveAdmin(admin(context))
        }
    }

    fun lockIfEnabled(context: Context) {
        if (TimerStore.getLockOnEnd(context) && isActive(context)) {
            policyManager(context).lockNow()
        }
    }
}
