import 'dart:convert';
import 'package:http/http.dart' as http;
import 'new_model.dart';

class NewService {
  final String _apiKey = "3797e8b0557079dc39b153fe861d5bc0";

  Future<List<NewModel>> readNews(String category) async {
    final url =
        "https://gnews.io/api/v4/top-headlines"
        "?category=$category"
        "&lang=en"
        "&apikey=$_apiKey";

    final response = await http.get(Uri.parse(url));

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["articles"] == null) {
        throw Exception("No articles found");
      }

      final List articles = data["articles"];

      return articles.map((json) {
        return NewModel.fromGNews(json);
      }).toList();
    } else {
      throw Exception("Failed: ${response.statusCode}");
    }
  }

  Future<List<NewModel>> searchNews(String query) async {
    final url =
        "https://gnews.io/api/v4/search"
        "?q=${Uri.encodeComponent(query)}"
        "&lang=en"
        "&apikey=$_apiKey";

    final response = await http.get(Uri.parse(url));

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["articles"] == null) {
        throw Exception("No search results");
      }

      final List articles = data["articles"];

      return articles.map((json) {
        return NewModel.fromGNews(json);
      }).toList();
    } else {
      throw Exception("Search failed: ${response.statusCode}");
    }
  }
}
