import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vouchee/core/configs/assets/app_vector.dart';
import 'package:vouchee/core/configs/theme/app_color.dart';
import 'package:vouchee/presentation/pages/verifyPage/verify.dart';
import 'package:vouchee/presentation/widgets/appBar/top_app_bar.dart';
import 'package:vouchee/presentation/widgets/buttons/basic_button.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(
        topTitle: SvgPicture.asset(AppVector.logo),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _registerText(),
            const SizedBox(
              height: 40,
            ),
            _inputFullName(context),
            const SizedBox(
              height: 20,
            ),
            _inputEmail(context),
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
                          builder: (BuildContext context) =>
                              const VerifyPage()));
                },
                backgroundColor: AppColor.primary,
                textColor: AppColor.white,
                title: 'Tiếp tục')
          ],
        ),
      ),
    );
  }

  Widget _registerText() {
    return const Text(
      'Đăng kí',
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
    );
  }

  Widget _inputFullName(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(hintText: 'Họ và tên')
          .applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _inputEmail(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(hintText: 'Email / Số điện thoại')
          .applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _inputPassword(BuildContext context) {
    return TextField(
      obscureText: true,
      decoration: const InputDecoration(hintText: 'Mật khẩu')
          .applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }
}
