import 'dart:convert';

import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:solvequation/data/result.dart';

class ImageService {
  Future<ResultItem> Upload(File imageFile) async {
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    var uri = Uri.parse('${url}/api/images');

    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));
    //contentType: new MediaType('image', 'png'));

    request.files.add(multipartFile);
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      print('response.body ' + response.body);
      final body = json.decode(response.body);
      String expression = body['expression'];
      bool success = body['success'];
      String message = body['message'];
      String latex = body['latex'];
      // expression = 'r"""$expression"""';
      print(expression);
      var rootsJson = jsonDecode(response.body)['roots'];
      List<double> roots = rootsJson != null ? List.from(rootsJson) : null;
      ResultItem result =
          new ResultItem(success, message, latex, expression, roots);
      return result;
    }

    // http.Response.fromStream(streamedResponse).then((response) {
    //   if (response.statusCode == 200) {
    //     print('response.body ' + response.body);
    //     final body = json.decode(response.body);
    //     String expression = body['expression'];
    //     expression = 'r"""$expression"""';
    //     print(expression);
    //     var rootsJson = jsonDecode(response.body)['roots'];
    //     List<double> roots = rootsJson != null ? List.from(rootsJson) : null;
    //     ResultItem result =
    //         new ResultItem(expression: expression, roots: roots);
    //     return result;
    //   }
    // request.send().then((result) async {
    //   http.Response.fromStream(result).then((response) {
    //     if (response.statusCode == 200) {
    //       print('response.body ' + response.body);
    //       final body = json.decode(response.body);
    //       String expression = body['expression'];
    //       expression = 'r"""$expression"""';
    //       print(expression);
    //       var rootsJson = jsonDecode(response.body)['roots'];
    //       List<double> roots = rootsJson != null ? List.from(rootsJson) : null;
    //       ResultItem result = new ResultItem(expression, roots);
    //       return result;
    //     }
    //   });
    // }).catchError((err) => print('error : ' + err.toString()));
  }
}
