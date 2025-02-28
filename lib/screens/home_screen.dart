import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/download_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<String>> images;
  List<String> allImages = [];
  List<String> filteredImages = [];
  TextEditingController searchController = TextEditingController();
  Map<String, bool> isDownloading = {}; // Track download state

  @override
  void initState() {
    super.initState();
    images = ApiService.fetchImages();
    images.then((value) {
      setState(() {
        allImages = value;
        filteredImages = value;
      });
    });
  }

  void downloadImage(String url) async {
    setState(() {
      isDownloading[url] = true;
    });

    String? path = await DownloadService.downloadFile(
        url, "image_${DateTime.now().millisecondsSinceEpoch}");

    setState(() {
      isDownloading[url] = false;
    });

    if (path != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Downloaded to: $path")));
    }
  }

  void filterImages(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredImages = allImages;
      });
      return;
    }

    setState(() {
      filteredImages = allImages
          .where((image) => (allImages.indexOf(image) + 1)
          .toString()
          .contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Image Downloader")),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: searchController,
                onChanged: filterImages,
                decoration: InputDecoration(
                  labelText: "Search by Index",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            Expanded(
              child: FutureBuilder<List<String>>(
                future: images,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error loading images"));
                  }

                  return ListView.separated(
                    itemCount: filteredImages.length,
                    separatorBuilder: (context, index) => Divider(),
                    itemBuilder: (context, index) {
                      String imageUrl = filteredImages[index];
                      int originalIndex = allImages.indexOf(imageUrl) + 1;

                      return ListTile(
                        leading: Image.network(
                          imageUrl,
                          width: 120,
                          height: 150,
                          fit: BoxFit.fill,
                        ),
                        title: Center(child: Text("Image $originalIndex",style: TextStyle(fontWeight: FontWeight.bold),)),
                        trailing: SizedBox(
                          width: 40,
                          child: isDownloading[imageUrl] == true
                              ? Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 4),
                            ),
                          )
                              : IconButton(
                            icon: Icon(Icons.download),
                            onPressed: () => downloadImage(imageUrl),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
