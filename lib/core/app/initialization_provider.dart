import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../firebase_options.dart';
import '../controllers/applinks/app_links_controller.dart';
import '../controllers/auth/auth_controller.dart';
import '../controllers/auth/auth_state.dart';
import '../controllers/internet/internet_state_provider.dart';
import '../controllers/notifications/notification_handler.dart';
import '../controllers/notifications/notification_local.dart';
import '../localization/app_locales.dart';
import '../logger/app_logger.dart';
import '../models/config.dart';
import '../models/notification_model.dart';
import '../repositories/auth/auth_repository.dart';
import '../repositories/others/onboarding_local.dart';
import '../repositories/others/post_style_local.dart';
import '../repositories/others/search_local.dart';

// Enum para representar el estado de la app
enum AppState {
  introNotDone,
  consentNotDone,
  loggedIn,
  loggedOut,
  initializing,
}

// Estado de inicialización
class InitializationState {
  final bool isCriticalInitComplete;
  final bool isLazyInitComplete;
  final AppState currentAppState;
  final Object? error;
  final StackTrace? stackTrace;

  const InitializationState({
    this.isCriticalInitComplete = false,
    this.isLazyInitComplete = false,
    this.currentAppState = AppState.initializing,
    this.error,
    this.stackTrace,
  });

  InitializationState copyWith({
    bool? isCriticalInitComplete,
    bool? isLazyInitComplete,
    AppState? currentAppState,
    Object? error,
    StackTrace? stackTrace,
  }) {
    return InitializationState(
      isCriticalInitComplete:
          isCriticalInitComplete ?? this.isCriticalInitComplete,
      isLazyInitComplete: isLazyInitComplete ?? this.isLazyInitComplete,
      currentAppState: currentAppState ?? this.currentAppState,
      error: error ?? this.error,
      stackTrace: stackTrace ?? this.stackTrace,
    );
  }
}

// Argumentos para inicialización
class InitializationArgument {
  final NewsProConfig config;
  final BuildContext context;

  InitializationArgument({
    required this.config,
    required this.context,
  });
}

// Provider principal de inicialización
final appInitializationProvider =
    StateNotifierProvider<AppInitializer, InitializationState>((ref) {
  return AppInitializer(ref);
});

// Provider que expone solo el AppState para la UI
final appStateProvider = Provider<AsyncValue<AppState>>((ref) {
  final initState = ref.watch(appInitializationProvider);

  if (initState.error != null) {
    return AsyncValue.error(initState.error!, initState.stackTrace!);
  }

  if (!initState.isCriticalInitComplete) {
    return const AsyncValue.loading();
  }

  return AsyncValue.data(initState.currentAppState);
});

// Clase que maneja la inicialización
class AppInitializer extends StateNotifier<InitializationState> {
  final Ref ref;

  AppInitializer(this.ref) : super(const InitializationState());

  // Inicialización principal
  Future<void> initialize(InitializationArgument arg) async {
    if (state.isCriticalInitComplete) return;

    try {
      // Inicialización crítica
      await _performCriticalInitialization(arg);

      // Determinar estado de la app (login, onboarding o home)
      final appState = await _determineAppState(arg.config);

      // Actualizar estado con inicialización crítica completa
      state = state.copyWith(
        isCriticalInitComplete: true,
        currentAppState: appState,
      );

      // Inicialización lazy en segundo plano
      _performLazyInitialization(arg).then((_) async {
        state = state.copyWith(isLazyInitComplete: true);

        // Revalidar estado tras lazy init
        final updatedAppState = await _determineAppState(arg.config);
        state = state.copyWith(currentAppState: updatedAppState);
      }).catchError((e, st) {
        Log.error('Lazy initialization error: $e');
      });
    } catch (e, st) {
      Log.fatal(error: e, stackTrace: st);
      state = state.copyWith(
        error: e,
        stackTrace: st,
      );
    }
  }

  // Inicialización crítica
  Future<void> _performCriticalInitialization(
      InitializationArgument arg) async {
    Log.info('Starting critical initialization');

    // Abrir cajas esenciales
    await Hive.openBox('settingsBox');
    await Hive.openBox<NotificationModel>('notifications');

    // Conectividad
    ref.read(connectivityProvider);

    // Inicializar notificaciones
    await NotificationHandler.init(arg.context, ref);

    // Repositorios esenciales
    await OnboardingRepository().init();
    await PostStyleRepository().init();

    // Controlador de autenticación
    await ref.read(authController.notifier).init();

    Log.info('Critical initialization complete');
  }

  // Inicialización lazy
  Future<void> _performLazyInitialization(InitializationArgument arg) async {
    Log.info('Starting lazy initialization');

    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    await ref.read(authRepositoryProvider).init();
    await SearchLocalRepo().init();
    ref.read(localNotificationProvider);
    // Nota: Si eliminaste setLocaleMessages de AppLocales, comenta la siguiente línea:
    // AppLocales.setLocaleMessages();
    ref.read(applinkNotifierProvider(arg.context));

    Log.info('Lazy initialization complete');
  }

  // Determinar estado de la app
  Future<AppState> _determineAppState(NewsProConfig? config) async {
    Log.info('Determining app state');

    final onboarding = await OnboardingRepository().init();
    final onboardingEnabled = config?.onboardingEnabled ?? false;
    final isOnboardingDone = onboarding.isIntroDone();
    final isLoggedIn = ref.read(authController) is AuthLoggedIn;

    // --- LÓGICA CORREGIDA ---

    // 1. Primero verificamos Onboarding. Si está activado y no se ha hecho, mostramos intro.
    if (onboardingEnabled && !isOnboardingDone) {
      return AppState.introNotDone;
    }

    // 2. Si ya pasó el onboarding, verificamos si necesita login.
    if (!isLoggedIn) {
      return AppState.loggedOut;
    }

    // 3. Si tiene sesión activa, entra a la app.
    return AppState.loggedIn;
  }
}
