import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/controllers/config/config_controllers.dart';
import '../../../core/repositories/others/onboarding_local.dart';
import '../../../core/utils/app_utils.dart';

class CookieConsentSheet extends ConsumerWidget {
  const CookieConsentSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String langCode = Localizations.localeOf(context).languageCode;
    final bool isEs = langCode == 'es';

    final Map<String, String> texts = {
      'title': isEs ? 'Uso de Cookies' : 'Cookie Usage',
      'policyLink': isEs ? 'Políticas de Privacidad' : 'Privacy Policy',
      'decline': isEs ? 'Rechazar' : 'Decline',
      'accept': isEs ? 'Aceptar' : 'Accept',
    };

    final privacyPolicy =
        ref.watch(configProvider).value?.privacyPolicyUrl ?? '';

    final String consentText = isEs
        ? 'Utilizamos cookies propias y de terceros para mejorar nuestros servicios, personalizar el contenido y analizar el tráfico de la aplicación. Al hacer clic en "Aceptar", consientes el uso de estas tecnologías.'
        : 'We use our own and third-party cookies to improve our services, personalize content, and analyze application traffic. By clicking "Accept", you consent to the use of these technologies.';
    // ---------------------------------------------------------

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            texts['title']!,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            consentText,
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              AppUtils.openLink(privacyPolicy);
            },
            child: Text(
              texts['policyLink']!,
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  SystemNavigator.pop();
                },
                child: Text(texts['decline']!),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  OnboardingRepository().saveConsentDone();
                },
                child: Text(texts['accept']!),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
