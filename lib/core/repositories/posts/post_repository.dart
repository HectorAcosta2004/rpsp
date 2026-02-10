import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/wp_config.dart';
import '../../controllers/dio/dio_provider.dart';
import '../../logger/app_logger.dart';
import '../../models/article.dart';
import '../../utils/app_utils.dart';
import 'offline_post_repository.dart';

final postRepoProvider = Provider<PostRepository>((ref) {
  final dio = ref.read(dioProvider);
  final offlineRepo = ref.read(offlinePostRepoProvider);
  return PostRepository(dio, offlineRepo);
});

abstract class PostRepoAbstract {
  Future<List<ArticleModel>> getAllPost(
      {required int pageNumber, int perPage = 10});
  Future<List<ArticleModel>> getPostByCategory(
      {required int pageNumber, required int categoryID, int perPage = 10});
  Future<List<ArticleModel>> getPostByTag(
      {required int pageNumber, required int tagID, int perPage = 10});
  Future<List<ArticleModel>> getPostByAuthor(
      {required int pageNumber, required int authorID, int perPage = 10});
  Future<ArticleModel?> getPost({required int postID});
  Future<List<ArticleModel>> getPopularPosts({int perPage = 10});
  Future<List<ArticleModel>> getThesePosts({required List<int> ids});
  Future<List<ArticleModel>> searchPost({required String keyword});
  Future<ArticleModel?> getPostFromUrl({required String requestedURL});
  Future<List<ArticleModel>> getPostsBySlug({required String slug});
  Future<bool> reportPost({
    required int postID,
    required String postTitle,
    required String userEmail,
    required String userName,
    required String reportEmail,
  });
}

class PostRepository extends PostRepoAbstract {
  PostRepository(this.dio, this.offlineRepo);

  final Dio dio;
  final OfflinePostRepository offlineRepo;

  final String baseUrl = 'https://${WPConfig.url}/wp-json/wp/v2/posts';

  /// Helper: parse safely response.data as list
  List<dynamic> _parseResponseData(dynamic data) {
    if (data is List) {
      return data;
    } else if (data is Map<String, dynamic> && data['data'] is List) {
      return data['data'] as List;
    } else {
      return [];
    }
  }

  @override
  Future<List<ArticleModel>> getAllPost(
      {required int pageNumber, int perPage = 10}) async {
    final url = '$baseUrl?page=$pageNumber&per_page=$perPage';
    final List<ArticleModel> articles = [];

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200 || response.statusCode == 304) {
        final posts = _parseResponseData(response.data);
        for (final post in posts) {
          try {
            articles.add(ArticleModel.fromMap(post));
          } catch (e) {
            Log.error('Failed to parse article: $e');
          }
        }
      }
      if (pageNumber == 1 && articles.isNotEmpty) {
        _autoSavePostsForOffline(articles.take(10).toList());
      }
      return articles;
    } catch (e) {
      debugPrint('Network error: $e');
      return [];
    }
  }

  Future<void> _autoSavePostsForOffline(List<ArticleModel> posts) async {
    for (final post in posts) {
      if (!await offlineRepo.isPostSaved(post.id)) {
        await offlineRepo.savePost(post);
        Log.info('Saved post offline: ${post.title}');
      }
    }
  }

  // --- FUNCIÓN CORREGIDA CON DEBUG ---
  @override
  Future<List<ArticleModel>> getPostByCategory({
    required int pageNumber,
    required int categoryID,
    int perPage = 10,
  }) async {
    final url =
        '$baseUrl?categories=$categoryID&page=$pageNumber&per_page=$perPage';
    List<ArticleModel> articles = [];

    // --- DEBUG: Imprime la información de la petición ---
    debugPrint(
        '📢 [Categoría] Buscando posts para el ID de categoría: $categoryID');
    debugPrint('🔗 [Categoría] URL consultada: $url');
    // ---

    try {
      final response = await dio.get(url);

      // --- DEBUG: Imprime la respuesta del servidor ---
      debugPrint(
          '✅ [Categoría] Respuesta recibida. Código: ${response.statusCode}. Datos: ${response.data.toString()}');
      // ---

      final posts = _parseResponseData(response.data);
      articles = posts.map((e) => ArticleModel.fromMap(e)).toList();

      // --- DEBUG: Imprime el resultado final ---
      debugPrint('📝 [Categoría] Se procesaron ${articles.length} artículos.');
      // ---

      return articles;
    } catch (e) {
      // --- DEBUG: Imprime si hubo un error ---
      debugPrint('❌ [Categoría] ERROR al buscar posts: $e');
      // ---
      return [];
    }
  }

  @override
  Future<List<ArticleModel>> getPostByTag(
      {required int pageNumber, required int tagID, int perPage = 10}) async {
    final url = '$baseUrl?tags=$tagID&page=$pageNumber&per_page=$perPage';
    try {
      final response = await dio.get(url);
      final posts = _parseResponseData(response.data);
      return posts.map((e) => ArticleModel.fromMap(e)).toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  @override
  Future<List<ArticleModel>> getPostByAuthor(
      {required int pageNumber,
      required int authorID,
      int perPage = 10}) async {
    final url =
        '$baseUrl?page=$pageNumber&author=$authorID&status=publish&per_page=$perPage';
    try {
      final response = await dio.get(url);
      final posts = _parseResponseData(response.data);
      return posts.map((e) => ArticleModel.fromMap(e)).toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  @override
  Future<List<ArticleModel>> getThesePosts(
      {required List<int> ids, int page = 1}) async {
    final postsQuery = ids.join(',');
    final url = '$baseUrl?include=$postsQuery&page=$page&orderby=include';
    try {
      final response = await dio.get(url);
      final posts = _parseResponseData(response.data);
      return posts.map((e) => ArticleModel.fromMap(e)).toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  @override
  Future<List<ArticleModel>> getPopularPosts({int perPage = 10}) async {
    final url =
        'https://${WPConfig.url}/wp-json/wordpress-popular-posts/v1/popular-posts?limit=$perPage';
    try {
      final response = await dio.get(url);
      final posts = _parseResponseData(response.data);
      var articles = posts.map((e) => ArticleModel.fromMap(e)).toList();
      if (articles.isEmpty) articles = await getAllPost(pageNumber: 1);
      return articles;
    } catch (e) {
      debugPrint(e.toString());
      return await getAllPost(pageNumber: 1);
    }
  }

  @override
  Future<ArticleModel?> getPost({required int postID}) async {
    final url = '$baseUrl/$postID';
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        return ArticleModel.fromMap(response.data);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  @override
  Future<List<ArticleModel>> searchPost({required String keyword}) async {
    final url = '$baseUrl?search=$keyword';
    try {
      final response = await dio.get(url);
      final posts = _parseResponseData(response.data);
      return posts.map((e) => ArticleModel.fromMap(e)).toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  @override
  Future<ArticleModel?> getPostFromUrl({required String requestedURL}) async {
    final theUrl = Uri.parse(requestedURL);
    int postID = int.tryParse(theUrl.pathSegments[1]) ?? 0;
    if (theUrl.host == WPConfig.url) {
      if (WPConfig.usingPlainFormatLink) {
        final articles = await getPostsBySlug(slug: theUrl.path);
        return articles.isNotEmpty ? articles.first : null;
      } else {
        return await getPost(postID: postID);
      }
    }
    return null;
  }

  @override
  Future<List<ArticleModel>> getPostsBySlug({required String slug}) async {
    final url = '$baseUrl?slug=$slug';
    try {
      final response = await dio.get(url);
      final posts = _parseResponseData(response.data);
      return posts.map((e) => ArticleModel.fromMap(e)).toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  @override
  Future<bool> reportPost({
    required int postID,
    required String postTitle,
    required String userEmail,
    required String userName,
    required String reportEmail,
  }) async {
    final mail = '''Hello Admin,

Post title: "$postTitle",
Post id: $postID

From: $userName <$userEmail>
''';
    try {
      await AppUtils.sendEmail(
          email: reportEmail, content: mail, subject: 'Reporting Post $postID');
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  static Future<bool> addViewsToPost({required int postID}) async {
    final url =
        'https://${WPConfig.url}/wp-json/wordpress-popular-posts/v1/popular-posts?wpp_id=$postID';
    try {
      final response = await Dio().post(url);
      return response.statusCode == 201;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
