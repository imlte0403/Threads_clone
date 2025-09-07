import 'package:flutter/material.dart';
import 'settings_model.dart';
import 'settings_repository.dart';

class SettingsViewModel extends ChangeNotifier {
  final SettingsRepository _repository = SettingsRepository();
  SettingsModel _settings = SettingsModel(darkMode: false);
  final bool _isInitialized = true; // 초기값을 true로 설정

  SettingsModel get settings => _settings;
  bool get darkMode => _settings.darkMode;
  bool get isInitialized => _isInitialized;

  SettingsViewModel() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final isDarkMode = await _repository.isDarkMode();
      _settings = SettingsModel(darkMode: isDarkMode);
      notifyListeners();
    } catch (e) {
      // 에러 발생 시 기본값 사용 (이미 초기화됨)
      _settings = SettingsModel(darkMode: false);
      notifyListeners();
    }
  }

  Future<void> setDarkMode(bool darkMode) async {
    await _repository.setDarkMode(darkMode);
    _settings = _settings.copyWith(darkMode: darkMode);
    notifyListeners();
  }
}
