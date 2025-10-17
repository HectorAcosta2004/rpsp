import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:news_pro/views/explore/explore_page.dart';
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

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authController);

    // Verificar si el usuario está autenticado
    final bool isLoggedIn = authState is AuthLoggedIn;

    // Lista de páginas según el estado de autenticación
    final List<Widget> pages = [
      const ExplorePage(),
      if (isLoggedIn) const SavedPage(),
      const SettingsPage(),
    ];

    // Asegurar que el índice actual esté dentro del rango válido
    if (_currentIndex >= pages.length) {
      _currentIndex = pages.length - 1;
    }

    // Lista de ítems del BottomNavigationBar
    final List<BottomNavigationBarItem> items = [
      BottomNavigationBarItem(
        icon: const Icon(IconlyLight.discovery),
        activeIcon: const Icon(IconlyBold.discovery),
        label: 'explore'.tr(),
      ),
      if (isLoggedIn)
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
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor:
            Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey,
        items: items,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
