import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension AppLocalizationsExtension on AppLocalizations {
  String getMonth(int month) {
    switch (month) {
      case 1:
        return january;
      case 2:
        return february;
      case 3:
        return march;
      case 4:
        return april;
      case 5:
        return may;
      case 6:
        return june;
      case 7:
        return july;
      case 8:
        return august;
      case 9:
        return september;
      case 10:
        return october;
      case 11:
        return november;
      case 12:
        return december;
      default:
        throw ArgumentError('Month must be between 1 and 12');
    }
  }
}
class LocaleProvider extends ChangeNotifier {
  Locale _locale = Locale('es');  // Lenguaje por defecto

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!isLocaleSupported(locale)) {
      throw Exception('Locale not supported');
    }

    if (_locale == locale) return;

    _locale = locale;
    notifyListeners();
  }

  bool isLocaleSupported(Locale locale) {
    return ['en', 'es', 'de'].contains(locale.languageCode); //Lenguajes soportados
  }
}