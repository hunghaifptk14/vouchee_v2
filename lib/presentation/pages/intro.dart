import 'package:flutter/material.dart';
import 'package:vouchee/core/configs/assets/app_image.dart';
import 'package:vouchee/core/configs/theme/app_color.dart';
import 'package:vouchee/presentation/pages/registerPage/register.dart';
import 'package:vouchee/presentation/widgets/buttons/basic_button.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 300,
            decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage(AppImage.man))),
          ),
          Container(
            child: const Text(
              'Xin chào!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColor.secondary),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            child: const Text(
              'Cùng xem Vouchee có gì nhé',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: AppColor.secondary,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            child: const Text(
              'Trước hết hãy tạo cho mình một tài khoản.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: AppColor.secondary,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            child: BasicButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const RegisterPage()));
              },
              textColor: AppColor.white,
              title: 'Bắt đầu ngay',
              font: 16,
            ),
          )
        ],
      ),
    );
  }
}
