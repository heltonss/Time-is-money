class User {
  User({this.email, this.password, this.userName});

  factory User.fromJson(Map<String, dynamic> json) {
      return User(
        email: json['email'] as String,
        userName: json['user_name'] as String,
      );
  }

  Map<String, dynamic> toJson() => {
    'email': email,
    'user_name': userName,
  };

  final String email;
  final String password;
  String userName;
}
