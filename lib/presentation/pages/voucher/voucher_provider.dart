// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:vouchee/presentation/pages/voucher/voucher_model.dart';

// class VoucherProvider with ChangeNotifier {
//   final List<Result> _vouchers = [];
//   bool _isLoading = false;
//   String? _errorMessage;

//   List<Result> get vouchers => _vouchers;
//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;

//   // Fetch Vouchers from API
//   Future<void> fetchVouchers() async {
//     _isLoading = true;
//     const double fixedLon = 10.76833026;
//     const double fixedLat = 106.67583063;
//     const double? lon = null;
//     const double? lat = null;
//     double finalLon = lon ?? fixedLon;
//     double finalLat = lat ?? fixedLat;
//     notifyListeners();
//     const url = 'https://api.vouchee.shop/api/v1/voucher/get_all_voucher';
//     Map<String, dynamic> requestData = {
//       "lon": finalLon, // If dynamicField1 is empty, send defaultField1
//       "lat": finalLat, // If dynamicField2 is null, send defaultField2
//     };
//     try {
//       // Send POST request
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {
//           "Content-Type": "application/json",
//         },
//         body: jsonEncode(requestData), // Convert the map to JSON
//       );

//       if (response.statusCode == 200) {
//         print("Data sent successfully: 000000000000000000");
//       } else {
//         print("Failed to send data: 0000000000000000000");
//       }
//     } catch (e) {
//       print("Error: $e");
//     }
//     // try {
//     //   final response = await http.get(Uri.parse(url));

//     //   if (response.statusCode == 200) {
//     //     // Parse the JSON response
//     //     final Map<String, dynamic> jsonData = json.decode(response.body);
//     //     print('Response body: ${response.body}');

//     //     // Access the vouchers list correctly
//     //     if (jsonData['vouchers'] is List) {
//     //       _vouchers = (jsonData['vouchers'] as List)
//     //           .map((json) => Result.fromJson(json))
//     //           .toList();
//     //     } else {
//     //       _errorMessage = 'No vouchers found';
//     //     }
//     //   } else {
//     //     _errorMessage = 'Failed to load vouchers';
//     //   }
//     // } catch (error) {
//     //   _errorMessage = 'An error occurred: $error';
//     // } finally {
//     //   _isLoading = false;
//     //   notifyListeners();
//     // }
//   }

//   // Add Voucher
//   // Future<void> addVoucher(Result voucher) async {
//   //   const url =
//   //       'https://api.vouchee.shop/api/v1/voucher/get_all_voucher'; // Replace with actual API URL

//   //   try {
//   //     final response = await http.post(
//   //       Uri.parse(url),
//   //       headers: {"Content-Type": "application/json"},
//   //       body: json.encode(voucher.toJson()),
//   //     );

//   //     if (response.statusCode == 201) {
//   //       final newVoucher = Voucher.fromJson(json.decode(response.body));
//   //       _vouchers.add(newVoucher);
//   //       notifyListeners();
//   //     } else {
//   //       throw Exception('Failed to add voucher');
//   //     }
//   //   } catch (error) {
//   //     rethrow;
//   //   }
//   // }

//   // // Update Voucher
//   // Future<void> updateVoucher(String id, Voucher updatedVoucher) async {
//   //   final url =
//   //       'https://yourapi.com/vouchers/$id'; // Replace with actual API URL

//   //   try {
//   //     final response = await http.put(
//   //       Uri.parse(url),
//   //       headers: {"Content-Type": "application/json"},
//   //       body: json.encode(updatedVoucher.toJson()),
//   //     );

//   //     if (response.statusCode == 200) {
//   //       final index = _vouchers.indexWhere((voucher) => voucher.id == id);
//   //       if (index >= 0) {
//   //         _vouchers[index] = updatedVoucher;
//   //         notifyListeners();
//   //       }
//   //     } else {
//   //       throw Exception('Failed to update voucher');
//   //     }
//   //   } catch (error) {
//   //     rethrow;
//   //   }
//   // }

//   // // Delete Voucher
//   // Future<void> deleteVoucher(String id) async {
//   //   final url =
//   //       'https://yourapi.com/vouchers/$id'; // Replace with actual API URL

//   //   try {
//   //     final response = await http.delete(Uri.parse(url));

//   //     if (response.statusCode == 200) {
//   //       _vouchers.removeWhere((voucher) => voucher.id == id);
//   //       notifyListeners();
//   //     } else {
//   //       throw Exception('Failed to delete voucher');
//   //     }
//   //   } catch (error) {
//   //     rethrow;
//   //   }
//   // }

//   // // Fetch a single voucher by ID
//   // Voucher findById(String id) {
//   //   return _vouchers.firstWhere((voucher) => voucher.id == id,
//   //       orElse: () => throw Exception('Voucher not found'));
//   // }
// }
