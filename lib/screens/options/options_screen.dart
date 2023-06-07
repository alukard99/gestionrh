import 'package:flutter/material.dart';
import 'package:gestionrh/providers/locale_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class OptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.options),
      ),
      body: ListView(
        children: <Widget>[
          _buildLanguageOption(context),
        ],
      ),
    );
  }
  //Botones para cambiar la configuración
  Widget _buildOption(BuildContext context, String title, int optionNumber) {
    return ListTile(
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {
        _onOptionTapped(context, optionNumber);
      },
    );
  }
  //Botón para cambiar el lenguaje
  Widget _buildLanguageOption(BuildContext context) {
    var localeProvider = Provider.of<LocaleProvider>(context);
    return DropdownButton(
        value: localeProvider.locale,
        items: AppLocalizations.supportedLocales.map((locale) {
      String localeName = locale.languageCode;
      switch (localeName) {
        case 'en':
          localeName = 'English';
          break;
        case 'es':
          localeName = 'Español';
          break;
        case 'de':
          localeName = 'Deutsch';
          break;
      }
      return DropdownMenuItem(
        value: locale,
        child: Text(localeName),
      );
        }).toList(),
      onChanged: (locale) {
        localeProvider.setLocale(locale!);
      },
    );
  }

  void _onOptionTapped(BuildContext context, int optionNumber) {
    switch (optionNumber) {
      case 1:
      // Navigator.push(context, MaterialPageRoute(builder: (context) => DestinationWidget1()));
        break;
      case 2:
      // Navigator.push(context, MaterialPageRoute(builder: (context) => DestinationWidget2()));
        break;
      default:
        break;
    }
  }
}