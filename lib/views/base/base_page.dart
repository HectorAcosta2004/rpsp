import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_pro/views/explore/explore_page.dart';
import 'package:news_pro/views/home/home_page/home_page.dart';
import 'package:news_pro/views/saved/saved_page.dart';
import 'package:news_pro/views/settings/settings_page.dart';
import '../../core/controllers/auth/auth_controller.dart';
import '../../core/controllers/auth/auth_state.dart';
import '../../core/repositories/others/notification_local.dart';


class BasePage extends ConsumerStatefulWidget {
  const BasePage({super.key});

  @override
  ConsumerState<BasePage> createState() => _BasePageState();
}

class _BasePageState extends ConsumerState<BasePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authController);

    // --- LÍNEA DE DEBUG AÑADIDA ---
    // Esta línea nos dirá en la consola cuál es el estado de autenticación actual.
    debugPrint("[DEBUG] Estado de autenticación en BasePage: ${authState.runtimeType}");
    // --- FIN DE LA LÍNEA DE DEBUG ---

    // Creamos una variable que es 'true' SOLAMENTE si el estado es 'AuthLoggedIn'.
    final bool shouldShowFavoriteTab = authState is AuthLoggedIn;

    final List<Widget> pages = [
      const HomePage(),
      const ExplorePage(),
      // Usamos nuestra nueva variable para decidir si mostrar la página de 'Favoritos'.
      if (shouldShowFavoriteTab) const SavedPage(),
      const SettingsPage(),
    ];

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (v) => setState(() => _currentIndex = v),
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (v) => _pageController.jumpToPage(v),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor:
            Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(IconlyLight.home),
            activeIcon: const Icon(IconlyBold.home),
            label: 'home'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(IconlyLight.discovery),
            activeIcon: const Icon(IconlyBold.discovery),
            label: 'explore'.tr(),
          ),
          // Usamos la misma variable para decidir si mostrar el botón en la barra.
          if (shouldShowFavoriteTab)
            BottomNavigationBarItem(
              icon: const Icon(IconlyLight.heart),
              activeIcon: const Icon(IconlyBold.heart),
              label: 'favorites'.tr(),
            ),
          BottomNavigationBarItem(
            icon: const Icon(IconlyLight.setting),
            activeIcon: const Icon(IconlyBold.setting),
            label: 'settings'.tr(),
          ),
        ],
      ),
    );
  }
}