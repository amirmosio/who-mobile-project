import 'package:intl/intl.dart';

class NotificationItem {
  final int id;
  final String title;
  final String dateTimeString;

  DateTime get dateTime {
    final DateFormat format = DateFormat('yyyy-MM-dd HH:mm:ss.SSSSSS');
    return format.parse(dateTimeString);
  }

  NotificationItem({
    required this.id,
    required this.title,
    required this.dateTimeString,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'],
      title: json['property_name'],
      dateTimeString: json['date_time'],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "property_name": title,
    "date_time": dateTimeString,
  };

  factory NotificationItem.empty() {
    return NotificationItem(id: 0, title: '', dateTimeString: '');
  }
}
