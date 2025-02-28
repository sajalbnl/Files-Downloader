import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl = "https://free-images-api.p.rapidapi.com/v2/cat/1";
  static const Map<String, String> headers = {
    'x-rapidapi-host': 'free-images-api.p.rapidapi.com',
    'x-rapidapi-key': '78a2bdd017msh5b5dce52e24e172p1d492cjsnacd8e8dd3f95',  // Replace with your key
  };

  static Future<List<String>> fetchImages() async {
    final response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List).map((e) => e['image'] as String).toList();
    } else {
      throw Exception("Failed to fetch images");
    }
  }
}
