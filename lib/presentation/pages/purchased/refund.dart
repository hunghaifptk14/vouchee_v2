import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vouchee/core/configs/theme/app_color.dart';
import 'package:vouchee/networking/api_request.dart';
import 'package:vouchee/presentation/widgets/appBar/top_app_bar.dart';
import 'package:vouchee/presentation/widgets/snack_bar.dart';

class RefundPage extends StatefulWidget {
  final String voucherCodeId;
  const RefundPage({
    Key? key,
    required this.voucherCodeId,
  }) : super(key: key);

  @override
  State<RefundPage> createState() => _RefundPageState();
}

class _RefundPageState extends State<RefundPage> {
  num? latitude;
  num? longitude;
  List<String> imagePaths = []; // List to store image paths
  String? content;

  final _picker = ImagePicker();
  final ApiServices _apiService = ApiServices(); // Initialize the ApiService

  @override
  void initState() {
    super.initState();
    _getLocation(); // Fetch location when the page loads
  }

  // Method to get current location
  Future<void> _getLocation() async {
    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        // Request permission if not already granted
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("Location permission denied.");
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Handle permanently denied permission
        showPermissionDeniedDialog(context);
        throw Exception("Location permission permanently denied.");
      }

      // Get current position and store latitude and longitude in respective variables
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        latitude = position.latitude; // Store latitude
        longitude = position.longitude; // Store longitude
      });
    } catch (e) {
      print("Error getting location: $e");
      setState(() {
        latitude = null;
        longitude =
            null; // Set latitude and longitude to null if there's an error
      });
    }
  }

  void showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Cấp quyền vị trí'),
          content: Text(
              'Ứng dụng cần quyền truy cập vị trí để hiển thị các voucher gần bạn. Vui lòng bật quyền trong phần cài đặt.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Geolocator.openAppSettings();
              },
              child: Text('Đi đến cài đặt'),
            ),
          ],
        );
      },
    );
  }

  // Method to pick images
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imagePaths.add(pickedFile.path); // Add picked image path to the list
      });
    }
  }

  // Method to send data to API
  Future<void> _sendDataToApi() async {
    // Call the submitVoucher method from ApiService
    bool success = await _apiService.refundVoucherCode(
      imagePaths,
      widget.voucherCodeId,
      content ?? '',
      latitude,
      longitude,
    );

    if (success) {
      // Handle success response (you can show a success message or navigate)
      TopSnackbar.show(context, 'Data successfully sent',
          backgroundColor: AppColor.success);
    } else {
      // Handle failure response (show an error message)
      print('Failed to send data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thông tin cá nhân')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display location
            latitude == null || longitude == null
                ? CircularProgressIndicator()
                : Column(
                    children: [
                      Text('Latitude: $latitude'),
                      Text('Longitude: $longitude'),
                    ],
                  ),
            SizedBox(height: 16),
            // Content input
            TextField(
              onChanged: (text) {
                content = text; // Update content as user types
              },
              decoration: InputDecoration(
                labelText: 'Nội dung lỗi',
              ),
            ),
            SizedBox(height: 16),
            // Image picker button
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Chọn ảnh',
                  style: TextStyle(color: AppColor.white, fontSize: 16)),
            ),
            SizedBox(height: 16),
            // Show selected images (if any)
            if (imagePaths.isNotEmpty)
              Column(
                children: imagePaths.map((path) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Image.file(
                      File(path), // Load image from the file path
                      width:
                          250, // You can adjust the width and height as per your design
                      height: 300, // You can adjust the height too
                      fit: BoxFit
                          .cover, // You can use different BoxFit types based on your needs
                    ),
                  );
                }).toList(),
              ),
            SizedBox(height: 16),
            // Submit button to send data to the API
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _sendDataToApi,
                child: Text(
                  'Gửi ',
                  style: TextStyle(color: AppColor.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
