extension RouteTemplates on String {
  String get addIdPath {
    return "$this/:id";
  }

  String get addJsonPath {
    return "$this/:json";
  }

  String get addExtraJsonPath {
    return "$this/:extraJson";
  }

  String get addFiltersPath {
    return "$this/:filters";
  }

  String get addDateStringPath {
    return "$this/:date";
  }
}
