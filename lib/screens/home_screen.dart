import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/download_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<String>> images;

  @override
  void initState() {
    super.initState();
    images = ApiService.fetchImages();
  }

  void downloadImage(String url) async {
    String? path = await DownloadService.downloadFile(url, "image_${DateTime.now().millisecondsSinceEpoch}");
    if (path != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Downloaded to: $path")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Image Downloader")),
      body: FutureBuilder<List<String>>(
        future: images,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text("Error loading images"));

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              String imageUrl = snapshot.data![index];
              return ListTile(
                leading: Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                title: Text("Image ${index + 1}"),
                trailing: IconButton(
                  icon: Icon(Icons.download),
                  onPressed: () => downloadImage(imageUrl),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
