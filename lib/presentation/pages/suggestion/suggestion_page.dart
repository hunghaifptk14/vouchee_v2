import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vouchee/core/configs/theme/app_color.dart';
import 'package:vouchee/model/near_voucher.dart';
import 'package:vouchee/networking/api_request.dart';
import 'package:vouchee/presentation/pages/voucher/voucher_detail.dart';
import 'package:vouchee/presentation/widgets/bottomNav/bottom_app_bar.dart';

class SuggestionPage extends StatefulWidget {
  const SuggestionPage({super.key});

  @override
  State<SuggestionPage> createState() => _SuggestionPageState();
}

class _SuggestionPageState extends State<SuggestionPage> {
  late Future<List<NearVoucher>> futureNearVouchers;
  final ApiServices apiService = ApiServices();

  @override
  void initState() {
    super.initState();
    futureNearVouchers = _fetchVouchersBasedOnLocation();
  }

  Future<Position?> getUserLocation(BuildContext context) async {
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

      // Get and return the current position
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      print("Error getting location: $e");
      return null; // Return null if location cannot be fetched
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

  Future<List<NearVoucher>> _fetchVouchersBasedOnLocation() async {
    try {
      print("Fetching user location...");
      Position? position = await getUserLocation(context);

      if (position == null) {
        throw Exception("Unable to get user location.");
      }

      print("Location fetched: (${position.latitude}, ${position.longitude})");

      print("Fetching vouchers...");
      return await apiService.fetchNearVouchers(
        lat: position.latitude,
        lon: position.longitude,
      );
    } catch (e) {
      print("Error fetching vouchers: $e");
      throw Exception('Không thể lấy thông tin voucher. Vui lòng thử lại.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Địa chỉ áp dụng voucher gần bạn',
          style: TextStyle(fontSize: 18),
        ),
        backgroundColor: Colors.transparent,
      ),
      bottomNavigationBar: BottomAppBarcustom(),
      body: FutureBuilder<List<NearVoucher>>(
        future: futureNearVouchers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Lỗi: ${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        futureNearVouchers = _fetchVouchersBasedOnLocation();
                      });
                    },
                    child: Text('Thử lại'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không tìm thấy voucher gần bạn.'));
          }

          List<NearVoucher> nearvoucher = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: nearvoucher.length,
            itemBuilder: (context, index) {
              NearVoucher nvoucher = nearvoucher[index];
              return Card(
                color: AppColor.white,
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nvoucher.voucher.brandName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      // Filter and display addresses with distance <= 20
                      Column(
                        children: nvoucher.addresses
                            .where((address) => address.distance <= 20)
                            .map((address) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: AppColor.lightBlue,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.location_pin,
                                          color: AppColor.secondary,
                                          size: 18,
                                        ),
                                        Flexible(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                address.name,
                                                style: TextStyle(
                                                    overflow:
                                                        TextOverflow.visible),
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                'Khoảng cách: ${address.distance} km',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColor.secondary),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VoucherDetailPage(
                                      voucher: nvoucher.voucher,
                                    ),
                                  ),
                                );
                              },
                              child: Text('Xem chi tiết voucher',
                                  style: TextStyle(
                                    color: AppColor.white,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
