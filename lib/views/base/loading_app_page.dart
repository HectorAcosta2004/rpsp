import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_pro/core/controllers/internet/internet_state_provider.dart';
import '../../core/app/initialization_provider.dart';
import '../../core/logger/app_logger.dart';
import '../../core/controllers/config/config_controllers.dart';
import '../../core/models/config.dart';
import '../../core/repositories/posts/offline_post_repository.dart';
import '../auth/login_intro_page.dart';
import '../offline/offline_posts_page.dart';
import '../onboarding/onboarding_page.dart';
import 'components/loading_dependency.dart';
import 'configuration_error_page.dart';
import 'core_error_page.dart';
import 'base_page.dart';

class LoadingAppPage extends ConsumerWidget {
  const LoadingAppPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final internetAvailable = ref.watch(connectivityProvider);
    ref.read(offlinePostRepoProvider).init();

    Log.info('Internet state: ${internetAvailable.internetState}');

    if (internetAvailable.internetState == InternetState.loading) {
      return const LoadingDependencies();
    } else if (internetAvailable.internetState == InternetState.disconnected) {
      return const OfflinePostsPage();
    } else if (internetAvailable.internetState == InternetState.connected) {
      final configNotifier = ref.read(configProvider.notifier);
      final config = ref.watch(configProvider);

      if (config.isLoading) {
        configNotifier.init();
      }

      return config.map(
        data: (data) {
          _initializeApp(ref, data.value, context);
          final appState = ref.watch(appStateProvider);
          return appState.when(
            data: (state) => _buildAppStateUI(state, data.value),
            loading: () => const LoadingDependencies(),
            error: (error, _) {
              Log.fatal(error: error, stackTrace: StackTrace.current);
              return const CoreErrorPage();
            },
          );
        },
        error: (t) => const ConfigErrorPage(),
        loading: (t) => const LoadingDependencies(),
      );
    } else {
      return const CoreErrorPage(errorMessage: 'Connection error');
    }
  }

  void _initializeApp(
      WidgetRef ref, NewsProConfig config, BuildContext context) {
    ref.read(appInitializationProvider.notifier).initialize(
          InitializationArgument(
            config: config,
            context: context,
          ),
        );
  }

  Widget _buildAppStateUI(AppState state, NewsProConfig config) {
    switch (state) {
      case AppState.introNotDone:
        return const OnboardingPage();
      case AppState.consentNotDone:
        if (config.isLoginEnabled) {
          return const LoginIntroPage();
        } else {
          // --- CORRECCIÓN 1 ---
          return const BasePage();
        }
      case AppState.loggedIn:
        // --- CORRECCIÓN 2 ---
        return const BasePage();
      case AppState.loggedOut:
        // --- CORRECCIÓN 3 ---
        return const BasePage();
      case AppState.initializing:
        return const LoadingDependencies();
    }
  }
}