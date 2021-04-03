import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class HistoryData {
  final List<History> histories;
  final int total;
  final int statusCode;
  HistoryData(this.histories, this.statusCode, this.total);
  factory HistoryData.fromResponse(http.Response response) {
    Map<String, dynamic> jsonData = json.decode(response.body);
    var statusCode = response.statusCode;
    var histories =
        (jsonData['data'] as List).map((i) => History.fromJson(i)).toList();
    return HistoryData(histories, statusCode, jsonData['total'] as int);
  }
}

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
