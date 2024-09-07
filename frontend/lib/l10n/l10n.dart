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

  String? getLocalizedTitle(String titleKey) {
    switch (titleKey) {
      case 'Coffee Shop 4A':
        return title_1;
      case 'Apple Letter':
        return title_2;
      case 'Ascension Cathedral':
        return title_3;
      case 'If You Sit on the Shore for a Long Time':
        return title_4;
      case 'Border':
        return title_5;
      default:
        return null;
    }
  }

  String? getLocalizedAuthor(String authorKey) {
    switch (authorKey) {
      case 'Chingiz Tibey':
        return author_1;
      case 'Aliya Jimran':
        return author_2;
      case 'Talgat Dairov':
        return author_3;
      case 'Lily Kalaus':
        return author_4;
      default:
        return null;
    }
  }

  String? getLocalizedGuide(String guideKey) {
    switch (guideKey) {
      case 'Lily Kalaus':
        return guide_1;
      default:
        return null;
    }
  }

  String? getLocalizedCategory(String categoryKey) {
    switch (categoryKey) {
      case 'Historical Sites and Monuments':
        return category_1;
      case 'Natural Landmarks':
        return category_2;
      case 'Cultural Institutions and Museums':
        return category_3;
      case 'Religious Places':
        return category_4;
      case 'Architectural Landmarks and Structures':
        return category_5;
      case 'Entertainment Complexes and Parks':
        return category_6;
      case 'Recreational and Sports Facilities':
        return category_7;
      case 'Gastronomic Attractions':
        return category_8;
      default:
        return null;
    }
  }

  String? getLocalizedDescription(String descriptionKey) {
    switch (descriptionKey) {
      case 'description_1':
        return description_1;
      case 'description_2':
        return description_2;
      case 'description_3':
        return description_3; // Note: There's a typo in your .arb file for this key
      default:
        return null;
    }
  }
}
