import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserInfoDisplay extends StatelessWidget {
  final User user;

  const UserInfoDisplay({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(user.photoURL ?? ""),
          ),
          const SizedBox(height: 20),
          Text('Tên: ${user.displayName}',
              style: const TextStyle(fontSize: 20)),
          Text('Email: ${user.email}', style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
