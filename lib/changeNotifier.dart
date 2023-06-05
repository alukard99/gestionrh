import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = Locale('en');  // Idioma por defecto

  Locale get locale => _locale;

  void switchLocale(String languageCode) {
    _locale = Locale(languageCode);
    notifyListeners();
  }
}