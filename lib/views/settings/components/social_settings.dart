import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../config/wp_config.dart';
import '../../../core/constants/constants.dart';
import '../../../core/controllers/config/config_controllers.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/app_utils.dart';
import '../../view_on_web/view_on_web_page.dart';
import 'setting_list_tile.dart';

class SocialSettings extends ConsumerWidget {
  const SocialSettings({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(configProvider).value;
    final facebookUrl = config?.facebookUrl ?? '';
    final telegramUrl = config?.telegramUrl ?? '';
    final instagramUrl = config?.instagramUrl ?? '';
    final tiktokUrl = config?.tiktokUrl ?? '';
    final whatsappUrl = config?.whatsappUrl ?? '';
    final youtubeUrl = config?.youtubeUrl ?? '';
    final twitterUrl = config?.twitterUrl ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppDefaults.margin),
          child: Text(
            'Social'.tr(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        SettingTile(
          label: 'Contactanos',
          icon: Icons.contact_mail_rounded,
          iconColor: Colors.blueGrey,
          trailing: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(IconlyLight.arrowRight2),
          ),
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.contact);
          },
        ),
        SettingTile(
          label: 'Sitio Web',
          icon: FontAwesomeIcons.earthAsia,
          isFaIcon: true,
          iconColor: Colors.green,
          trailing: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(IconlyLight.arrowRight2),
          ),
          onTap: () {
            const url = 'https://${WPConfig.url}';
            if (url.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ViewOnWebPage(
                    title: 'Sitio Web'.tr(),
                    url: url,
                  ),
                ),
              );
            } else {
              Fluttertoast.showToast(msg: 'No App Url link provided');
            }
          },
        ),
        if (facebookUrl.isNotEmpty)
          SettingTile(
            label: 'Facebook',
            icon: FontAwesomeIcons.facebook,
            shouldTranslate: false,
            isFaIcon: true,
            iconColor: Colors.blue,
            trailing: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(IconlyLight.arrowRight2),
            ),
            onTap: () {
              final url = facebookUrl;
              if (url.isNotEmpty) {
                AppUtils.openLink(url);
              } else {
                Fluttertoast.showToast(msg: 'No se encontro el Link de Facebook');
              }
            },
          ),
        if (youtubeUrl.isNotEmpty)
          SettingTile(
            label: 'Youtube',
            shouldTranslate: false,
            icon: FontAwesomeIcons.youtube,
            isFaIcon: true,
            iconColor: Colors.red,
            trailing: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(IconlyLight.arrowRight2),
            ),
            onTap: () {
              final url = youtubeUrl;
              if (url.isNotEmpty) {
                AppUtils.openLink(url);
              } else {
                Fluttertoast.showToast(msg: 'No se encontro el link Youtube ');
              }
            },
          ),
        if (twitterUrl.isNotEmpty)
          SettingTile(
            label: 'X',
            shouldTranslate: false,
            icon: FontAwesomeIcons.twitter,
            isFaIcon: true,
            iconColor: Colors.lightBlue,
            trailing: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(IconlyLight.arrowRight2),
            ),
            onTap: () {
              final url = twitterUrl;
              if (url.isNotEmpty) {
                AppUtils.openLink(url);
              } else {
                Fluttertoast.showToast(msg: 'No se encontro el link X ');
              }
            },
          ),
        if (instagramUrl.isNotEmpty)
          SettingTile(
            label: 'Instagram',
            shouldTranslate: false,
            icon: FontAwesomeIcons.instagram,
            isFaIcon: true,
            iconColor: Colors.red,
            trailing: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(IconlyLight.arrowRight2),
            ),
            onTap: () {
              final url = instagramUrl;
              if (url.isNotEmpty) {
                AppUtils.openLink(url);
              } else {
                Fluttertoast.showToast(msg: 'No se encontro el link de Instragram ');
              }
            },
          ),
        if (tiktokUrl.isNotEmpty)
          SettingTile(
            label: 'Tiktok',
            shouldTranslate: false,
            icon: FontAwesomeIcons.tiktok,
            isFaIcon: true,
            iconColor: Colors.red,
            trailing: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(IconlyLight.arrowRight2),
            ),
            onTap: () {
              final url = tiktokUrl;
              if (url.isNotEmpty) {
                AppUtils.openLink(url);
              } else {
                Fluttertoast.showToast(msg: 'No se encontro el Link de Tiktok');
              }
            },
          ),
        if (whatsappUrl.isNotEmpty)
          SettingTile(
            label: 'Whatsapp',
            shouldTranslate: false,
            icon: FontAwesomeIcons.whatsapp,
            isFaIcon: true,
            iconColor: Colors.green,
            trailing: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(IconlyLight.arrowRight2),
            ),
            onTap: () {
              final url = whatsappUrl;
              if (url.isNotEmpty) {
                AppUtils.openLink(url);
              } else {
                Fluttertoast.showToast(msg: 'No se encontro el Link de Whatsapp');
              }
            },
          ),
      ],
    );
  }
}
