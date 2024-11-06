// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:vouchee/core/configs/assets/app_vector.dart';
import 'package:vouchee/core/configs/theme/app_color.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? topTitle;
  // final bool? isVisible;
  const TopAppBar({
    super.key,
    this.topTitle,
    // this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                PopScope(
                  child: IconButton(
                    icon: Container(
                      height: 30,
                      width: 30,
                      decoration: const BoxDecoration(
                          color: Colors.transparent, shape: BoxShape.circle),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 20,
                        color: AppColor.black,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Container(
                  child: topTitle,
                ),
              ],
            ),
            IconButton(
                onPressed: () {
                  // Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (BuildContext context) => const CartPage()));
                },
                icon: SvgPicture.asset(AppVector.cartIcon))
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
