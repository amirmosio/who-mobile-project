/// Utility functions for client-side list searching and filtering
class SearchUtils {
  /// Generic filter function that searches a list by extracting searchable text
  ///
  /// [items] - The list to filter
  /// [query] - The search query (case-insensitive)
  /// [getSearchableText] - Function to extract searchable text from an item
  ///
  /// Returns filtered list if query is not empty, otherwise returns a copy of all items
  static List<T> filterList<T>(
    List<T> items,
    String query,
    String Function(T) getSearchableText,
  ) {
    if (query.isEmpty) {
      return List.from(items);
    }

    final searchLower = query.toLowerCase();
    return items.where((item) {
      final searchableText = getSearchableText(item).toLowerCase();
      return searchableText.contains(searchLower);
    }).toList();
  }

  /// Filter with multiple searchable fields
  ///
  /// [items] - The list to filter
  /// [query] - The search query (case-insensitive)
  /// [getSearchableTexts] - Function to extract multiple searchable texts from an item
  ///
  /// Returns filtered list where query matches ANY of the searchable fields
  static List<T> filterListMultiField<T>(
    List<T> items,
    String query,
    List<String> Function(T) getSearchableTexts,
  ) {
    if (query.isEmpty) {
      return List.from(items);
    }

    final searchLower = query.toLowerCase();
    return items.where((item) {
      final texts = getSearchableTexts(item);
      return texts.any((text) => text.toLowerCase().contains(searchLower));
    }).toList();
  }
}
