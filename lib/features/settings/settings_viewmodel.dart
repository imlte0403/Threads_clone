import 'package:flutter/material.dart';
import 'settings_model.dart';
import 'settings_repository.dart';

class SettingsViewModel extends ChangeNotifier {
  final SettingsRepository _repository = SettingsRepository();
  SettingsModel _settings = SettingsModel(darkMode: false);

  SettingsModel get settings => _settings;
  bool get darkMode => _settings.darkMode;

  SettingsViewModel() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final isDarkMode = await _repository.isDarkMode();
    _settings = SettingsModel(darkMode: isDarkMode);
    notifyListeners();
  }

  Future<void> setDarkMode(bool darkMode) async {
    await _repository.setDarkMode(darkMode);
    _settings = _settings.copyWith(darkMode: darkMode);
    notifyListeners();
  }
}