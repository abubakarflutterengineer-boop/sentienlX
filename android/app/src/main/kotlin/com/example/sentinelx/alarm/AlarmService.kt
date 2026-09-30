package com.example.sentinelx.alarm
import android.app.*
import android.content.*
import android.media.*
import android.os.*
import android.provider.Settings
import androidx.core.app.NotificationCompat
import com.example.sentinelx.R
class AlarmService:Service(){
 companion object{const val CHANNEL="sentinelx_alarm";const val ID=1001}
 private var player:MediaPlayer?=null
 override fun onCreate(){super.onCreate();channel();startForeground(ID,notification());try{player=MediaPlayer.create(this,Settings.System.DEFAULT_ALARM_ALERT_URI);player?.isLooping=true;player?.start()}catch(_:Exception){}}
 private fun channel(){if(Build.VERSION.SDK_INT>=26){val m=getSystemService(NotificationManager::class.java);m.createNotificationChannel(NotificationChannel(CHANNEL,"Security Alarm",NotificationManager.IMPORTANCE_HIGH))}}
 private fun notification():Notification=NotificationCompat.Builder(this,CHANNEL).setSmallIcon(R.mipmap.ic_launcher).setContentTitle("SentinelX Alarm").setContentText("Security alert is active").setOngoing(true).setPriority(NotificationCompat.PRIORITY_MAX).build()
 override fun onDestroy(){player?.stop();player?.release();player=null;super.onDestroy()}
 override fun onBind(intent:Intent?):IBinder?=null
}
