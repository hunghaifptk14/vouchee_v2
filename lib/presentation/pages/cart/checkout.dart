// // ignore_for_file: avoid_print

// import 'dart:io';

// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:gal/gal.dart';
// import 'package:intl/intl.dart';
// import 'package:vouchee/core/configs/assets/app_vector.dart';
// import 'package:vouchee/core/configs/theme/app_color.dart';
// import 'package:vouchee/model/checkout.dart';
// import 'package:vouchee/model/modal.dart';
// import 'package:vouchee/networking/api_request.dart';
// import 'package:vouchee/presentation/pages/homePage/home_page.dart';
// import 'package:vouchee/presentation/widgets/snack_bar.dart';

// class CheckoutPage extends StatefulWidget {


//   const CheckoutPage({super.key});

//   @override
//   State<CheckoutPage> createState() => _CheckoutPageState();
// }

// class _CheckoutPageState extends State<CheckoutPage> {
//   late double totalPrice;
//   final ApiServices apiServices = ApiServices();
//   @override
//   void initState() {
//     super.initState();
//     _calculateTotalPrice();
//   }

//   void _calculateTotalPrice() {
//     setState(() {
//       totalPrice = widget.checkoutItems.fold(
//         0.0,
//         (total, checkoutItems) => total + (checkoutItems. * checkoutItems.quantity),
//       );
//     });
//   }

//   String? orderID;
//   Future<void> _createOrder(String modalID) async {
//     // bool success =
//     await apiServices.createOrder(
//         modalId: selec,
//         giftEmail: 'mail',
//         promotionId: '',
//         useBalance: 0,
//         useVpoint: 0);
//   }

//   String _currencyFormat(double amount) {
//     String format = NumberFormat.currency(
//       locale: 'vi_VN',
//       symbol: '₫',
//       decimalDigits: 0, // No decimal digits
//     ).format(amount);
//     return format;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Checkout'),
//         actions: <Widget>[
//           IconButton(
//             onPressed: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (BuildContext context) => const HomePage()));
//             },
//             icon: SvgPicture.asset(
//               AppVector.homeIcon,
//               height: 22,
//               fit: BoxFit.cover,
//               colorFilter:
//                   const ColorFilter.mode(AppColor.black, BlendMode.srcIn),
//             ),
//             iconSize: 22,
//           )
//         ],
//         // backgroundColor: Colors.teal,
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: ListView.builder(
//           itemCount: widget.checkoutItems.length,
//           itemBuilder: (context, index) {
//             final modal = widget.checkoutItems[index];
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Chi tiết đơn hàng',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 SizedBox(height: 12),
//                 Container(
//                   padding: const EdgeInsets.all(16.0),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12.0),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 4,
//                         offset: Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       _buildTextRow('Tên voucher', modal.title),
//                       _buildTextRow('Thương hiệu', modal.brandName),
//                       // _buildTextRow('Hạn sử dụng', widget.modal.),
//                       _buildPriceRow('Giá', modal.originalPrice),
//                       _buildPriceRow('Giá', modal.salePrice),
//                       _buildPriceRow('Giảm giá', modal.discountPrice),
//                       _buildNumberRow('Số lượng', modal.quantity),
//                       // _buildPromotionRow(
//                       //     'Mã giảm giá', widget.modal.),
//                       Divider(),
//                       _buildPriceRow(
//                         'Tổng thanh toán',
//                         modal.totalFinalPrice,
//                         isBold: true,
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 24),
//                 Text(
//                   'Phương thức thanh toán',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 SizedBox(height: 12),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12.0),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 4,
//                         offset: Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Padding(
//                     padding:
//                         const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
//                     child: Column(
//                       children: [
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             IconButton(
//                                 padding: EdgeInsets.zero,
//                                 constraints: BoxConstraints(),
//                                 onPressed: () {},
//                                 icon: Icon(
//                                   Icons.radio_button_off,
//                                   color: AppColor.lightGrey,
//                                   size: 16,
//                                 )),
//                             Text('Sử dụng số dư ví')
//                           ],
//                         ),
//                         Container(
//                           decoration: BoxDecoration(
//                             color: AppColor.lightBlue,
//                             borderRadius: BorderRadius.circular(7.0),
//                           ),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               IconButton(
//                                   padding: EdgeInsets.zero,
//                                   constraints: BoxConstraints(),
//                                   onPressed: () {},
//                                   icon: Icon(
//                                     Icons.radio_button_checked,
//                                     color: AppColor.primary,
//                                     size: 16,
//                                   )),
//                               Text('Chuyển khoản bằng QR code')
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 30),

//                 // Proceed to Checkout Button
//                 Center(
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       _showCheckoutModal(context);
//                       print(modal.id);
//                       // _createOrder(modal.id);
//                     },
//                     child: Text(
//                       'Thanh toán',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   // Helper method to build each row in the pricing summary
//   Widget _buildPromotionRow(String label, String? content) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               color: AppColor.black,
//               fontSize: 11,
//             ),
//           ),
//           content == null
//               ? Text(
//                   content.toString(),
//                   style: TextStyle(
//                     color: AppColor.black,
//                     fontSize: 11,
//                   ),
//                 )
//               : Text(
//                   'Chưa có khuyến mãi',
//                   style: TextStyle(color: AppColor.lightGrey, fontSize: 11),
//                 )
//         ],
//       ),
//     );
//   }

//   Widget _buildNumberRow(String label, num content) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               color: AppColor.black,
//               fontSize: 11,
//             ),
//           ),
//           Text(
//             content.toInt().toString(),
//             style: TextStyle(
//               color: AppColor.black,
//               fontSize: 11,
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildTextRow(String label, String content) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               color: AppColor.black,
//               fontSize: 11,
//             ),
//           ),
//           Text(
//             content,
//             style: TextStyle(
//               color: AppColor.black,
//               fontSize: 11,
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildPriceRow(String label, double amount, {bool isBold = false}) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 11,
//               fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//           Text(
//             _currencyFormat(amount),
//             style: TextStyle(
//               fontSize: 11,
//               fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//               color: isBold ? Colors.teal : Colors.black,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showCheckoutModal(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Center(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(height: 10),
//                 SizedBox(
//                   height: 240,
//                   width: 240,
//                   child: Image.network(
//                     'https://qr.sepay.vn/img?acc=0000321753575&bank=MBBank&amount=${widget.checkoutItems}&des=ORD$orderID&template=TEMPLATE&download=DOWNLOAD',
//                   ),
//                 ),
//                 SizedBox(
//                   height: 8,
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     final path = '${Directory.systemTemp.path}/QR-code.jpg';
//                     await Dio().download(
//                       'https://qr.sepay.vn/img?acc=0000321753575&bank=MBBank&amount=${widget.checkoutItems}&des=ORD$orderID&template=TEMPLATE&download=DOWNLOAD',
//                       path,
//                     );
//                     await Gal.putImage(path);
//                     TopSnackbar.show(context, 'Đã tải ảnh');
//                   },
//                   child: SizedBox(
//                     width: 100,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.download_outlined,
//                           color: AppColor.white,
//                         ),
//                         SizedBox(
//                           width: 8,
//                         ),
//                         Text(
//                           'Tải ảnh',
//                           style: TextStyle(
//                             color: AppColor.white,
//                             fontSize: 11,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // void _showSnackbar() {
//   //   final context = navigatorKey.currentContext;
//   //   if (context == null || !context.mounted) return;
//   //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//   //     content: const Text('Đã tải ảnh'),
//   //     // action: SnackBarAction(
//   //     //   label: 'Gallery ->',
//   //     //   onPressed: () async => Gal.open(),
//   //     // ),
//   //   ));
//   // }
// }
