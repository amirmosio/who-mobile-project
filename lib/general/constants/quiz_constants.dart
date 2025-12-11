/// Quiz answer result values (matching iOS/Android exactly)
enum QuizAnswerResult {
  wrong(0), // Risposta errata
  correct(1), // Risposta corretta
  notAnswered(2); // Non risposta

  const QuizAnswerResult(this.value);

  final int value;

  static QuizAnswerResult? fromValue(int value) {
    for (final result in QuizAnswerResult.values) {
      if (result.value == value) return result;
    }
    return null;
  }
}

/// Sheet types (matching iOS exactly)
enum SheetType {
  ministerial(0), // Quiz ministeriale / Quiz ministeriale con manuale
  ministerialByTopic(1), // Quiz ministeriale per argomento
  errorReview(2), // Ripasso errori
  errorReviewByTopic(3), // Ripasso errori per argomento
  teacherSheet(4), // Scheda insegnante (assigned by teacher)
  exercise(5), // Esercitazione
  offlineTeacherSheet(100); // Temporary offline teacher sheet status

  const SheetType(this.value);

  final int value;

  static SheetType? fromValue(int value) {
    for (final type in SheetType.values) {
      if (type.value == value) return type;
    }
    return null;
  }

  /// Check if a sheet is a teacher sheet
  static bool isTeacherSheet(int type, int? teacherId) {
    return (type == SheetType.teacherSheet.value ||
            type == SheetType.offlineTeacherSheet.value) &&
        (teacherId != null && teacherId > 0);
  }

  /// Get display name for sheet type by int value
  static String getDisplayName(int type) {
    final sheetType = SheetType.fromValue(type);
    return sheetType?.displayName ?? 'Quiz';
  }
}

/// Extension to add display name functionality to SheetType
extension SheetTypeExtension on SheetType {
  /// Get display name for sheet type
  String get displayName {
    switch (this) {
      case SheetType.ministerial:
        return 'Quiz Ministeriale';
      case SheetType.ministerialByTopic:
        return 'Quiz per Argomento';
      case SheetType.errorReview:
        return 'Ripasso Errori';
      case SheetType.errorReviewByTopic:
        return 'Ripasso Errori per Argomento';
      case SheetType.teacherSheet:
      case SheetType.offlineTeacherSheet:
        return 'Scheda Insegnante';
      case SheetType.exercise:
        return 'Esercitazione';
    }
  }
}
