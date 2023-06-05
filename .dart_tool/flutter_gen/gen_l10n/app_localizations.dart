import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @calendar.
  ///
  /// In es, this message translates to:
  /// **'Calendario'**
  String get calendar;

  /// No description provided for @addHours.
  ///
  /// In es, this message translates to:
  /// **'Agregar horas'**
  String get addHours;

  /// No description provided for @hours.
  ///
  /// In es, this message translates to:
  /// **'Horas'**
  String get hours;

  /// No description provided for @day.
  ///
  /// In es, this message translates to:
  /// **'Día'**
  String get day;

  /// No description provided for @month.
  ///
  /// In es, this message translates to:
  /// **'Mes'**
  String get month;

  /// No description provided for @year.
  ///
  /// In es, this message translates to:
  /// **'Año'**
  String get year;

  /// No description provided for @home.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get home;

  /// No description provided for @admin.
  ///
  /// In es, this message translates to:
  /// **'Administracion'**
  String get admin;

  /// No description provided for @options.
  ///
  /// In es, this message translates to:
  /// **'Opciones'**
  String get options;

  /// No description provided for @stats.
  ///
  /// In es, this message translates to:
  /// **'Estadísticas'**
  String get stats;

  /// No description provided for @department.
  ///
  /// In es, this message translates to:
  /// **'Departamentos'**
  String get department;

  /// No description provided for @employees.
  ///
  /// In es, this message translates to:
  /// **'Empleados'**
  String get employees;

  /// No description provided for @name.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get name;

  /// No description provided for @description.
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get description;

  /// No description provided for @manager.
  ///
  /// In es, this message translates to:
  /// **'Gerente'**
  String get manager;

  /// No description provided for @plsaddhours.
  ///
  /// In es, this message translates to:
  /// **'Por favor ingresa las horas'**
  String get plsaddhours;

  /// No description provided for @plsaddint.
  ///
  /// In es, this message translates to:
  /// **'Por favor ingresa un número entero'**
  String get plsaddint;

  /// No description provided for @plschoosedate.
  ///
  /// In es, this message translates to:
  /// **'Selecciona una fecha en el calendario'**
  String get plschoosedate;

  /// No description provided for @plsaddday.
  ///
  /// In es, this message translates to:
  /// **'Por favor ingrese el día'**
  String get plsaddday;

  /// No description provided for @plsaddmonth.
  ///
  /// In es, this message translates to:
  /// **'Por favor ingrese el mes'**
  String get plsaddmonth;

  /// No description provided for @plsaddyear.
  ///
  /// In es, this message translates to:
  /// **'Por favor ingrese el año'**
  String get plsaddyear;

  /// No description provided for @plsaddemployee.
  ///
  /// In es, this message translates to:
  /// **'Por favor, introduce un ID de usuario'**
  String get plsaddemployee;

  /// No description provided for @plsadddepartment.
  ///
  /// In es, this message translates to:
  /// **'Por favor, introduce un departamento'**
  String get plsadddepartment;

  /// No description provided for @plsadddni.
  ///
  /// In es, this message translates to:
  /// **'Por favor, introduce un DNI'**
  String get plsadddni;

  /// No description provided for @plsaddposition.
  ///
  /// In es, this message translates to:
  /// **'Por favor, introduce un puesto'**
  String get plsaddposition;

  /// No description provided for @plsaddsalary.
  ///
  /// In es, this message translates to:
  /// **'Por favor, introduce un salario'**
  String get plsaddsalary;

  /// No description provided for @plsaddname.
  ///
  /// In es, this message translates to:
  /// **'Por favor, introduce un nombre'**
  String get plsaddname;

  /// No description provided for @category.
  ///
  /// In es, this message translates to:
  /// **'Categoría'**
  String get category;

  /// No description provided for @normalHours.
  ///
  /// In es, this message translates to:
  /// **'Normales'**
  String get normalHours;

  /// No description provided for @extraHours.
  ///
  /// In es, this message translates to:
  /// **'Extra'**
  String get extraHours;

  /// No description provided for @vacationHours.
  ///
  /// In es, this message translates to:
  /// **'Vacaciones'**
  String get vacationHours;

  /// No description provided for @medicalLeaveHours.
  ///
  /// In es, this message translates to:
  /// **'Baja médica'**
  String get medicalLeaveHours;

  /// No description provided for @festiveHours.
  ///
  /// In es, this message translates to:
  /// **'Festivas'**
  String get festiveHours;

  /// No description provided for @unknowCategory.
  ///
  /// In es, this message translates to:
  /// **'Categoría desconocida'**
  String get unknowCategory;

  /// No description provided for @dayswithoutdata.
  ///
  /// In es, this message translates to:
  /// **'Días sin datos este mes'**
  String get dayswithoutdata;

  /// No description provided for @noData.
  ///
  /// In es, this message translates to:
  /// **'No hay datos para mostrar'**
  String get noData;

  /// No description provided for @save.
  ///
  /// In es, this message translates to:
  /// **'Guardar cambios'**
  String get save;

  /// No description provided for @saved.
  ///
  /// In es, this message translates to:
  /// **'Cambios guardados'**
  String get saved;

  /// No description provided for @search.
  ///
  /// In es, this message translates to:
  /// **'Buscar'**
  String get search;

  /// No description provided for @editHours.
  ///
  /// In es, this message translates to:
  /// **'Editar horas'**
  String get editHours;

  /// No description provided for @january.
  ///
  /// In es, this message translates to:
  /// **'Enero'**
  String get january;

  /// No description provided for @february.
  ///
  /// In es, this message translates to:
  /// **'Febrero'**
  String get february;

  /// No description provided for @march.
  ///
  /// In es, this message translates to:
  /// **'Marzo'**
  String get march;

  /// No description provided for @april.
  ///
  /// In es, this message translates to:
  /// **'Abril'**
  String get april;

  /// No description provided for @may.
  ///
  /// In es, this message translates to:
  /// **'Mayo'**
  String get may;

  /// No description provided for @june.
  ///
  /// In es, this message translates to:
  /// **'Junio'**
  String get june;

  /// No description provided for @july.
  ///
  /// In es, this message translates to:
  /// **'Julio'**
  String get july;

  /// No description provided for @august.
  ///
  /// In es, this message translates to:
  /// **'Agosto'**
  String get august;

  /// No description provided for @september.
  ///
  /// In es, this message translates to:
  /// **'Septiembre'**
  String get september;

  /// No description provided for @october.
  ///
  /// In es, this message translates to:
  /// **'Octubre'**
  String get october;

  /// No description provided for @november.
  ///
  /// In es, this message translates to:
  /// **'Noviembre'**
  String get november;

  /// No description provided for @december.
  ///
  /// In es, this message translates to:
  /// **'Diciembre'**
  String get december;

  /// No description provided for @userId.
  ///
  /// In es, this message translates to:
  /// **'ID de usuario'**
  String get userId;

  /// No description provided for @position.
  ///
  /// In es, this message translates to:
  /// **'Puesto'**
  String get position;

  /// No description provided for @salary.
  ///
  /// In es, this message translates to:
  /// **'Salario'**
  String get salary;

  /// No description provided for @addEmployee.
  ///
  /// In es, this message translates to:
  /// **'Crear empleado'**
  String get addEmployee;

  /// No description provided for @addDepartment.
  ///
  /// In es, this message translates to:
  /// **'Crear departamento'**
  String get addDepartment;

  /// No description provided for @edit.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get edit;

  /// No description provided for @editEmployee.
  ///
  /// In es, this message translates to:
  /// **'Editar empleado'**
  String get editEmployee;

  /// No description provided for @dni.
  ///
  /// In es, this message translates to:
  /// **'DNI'**
  String get dni;

  /// No description provided for @succesfulEmployee.
  ///
  /// In es, this message translates to:
  /// **'Empleado creado con éxito'**
  String get succesfulEmployee;

  /// No description provided for @succesfulDepartment.
  ///
  /// In es, this message translates to:
  /// **'Departamento creado con éxito'**
  String get succesfulDepartment;

  /// No description provided for @userNotInColection.
  ///
  /// In es, this message translates to:
  /// **'El usuario no está en la colección'**
  String get userNotInColection;

  /// No description provided for @googleSignIn.
  ///
  /// In es, this message translates to:
  /// **'Iniciar sesión con Google'**
  String get googleSignIn;

  /// No description provided for @googleSignInError.
  ///
  /// In es, this message translates to:
  /// **'Error al iniciar sesión con Google.'**
  String get googleSignInError;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
