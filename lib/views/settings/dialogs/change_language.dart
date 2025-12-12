import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../../../core/components/bottom_sheet_top_handler.dart';
import '../../../core/components/country_flag.dart';
import '../../../core/constants/constants.dart';

class ChangeLanguageDialog extends StatelessWidget {
  const ChangeLanguageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Locale> myLanguages = [
      const Locale('es', 'ES'),
      const Locale('en', 'US'),
    ];

    return Padding(
      padding: const EdgeInsets.all(AppDefaults.padding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BottomSheetTopHandler(),
          const _ChangeLanguageHeader(),
          const Divider(),
          ListView.separated(
            itemCount: myLanguages.length,
            itemBuilder: (context, index) {
              Locale current = myLanguages[index];
              bool isSelected =
                  context.locale.languageCode == current.languageCode;

              return ListTile(
                onTap: () async {
                  await context.setLocale(current);
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                title: Text(
                  _getLanguageName(current.languageCode),
                  style: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Theme.of(context).primaryColor : null,
                  ),
                ),
                leading: CountryFlag(countryCode: current.countryCode ?? 'US'),
                trailing: isSelected
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : const SizedBox(),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
            shrinkWrap: true,
          ),
          AppSizedBox.h16,
        ],
      ),
    );
  }

  String _getLanguageName(String code) {
    if (code == 'es') return 'Español';
    if (code == 'en') return 'English';
    return code.toUpperCase();
  }
}

class _ChangeLanguageHeader extends StatelessWidget {
  const _ChangeLanguageHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'change_lanuage'.tr(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const Spacer(),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            IconlyLight.closeSquare,
          ),
        ),
      ],
    );
  }
}
