class User {
  User({this.email, this.password, this.userName});

  factory User.fromJson(Map<String, dynamic> json) {
      return User(
        email: json['email'] as String,
        userName: json['userName'] as String,
      );
  }

  Map<String, dynamic> toJson() => {
    'email': email,
    'userName': userName,
  };

  final String email;
  final String password;
  String userName;
}
