package com.example.tele_book

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.IBinder
import android.os.PowerManager
import androidx.core.app.NotificationCompat
import androidx.core.app.ServiceCompat

/**
 * 同步保活前台服务（Android 原生）：Flutter 队列执行同步/上传时启动，
 * 持有 PARTIAL_WAKE_LOCK 保持 CPU 唤醒并维持前台通知，防止熄屏后
 * 进程被挂起/网络连接被掐断（Doze/Standby 下 Dio socket abort）。
 *
 * 任务本身仍在 Flutter（Dart）侧执行；本服务只负责"保活 + 前台可见"。
 * 进程若仍被系统回收，由客户端的 sync_op 中断恢复机制在下次启动兜底。
 */
class SyncForegroundService : Service() {

    companion object {
        const val CHANNEL_ID = "telebook_sync"
        const val NOTIFICATION_ID = 1001
        const val EXTRA_TEXT = "text"
        private var wakeLock: PowerManager.WakeLock? = null
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        createChannel()
        ensureWakeLock()

        val text = intent?.getStringExtra(EXTRA_TEXT) ?: "正在同步…"
        startAsForeground(text)
        return START_NOT_STICKY // 进程被杀不自动复活：交给客户端中断恢复
    }

    private fun startAsForeground(text: String) {
        val pi = PendingIntent.getActivity(
            this, 0,
            Intent(this, MainActivity::class.java),
            PendingIntent.FLAG_IMMUTABLE,
        )
        val notification: Notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(android.R.drawable.stat_notify_sync)
            .setContentTitle("TeleBook 正在同步")
            .setContentText(text)
            .setOngoing(true)
            .setContentIntent(pi)
            .build()

        // Android 14+ 必须声明 dataSync 前台服务类型；旧版本传 0 即可
        val type = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            ServiceInfo.FOREGROUND_SERVICE_TYPE_DATA_SYNC
        } else {
            0
        }
        ServiceCompat.startForeground(this, NOTIFICATION_ID, notification, type)
    }

    private fun createChannel() {
        val manager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        val channel = NotificationChannel(
            CHANNEL_ID, "同步任务", NotificationManager.IMPORTANCE_LOW,
        ).apply {
            description = "同步/上传进行中保持应用在后台运行"
            setShowBadge(false)
        }
        manager.createNotificationChannel(channel)
    }

    private fun ensureWakeLock() {
        if (wakeLock?.isHeld == true) return
        val pm = getSystemService(POWER_SERVICE) as PowerManager
        wakeLock = pm.newWakeLock(
            PowerManager.PARTIAL_WAKE_LOCK, "TeleBook:sync",
        ).apply {
            setReferenceCounted(false)
            acquire()
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        wakeLock?.let {
            if (it.isHeld) it.release()
        }
        wakeLock = null
    }
}
