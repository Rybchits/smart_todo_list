import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService{
  final _storage = GetStorage();
  final _keyThemeMode = 'isDarkMode';

  _saveThemeModeToStorage(bool isDarkMode) => _storage.write(_keyThemeMode, isDarkMode);

  bool _loadThemeModeFromStorage() => _storage.read(_keyThemeMode) ?? false;

  ThemeMode get themeMode => _loadThemeModeFromStorage()? ThemeMode.dark : ThemeMode.light;

  void switchTheme(){
    Get.changeThemeMode(_loadThemeModeFromStorage()? ThemeMode.light : ThemeMode.dark);
    _saveThemeModeToStorage(!_loadThemeModeFromStorage());
  }
}