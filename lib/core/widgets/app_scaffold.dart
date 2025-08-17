import 'package:flutter/material.dart';

import '../utils/app_strings.dart';
import 'package:roadtrip_sidekick/features/dashboard/dashboard_screen.dart';
import 'package:roadtrip_sidekick/features/map/map_screen.dart';
import 'package:roadtrip_sidekick/features/stops/stops_screen.dart';
import 'package:roadtrip_sidekick/features/supplies/supplies_page.dart';
import 'package:roadtrip_sidekick/features/expenses/expenses_page.dart';
import 'package:roadtrip_sidekick/features/settings/settings_page.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold({super.key});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _index = 0;

  static const _pages = <Widget>[
    DashboardScreen(),
    MapScreen(),
    StopsScreen(),
    SuppliesPage(),
    ExpensesPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _pages[_index],
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard),
              label: AppStrings.dashboard,
            ),
            NavigationDestination(icon: Icon(Icons.map), label: AppStrings.map),
            NavigationDestination(
              icon: Icon(Icons.flag),
              label: AppStrings.stops,
            ),
            NavigationDestination(
              icon: Icon(Icons.inventory_2),
              label: AppStrings.supplies,
            ),
            NavigationDestination(
              icon: Icon(Icons.attach_money),
              label: AppStrings.expenses,
            ),
            NavigationDestination(
              icon: Icon(Icons.settings),
              label: AppStrings.settings,
            ),
          ],
        ),
      ),
    );
  }
}
