import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rpsp_iasd/core/themes/theme_manager.dart';
import '../../core/controllers/config/config_controllers.dart';

import '../../core/components/country_flag.dart';
import '../../core/components/select_theme_mode.dart';
import '../../core/constants/constants.dart';
import '../../core/routes/app_routes.dart';

class SelectLanguageAndThemePage extends StatelessWidget {
  const SelectLanguageAndThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: AppDefaults.padding),
          child: Column(
            children: [
              _ThemeWrapper(),
              const Divider(
                indent: AppDefaults.padding,
                endIndent: AppDefaults.padding,
                height: 10,
                thickness: 1,
              ),
              const SelectLanguage(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const _DoneButton(),
    );
  }
}

class _ThemeWrapper extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkMode(context));
    return Container(
      color: isDark ? AppColors.cardColorDark : AppColors.scaffoldBackground,
      child: const SelectThemeMode(),
    );
  }
}

class _DoneButton extends ConsumerWidget {
  const _DoneButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoginEnabled =
        ref.watch(configProvider).value?.isLoginEnabled ?? false;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(AppDefaults.padding),
          decoration: BoxDecoration(
            color: Theme.of(context)
                .scaffoldBackgroundColor
                .withValues(alpha: 0.8),
            border: Border(
              top: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 0.5,
              ),
            ),
          ),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                if (isLoginEnabled) {
                  Navigator.pushNamed(context, AppRoutes.loginIntro);
                } else {
                  Navigator.pushNamed(context, AppRoutes.entryPoint);
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDefaults.radius),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'done'.tr(),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 8),
                  const Icon(IconlyLight.arrowRight2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SelectLanguage extends StatelessWidget {
  const SelectLanguage({
    super.key,
  });

  String _getLanguageName(String code) {
    if (code == 'es') return 'Español';
    if (code == 'en') return 'English';
    return code.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final List<Locale> myLanguages = [
      const Locale('es', 'ES'),
      const Locale('en', 'US'),
    ];

    return Padding(
      padding: const EdgeInsets.all(AppDefaults.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'select_language'.tr(),
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              InkWell(
                onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.loginIntro,
                  (v) => false,
                ),
                borderRadius: BorderRadius.circular(AppDefaults.radius),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text('skip'.tr(),
                          style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(width: 4),
                      const Icon(IconlyLight.arrowRight2, size: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Language list
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDefaults.radius),
              color: Theme.of(context).cardColor,
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDefaults.radius),
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: myLanguages.length, // Usamos nuestra lista manual
                itemBuilder: (context, index) {
                  Locale current = myLanguages[index];
                  bool isSelected =
                      context.locale.languageCode == current.languageCode;

                  return ListTile(
                    onTap: () async {
                      await context.setLocale(current);
                    },
                    // Usamos la función para el nombre bonito
                    title: Text(_getLanguageName(current.languageCode)),
                    leading:
                        CountryFlag(countryCode: current.countryCode ?? 'US'),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : const SizedBox(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(
                  height: 1,
                  thickness: 1,
                  indent: 16,
                  endIndent: 16,
                ),
                shrinkWrap: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
