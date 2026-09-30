package com.example.sentinelx.security
import android.content.Context
object SecurityStateStore {
 private const val PREF="sentinelx_security"; private const val FAILED="failed"; private const val PENDING="pending"
 private fun p(c:Context)=c.getSharedPreferences(PREF,Context.MODE_PRIVATE)
 fun getFailed(c:Context)=p(c).getInt(FAILED,0)
 fun setFailed(c:Context,v:Int)=p(c).edit().putInt(FAILED,v).apply()
 fun increment(c:Context):Int{val n=getFailed(c)+1;setFailed(c,n);return n}
 fun reset(c:Context)=setFailed(c,0)
 fun setPending(c:Context,v:Boolean)=p(c).edit().putBoolean(PENDING,v).apply()
 fun isPending(c:Context)=p(c).getBoolean(PENDING,false)
 fun clearPending(c:Context)=setPending(c,false)
}
