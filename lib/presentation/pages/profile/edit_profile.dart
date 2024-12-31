import 'package:flutter/material.dart';
import 'package:vouchee/model/user.dart';
import 'package:vouchee/networking/api_request.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late Future<AppUser> currentUser;
  ApiServices apiServices = ApiServices();
  @override
  void initState() {
    super.initState();
    currentUser = apiServices.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
