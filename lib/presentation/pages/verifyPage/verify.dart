import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vouchee/core/configs/assets/app_vector.dart';
import 'package:vouchee/core/configs/theme/app_color.dart';
import 'package:vouchee/presentation/widgets/appBar/top_app_bar.dart';
import 'package:vouchee/presentation/widgets/buttons/basic_button.dart';

class VerifyPage extends StatelessWidget {
  const VerifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(
        topTitle: SvgPicture.asset(AppVector.logo),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            // padding: const EdgeInsets.all(0),

            children: [
              _titleText(),
              const SizedBox(
                height: 20,
              ),
              _verifyCode(),
              const SizedBox(
                height: 20,
              ),
              BasicButton(
                  onPressed: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (BuildContext context) =>
                    //             const LoginPage()));
                  },
                  backgroundColor: AppColor.primary,
                  textColor: AppColor.white,
                  title: 'Xác nhận')
            ]),
      ),
    );
  }

  Widget _titleText() {
    return const Text(
      'Nhập mã xác nhận',
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
    );
  }

  Widget _verifyCode() {
    return const TextField(
      decoration: InputDecoration(

          // errorText: _errormessage
          ),
      keyboardType: TextInputType.number,
      maxLength: 5,
    );
  }
}
