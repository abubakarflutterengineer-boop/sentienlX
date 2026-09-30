package com.example.sentinelx.security

import android.content.Context

object SecurityStateStore {

    private const val PREF_NAME = "sentinelx_security"

    private const val FAILED_ATTEMPTS =
        "failed_attempts"

    private fun preferences(context: Context) =
        context.getSharedPreferences(
            PREF_NAME,
            Context.MODE_PRIVATE
        )

    fun getFailedAttempts(
        context: Context
    ): Int {
        return preferences(context)
            .getInt(FAILED_ATTEMPTS, 0)
    }

    fun setFailedAttempts(
        context: Context,
        value: Int
    ) {
        preferences(context)
            .edit()
            .putInt(
                FAILED_ATTEMPTS,
                value
            )
            .apply()
    }

    fun incrementFailedAttempts(
        context: Context
    ): Int {
        val current =
            getFailedAttempts(context)

        val next = current + 1

        setFailedAttempts(
            context,
            next
        )

        return next
    }

    fun resetFailedAttempts(
        context: Context
    ) {
        setFailedAttempts(
            context,
            0
        )
    }
}