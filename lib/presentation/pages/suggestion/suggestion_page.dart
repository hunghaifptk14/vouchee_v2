// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vouchee/core/configs/theme/app_color.dart';
import 'package:vouchee/model/near_voucher.dart';
import 'package:vouchee/networking/api_request.dart';
import 'package:vouchee/presentation/pages/suggestion/location_service.dart';

class SuggestionPage extends StatefulWidget {
  const SuggestionPage({
    super.key,
  });

  @override
  State<SuggestionPage> createState() => _SuggestionPageState();
}

class _SuggestionPageState extends State<SuggestionPage> {
  late Future<List<NearVoucher>> futureNearVouchers;
  final GetNearVoucher apiService = GetNearVoucher();
  final LocationService locationService = LocationService();

  @override
  void initState() {
    super.initState();
    _fetchVouchersBasedOnLocation();
    futureNearVouchers = Future.value([]);
  }

  void _fetchVouchersBasedOnLocation() async {
    try {
      // Get user location
      Position position = await locationService.getUserLocation();

      // Fetch vouchers based on location
      setState(() {
        futureNearVouchers = apiService.fetchNearVouchers(
          lat: position.latitude,
          lon: position.longitude,
        );
      });
    } catch (e) {
      print("Error fetching vouchers: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voucher gần bạn'),
      ),
      body: FutureBuilder<List<NearVoucher>>(
        future: futureNearVouchers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có voucher'));
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              NearVoucher nvoucher = snapshot.data![index];
              print(nvoucher.addresses);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: Image.network(
                            nvoucher.voucher.brandImage,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nvoucher.voucher.brandName,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  'Cách bạn: ',
                                  style: TextStyle(
                                    color: AppColor.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(nvoucher.addresses.distance.toString()),
                                // Text('${nvoucher.addresses}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    // Add your navigation code here
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Widget _countAddress() {
//   final Voucher voucher;
//   return ListView.builder(
//     shrinkWrap: true,
//     itemCount: voucher.addresses.length,
//     itemBuilder: (context, index) {
//       final address = voucher.addresses[index];
//       return ListTile(
//         leading: Icon(Icons.location_on),
//         title: Text(address.name),
//         subtitle: Text("${address.distance.toStringAsFixed(2)} m away"),
//       );
//     },
//   );
// }
