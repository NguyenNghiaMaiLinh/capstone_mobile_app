class Customer {
  final String id;
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

  Map<String, dynamic> toJson() => {
        'email': email,
        'phone': phone,
        'uid': uid,
        'avatar_url': avatarUrl,
        'password': password,
        'name': name,
        'role': role,
        'is_active': isActive,
      };
}
