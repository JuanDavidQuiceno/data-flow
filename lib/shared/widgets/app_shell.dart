import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../features/habits/presentation/pages/habits_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/stats/presentation/pages/stats_page.dart';
import '../../features/tasks/presentation/pages/tasks_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  static const _pages = <Widget>[
    HomePage(),
    TasksPage(),
    HabitsPage(),
    StatsPage(),
    _MorePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: AppColors.surface,
          indicatorColor: Colors.transparent,
          labelTextStyle: WidgetStateProperty.resolveWith(
            (states) => TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: states.contains(WidgetState.selected)
                  ? AppColors.primary
                  : AppColors.textSecondary,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _index,
          height: 64,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: AppColors.textSecondary),
              selectedIcon: Icon(Icons.home, color: AppColors.primary),
              label: 'Inicio',
            ),
            NavigationDestination(
              icon: Icon(Icons.check_box_outlined,
                  color: AppColors.textSecondary),
              selectedIcon: Icon(Icons.check_box, color: AppColors.primary),
              label: 'Tareas',
            ),
            NavigationDestination(
              icon: Icon(Icons.verified_outlined,
                  color: AppColors.textSecondary),
              selectedIcon: Icon(Icons.verified, color: AppColors.primary),
              label: 'Hábitos',
            ),
            NavigationDestination(
              icon: Icon(Icons.bar_chart_outlined,
                  color: AppColors.textSecondary),
              selectedIcon: Icon(Icons.bar_chart, color: AppColors.primary),
              label: 'Estadísticas',
            ),
            NavigationDestination(
              icon: Icon(Icons.more_horiz, color: AppColors.textSecondary),
              selectedIcon: Icon(Icons.more_horiz, color: AppColors.primary),
              label: 'Más',
            ),
          ],
        ),
      ),
    );
  }
}

class _MorePage extends StatelessWidget {
  const _MorePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Más')),
      body: const Center(child: Text('Próximamente')),
    );
  }
}
