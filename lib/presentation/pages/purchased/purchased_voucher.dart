import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vouchee/core/configs/assets/app_vector.dart';
import 'package:vouchee/core/configs/theme/app_color.dart';
import 'package:vouchee/presentation/pages/homePage/home_page.dart';

class PurchasedVoucherPage extends StatefulWidget {
  const PurchasedVoucherPage({super.key});

  @override
  State<PurchasedVoucherPage> createState() => _PurchasedVoucherPageState();
}

class _PurchasedVoucherPageState extends State<PurchasedVoucherPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Voucher của bạn'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const HomePage()));
            },
            icon: SvgPicture.asset(
              AppVector.homeIcon,
              height: 22,
              fit: BoxFit.cover,
              colorFilter:
                  const ColorFilter.mode(AppColor.black, BlendMode.srcIn),
            ),
            iconSize: 22,
          )
        ],
      ),
    );
  }
}
