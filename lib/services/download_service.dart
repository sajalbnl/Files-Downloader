import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class DownloadService {
  static Future<String?> downloadFile(String url, String fileName) async {
    try {
      // Request storage permission when downloading for the first time
      if (Platform.isAndroid) {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
          if (!status.isGranted) return null; // Return if permission is denied
        }
      }

      // Get app's private storage directory
      Directory directory = await getApplicationDocumentsDirectory();
      String filePath = '${directory.path}/$fileName.jpg';

      // Download file
      await Dio().download(url, filePath);

      // Save to gallery
      await _saveToGallery(File(filePath), fileName);

      return filePath;
    } catch (e) {
      debugPrint("Error downloading: $e");
      return null;
    }
  }

  /// **Save file to Gallery**
  static Future<void> _saveToGallery(File file, String fileName) async {
    try {
      await _channel.invokeMethod('saveImageToGallery', {
        'filePath': file.path,
        'fileName': fileName,
      });
    } catch (e) {
      debugPrint("Error saving to gallery: $e");
    }
  }

  static const MethodChannel _channel = MethodChannel('gallery_saver');
}
