import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:solvequation/constants/constants.dart';
import 'package:solvequation/data/customer.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CustomerService {
  Future create(Customer customer) async {
    final storage = new FlutterSecureStorage();
    String url = await storage.read(key: "url");
    var body = customer.toJson();
    http
        .post(
      'https://api.mocki.io/v1/184c1f25',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    )
        .then((value) {
      if (value.statusCode == 201) {
        var data = Customer.fromJson(jsonDecode(value.body));
        // Delete value
        storage.delete(key: "id");
        // Write value
        storage.write(key: "id", value: data.id);
      } else {
        var data = Customer.fromJson(jsonDecode(value.body));
        // Delete value
        storage.delete(key: "id");
        // Write value
        storage.write(key: "id", value: data.id);
      }
    });
  }
  //   Future create(Customer customer) async {
  //   final storage = new FlutterSecureStorage();
  //   String url = await storage.read(key: "url");
  //   var body = customer.toJson();
  //   http
  //       .post(
  //     '$url/users',
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(body),
  //   )
  //       .then((value) {
  //     if (value.statusCode == 201) {
  //       var data = Customer.fromJson(jsonDecode(value.body));
  //       // Delete value
  //       storage.delete(key: "id");
  //       // Write value
  //       storage.write(key: "id", value: data.id);
  //     } else {
  //       var data = Customer.fromJson(jsonDecode(value.body));
  //       // Delete value
  //       storage.delete(key: "id");
  //       // Write value
  //       storage.write(key: "id", value: data.id);
  //     }
  //   });
  // }

  Future getUrl() async {
    http
        .get("https://fuslqewebapi20210320190107.azurewebsites.net/api/url/1")
        .then((result) {
      String url = json.decode(result.body)['url'];
      final storage = new FlutterSecureStorage();
      // Delete value
      storage.delete(key: "url");
      // Write value
      storage.write(key: "url", value: url);
      print(url);
    });
    // Create storage
  }
}
