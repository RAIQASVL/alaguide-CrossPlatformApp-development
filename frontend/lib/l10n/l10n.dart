import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class L10n {
  static final all = [
    const Locale('en', 'US'),
    const Locale('ru', 'RU'),
    const Locale('kk', 'KK'),
  ];
}

extension AppLocalizationsX on AppLocalizations {
  String? getCountryName(String countryKey) {
    switch (countryKey) {
      case 'Kazakhstan':
        return kazakhstan;
      case 'Russia':
        return russia;
      case 'United Kingdom':
        return uk;

      default:
        return null;
    }
  }

  String? getCityName(String cityKey) {
    switch (cityKey) {
      case '1':
        return almaty; // Use a hardcoded string or localization key if needed
      case '2':
        return moscow; // These should match the localization keys in your ARB files
      case '3':
        return london; // Ensure these are defined in your localization files
      // Add more cases for other cities as needed
      default:
        return null; // Return null or a default value if cityKey doesn't match
    }
  }
}
