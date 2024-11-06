import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vouchee/core/configs/assets/app_vector.dart';
import 'package:vouchee/core/configs/theme/app_color.dart';
import 'package:vouchee/presentation/pages/cart/cart_list.dart';

class CartButton extends StatelessWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const CartPage()));
      },
      icon: SvgPicture.asset(
        AppVector.homeIcon,
        height: 22,
        fit: BoxFit.cover,
        colorFilter: const ColorFilter.mode(AppColor.white, BlendMode.srcIn),
      ),
      iconSize: 22,
    );
  }
}
