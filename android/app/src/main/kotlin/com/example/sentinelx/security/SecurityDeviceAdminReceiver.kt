package com.example.sentinelx.security
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.core.app.NotificationCompat
import com.example.sentinelx.MainActivity
import com.example.sentinelx.R
import android.app.admin.DeviceAdminReceiver

class SecurityDeviceAdminReceiver: DeviceAdminReceiver() {
 companion object { const val CHANNEL="sentinelx_security"; const val NOTIFICATION=77; const val THRESHOLD=3 }
 override fun onPasswordFailed(context:Context,intent:Intent,user:android.os.UserHandle){
  super.onPasswordFailed(context,intent,user)
  val count=SecurityStateStore.increment(context)
  if(count>=THRESHOLD && count%THRESHOLD==0){
   SecurityStateStore.setPending(context,true)
   showAlert(context,count)
  }
 }
 override fun onPasswordSucceeded(context:Context,intent:Intent,user:android.os.UserHandle){ super.onPasswordSucceeded(context,intent,user); SecurityStateStore.reset(context) }
 private fun showAlert(context:Context,count:Int){
  val manager=context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
  if(Build.VERSION.SDK_INT>=26) manager.createNotificationChannel(NotificationChannel(CHANNEL,"Security Alerts",NotificationManager.IMPORTANCE_HIGH))
  val open=PendingIntent.getActivity(context,0,Intent(context,MainActivity::class.java).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP),PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
  val n=NotificationCompat.Builder(context,CHANNEL).setSmallIcon(R.mipmap.ic_launcher).setContentTitle("SentinelX security alert").setContentText("$count failed unlock attempts. Open SentinelX to capture evidence.").setPriority(NotificationCompat.PRIORITY_MAX).setAutoCancel(true).setContentIntent(open).build()
  manager.notify(NOTIFICATION,n)
 }
}
