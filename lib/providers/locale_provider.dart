import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class LocaleProvider extends ChangeNotifier {
  Locale _locale = Locale('en');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!AppLocalizations.supportedLocales.contains(locale)) return;

    _locale = locale;
    notifyListeners();
    _saveToPrefs();
  }

  LocaleProvider() {
    _loadFromPrefs();
  }

  _loadFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('language_code');
    if (languageCode != null) {
      setLocale(Locale(languageCode));
    }
  }

  _saveToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', _locale.languageCode);
  }
}