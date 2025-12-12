import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../core/controllers/config/config_controllers.dart';

import '../../view_on_web/view_on_web_page.dart';
import 'setting_list_tile.dart';

class AboutSettings extends ConsumerWidget {
  const AboutSettings({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(configProvider).value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingTile(
          label: 'terms_conditions'.tr(),
          icon: IconlyLight.paper,
          iconColor: Colors.pink,
          trailing: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(IconlyLight.arrowRight2),
          ),
          onTap: () {
            final theURL = config?.termsAndServicesUrl ?? '';
            if (theURL.isNotEmpty) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ViewOnWebPage(
                            title: 'terms_conditions'.tr(),
                            url: theURL,
                          )));
            } else {
              Fluttertoast.showToast(msg: 'no_terms_provided'.tr());
            }
          },
        ),
        SettingTile(
          label: 'privacy_policy'.tr(),
          icon: IconlyLight.lock,
          iconColor: Colors.green,
          trailing: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(IconlyLight.arrowRight2),
          ),
          onTap: () {
            final privacyPolicy = config?.privacyPolicyUrl ?? '';
            if (privacyPolicy.isNotEmpty) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ViewOnWebPage(
                            title: 'privacy_policy'.tr(),
                            url: privacyPolicy,
                          )));
            } else {
              Fluttertoast.showToast(msg: 'no_privacy_provided'.tr());
            }
          },
        ),
      ],
    );
  }
}
