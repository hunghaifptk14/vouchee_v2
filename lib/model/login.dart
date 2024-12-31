import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class LoginRole {
  final String role;
  LoginRole({
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'role': role,
    };
  }

  factory LoginRole.fromMap(Map<String, dynamic> map) {
    return LoginRole(
      role: map['role'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginRole.fromJson(String source) =>
      LoginRole.fromMap(json.decode(source) as Map<String, dynamic>);
}
