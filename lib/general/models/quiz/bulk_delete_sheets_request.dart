/// Bulk Delete Sheets Request Model
/// Used for deleting multiple sheets at once via /sheets/bulk-delete/ endpoint
class BulkDeleteSheetsRequest {
  final List<int> ids;

  const BulkDeleteSheetsRequest({required this.ids});

  Map<String, dynamic> toJson() {
    return {'ids': ids};
  }

  factory BulkDeleteSheetsRequest.fromJson(Map<String, dynamic> json) {
    return BulkDeleteSheetsRequest(
      ids: (json['ids'] as List<dynamic>).map((e) => e as int).toList(),
    );
  }
}
