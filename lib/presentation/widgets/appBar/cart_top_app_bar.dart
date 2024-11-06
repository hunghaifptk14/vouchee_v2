import 'package:flutter/material.dart';
import 'package:vouchee/core/configs/theme/app_color.dart';

class CartTopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? topTitle;
  const CartTopAppBar({super.key, this.topTitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
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
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (BuildContext context) => const HomePage()));
          },
        ),
        const SizedBox(
          width: 8,
        ),
        Container(
          child: topTitle,
        ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
