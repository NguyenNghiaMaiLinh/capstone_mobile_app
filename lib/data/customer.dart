import 'dart:convert';
import 'package:http/http.dart' as http;

class Customer {
  final int id;
  final String email;
  final String phone;
  final String name;
  final String avatarUrl;
  final String password;
  final int role;
  final bool isActive;
  final String uid;

  Customer(this.id, this.email, this.uid, this.phone, this.name, this.avatarUrl,
      this.password, this.role, this.isActive);

  factory Customer.fromJson(Map<String, dynamic> data) => Customer(
      data['id'],
      data['email'],
      data['phone'],
      data['uid'],
      data['avatar_url'],
      data['password'],
      data['name'],
      data['role'] as int,
      data['is_active'] as bool);

  Map<String, dynamic> toJson() => {'uid': uid};
}

class CustomerData {
  final Customer customer;
  final int status;
  CustomerData(this.customer, this.status);
  factory CustomerData.fromResponse(http.Response response) {
    var statusCode = response.statusCode;
    Map<String, dynamic> jsonData = json.decode(response.body);
    return CustomerData(Customer.fromJson(jsonData), statusCode);
  }
}
