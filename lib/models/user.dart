class User {
  int? id;
  String name;
  String email;
  String password;
  int isAdmin;
  String? createdAt;
  String? updatedAt;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.isAdmin,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
      'is_admin': isAdmin,
      'created_at': createdAt ?? DateTime.now().toIso8601String(),
      'updated_at': updatedAt ?? DateTime.now().toIso8601String(),
    };
    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      isAdmin: map['is_admin'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }
}
