import 'dart:convert';

class AuthorData {
  String name;
  String avatarUrl;
  String avatarUrlHD;
  int userID;
  String description;
  String url;
  List<String> savedArticles;
  AuthorData({
    required this.name,
    required this.avatarUrl,
    required this.userID,
    required this.description,
    required this.url,
    required this.avatarUrlHD,
    required this.savedArticles,
  });

  factory AuthorData.fromMap(Map<String, dynamic> map) {
    return AuthorData(
      name: map['Nombre'] ?? '',
      avatarUrl: map['avatar_urls']['24'] ?? '',
      avatarUrlHD: map['avatar_urls']['96'] ?? '',
      userID: map['id']?.toInt() ?? 0,
      description: map['Descripcio'],
      url: map['url'],
      savedArticles: map['Articulos Guardados'] != null
          ? List<String>.from(map['Articulos Guardados'])
          : [],
    );
  }

  factory AuthorData.fromJson(String source) =>
      AuthorData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AuthorData(name: $name, avatarUrl: $avatarUrl, avatarUrlHD: $avatarUrlHD, userID: $userID, description: $description, url: $url, savedArticles: $savedArticles)';
  }
}
