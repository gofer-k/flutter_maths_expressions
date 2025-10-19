import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pl'),
  ];

  /// No description provided for @mainPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Maths Expressions'**
  String get mainPageTitle;

  /// No description provided for @derivativePageTitle.
  ///
  /// In en, this message translates to:
  /// **'Derivative theorems'**
  String get derivativePageTitle;

  /// No description provided for @deriveTheoremDefinition.
  ///
  /// In en, this message translates to:
  /// **'Derive theorem definition'**
  String get deriveTheoremDefinition;

  /// No description provided for @derivativesComputationRules.
  ///
  /// In en, this message translates to:
  /// **'Derivatives computation rules'**
  String get derivativesComputationRules;

  /// No description provided for @basicDerivativesExpressions.
  ///
  /// In en, this message translates to:
  /// **'Basic derivatives expressions'**
  String get basicDerivativesExpressions;

  /// No description provided for @logarithmsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Logarithms'**
  String get logarithmsPageTitle;

  /// No description provided for @planimetryPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Planimetry'**
  String get planimetryPageTitle;

  /// No description provided for @triangleTheorems.
  ///
  /// In en, this message translates to:
  /// **'Triangle theorems'**
  String get triangleTheorems;

  /// No description provided for @triangleArea.
  ///
  /// In en, this message translates to:
  /// **'Triangle area'**
  String get triangleArea;

  /// No description provided for @trigonometryPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Trigonometry'**
  String get trigonometryPageTitle;

  /// No description provided for @trigonometryFunctions.
  ///
  /// In en, this message translates to:
  /// **'Trigonometry functions'**
  String get trigonometryFunctions;

  /// No description provided for @trigonometryReversedFunctions.
  ///
  /// In en, this message translates to:
  /// **'Trigonometry reversed functions'**
  String get trigonometryReversedFunctions;

  /// No description provided for @trigonometryParityFeatures.
  ///
  /// In en, this message translates to:
  /// **'Trigonometry parity features'**
  String get trigonometryParityFeatures;

  /// No description provided for @trigonometryPeriodicFunctions.
  ///
  /// In en, this message translates to:
  /// **'Trigonometry periodic functions'**
  String get trigonometryPeriodicFunctions;

  /// No description provided for @trigonometryEquations.
  ///
  /// In en, this message translates to:
  /// **'Trigonometry equations'**
  String get trigonometryEquations;

  /// No description provided for @trigonometryValues.
  ///
  /// In en, this message translates to:
  /// **'Trigonometry values'**
  String get trigonometryValues;

  /// No description provided for @trigonometryReducedExpressions.
  ///
  /// In en, this message translates to:
  /// **'Trigonometry reduced expressions'**
  String get trigonometryReducedExpressions;

  /// No description provided for @blockShapesPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Block shapes'**
  String get blockShapesPageTitle;

  /// No description provided for @limitsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Limits'**
  String get limitsPageTitle;

  /// No description provided for @limitsTheorems.
  ///
  /// In en, this message translates to:
  /// **'Limits theorems'**
  String get limitsTheorems;

  /// No description provided for @shapeTypeEllipsoid.
  ///
  /// In en, this message translates to:
  /// **'Ellipsoid'**
  String get shapeTypeEllipsoid;

  /// No description provided for @shapeTypeHyperboloidTwoShell.
  ///
  /// In en, this message translates to:
  /// **'Hyperboloid 2-shell'**
  String get shapeTypeHyperboloidTwoShell;

  /// No description provided for @shapeTypeHyperboloidOneShell.
  ///
  /// In en, this message translates to:
  /// **'Hyperboloid 1-shell'**
  String get shapeTypeHyperboloidOneShell;

  /// No description provided for @shapeTypeSaddle.
  ///
  /// In en, this message translates to:
  /// **'Saddle'**
  String get shapeTypeSaddle;

  /// No description provided for @shapeTypeCone.
  ///
  /// In en, this message translates to:
  /// **'Cone'**
  String get shapeTypeCone;

  /// No description provided for @shapeTypeCylinder.
  ///
  /// In en, this message translates to:
  /// **'Cylinder'**
  String get shapeTypeCylinder;

  /// No description provided for @shapeTypeHyperbolicCylinder.
  ///
  /// In en, this message translates to:
  /// **'Hyperbolic cylinder'**
  String get shapeTypeHyperbolicCylinder;

  /// No description provided for @vertex.
  ///
  /// In en, this message translates to:
  /// **'Vertex'**
  String get vertex;

  /// No description provided for @vertexInputTitle.
  ///
  /// In en, this message translates to:
  /// **'Vertex values'**
  String get vertexInputTitle;

  /// No description provided for @enterValue.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get enterValue;

  /// No description provided for @parseValueError.
  ///
  /// In en, this message translates to:
  /// **'Invalid number'**
  String get parseValueError;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @tooLongValueError.
  ///
  /// In en, this message translates to:
  /// **'Too long value'**
  String get tooLongValueError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pl':
      return AppLocalizationsPl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
