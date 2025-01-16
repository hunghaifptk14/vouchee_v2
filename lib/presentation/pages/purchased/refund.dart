// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vouchee/core/configs/theme/app_color.dart';
import 'package:vouchee/networking/api_request.dart';
import 'package:vouchee/presentation/pages/homePage/home_page.dart';
import 'package:vouchee/presentation/widgets/snack_bar.dart';

class RefundPage extends StatefulWidget {
  final String voucherCodeId;
  const RefundPage({
    super.key,
    required this.voucherCodeId,
  });

  @override
  State<RefundPage> createState() => _RefundPageState();
}

class _RefundPageState extends State<RefundPage> {
  num? latitude;
  num? longitude;
  List<String> imagePaths = []; // List to store image paths
  String? content;
  bool isSuccess = false;
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

  void _deleteImage(int index) {
    setState(() {
      imagePaths.removeAt(index); // Remove image from the list by index
    });
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
      TopSnackbar.show(context, 'Gửi yêu cầu thành công',
          backgroundColor: AppColor.success);
      setState(() {
        isSuccess = true;
      });
    } else {
      TopSnackbar.show(context, 'Gửi yêu cầu thất bại',
          backgroundColor: AppColor.warning);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Yêu cầu hoàn trả')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display location
              // latitude == null || longitude == null
              //     ? CircularProgressIndicator()
              //     : Column(
              //         children: [
              //           Text('Latitude: $latitude'),
              //           Text('Longitude: $longitude'),
              //         ],
              //       ),

              SizedBox(height: 16),
              // Show selected images (if any)
              imagePaths.isNotEmpty
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: imagePaths.map((path) {
                          int index = imagePaths.indexOf(path);
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Stack(
                              clipBehavior: Clip
                                  .none, // To allow floating button outside the image
                              children: [
                                // Display image
                                Image.file(
                                  File(path),
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _deleteImage(
                                          index); // Delete image on tap
                                    },
                                    child: Text(
                                      'Xóa',
                                      style: TextStyle(color: AppColor.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  : Center(child: Text('Không có ảnh nào được chọn')),
              SizedBox(height: 16),
              // Image picker button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _pickImage();
                    print(imagePaths);
                    isSuccess
                        ? showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Center(
                                child: Container(
                                  width: 225,
                                  height: 300,
                                  color: AppColor.white,
                                  child: Column(
                                    children: [
                                      Text("Cảm ơn bạn đã gửi phản hồi!"),
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        const HomePage()));
                                          },
                                          child: Text('Về trang chủ'))
                                    ],
                                  ),
                                ),
                              );
                            })
                        : null;
                  },
                  child: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.upload_outlined,
                          color: AppColor.white,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Tải ảnh',
                          style: TextStyle(
                            color: AppColor.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
              // Submit button to send data to the API
              SizedBox(
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
      ),
    );
  }
}
