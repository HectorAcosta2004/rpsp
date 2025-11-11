import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:news_pro/core/utils/extensions.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../config/wp_config.dart';

import '../../../../core/components/app_video.dart'; // IMPORTANTE: Importar el componente de video
import '../../../../core/components/mini_player.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/controllers/analytics/analytics_controller.dart';
import '../../../../core/models/article.dart';
import '../components/more_related_post.dart';
import '../components/post_image_renderer.dart';
import '../components/post_page_body.dart';
import 'comment_button_floating.dart';
import 'post_sidebar.dart';
import 'save_post_button.dart';

class NormalPost extends StatelessWidget {
  const NormalPost({
    super.key,
    required this.article,
  });
  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // MODIFICACIÓN: Si es video/audio, mostrar el reproductor, si no, la imagen normal
                  ArticleModel.isVideoArticle(article)
                      ? _CustomMediaRenderer(article: article)
                      : PostImageRenderer(article: article),
                  
                  PostPageBody(article: article),
                 
                  Container(
                    color: Theme.of(context).cardColor,
                    child: MoreRelatedPost(
                      categoryID: article.categories.isNotEmpty
                          ? article.categories.first
                          : 0,
                      currentArticleID: article.id,
                    ),
                  ),
                 
                  Padding(
                    padding: const EdgeInsets.all(AppDefaults.padding),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('go_back'.tr()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _NormalPostAppBar(article: article),
          CommentButtonFloating(article: article),
          PostSidebar(
            link: article.link,
            title: article.title,
          ),
          MiniPlayer(
            isOnStack: true,
            articleModel: article,
          ),
        ],
      ),
    );
  }
}

class _NormalPostAppBar extends StatelessWidget {
  _NormalPostAppBar({
    required this.article,
  });

  final ArticleModel article;
  final GlobalKey _shareButtonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor: AppColors.cardColorDark.withOpacityValue(0.3),
              elevation: 0,
              padding: const EdgeInsets.all(8),
            ),
            onPressed: () => Navigator.pop(context),
            child: Icon(
              Icons.adaptive.arrow_back_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        actions: [
          ElevatedButton(
            key: _shareButtonKey,
            onPressed: () async {
              final RenderBox button = _shareButtonKey.currentContext!
                  .findRenderObject() as RenderBox;
              final RenderBox overlay =
                  Overlay.of(context).context.findRenderObject() as RenderBox;
              final Offset position =
                  button.localToGlobal(Offset.zero, ancestor: overlay);
              final Size size = button.size;

              await SharePlus.instance.share(ShareParams(
                text:
                    'Check out this article on ${WPConfig.appName}:\n${article.title}\n${article.link}',
                sharePositionOrigin: Rect.fromLTWH(position.dx,
                    position.dy + size.height, size.width, size.height),
              ));
              AnalyticsController.logUserContentShare(article);
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor: AppColors.cardColorDark.withOpacityValue(0.3),
              elevation: 0,
              padding: const EdgeInsets.all(8),
            ),
            child: const Icon(
              IconlyLight.send,
              color: Colors.white,
              size: 18,
            ),
          ),
          SavePostButton(article: article),
        ],
      ),
    );
  }
}

// NUEVA CLASE: Para manejar el renderizado de Video y Audio
class _CustomMediaRenderer extends StatelessWidget {
  const _CustomMediaRenderer({
    required this.article,
  });

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    bool isNormalVideo = article.featuredVideo != null;
    bool isYoutubeVideo = article.featuredYoutubeVideoUrl != null;
    String? thumbnail;
    
    String getYouTubeThumbnail(String url) {
      try {
        final Uri uri = Uri.parse(url);
        final videoId = uri.queryParameters['v'] ?? uri.pathSegments.last;
        return 'https://img.youtube.com/vi/$videoId/0.jpg';
      } catch (e) {
        return article.featuredImage ?? '';
      }
    }

    if (isYoutubeVideo) {
      thumbnail = getYouTubeThumbnail(article.featuredYoutubeVideoUrl ?? '');
      return AppVideoHtmlRender(
        url: article.featuredYoutubeVideoUrl ?? '',
        isYoutube: true,
        aspectRatio: 16 / 9,
        isVideoPage: true,
        thumbnail: thumbnail,
        article: article,
      );
    } else if (isNormalVideo) {
      // Esto manejará tanto video mp4 como audio si la URL se pasa en featuredVideo
      return AppVideoHtmlRender(
        url: article.featuredVideo ?? '',
        isYoutube: false,
        aspectRatio: 16 / 9,
        isVideoPage: true,
        thumbnail: article.featuredImage, // Usamos la imagen destacada como miniatura
        article: article,
      );
    } else {
      return const SizedBox();
    }
  }
}