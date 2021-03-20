class Customer {
  final String id;
  final String email;
  final String phone;
  final String name;
  final String avatarUrl;
  final String role;
  final bool isActive;

  Customer(this.id, this.email, this.phone, this.name, this.avatarUrl,
      this.role, this.isActive);

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'phone': phone,
        'avatar-url': avatarUrl,
        'name': name,
        'role': role,
        'is_active': isActive,
      };
}
