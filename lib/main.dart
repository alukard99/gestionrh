import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gestionrh/providers/locale_provider.dart';
import 'package:gestionrh/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:gestionrh/providers/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gestionrh/changeNotifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]); //Fuerza modo vertical
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LocaleProvider()), //Escucha a cambios de estado del lenguaje
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
        Provider<AuthService>(create: (_) => AuthService()), //Servicio de autenticación de Google
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var localeProvider = Provider.of<LocaleProvider>(context);
    return MaterialApp(
      title: 'Gestionate',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [ //Lenguajes soportados TODO Modificar lenguajes
        Locale('en'), // English
        Locale('es'), // Spanish
        Locale('de'), // German
      ],
      locale: localeProvider.locale, //Cambia el estado de la app según el idioma elegido
    );
  }
}