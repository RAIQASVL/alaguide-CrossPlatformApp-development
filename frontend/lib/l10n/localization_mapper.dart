class LocalizationMapper {
  static String? mapTitle(String? key) {
    switch (key) {
      case 'Coffee Shop 4A':
        return 'title_1';
      case 'Apple Letter':
        return 'title_2';
      case 'Ascension Cathedral':
        return 'title_3';
      case 'If You Sit on the Shore for a Long Time':
        return 'title_4';
      case 'Border':
        return 'title_5';
      default:
        return null;
    }
  }

  static String? mapAuthor(String? key) {
    switch (key) {
      case 'Chingiz Tibey':
        return 'author_1';
      case 'Aliya Jimran':
        return 'author_2';
      case 'Talgat Dairov':
        return 'author_3';
      case 'Lily Kalaus':
        return 'author_4';
      default:
        return null;
    }
  }

  static String? mapGuide(String? key) {
    switch (key) {
      case 'Lily Kalaus':
        return 'guide_1';
      default:
        return null;
    }
  }

  static String? mapCategory(String? key) {
    switch (key) {
      case 'Historical Sites and Monuments':
        return 'category_1';
      case 'Natural Landmarks':
        return 'category_2';
      case 'Cultural Institutions and Museums':
        return 'category_3';
      case 'Religious Places':
        return 'category_4';
      case 'Architectural Landmarks and Structures':
        return 'category_5';
      case 'Entertainment Complexes and Parks':
        return 'category_6';
      case 'Recreational and Sports Facilities':
        return 'category_7';
      case 'Gastronomic Attractions':
        return 'category_8';
      default:
        return null;
    }
  }

  static String? mapDescription(int? id) {
    switch (id) {
      case 1:
        return 'description_1';
      case 2:
        return 'description_2';
      case 3:
        return 'description_3';
      // Add more cases as needed
      default:
        return null;
    }
  }
}
