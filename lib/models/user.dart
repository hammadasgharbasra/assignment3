class User {
  final String name;
  final String address;
  final String password;

  User({required this.name, required this.address, required this.password});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'password': password,
    };
  }
}
