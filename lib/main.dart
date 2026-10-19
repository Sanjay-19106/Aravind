import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/system_state.dart';
import 'theme/app_theme.dart';
import 'screens/main_navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final systemState = SystemState();
  await systemState.initialize();

  runApp(
    ChangeNotifierProvider.value(
      value: systemState,
      child: const AravindApp(),
    ),
  );
}

class AravindApp extends StatelessWidget {
  const AravindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ARAVIND - Anti-Gravity Operating System',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const MainNavigationScreen(),
    );
  }
}
