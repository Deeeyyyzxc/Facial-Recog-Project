class User {
  final String name;
  final String email;

  User({required this.name, required this.email});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
    };
  }
}
