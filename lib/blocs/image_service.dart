import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:solvequation/data/history.dart';
import 'package:solvequation/data/result.dart';

class ImageService {
  Future<ResultItem> Upload(File imageFile) async {
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    final storage = new FlutterSecureStorage();
    String id = await storage.read(key: "id");
    String url = await storage.read(key: "url");
    String token = await storage.read(key: "token");
    String auto = await storage.read(key: "auto");
    var uri = Uri.parse('$url/users/$id/images');
    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));
    if (auto == "true") {
      Map<String, String> requestBody = <String, String>{'save': '1'};
      request.fields.addAll(requestBody);
    }
    request.files.add(multipartFile);
    final Map<String, String> headers = {'Authorization': '$token'};
    request.headers.addAll(headers);
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      String expression = body['expression'] ?? "";
      bool success = body['success'];
      String message = body['message'] ?? "";
      String latex = body['latex'] ?? "";
      int id = body['id'];
      int user = body['user'];
      String url = body['url'] ?? "";
      String datetime;
      if (body['date_time'] != null) {
        final dateTime = DateTime.parse(body['date_time']);
        final format = DateFormat('dd-MM-yyyy HH:mm');
        datetime = format.format(dateTime);
      }
      List<dynamic> rootsJson = jsonDecode(response.body)['roots'];
      List<String> roots =
          rootsJson != null ? rootsJson.map((e) => e.toString()).toList() : [];
      ResultItem result = new ResultItem(success, message, latex, expression,
          roots, id, url, user, datetime, response.statusCode);
      return result;
    } else if (response.statusCode == 201) {
      final body = json.decode(response.body);
      String expression = body['expression'] ?? "";
      bool success = body['success'];
      String message = body['message'] ?? "";
      String latex = body['latex'] ?? "";
      int id = body['id'];
      int user = body['user'];
      String url = body['url'] ?? "";
      String datetime;
      if (body['date_time'] != null) {
        final dateTime = DateTime.parse(body['date_time']);
        final format = DateFormat('dd-MM-yyyy HH:mm');
        datetime = format.format(dateTime);
      }

      List<dynamic> rootsJson = jsonDecode(response.body)['roots'];
      List<String> roots =
          rootsJson != null ? rootsJson.map((e) => e.toString()).toList() : [];
      ResultItem result = new ResultItem(success, message, latex, expression,
          roots, id, url, user, datetime, response.statusCode);
      return result;
    } else {
      ResultItem result = new ResultItem(
          true, "", "", "", null, 0, "", 0, "", response.statusCode);
    }
  }

  Future<HistoryData> getHistory(int page) async {
    int limit = 5;
    int offset = page * limit;
    final storage = new FlutterSecureStorage();
    HistoryData result;
    String url = await storage.read(key: "url");
    String id = await storage.read(key: "id");
    String token = await storage.read(key: "token");
    await http
        .get('$url/users/$id/images?offset=$offset&limit=$limit', headers: {
      'Authorization': '$token',
    }).then((response) {
      result = new HistoryData.fromResponse(response);
    });
    return result;
  }

  // Future<List<History>> getHistory(int id) async {
  //   final storage = new FlutterSecureStorage();
  //   List<History> result = <History>[];
  //   String url = await storage.read(key: "url");
  //   String id_new = await storage.read(key: "id");
  //   await http.get("https://api.mocki.io/v1/6ca9ab7a").then((response) {
  //     if (response.statusCode == 200) {
  //       if (response.body != null) {
  //         result = (json.decode(response.body) as List)
  //             .map((i) => History.fromJson(i))
  //             .toList();
  //       }
  //     } else {
  //       return result;
  //     }
  //   });
  //   return result;
  // }

  Future<History> getHistoryDetail(int id) async {
    final storage = new FlutterSecureStorage();
    History result;
    String url = await storage.read(key: "url");
    String id_user = await storage.read(key: "id");
    String token = await storage.read(key: "token");
    String path = "$url/users/$id_user/images/$id";
    await http.get(path, headers: {
      'Authorization': '$token',
    }).then((response) {
      if (response.statusCode == 200) {
        if (response.body != null) {
          result = History.fromJson(json.decode(response.body));
        }
      } else {
        return result;
      }
    });
    return result;
  }
  Future<History> deleteImage(int id) async {
    final storage = new FlutterSecureStorage();
    History result;
    String url = await storage.read(key: "url");
    String id_user = await storage.read(key: "id");
    String token = await storage.read(key: "token");
    String path = "$url/users/$id_user/images/$id";
    await http.delete(path, headers: {
      'Authorization': '$token',
    }).then((response) {
      if (response.statusCode == 200) {
        if (response.body != null) {
          result = History.fromJson(json.decode(response.body));
        }
      } else {
        return result;
      }
    });
    return result;
  }
}
