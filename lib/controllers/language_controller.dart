import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  static const String LANGUAGE_KEY = 'selected_language';
  
  final _currentLanguage = 'en'.obs;
  
  String get currentLanguage => _currentLanguage.value;
  Locale get currentLocale => Locale(_currentLanguage.value);
  
  @override
  void onInit() {
    super.onInit();
    _loadSelectedLanguage();
  }
  
  Future<void> _loadSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString(LANGUAGE_KEY);
    if (savedLanguage != null) {
      _currentLanguage.value = savedLanguage;
      await updateLocale(savedLanguage);
    }
  }
  
  Future<void> changeLanguage(String languageCode) async {
    if (_currentLanguage.value != languageCode) {
      _currentLanguage.value = languageCode;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(LANGUAGE_KEY, languageCode);
      await updateLocale(languageCode);
    }
  }
  
  Future<void> toggleLanguage() async {
    final newLanguage = _currentLanguage.value == 'en' ? 'ar' : 'en';
    await changeLanguage(newLanguage);
  }
  
  Future<void> updateLocale(String languageCode) async {
    Get.updateLocale(Locale(languageCode));
  }
  
  bool get isRTL => _currentLanguage.value == 'ar';
} 