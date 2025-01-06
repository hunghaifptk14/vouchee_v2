// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vouchee/core/configs/assets/app_image.dart';
import 'package:vouchee/core/configs/assets/app_vector.dart';
import 'package:vouchee/core/configs/theme/app_color.dart';
import 'package:vouchee/model/banks.dart';
import 'package:vouchee/networking/api_request.dart';
import 'package:vouchee/model/user.dart';

import 'package:vouchee/presentation/pages/homePage/home_page.dart';
import 'package:vouchee/presentation/pages/login/login.dart';
import 'package:vouchee/presentation/pages/profile/edit_bank.dart';
import 'package:vouchee/presentation/pages/profile/edit_profile.dart';

class ProfilePage extends StatefulWidget {
  // final User? user;

  const ProfilePage({
    super.key,
    // required this.user,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? selectedBank;

  late Future<AppUser> currentUser;
  ApiServices apiServices = ApiServices();
  @override
  void initState() {
    super.initState();
    currentUser = apiServices.getCurrentUser();
    selectedBank = bankList.first;
  }

  Future<void> loadData() async {
    currentUser = apiServices.getCurrentUser();
    selectedBank = bankList.first;
  }

  String? base64Image;
  Future<void> _encodeImageToBase64(String imagePath) async {
    try {
      final bytes = await File(imagePath).readAsBytes();
      String base64ImageString = base64Encode(bytes);

      setState(() {
        base64Image = base64ImageString; // Store the Base64 string
      });
    } catch (e) {
      print("Error encoding image: $e");
    }
  }

  void changeImage(String newImagePath) {
    _encodeImageToBase64(
        newImagePath); // Call the encoding function with new path
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Thông tin cá nhân'),
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
        body: RefreshIndicator(
          onRefresh: loadData,
          child: FutureBuilder<AppUser>(
              future: currentUser,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final user = snapshot.data!;
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        user.image == ""
                            ? Center(
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage: AssetImage(AppImage.man),
                                ),
                              )
                            : FutureBuilder<void>(
                                future: _encodeImageToBase64(user.image),
                                builder: (context, encodingSnapshot) {
                                  // If the encoding is still in progress, show a loading indicator
                                  if (encodingSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage:
                                            AssetImage(AppImage.man),
                                      ),
                                    );
                                  } else if (encodingSnapshot.hasError) {
                                    return Center(
                                        child: Text(
                                            'Error: ${encodingSnapshot.error}'));
                                  } else if (encodingSnapshot.hasData ||
                                      base64Image != null) {
                                    // Once base64Image is available, show the image
                                    return Center(
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage: base64Image != null
                                            ? MemoryImage(
                                                base64Decode(base64Image!))
                                            : AssetImage(AppImage.man)
                                                as ImageProvider,
                                      ),
                                    );
                                  } else {
                                    // If there's no data or still loading, show a default image
                                    return Center(
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage:
                                            AssetImage(AppImage.man),
                                      ),
                                    );
                                  }
                                },
                              ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      ' ${user.name}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        EditProfile()));
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: AppColor.lightGrey,
                                      ),
                                      iconSize: 20,
                                    )
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(user.email.toString()),
                                const SizedBox(height: 8),
                                user.phoneNumber != ''
                                    ? Text(user.phoneNumber.toString())
                                    : Text(
                                        'Chưa có số điện thoại',
                                        style: TextStyle(
                                            color: AppColor.lightGrey),
                                      ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tên ngân hàng:',
                                  style: TextStyle(
                                      fontSize: 14, color: AppColor.lightGrey),
                                ),
                                user.bankName != ''
                                    ? Text(user.bankName.toString())
                                    : Text('Chưa có thông tin'),
                                const SizedBox(height: 8),
                                Text(
                                  'Tên tài khoản: ',
                                  style: TextStyle(
                                      fontSize: 14, color: AppColor.lightGrey),
                                ),
                                user.bankAccount != null
                                    ? Text(user.bankAccount.toString())
                                    : Text('Chưa có thông tin'),
                                const SizedBox(height: 8),
                                Text(
                                  'Số tài khoản:',
                                  style: TextStyle(
                                      fontSize: 14, color: AppColor.lightGrey),
                                ),
                                Text(user.bankNumber.toString()),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        minimumSize: Size.zero,
                                        padding: EdgeInsets.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        const EditBank()));
                                      },
                                      child: Text(
                                        'Cập nhật thông tin ngân hàng',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () async {
                                await GoogleSignIn().signOut();
                                FirebaseAuth.instance.signOut();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            LoginPage()));
                              },
                              icon: Icon(Icons.logout),
                            ),
                            Text('Đăng xuất')
                          ],
                        )
                      ],
                    ),
                  );
                } else {
                  return Center(child: Text('No user data found'));
                }
              }),
        ));
  }
}
