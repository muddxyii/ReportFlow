package com.anybackflow.report_flow

import android.content.Intent
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "app_channel").setMethodCallHandler { call, result ->
            if (call.method == "getInitialFilePath") {
                val intent = activity.intent
                result.success(intent.data?.path)
            }
        }
    }
}