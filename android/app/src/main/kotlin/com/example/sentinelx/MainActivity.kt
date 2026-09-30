package com.example.sentinelx
import android.app.admin.DevicePolicyManager
import android.content.*
import android.net.Uri
import android.os.Build
import androidx.core.content.ContextCompat
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.example.sentinelx.alarm.AlarmService
import com.example.sentinelx.security.SecurityDeviceAdminReceiver
import com.example.sentinelx.security.SecurityStateStore

class MainActivity:FlutterActivity(){
 companion object{const val CHANNEL="com.example.sentinelx/security"}
 private lateinit var dpm:DevicePolicyManager
 private lateinit var admin:ComponentName
 override fun configureFlutterEngine(engine:FlutterEngine){super.configureFlutterEngine(engine);dpm=getSystemService(DEVICE_POLICY_SERVICE) as DevicePolicyManager;admin=ComponentName(this,SecurityDeviceAdminReceiver::class.java);MethodChannel(engine.dartExecutor.binaryMessenger,CHANNEL).setMethodCallHandler{call,result->when(call.method){"enableDeviceAdmin"->{enableAdmin();result.success(true)};"isDeviceAdminEnabled"->result.success(dpm.isAdminActive(admin));"getFailedAttempts"->result.success(SecurityStateStore.getFailed(this));"resetFailedAttempts"->{SecurityStateStore.reset(this);result.success(null)};"hasPendingCapture"->result.success(SecurityStateStore.isPending(this));"clearPendingCapture"->{SecurityStateStore.clearPending(this);result.success(null)};"startAlarm"->{startAlarm();result.success(null)};"stopAlarm"->{stopService(Intent(this,AlarmService::class.java));result.success(null)};"shareInstalledApk"->{shareApk();result.success(null)};else->result.notImplemented()}}}
 private fun enableAdmin(){if(dpm.isAdminActive(admin))return;startActivity(Intent(DevicePolicyManager.ACTION_ADD_DEVICE_ADMIN).apply{putExtra(DevicePolicyManager.EXTRA_DEVICE_ADMIN,admin);putExtra(DevicePolicyManager.EXTRA_ADD_EXPLANATION,"SentinelX uses supported Android device security events to detect failed unlock attempts.")})}
 private fun startAlarm(){val i=Intent(this,AlarmService::class.java);if(Build.VERSION.SDK_INT>=26)ContextCompat.startForegroundService(this,i) else startService(i)}
 private fun shareApk(){val apk=applicationInfo.sourceDir;val uri:Uri=FileProvider.getUriForFile(this,"$packageName.fileprovider",java.io.File(apk));startActivity(Intent.createChooser(Intent(Intent.ACTION_SEND).apply{type="application/vnd.android.package-archive";putExtra(Intent.EXTRA_STREAM,uri);addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)},"Share SentinelX"))}
}
