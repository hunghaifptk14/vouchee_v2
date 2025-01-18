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
  final List<XFile> _selectedFiles = []; // Store XFile objects for the images
  String? content;
  bool isSuccess = false;
  bool _isLoading = false;
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
      // showPermissionDeniedDialog(context);
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
          content:
              Text('Ứng dụng cần cập nhật vị trí của bạn để hỗ trợ hoàn tiền'),
          actions: [
            // TextButton(
            //   onPressed: () => Navigator.of(context).pop(),
            //   child: Text('Hủy'),
            // ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Geolocator.openAppSettings();
              },
              child: Text('Cho phép'),
            ),
          ],
        );
      },
    );
  }

  // Method to pick image(s)
  Future<void> _pickImage() async {
    final pickedFiles =
        await _picker.pickMultiImage(); // Pick multiple images if needed
    setState(() {
      _selectedFiles.addAll(pickedFiles); // Add all picked files to the list
    });
  }

  // Method to delete image
  void _deleteImage(int index) {
    setState(() {
      _selectedFiles.removeAt(index); // Remove image from the list by index
    });
  }

  // Method to send data to API
  Future<void> _sendDataToApi() async {
    setState(() {
      _isLoading = true; // Set loading state to true when starting API call
    });
    // if (_selectedFiles.isEmpty) {
    //   TopSnackbar.show(context, 'Vui lòng chọn ít nhất một hình ảnh',
    //       backgroundColor: AppColor.warning);
    //   return;
    // }

    // Convert selected files to the format required by the API (multipart)
    bool success = await _apiService.refundVoucherCode(
      widget.voucherCodeId,
      content ?? '',
      latitude,
      longitude,
    );

    if (success) {
      TopSnackbar.show(context, 'Gửi yêu cầu thành công',
          backgroundColor: AppColor.success);
      Navigator.pop(context);
      setState(() {
        isSuccess = true;
        _isLoading = false;
      });
    } else {
      TopSnackbar.show(context, 'Gửi yêu cầu thất bại',
          backgroundColor: AppColor.warning);
      setState(() {
        _isLoading = false;
      });
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
              // Display selected images
              // _selectedFiles.isNotEmpty
              //     ? SingleChildScrollView(
              //         scrollDirection: Axis.horizontal,
              //         child: Row(
              //           children: _selectedFiles.map((file) {
              //             int index = _selectedFiles.indexOf(file);
              //             return Padding(
              //               padding: const EdgeInsets.only(right: 8.0),
              //               child: Stack(
              //                 clipBehavior: Clip.none,
              //                 children: [
              //                   Image.file(
              //                     File(file.path),
              //                     width: 200,
              //                     height: 200,
              //                     fit: BoxFit.cover,
              //                   ),
              //                   Positioned(
              //                     right: 0,
              //                     top: 0,
              //                     child: ElevatedButton(
              //                       onPressed: () {
              //                         _deleteImage(
              //                             index); // Delete image from the list
              //                       },
              //                       child: Text(
              //                         'Xóa',
              //                         style: TextStyle(color: AppColor.white),
              //                       ),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             );
              //           }).toList(),
              //         ),
              //       )
              //     : Center(child: Text('Không có ảnh nào được chọn')),

              // SizedBox(height: 16),

              // // Image picker button
              // Center(
              //   child: ElevatedButton(
              //     onPressed: _pickImage,
              //     child: SizedBox(
              //       width: 100,
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         children: [
              //           Icon(
              //             Icons.upload_outlined,
              //             color: AppColor.white,
              //           ),
              //           SizedBox(width: 8),
              //           Text(
              //             'Tải ảnh',
              //             style: TextStyle(
              //               color: AppColor.white,
              //               fontSize: 14,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),

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
                  onPressed: _isLoading
                      ? null
                      : _sendDataToApi, // Disable button if loading
                  child: _isLoading
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white), // Spinner color
                        )
                      : Text(
                          'Gửi',
                          style: TextStyle(color: Colors.white, fontSize: 16),
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
