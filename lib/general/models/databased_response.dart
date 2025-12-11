import 'package:who_mobile_project/general/constants/api_error_types.dart';

class DataBasedResponse<T, M extends BaseMetaData> {
  bool ok;
  T? successData;
  M? metaData;
  String? errorTypeStrings;
  String? errorMessage;

  // Getter to provide 'data' alias for 'successData'
  T? get data => successData;

  ErrorType? get errorType {
    if (errorTypeStrings != null) {
      return getByErrorTypeByErrorTypeString(errorTypeStrings!);
    }
    return null;
  }

  DataBasedResponse({required this.ok});

  factory DataBasedResponse.fromJson(
    dynamic json,
    T Function(Object? data) fromJsonT,
    M Function(Object? metadata) fromJsonM,
  ) {
    bool computedOk;
    if (json is Map<String, dynamic>) {
      if (json.containsKey('ok')) {
        computedOk = (json['ok'] as bool?) ?? false;
      } else if (json.containsKey('detail') || json.containsKey('error')) {
        computedOk = false;
      } else {
        try {
          // Prefer 'data' when available; otherwise treat the whole map as the data payload
          if (json.containsKey('data')) {
            var _ = fromJsonT(json['data']);
          } else if (!json.containsKey('detail') &&
              !json.containsKey('error')) {
            var _ = fromJsonT(json);
          }
          computedOk = true;
        } catch (e) {
          computedOk = false;
        }
      }
    } else {
      // Non-map payloads (e.g., list or primitive) are considered success data
      computedOk = true;
    }

    final DataBasedResponse<T, M> res = DataBasedResponse<T, M>(ok: computedOk);

    if (json is Map<String, dynamic>) {
      if (json['meta'] != null) {
        res.metaData = fromJsonM(json['meta']);
      }

      if (res.ok) {
        // Prefer 'data' when available; otherwise treat the whole map as the data payload
        if (json.containsKey('data')) {
          res.successData = fromJsonT(json['data']);
        } else if (!json.containsKey('detail') && !json.containsKey('error')) {
          res.successData = fromJsonT(json);
        }
      } else {
        // Unified error handling: "detail" or { error: { message, code } }
        if (json['detail'] != null) {
          if (json['detail'] is String) {
            res.errorMessage = json['detail'] as String;
          } else if (json['detail'] is List) {
            // FastAPI / DRF-style validation errors: [{loc, msg, type}, ...]
            res.errorMessage = (json['detail'] as List)
                .map((e) => e['msg'])
                .join('\n');
          }
          res.errorTypeStrings = ErrorType.validationError.identifier;
        } else if (json['error'] != null) {
          final dynamic err = json['error'];
          if (err is Map<String, dynamic>) {
            res.errorMessage = err['message']?.toString();
            res.errorTypeStrings = err['code']?.toString();
          } else {
            res.errorMessage = err?.toString();
          }
        } else {
          res.errorMessage = json.keys
              .map((e) => "$e: ${json[e]}")
              .toList()
              .join("\n");
        }
      }
    } else {
      // Non-map success payloads (e.g., list root)
      if (res.ok) {
        res.successData = fromJsonT(json);
      }
    }

    return res;
  }
}

class BaseMetaData {
  BaseMetaData();

  factory BaseMetaData.fromJson(Object? json) {
    return BaseMetaData();
  }
}

class PaginatedMetaData extends BaseMetaData {
  int totalItems;
  int limit;
  int offset;

  PaginatedMetaData({
    required this.totalItems,
    required this.limit,
    required this.offset,
  });

  factory PaginatedMetaData.fromJson(Map<String, dynamic> json) {
    return PaginatedMetaData(
      totalItems: json['total_items'],
      limit: json['limit'],
      offset: json['offset'],
    );
  }
}
