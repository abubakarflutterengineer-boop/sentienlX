package com.example.sentinelx.security

import android.app.admin.DeviceAdminReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class SecurityDeviceAdminReceiver :
    DeviceAdminReceiver() {

    companion object {
        private const val TAG = "SentinelX"
        private const val THRESHOLD = 3
    }

    override fun onPasswordFailed(
        context: Context,
        intent: Intent
    ) {
        super.onPasswordFailed(
            context,
            intent
        )

        val attempts =
            SecurityStateStore
                .incrementFailedAttempts(context)

        Log.d(
            TAG,
            "Failed device credential attempts: $attempts"
        )

        if (attempts >= THRESHOLD) {
            Log.d(
                TAG,
                "SentinelX security threshold reached"
            )
        }
    }

    override fun onEnabled(
        context: Context,
        intent: Intent
    ) {
        super.onEnabled(
            context,
            intent
        )

        Log.d(
            TAG,
            "SentinelX device admin enabled"
        )
    }

    override fun onDisabled(
        context: Context,
        intent: Intent
    ) {
        super.onDisabled(
            context,
            intent
        )

        SecurityStateStore
            .resetFailedAttempts(context)

        Log.d(
            TAG,
            "SentinelX device admin disabled"
        )
    }
}