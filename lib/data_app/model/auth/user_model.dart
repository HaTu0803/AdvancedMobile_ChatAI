class UserModel {
  final String email;
  final String name;

  UserModel({
    required this.email,
    required this.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        email: json['email'],
        name: json['name'],
      );
}
