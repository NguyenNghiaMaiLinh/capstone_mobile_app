import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:solvequation/data/customer.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CustomerService {
  Future create(Customer customer) async {
    final storage = new FlutterSecureStorage();
    String url = await storage.read(key: "url");
    var body = customer.toJson();
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
      storage.write(key: "auto", value: "true");
      // Write value
      storage.write(key: "id", value: data.id.toString());
      storage.write(key: "token", value: dataReponse['token']);
      return data;
    } else {
      var dataReponse = jsonDecode(response.body);
      var data = Customer.fromJson(dataReponse['user']);
      storage.write(key: "auto", value: "true");
      // Write value
      storage.write(key: "id", value: data.id.toString());
      storage.write(key: "token", value: dataReponse['token']);
      return data;
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
    var result = await http.get(
        "http://url-env.eba-rvk73mrv.ap-southeast-1.elasticbeanstalk.com/api/url/1");
    String url = json.decode(result.body)['url'];
    final storage = new FlutterSecureStorage();
    storage.write(key: "url", value: url);
    // Create storage
  }
}
