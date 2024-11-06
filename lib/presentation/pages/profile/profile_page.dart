// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vouchee/presentation/pages/login/google_service.dart';
import 'package:vouchee/presentation/pages/login/login.dart';
import 'package:vouchee/presentation/pages/profile/user_info.dart';

class ProfilePage extends StatefulWidget {
  final User? user;
  const ProfilePage({
    super.key,
    this.user,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GoogleSignInService googleSignInService = GoogleSignInService();
  // @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Hồ sơ'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: widget.user != null
                    ? UserInfoDisplay(user: widget.user!)
                    : const Text('Không tìm thấy người dùng.'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await googleSignInService.signOut();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const LoginPage()));
                },
                child: const Text('Sign out'),
              ),
            ],
          ),
        ));
  }
}
