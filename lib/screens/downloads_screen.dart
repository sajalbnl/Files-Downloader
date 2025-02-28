import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DownloadsScreen extends StatefulWidget {
  @override
  _DownloadsScreenState createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  List<File> downloadedFiles = [];

  @override
  void initState() {
    super.initState();
    fetchDownloads();
  }

  Future<void> fetchDownloads() async {
    Directory? dir = await getExternalStorageDirectory();
    List<FileSystemEntity> files = dir!.listSync();

    setState(() {
      downloadedFiles = files.whereType<File>().toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Downloads")),
      body: downloadedFiles.isEmpty
          ? Center(child: Text("No Downloads"))
          : ListView.builder(
        itemCount: downloadedFiles.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.file(downloadedFiles[index], width: 50, height: 50, fit: BoxFit.cover),
            title: Text(downloadedFiles[index].path.split('/').last),
          );
        },
      ),
    );
  }
}
