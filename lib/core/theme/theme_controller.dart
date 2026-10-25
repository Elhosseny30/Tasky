import 'package:flutter/material.dart';
import 'package:try_shared_preferences/core/services/preferneces_manager.dart';

class ThemeController {
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(
    ThemeMode.dark,
  );

  static void init() {
    bool res = PrefernecesManager().getBool("theme") ?? true;
    if (res) {
      themeNotifier.value = ThemeMode.dark;
    } else {
      themeNotifier.value = ThemeMode.light;
    }
  }

  static void toggleTheme(bool value)async {
    
    if (value) {
      themeNotifier.value = ThemeMode.dark;
      await PrefernecesManager().setBool("theme", value);
    } else {
      themeNotifier.value = ThemeMode.light;
      await PrefernecesManager().setBool("theme", value);
    }
  }
}
