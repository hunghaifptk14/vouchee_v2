import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vouchee/core/configs/assets/app_image.dart';
import 'package:vouchee/core/configs/assets/app_vector.dart';
import 'package:vouchee/networking/api_request.dart';
import 'package:vouchee/presentation/pages/homePage/home_page.dart';
import 'package:vouchee/presentation/pages/login/google_service.dart';
import 'package:vouchee/presentation/widgets/snack_bar.dart';

import '../../../../core/configs/theme/app_color.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GoogleSignInService _authService = GoogleSignInService();
  ApiServices apiServices = ApiServices();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 60.0),
              child: SizedBox(
                  height: 200, child: SvgPicture.asset(AppVector.logo)),
            ),
            Container(
              height: 250,
              decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage(AppImage.man))),
            ),
            _loginWithGoogle(),
          ],
        ),
      ),
    );
  }

  Widget _Logout() {
    return IconButton(
        onPressed: () async {
          await GoogleSignIn().signOut();
          FirebaseAuth.instance.signOut();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginPage()));
        },
        icon: Icon(Icons.logout));
  }

  Widget _loginWithGoogle() {
    bool isLoading = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return isLoading
            ? CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });

                  try {
                    User? user = await _authService.signInWithGoogle();

                    if (user != null && mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    } else if (mounted) {
                      // Handle case where user is null
                      TopSnackbar.show(
                          context, 'Login thất bại, vui lòng thử lại');
                    }
                  } catch (e) {
                    if (mounted) {
                      TopSnackbar.show(
                          context, 'Đã xải ra lỗi, vui lòng thử lại');
                    }
                  } finally {
                    if (mounted) {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: const Text(
                        'Đăng nhập với Google',
                        style: TextStyle(color: AppColor.white),
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }
}
