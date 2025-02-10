package com.anybackflow.reportflow

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import com.tom_roush.pdfbox.android.PDFBoxResourceLoader
import com.tom_roush.pdfbox.pdmodel.PDDocument
import java.io.File

class PdfPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "com.your.app/pdf")
        channel.setMethodCallHandler(this)
        context = binding.applicationContext
        PDFBoxResourceLoader.init(context)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "fillPdfForm" -> {
                try {
                    val templatePath = call.argument<String>("templatePath")
                        ?: throw IllegalArgumentException("templatePath is required")
                    val formData = call.argument<Map<String, String>>("formData")
                        ?: throw IllegalArgumentException("formData is required")
                    val outputPath = call.argument<String>("outputPath")
                        ?: throw IllegalArgumentException("outputPath is required")

                    fillPdfForm(templatePath, formData, outputPath)
                    result.success(null)
                } catch (e: Exception) {
                    result.error("PDF_ERROR", e.message, null)
                }
            }

            else -> result.notImplemented()
        }
    }

    private fun fillPdfForm(templatePath: String, formData: Map<String, String>, outputPath: String) {
        PDDocument.load(File(templatePath)).use { document ->
            val acroForm = document.documentCatalog.acroForm

            formData.forEach { (fieldName, value) ->
                acroForm.getField(fieldName)?.setValue(value)
            }

            document.save(outputPath)
        }
    }
}