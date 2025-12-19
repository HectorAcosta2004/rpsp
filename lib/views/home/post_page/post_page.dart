import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/controllers/ui/post_style_controller.dart';
import '../../../core/models/article.dart';
import '../../../core/repositories/others/post_style_local.dart';
import 'styles/card_post.dart';
import 'styles/classic_post.dart';
import 'styles/magazine_post.dart';
import 'styles/minimal_post.dart';
import 'styles/story_post.dart';

class PostPage extends HookConsumerWidget {
  const PostPage({
    super.key,
    required this.article,
  });
  final ArticleModel article;

  @override // Implementación requerida para HookConsumerWidget
  Widget build(BuildContext context, WidgetRef ref) {
    // CORRECCIÓN: Se cambia 'postStyleController' por el nombre correcto del proveedor:
    // 'postStyleControllerProvider'.
    final currentStyle = ref.watch(postStyleControllerProvider);
    // Devuelve el widget de publicación correcto según el estilo
    return _buildPostWithStyle(currentStyle);
  }

  Widget _buildPostWithStyle(PostDetailStyle style) {
    switch (style) {
      case PostDetailStyle.classic:
        return ClassicPost(article: article);
      case PostDetailStyle.magazine:
        return MagazinePost(article: article);
      case PostDetailStyle.minimal:
        return MinimalPost(article: article);
      case PostDetailStyle.card:
        return CardPost(article: article);
      case PostDetailStyle.story:
        return StoryPost(article: article);
    }
  }
}

class ArticlePageArguments {
  final ArticleModel article;
  final bool initialArticleLoaded;
  ArticlePageArguments({
    required this.article,
    this.initialArticleLoaded = false,
  });
}
