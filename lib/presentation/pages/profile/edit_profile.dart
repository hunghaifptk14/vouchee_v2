// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vouchee/core/configs/theme/app_color.dart';
import 'package:vouchee/networking/api_request.dart';
import 'package:vouchee/presentation/pages/profile/profile_page.dart'; // Make sure to import your HomePage

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _imageUrl;
  ApiServices apiServices = ApiServices();

  // Pick an image from the gallery

  // Convert the image to Base64
  Future<String> _encodeImageToBase64(String imagePath) async {
    try {
      final bytes = await File(imagePath).readAsBytes();
      String base64ImageString = base64Encode(bytes);
      return base64ImageString;
    } catch (e) {
      print("Error encoding image: $e");
      return '';
    }
  }

  // Navigate to homepage after update
  void _navigateToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => ProfilePage()), // Ensure HomePage is imported
    );
  }

  // Regex to validate Vietnamese phone number
  final String phoneNumberPattern = r'^(0[3|5|7|8|9])[0-9]{8}$';

  bool isValidPhoneNumber(String phone) {
    final RegExp regExp = RegExp(phoneNumberPattern);
    return regExp.hasMatch(phone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cập nhật thông tin')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name TextField
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Họ tên'),
            ),
            SizedBox(height: 16),

            // Phone Number TextField
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Số điện thoại'),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập số điện thoại';
                }
                if (!isValidPhoneNumber(value)) {
                  return 'Số điện thoại không tồn tại. vui lòng nhập lại';
                }
                return null;
              },
            ),

            // Image Picker Button
            // Row(
            //   children: [
            //     Text('Upload Image:'),
            //     SizedBox(width: 10),
            //     ElevatedButton(
            //       onPressed: _pickImage,
            //       child: Text('Pick Image'),
            //     ),
            //   ],
            // ),
            // SizedBox(height: 16),

            // // Show selected image if available
            // _imageUrl != null
            //     ? Image.file(
            //         File(_imageUrl!),
            //         width: 100,
            //         height: 100,
            //       )
            //     : SizedBox(),

            SizedBox(height: 16),

            // Update Button
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  String? base64Image = _imageUrl != null
                      ? await _encodeImageToBase64(_imageUrl!)
                      : null;

                  // Call the update function
                  await apiServices.updateBuyerInfo(
                    _nameController.text,
                    _phoneController.text,
                    base64Image,
                  );

                  // After successful update, navigate to the home page
                  _navigateToHomePage();
                },
                child: Text(
                  'Cập nhật',
                  style: TextStyle(color: AppColor.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
