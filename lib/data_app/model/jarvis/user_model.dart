class CurrentUserReponse {
  final String id;
  final String email;
  final String username;
  final List<String> roles;
  final Map<String, dynamic>? geo;

  CurrentUserReponse({
    required this.id,
    required this.email,
    required this.username,
    required this.roles,
    this.geo,
  });

  factory CurrentUserReponse.fromJson(Map<String, dynamic> json) {
    return CurrentUserReponse(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      roles: List<String>.from(json['roles'] ?? []),
      geo: json['geo'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'roles': roles,
      'geo': geo,
    };
  }
}
