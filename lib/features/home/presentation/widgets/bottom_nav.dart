import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

/// Barra de navegación inferior de la zona autenticada (Inicio / Mis Obras /
/// Sync / Perfil).
class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      destinations: [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Inicio',
        ),
        NavigationDestination(
          icon: Icon(Icons.description_outlined),
          selectedIcon: Icon(Icons.description),
          label: 'Mis Obras',
        ),
        NavigationDestination(
          // Badge de M3: punto rojo indicando audios en cola por sincronizar.
          icon: Badge(
            backgroundColor: context.colors.error,
            smallSize: 8,
            child: Icon(Icons.sync_outlined),
          ),
          selectedIcon: Icon(Icons.sync),
          label: 'Sync',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }
}
