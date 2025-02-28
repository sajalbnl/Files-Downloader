import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class DownloadService {
  static Future<String?> downloadFile(String url, String fileName) async {
    try {
      // Request storage permission (Only required for Android < 10)
      if (Platform.isAndroid) {
        var status = await Permission.storage.request();
        if (!status.isGranted) return null;
      }

      String filePath = "";

      if (Platform.isAndroid && await _isAndroid10OrAbove()) {
        filePath = await _saveFileToGalleryAndroid10Plus(url, fileName);
      } else {
        filePath = await _saveFileToGalleryBelowAndroid10(url, fileName);
      }

      return filePath;
    } catch (e) {
      debugPrint("Error downloading: $e");
      return null;
    }
  }

  /// **For Android 10+ (Scoped Storage)**
  static Future<String> _saveFileToGalleryAndroid10Plus(String url, String fileName) async {
    try {
      final response = await Dio().get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      final dir = await getApplicationDocumentsDirectory();
      final tempFile = File('${dir.path}/$fileName.jpg');
      await tempFile.writeAsBytes(response.data);

      final result = await _saveToGallery(tempFile, fileName);
      return result;
    } catch (e) {
      debugPrint("Error saving to gallery (Android 10+): $e");
      throw e;
    }
  }

  /// **For Android 9 and below**
  static Future<String> _saveFileToGalleryBelowAndroid10(String url, String fileName) async {
    Directory? directory = await getExternalStorageDirectory();
    String filePath = '${directory!.path}/$fileName.jpg';

    await Dio().download(url, filePath);

    await _saveToGallery(File(filePath), fileName);
    return filePath;
  }

  /// **Save file to Gallery**
  static Future<String> _saveToGallery(File file, String fileName) async {
    final result = await _channel.invokeMethod('saveImageToGallery', {
      'filePath': file.path,
      'fileName': fileName,
    });
    return result;
  }

  /// **Check Android version**
  static Future<bool> _isAndroid10OrAbove() async {
    final version = await _channel.invokeMethod<int>('getAndroidVersion');
    return version != null && version >= 10;
  }

  static const MethodChannel _channel = MethodChannel('gallery_saver');
}
