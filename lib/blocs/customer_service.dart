import 'package:solvequation/constants/constants.dart';
import 'package:solvequation/data/customer.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ImageService {
  Future<Customer> Create(Customer customer) async {
    var url = '$URL/users';
    var body = customer.toJson();
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(body)));
    HttpClientResponse response = await request.close();
    // String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    return customer;
  }
}
