package com.example.sentinelx.alarm

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Intent
import android.media.AudioAttributes
import android.media.MediaPlayer
import android.os.Build
import android.os.IBinder
import android.provider.Settings
import androidx.core.app.NotificationCompat
import com.example.sentinelx.R

class AlarmService : Service() {

    companion object {
        private const val CHANNEL_ID =
            "sentinelx_security_alarm"

        private const val NOTIFICATION_ID = 1001
    }

    private var mediaPlayer: MediaPlayer? = null

    override fun onCreate() {
        super.onCreate()

        createNotificationChannel()

        startForeground(
            NOTIFICATION_ID,
            createNotification()
        )

        startAlarmSound()
    }

    override fun onStartCommand(
        intent: Intent?,
        flags: Int,
        startId: Int
    ): Int {

        if (mediaPlayer == null) {
            startAlarmSound()
        }

        return START_STICKY
    }

    private fun startAlarmSound() {
        try {
            val audioUri =
                Settings.System.DEFAULT_ALARM_ALERT_URI

            mediaPlayer =
                MediaPlayer.create(
                    this,
                    audioUri
                )

            mediaPlayer?.apply {
                isLooping = true

                if (Build.VERSION.SDK_INT >=
                    Build.VERSION_CODES.LOLLIPOP
                ) {
                    setAudioAttributes(
                        AudioAttributes.Builder()
                            .setUsage(
                                AudioAttributes.USAGE_ALARM
                            )
                            .setContentType(
                                AudioAttributes.CONTENT_TYPE_SONIFICATION
                            )
                            .build()
                    )
                }

                start()
            }

        } catch (exception: Exception) {
            exception.printStackTrace()
        }
    }

    private fun createNotification(): Notification {
        return NotificationCompat.Builder(
            this,
            CHANNEL_ID
        )
            .setContentTitle(
                "SentinelX Security Alert"
            )
            .setContentText(
                "Your device security alarm is active."
            )
            .setSmallIcon(
                R.mipmap.ic_launcher
            )
            .setPriority(
                NotificationCompat.PRIORITY_MAX
            )
            .setOngoing(true)
            .build()
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >=
            Build.VERSION_CODES.O
        ) {
            val channel =
                NotificationChannel(
                    CHANNEL_ID,
                    "SentinelX Security Alarm",
                    NotificationManager.IMPORTANCE_HIGH
                )

            channel.description =
                "Security alarm notification"

            val manager =
                getSystemService(
                    NotificationManager::class.java
                )

            manager.createNotificationChannel(
                channel
            )
        }
    }

    override fun onDestroy() {
        mediaPlayer?.stop()
        mediaPlayer?.release()
        mediaPlayer = null

        super.onDestroy()
    }

    override fun onBind(
        intent: Intent?
    ): IBinder? {
        return null
    }
}