import 'dart:convert';

List<NewModel> newModelFromGNews(
  String str,
) {

  final jsonData = json.decode(str);

  final List articles =
      jsonData['articles'] ?? [];

  return articles
      .map(
        (x) => NewModel.fromGNews(x),
      )
      .toList();
}

class NewModel {

  final String title;
  final String description;
  final String content;
  final String image;
  final String url;
  final String creationAt;
  final String category;

  NewModel({
    required this.title,
    required this.description,
    required this.content,
    required this.image,
    required this.url,
    required this.creationAt,
    required this.category,
  });

  factory NewModel.fromGNews(
    Map<String, dynamic> json,
  ) {

    return NewModel(
      title: json["title"] ?? "",

      description:
          json["description"] ?? "",

      content:
          json["content"] ?? "",

      image:
          json["image"] ?? "",

      url:
          json["url"] ?? "",

      creationAt:
          json["publishedAt"] ?? "",

      category: "",
    );
  }
}