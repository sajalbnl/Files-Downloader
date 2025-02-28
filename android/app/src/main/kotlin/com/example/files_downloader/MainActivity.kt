package com.example.files_downloader

import io.flutter.embedding.android.FlutterActivity

import android.content.ContentValues
import android.os.Build
import android.provider.MediaStore
import android.util.Log
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileInputStream
import java.io.OutputStream

class MainActivity : FlutterActivity() {
    private val CHANNEL = "gallery_saver"

    override fun configureFlutterEngine(flutterEngine: io.flutter.embedding.engine.FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "saveImageToGallery" -> {
                    val filePath = call.argument<String>("filePath") ?: return@setMethodCallHandler
                    val fileName = call.argument<String>("fileName") ?: return@setMethodCallHandler
                    val success = saveImageToGallery(filePath, fileName)
                    result.success(if (success) "Saved Successfully" else "Failed to Save")
                }
                "getAndroidVersion" -> {
                    result.success(Build.VERSION.SDK_INT)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun saveImageToGallery(filePath: String, fileName: String): Boolean {
        return try {
            val inputFile = File(filePath)
            if (!inputFile.exists()) return false

            val resolver = applicationContext.contentResolver
            val contentValues = ContentValues().apply {
                put(MediaStore.Images.Media.DISPLAY_NAME, "$fileName.jpg")
                put(MediaStore.Images.Media.MIME_TYPE, "image/jpeg")
                put(MediaStore.Images.Media.RELATIVE_PATH, "Pictures/DownloadedImages")
            }

            val uri = resolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, contentValues)
            uri?.let {
                val outputStream: OutputStream? = resolver.openOutputStream(it)
                outputStream?.use { output ->
                    FileInputStream(inputFile).use { input -> input.copyTo(output) }
                }
                true
            } ?: false
        } catch (e: Exception) {
            Log.e("GallerySaver", "Error saving image: ${e.message}")
            false
        }
    }
}
