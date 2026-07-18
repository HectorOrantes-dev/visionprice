import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'contratista/parametros_page.dart';
import 'arquitecto/gestion_proyectos_page.dart';
import 'ingeniero/anomalias_tecnicas_page.dart';

enum AppRole { contratista, arquitecto, ingeniero }

class MainRoleSwitcherPage extends StatefulWidget {
  const MainRoleSwitcherPage({super.key});

  @override
  State<MainRoleSwitcherPage> createState() => _MainRoleSwitcherPageState();
}

class _MainRoleSwitcherPageState extends State<MainRoleSwitcherPage> {
  AppRole _currentRole = AppRole.contratista;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modo Desarrollo: Roles'),
        actions: [
          PopupMenuButton<AppRole>(
            onSelected: (role) {
              setState(() {
                _currentRole = role;
              });
            },
            icon: const Icon(Icons.swap_horiz),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: AppRole.contratista,
                child: Text('Contratista'),
              ),
              const PopupMenuItem(
                value: AppRole.arquitecto,
                child: Text('Arquitecto'),
              ),
              const PopupMenuItem(
                value: AppRole.ingeniero,
                child: Text('Ingeniero Civil'),
              ),
            ],
          ),
        ],
      ),
      body: _buildBodyForRole(),
    );
  }

  Widget _buildBodyForRole() {
    switch (_currentRole) {
      case AppRole.contratista:
        return const ContratistaParametrosPage(); // Starting page for Contratista
      case AppRole.arquitecto:
        return const ArquitectoGestionProyectosPage(); // Starting page for Arquitecto
      case AppRole.ingeniero:
        return const IngenieroAnomaliasTecnicasPage(); // Starting page for Ingeniero
    }
  }
}
