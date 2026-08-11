import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';
import 'services/theme_service.dart';

void main() {
  runApp(const TodayApp());
}

class TodayApp extends StatefulWidget {
  const TodayApp({super.key});

  @override
  State<TodayApp> createState() => _TodayAppState();
}

class _TodayAppState extends State<TodayApp> {
  final ThemeService _themeService = ThemeService();
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _themeService.loadThemeMode().then((_) {
      if (mounted) {
        setState(() {
          _themeMode = _themeService.themeMode;
        });
      }
    });
    _themeService.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    _themeService.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    setState(() {
      _themeMode = _themeService.themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Today',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: const SplashScreen(),
    );
  }
}
