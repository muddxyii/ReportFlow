package com.anybackflow.report_flow

import android.content.ContentResolver
import android.content.Intent
import android.database.Cursor
import android.net.Uri
import android.provider.OpenableColumns
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream

class MainActivity : FlutterActivity() {

    private val CHANNEL = "app_channel"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getInitialFilePath" -> {
                    val uri: Uri? = intent?.data
                    val filePath = uri?.let { resolveContentUriToFilePath(it) }
                    result.success(filePath)
                }

                else -> result.notImplemented()
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)

        val uri: Uri? = intent.data
        val filePath = uri?.let { resolveContentUriToFilePath(it) }
        flutterEngine?.let { engine ->
            MethodChannel(engine.dartExecutor.binaryMessenger, CHANNEL).invokeMethod(
                "onNewFilePath",
                filePath
            )
        }
    }

    private fun resolveContentUriToFilePath(uri: Uri): String? {
        return try {
            if (ContentResolver.SCHEME_CONTENT == uri.scheme) {
                val cursor: Cursor? = contentResolver.query(uri, null, null, null, null)
                cursor?.use {
                    val nameIndex = it.getColumnIndex(OpenableColumns.DISPLAY_NAME)
                    if (it.moveToFirst() && nameIndex >= 0) {
                        val fileName = it.getString(nameIndex)
                        val tempFile = File(cacheDir, fileName)
                        contentResolver.openInputStream(uri)?.use { inputStream ->
                            FileOutputStream(tempFile).use { outputStream ->
                                inputStream.copyTo(outputStream)
                            }
                        }
                        return tempFile.absolutePath
                    }
                }
            }
            null
        } catch (e: Exception) {
            null
        }
    }
}
