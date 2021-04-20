class User {
  User({this.email, this.userName, this.userId, this.password});

  factory User.fromJson(Map<String, dynamic> json) {
      return User(
        email: json['email'] as String,
        password: json['password'] as String,
      );
  }

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
  };

  final String userId;
  final String email;
  final String userName;
  final String password;
}
