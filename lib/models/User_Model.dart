class UserModel {
  final int? userId;
  final String? username;
  final String? email;
  final String? password;
  final String? role;

  UserModel({this.userId, this.username, this.email, this.password, this.role});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      role: json['role'],
    );
  }
}
