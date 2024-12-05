import 'package:flutter/material.dart';
import 'package:vouchee/networking/api_request.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  late String? name;
  final ApiServices apiServices = ApiServices();
  @override
  void initState() {
    super.initState();
    name = apiServices.getUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Text(name.toString());
  }
}
