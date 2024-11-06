import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vouchee/presentation/pages/homePage/home_page.dart';
import 'package:vouchee/presentation/pages/login/google_service.dart';
import 'package:vouchee/presentation/widgets/buttons/basic_button.dart';

import '../../../../core/configs/theme/app_color.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GoogleSignInService _authService = GoogleSignInService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: TopAppBar(
      //   topTitle: SvgPicture.asset(AppVector.logo),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _loginText(),
            const SizedBox(
              height: 40,
            ),
            _inputLogin(context),
            const SizedBox(
              height: 20,
            ),
            _inputPassword(context),
            const SizedBox(
              height: 30,
            ),
            BasicButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => HomePage()));
                },
                backgroundColor: AppColor.primary,
                textColor: AppColor.white,
                title: 'Đăng nhập'),
            const SizedBox(
              height: 20,
            ),
            _otherText(),
            const SizedBox(
              height: 20,
            ),
            _loginWithGoogle(),
          ],
        ),
      ),
    );
  }

  Widget _loginText() {
    return const Text(
      'Đăng nhập',
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
    );
  }

  Widget _inputLogin(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(hintText: 'Số điện thoại / Email')
          .applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _inputPassword(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(hintText: 'Nhập mật khẩu')
          .applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _otherText() {
    return const Text(
      'Hoặc',
      style: TextStyle(
          fontSize: 15, fontWeight: FontWeight.w300, color: AppColor.grey),
    );
  }

  Widget _loginWithGoogle() {
    return ElevatedButton(
      onPressed: () async {
        // if (await confirm(
        //   context,
        //   title: const Text('Confirm'),
        //   content: const Text('Would you like to remove?'),
        //   textOK: const Text('Yes'),
        //   textCancel: const Text('No'),
        // )) {
        //   return print('pressedOK');
        // }
        // return print('pressedCancel');
        // User? user = await _authService.signInWithGoogle(googleAccessToken);
        User? user = await _authService.signInWithGoogle();

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(user: user),
            ));
      },
      child: const Text(
        'Sign in with Google',
        style: TextStyle(color: AppColor.white),
      ),
    );
  }
}
