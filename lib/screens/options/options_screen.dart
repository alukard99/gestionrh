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
  //Botón para cambiar el lenguaje
  Widget _buildLanguageOption(BuildContext context) {
    var localeProvider = Provider.of<LocaleProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(3.0),
        ),
        child: DropdownButtonHideUnderline(  // para esconder la línea subrayada
          child: DropdownButton(
            value: localeProvider.locale,
            isExpanded: true,  // para hacer que DropdownButton ocupe todo el espacio disponible
            items: AppLocalizations.supportedLocales.asMap().entries.map((entry) {
              int index = entry.key;
              Locale locale = entry.value;

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
              Color color = (index % 2 == 0) ? Colors.grey[200]! : Colors.white;  // Color gris claro para índices pares, blanco para índices impares
              return DropdownMenuItem(
                value: locale,
                child: Container(
                  width: double.infinity,
                  color: color,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(localeName),
                  ),
                ),
              );
            }).toList(),
            onChanged: (locale) {
              localeProvider.setLocale(locale!);
            },
          ),
        ),
      ),
    );
  }
}