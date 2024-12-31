// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Message {
  final String message;
  final bool status;

  Message({required this.message, required this.status});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'status': status,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      message: map['message'] as String,
      status: map['status'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source) as Map<String, dynamic>);
}
