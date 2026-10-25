import 'package:flutter/material.dart';
import 'package:try_shared_preferences/core/services/preferneces_manager.dart';
import 'package:try_shared_preferences/core/theme/dark_theme.dart';
import 'package:try_shared_preferences/core/theme/light_theme.dart';
import 'package:try_shared_preferences/core/theme/theme_controller.dart';
import 'package:try_shared_preferences/features/navigator/main_bottom_navigation_bar.dart';
import 'package:try_shared_preferences/features/welcome/welcom_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefernecesManager().init();
  ThemeController.init();

  //prefs.clear();

  runApp(Tasky(userName: PrefernecesManager().getString("username")));
}

class Tasky extends StatelessWidget {
  const Tasky({super.key, required this.userName});
  final String? userName;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.themeNotifier,
      builder: (context, ThemeMode value, Widget? child) {
        return MaterialApp(
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: value,
          title: "Tasky",
          debugShowCheckedModeBanner: false,
          home: userName == null ? WelcomScreen() : MainBottomNavigationBar(),
        );
      },
    );
  }
}
