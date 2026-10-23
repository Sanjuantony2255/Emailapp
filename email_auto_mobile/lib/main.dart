import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/home_screen.dart';
import 'services/preferences_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Dark navigation bar and status bar styling
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  final preferences = await PreferencesService.init();

  runApp(RecruitMailApp(preferences: preferences));
}

class RecruitMailApp extends StatelessWidget {
  final PreferencesService preferences;

  const RecruitMailApp({super.key, required this.preferences});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RecruitMail Automator',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: HomeScreen(preferences: preferences),
    );
  }
}
