import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:solvequation/data/history.dart';
import 'package:solvequation/data/result.dart';
import 'package:solvequation/constants/constants.dart';

class ImageService {
  Future<ResultItem> Upload(File imageFile) async {
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    final storage = new FlutterSecureStorage();
    String url = await storage.read(key: "url");
    var uri = Uri.parse('$url/images');

    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));
    //contentType: new MediaType('image', 'png'));

    request.files.add(multipartFile);
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      String expression = body['expression'];
      bool success = body['success'];
      String message = body['message'];
      String latex = body['latex'];
      List<dynamic> rootsJson = jsonDecode(response.body)['roots'];
      List<String> roots =
          rootsJson != null ? rootsJson.map((e) => e.toString()).toList() : [];
      ResultItem result =
          new ResultItem(success, message, latex, expression, roots);
      return result;
    }
  }

  // Future<List<History>> getHistory(String id) async {
  //   final storage = new FlutterSecureStorage();
  //   String url = await storage.read(key: "url");
  //   http.get('$url/users/$id/images').then((result) {
  //     if (result.statusCode == 200) {
  //       final response = json.decode(result.body);
  //       var datas = History.fromJson(response);
  //       print(datas);
  //       return datas;
  //     } else {
  //       return null;
  //     }
  //   });
  // }
  Future<List<History>> getHistory(String id) async {
    final storage = new FlutterSecureStorage();
    String url = await storage.read(key: "url");
    var response = await http.get('https://api.mocki.io/v1/34605ff8');
    if (response.statusCode == 200) {
      List<History> result = <History>[];
      if (response.body != null) {
        result = (json.decode(response.body) as List)
            .map((i) => History.fromJson(i))
            .toList();
      }

      return result;
    } else {
      return null;
    }
  }
}
