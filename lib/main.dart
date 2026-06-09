import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/database/app_database.dart';
import 'core/theme/app_theme.dart';
import 'shared/widgets/app_shell.dart';

void main() {
  // Instancia única de la base de datos local (Drift/SQLite).
  final database = AppDatabase();
  runApp(DayFlowApp(database: database));
}

class DayFlowApp extends StatelessWidget {
  final AppDatabase database;

  const DayFlowApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    // Exponemos la base de datos a todo el árbol para que los repositorios
    // de cada feature la consuman.
    return RepositoryProvider.value(
      value: database,
      child: MaterialApp(
        title: 'DayFlow',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const AppShell(),
      ),
    );
  }
}
