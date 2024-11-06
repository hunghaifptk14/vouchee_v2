// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:vouchee/core/configs/assets/app_vector.dart';
import 'package:vouchee/core/configs/theme/app_color.dart';
import 'package:vouchee/presentation/pages/cart/cart_list.dart';
import 'package:vouchee/presentation/pages/login/google_service.dart';
import 'package:vouchee/presentation/pages/profile/profile_page.dart';
import 'package:vouchee/presentation/pages/suggestion/suggestion_page.dart';

class BottomAppBarcustom extends StatefulWidget {
  final User? user;
  const BottomAppBarcustom({
    super.key,
    this.user,
  });

  @override
  State<BottomAppBarcustom> createState() => _BottomAppBarcustomState();
}

class _BottomAppBarcustomState extends State<BottomAppBarcustom> {
  // final GoogleSignInService _googleSignInService = GoogleSignInService();
  final GoogleSignInService _authService = GoogleSignInService();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        color: AppColor.secondary,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SizedBox(
          // height: 72,
          height: 72,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      AppVector.homeIcon,
                      height: 22,
                      fit: BoxFit.cover,
                      colorFilter: const ColorFilter.mode(
                          AppColor.white, BlendMode.srcIn),
                    ),
                    iconSize: 22,
                  ),
                  const Text(
                    'Trang chủ',
                    style: TextStyle(
                        fontSize: 10,
                        color: AppColor.white,
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const SuggestionPage()));
                    },
                    icon: SvgPicture.asset(AppVector.suggestIcon,
                        height: 22,
                        fit: BoxFit.cover,
                        colorFilter: const ColorFilter.mode(
                            AppColor.white, BlendMode.srcIn)),
                    iconSize: 22,
                  ),
                  const Text("Đề xuất",
                      style: TextStyle(
                          fontSize: 10,
                          color: AppColor.white,
                          fontWeight: FontWeight.w400))
                ],
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(AppVector.promotionIcon,
                        height: 22,
                        fit: BoxFit.cover,
                        colorFilter: const ColorFilter.mode(
                            AppColor.white, BlendMode.srcIn)),
                    iconSize: 22,
                  ),
                  const Text("Đã mua",
                      style: TextStyle(
                          fontSize: 10,
                          color: AppColor.white,
                          fontWeight: FontWeight.w400))
                ],
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => CartPage()));
                    },
                    icon: SvgPicture.asset(AppVector.cartIcon,
                        height: 22,
                        fit: BoxFit.cover,
                        colorFilter: const ColorFilter.mode(
                            AppColor.white, BlendMode.srcIn)),
                    iconSize: 22,
                  ),
                  const Text('Giỏ hàng',
                      style: TextStyle(
                          fontSize: 10,
                          color: AppColor.white,
                          fontWeight: FontWeight.w400))
                ],
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () async {
                      final String googleAccessToken =
                          "eyJhbGciOiJSUzI1NiIsImtpZCI6ImU2YWMzNTcyNzY3ZGUyNjE0ZmM1MTA4NjMzMDg3YTQ5MjMzMDNkM2IiLCJ0eXAiOiJKV1QifQ.eyJuYW1lIjoiQWRtaW4gVm91Y2hlZSIsInBpY3R1cmUiOiJodHRwczovL2xoMy5nb29nbGV1c2VyY29udGVudC5jb20vYS9BQ2c4b2NLODdtLTVZd0dJLTJjbVliNUNJLWtXLTlkT3Vkemg1ODRoNEVIaTJtT2I4Ri1rSnc9czk2LWMiLCJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vdm91Y2hlZS01MDRkYSIsImF1ZCI6InZvdWNoZWUtNTA0ZGEiLCJhdXRoX3RpbWUiOjE3MzA2NDkxNTAsInVzZXJfaWQiOiJWVUtGY1B5Z2VtTkE4Q29md3VLOEV1ZW9LMHkyIiwic3ViIjoiVlVLRmNQeWdlbU5BOENvZnd1SzhFdWVvSzB5MiIsImlhdCI6MTczMDY0OTE1MCwiZXhwIjoxNzMwNjUyNzUwLCJlbWFpbCI6ImFkdm91Y2hlZUBnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiZmlyZWJhc2UiOnsiaWRlbnRpdGllcyI6eyJnb29nbGUuY29tIjpbIjEwODg2NTgzMDc1NzIxNjY5OTk1MCJdLCJlbWFpbCI6WyJhZHZvdWNoZWVAZ21haWwuY29tIl19LCJzaWduX2luX3Byb3ZpZGVyIjoiZ29vZ2xlLmNvbSJ9fQ.NjrWwEFJUXa5S3C8cvKZgy9P7liwJ0CFcEs6lmIimRB9n39iTpjPsbGyhgIh-lW-FkeqiLlijEg7NJtJ4L7Q9H0x6AklPfB_s-PYS_mm9ckrgg-IEulVWoq-T6Kq0zo4No_arb1N2aCAcLxis_X-1apEaRc4lakIog2gZgdFW0QU7bic79w6qKutOnAMawlyPpcCT9eg1t07PwMiGbs46ukTM11xRBLb0r2DDk2zetQYwTkJj-flpzB71ZpQPRk2gjPtdfgz1RqiNrix0S644Ah-3cHUEGijTAgWO_DeJGvLzNhaIUPQ73QAGsJ7gDf89wAzu-C0e6YTWa4uOWxf5w";

                      User? user = await _authService.signInWithGoogle();
                      // Navigate to homepage with the user data
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(user: user),
                        ),
                      );
                    },
                    icon: SvgPicture.asset(AppVector.userProfileIcon,
                        height: 22,
                        fit: BoxFit.cover,
                        colorFilter: const ColorFilter.mode(
                            AppColor.white, BlendMode.srcIn)),
                    iconSize: 22,
                  ),
                  const Text('Hồ sơ',
                      style: TextStyle(
                          fontSize: 10,
                          color: AppColor.white,
                          fontWeight: FontWeight.w400))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
