import 'package:intl/intl.dart';

class History {
  final int id;
  final int user;
  final String url;
  final String latex;
  final List<String> roots;
  final String message;
  final bool success;
  final String dateTime;
  final String expression;

  History(this.id, this.user, this.url, this.latex, this.roots, this.message,
      this.success, this.dateTime, this.expression);
  factory History.fromJson(Map<String, dynamic> data) {
    List<dynamic> rootsJson = data['roots'];
    List<String> roots =
        rootsJson != null ? rootsJson.map((e) => e.toString()).toList() : [];
    final dateTime = DateTime.parse(data['date_time']);
    final format = DateFormat('dd-MM-yyyy HH:mm');
    final clockString = format.format(dateTime);
    return History(
      data['id'] as int,
      data['user'] as int,
      data['url'] as String,
      data['latex'] as String,
      roots,
      data['message'] as String,
      data['success'] as bool,
      clockString,
      data['expression'] as String,
    );
  }
}
