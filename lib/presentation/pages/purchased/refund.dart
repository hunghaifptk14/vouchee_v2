// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

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
  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
    _getLocation;
  }

  Future<void> _getLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled');
        showLocationServiceDisabledDialog(context);
        return;
      }

      // Request permission to access location
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permission denied');
        showPermissionDeniedDialog(context);
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        // The user has denied location access forever
        print('Location permission permanently denied');
        showPermissionDeniedDialog(context);
        return;
      }

      // Get the current position (latitude and longitude)
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Update the state with the obtained location
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
    } catch (e) {
      print("Error getting location: $e");
      showErrorDialog(context, "Unable to get user location.");
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
                Geolocator
                    .openAppSettings(); // Open app settings to allow user to enable location manually
              },
              child: Text('Đi đến cài đặt'),
            ),
          ],
        );
      },
    );
  }

  void showLocationServiceDisabledDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Vị trí chưa bật'),
          content:
              Text('Vui lòng bật dịch vụ vị trí trong cài đặt của thiết bị.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Geolocator.openLocationSettings(); // Open location settings
              },
              child: Text('Đi đến cài đặt'),
            ),
          ],
        );
      },
    );
  }

  void showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Lỗi'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Đóng'),
            ),
          ],
        );
      },
    );
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
            Center(
              child: latitude == null || longitude == null
                  ? CircularProgressIndicator() // Show loading if location is not yet available
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Latitude: $latitude'),
                        Text('Longitude: $longitude'),
                      ],
                    ),
            ),

            SizedBox(height: 16),

            // Display voucher content
            Text(
              'voucher.content,',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),

            // Display voucher code ID
            Text(
              'Voucher Code ID: ${widget.voucherCodeId}',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 16),

            // Display location (latitude, longitude)
            Text(
              'location',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
