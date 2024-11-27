// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vouchee/core/configs/assets/app_vector.dart';
import 'package:vouchee/core/configs/theme/app_color.dart';
// import 'package:vouchee/model/user.dart';
import 'package:vouchee/presentation/pages/cart/cart_list.dart';
import 'package:vouchee/presentation/pages/login/google_service.dart';
import 'package:vouchee/presentation/pages/profile/profile_page.dart';
import 'package:vouchee/presentation/pages/suggestion/suggestion_page.dart';
import 'package:vouchee/presentation/pages/wallet/wallet.dart';
import 'package:vouchee/presentation/widgets/slide.dart';

class BottomAppBarcustom extends StatefulWidget {
  // final User? user;
  const BottomAppBarcustom({
    super.key,
    // required this.user,
  });

  @override
  State<BottomAppBarcustom> createState() => _BottomAppBarcustomState();
}

class _BottomAppBarcustomState extends State<BottomAppBarcustom> {
  // final GoogleSignInService _googleSignInService = GoogleSignInService();
  final GoogleSignInService _authService = GoogleSignInService();
  @override
  Widget build(BuildContext context) {
    User? user;
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
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => WalletPage()));
                    },
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
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ProductScreen()));
                    },
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
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ProfilePage()));
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
