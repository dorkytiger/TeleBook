package com.dorkytiger.tele_book

import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // 创建下载通知渠道
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager

            // 创建下载通知渠道
            val downloadChannel = NotificationChannel(
                "background_downloader",
                "下载管理",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "显示文件下载进度和状态"
                setShowBadge(false)
                enableVibration(false)
            }
            notificationManager.createNotificationChannel(downloadChannel)

            // 创建前台服务通知渠道
            val foregroundChannel = NotificationChannel(
                "background_downloader_foreground",
                "后台下载服务",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "保持后台下载服务运行"
                setShowBadge(false)
                enableVibration(false)
            }
            notificationManager.createNotificationChannel(foregroundChannel)
        }
    }
}
