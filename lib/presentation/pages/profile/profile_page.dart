// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vouchee/core/configs/assets/app_vector.dart';
import 'package:vouchee/core/configs/theme/app_color.dart';

import 'package:vouchee/presentation/pages/homePage/home_page.dart';
import 'package:vouchee/presentation/pages/login/login.dart';

class ProfilePage extends StatelessWidget {
  // final User? user;

  const ProfilePage({
    super.key,
    // required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Information'),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display User Image
            // Center(
            //   child: CircleAvatar(
            //     radius: 50,
            //     backgroundImage: NetworkImage(user.image),
            //   ),
            // ),
            // const SizedBox(height: 16),

            // // User Name
            // Text(
            //   'Name: ${user.name}',
            //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(height: 8),

            // // Email
            // Text(
            //   'Email: ${user.email}',
            //   style: TextStyle(fontSize: 16),
            // ),
            // const SizedBox(height: 8),

            // // Phone Number
            // Text(
            //   'Phone Number: ${user.phoneNumber ?? "Not Provided"}',
            //   style: TextStyle(fontSize: 16),
            // ),
            // const SizedBox(height: 8),

            // // Role
            // Text(
            //   'Role: ${user.roleName}',
            //   style: TextStyle(fontSize: 16),
            // ),
            // const SizedBox(height: 8),

            // // Status
            // Text(
            //   'Status: ${user.status}',
            //   style: TextStyle(fontSize: 16),
            // ),
            // const SizedBox(height: 8),

            // // Wallet Information
            // Text(
            //   'Buyer Wallet Balance: ${user.buyerWallet.balance}',
            //   style: TextStyle(fontSize: 16),
            // ),
            // const SizedBox(height: 8),

            // Text(
            //   'Seller Wallet Balance: ${user.sellerWallet.balance}',
            //   style: TextStyle(fontSize: 16),
            // ),
            // const SizedBox(height: 16),

            // // Display other details as needed
            // Text(
            //   'Account Created: ${user.createDate}',
            //   style: TextStyle(fontSize: 16),
            // ),
            IconButton(
                onPressed: () async {
                  await GoogleSignIn().signOut();
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => LoginPage()));
                },
                icon: Icon(Icons.logout))
          ],
        ),
      ),
    );
  }
}
