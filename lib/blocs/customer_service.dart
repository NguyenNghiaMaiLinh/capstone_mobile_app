import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:solvequation/data/customer.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CustomerService {
  Future<Customer> create(Customer customer) async {
    final storage = new FlutterSecureStorage();
    String url = await storage.read(key: "url");
    if (url == null) {
      await getUrl();
      url = await storage.read(key: "url");
    }
    var body = customer.toJson();
    try {
      var response = await http.post(
        '$url/users',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 201) {
        var dataReponse = jsonDecode(response.body);
        var data = Customer.fromJson(dataReponse['user']);
        await storage.write(key: "auto", value: "true");
        // Write value
        await storage.write(key: "id", value: data.id.toString());
        await storage.write(key: "token", value: dataReponse['token']);
        return data;
      }
      if (response.statusCode == 200) {
        var dataReponse = jsonDecode(response.body);
        var data = Customer.fromJson(dataReponse['user']);
        await storage.write(key: "auto", value: "true");
        // Write value
        await storage.write(key: "id", value: data.id.toString());
        await storage.write(key: "token", value: dataReponse['token']);
        return data;
      }
    } on SocketException {
      print('No Internet connection ');
      throw ("Internal server error!");
    } on HttpException {
      print("Couldn't find the post ");
      throw ("Internal server error!");
    } on FormatException {
      print("Bad response format ");
      throw ("Internal server error!");
    }
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
    try {
      var result = await http
          .get(
              "http://url-env.eba-rvk73mrv.ap-southeast-1.elasticbeanstalk.com/api/url/1")
          .timeout(const Duration(seconds: 60), onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, Please try again!');
      });
      String url = json.decode(result.body)['url'];
      final storage = new FlutterSecureStorage();
      await storage.write(key: "url", value: url);
    } on SocketException {
      print("You are not connected to internet");
    }
    // Create storage
  }
}
