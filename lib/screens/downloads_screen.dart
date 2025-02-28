import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DownloadsScreen extends StatefulWidget {
  @override
  _DownloadsScreenState createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  List<FileSystemEntity> downloadedFiles = [];

  @override
  void initState() {
    super.initState();
    fetchDownloads();
  }

  Future<void> fetchDownloads() async {
    try {
      Directory dir = await getApplicationDocumentsDirectory();
      List<FileSystemEntity> files = dir.listSync();

      setState(() {
        downloadedFiles = files
            .where((file) =>
        file is File &&
            !file.path.split('/').last.startsWith('res_timestamp-')) // Excluded unwanted files
            .toList();
      });
    } catch (e) {
      debugPrint("Error fetching downloads: $e");
    }
  }


  // Function to check if the file is an image
  bool isImageFile(String path) {
    return path.endsWith('.png') ||
        path.endsWith('.jpg') ||
        path.endsWith('.jpeg') ||
        path.endsWith('.gif') ||
        path.endsWith('.webp');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Downloads")),
      body: downloadedFiles.isEmpty
          ? Center(
        child: Text(
          "No Downloads",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.separated(
        itemCount: downloadedFiles.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          File file = File(downloadedFiles[index].path);
          String fileName = file.path.split('/').last;

          return ListTile(
            leading: isImageFile(file.path)
                ? Image.file(file, width: 120, height: 150, fit: BoxFit.fill)
                : Icon(Icons.insert_drive_file, size: 50, color: Colors.grey),
            title: Text(fileName),
          );
        },
      ),
    );
  }
}
