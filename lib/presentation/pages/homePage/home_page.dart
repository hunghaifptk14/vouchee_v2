// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vouchee/core/configs/assets/app_vector.dart';
import 'package:vouchee/presentation/pages/category/category_list.dart';
import 'package:vouchee/presentation/pages/voucher/voucher_list.dart';

import 'package:vouchee/presentation/widgets/bottomNav/bottom_app_bar.dart';

class HomePage extends StatelessWidget {
  final User? user;
  const HomePage({
    super.key,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomAppBarcustom(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // Banner Image
            SizedBox(
              height: 250,
              width: double.infinity,
              child: SvgPicture.asset(AppVector.logo),
              // fit: BoxFit.cover,
            ),

            // Search Field
            // const Padding(
            //     padding: EdgeInsets.all(16), child: SearchBarCustom()),

            // const SizedBox(height: 16),

            // "Khám phá" Section Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Khám phá',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: CategoryList(),
            ),
            const SizedBox(height: 8),

            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Giành cho bạn',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Fetch and Display Product Cards
            // const SizedBox(width: 380, height: 600, child: VoucherPageTest())
            SizedBox(child: VoucherList()),
          ],
        ),
      ),
    );
  }
}
