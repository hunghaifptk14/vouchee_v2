// import 'dart:async';
// import 'dart:io';

// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:gal/gal.dart';
// import 'package:intl/intl.dart';
// import 'package:vouchee/core/configs/theme/app_color.dart';
// import 'package:vouchee/model/checkout.dart';
// import 'package:vouchee/model/modal.dart';
// import 'package:vouchee/networking/api_request.dart';
// import 'package:vouchee/presentation/widgets/snack_bar.dart';

// class CheckoutPageTest extends StatefulWidget {
//   final List<Modal> selectedItems;

//   const CheckoutPageTest({super.key, required this.selectedItems});

//   @override
//   _CheckoutPageState createState() => _CheckoutPageState();
// }

// class _CheckoutPageState extends State<CheckoutPageTest> {
//   late Future<List<Checkout>> futureCheckout;
//   late double totalPrice;
//   ApiServices apiServices = ApiServices();
//   String? getOrderIDString;

//   @override
//   void initState() {
//     super.initState();
//     // futureCheckout = apiServices.checkoutCart(giftEmail: widget.selectedItems.);
//     _calculateTotalPrice();
//   }

//   double _calculateTotalPrice() {
//     setState(() {
//       totalPrice = widget.selectedItems.fold(
//         0.0,
//         (total, modal) => total + (modal.salePrice * modal.quantity),
//       );
//     });
//     return totalPrice;
//   }

//   @override
//   void dispose() {
//     if (_timer.isActive) {
//       _timer.cancel(); // Cancel the timer when the widget is disposed
//     }
//     if (_cancelTimer.isActive) _cancelTimer.cancel(); // Cancel the cancel timer
//     super.dispose();
//   }

//   String status = '';
//   late Timer _timer;
//   late Timer _cancelTimer;
//   int _elapsedTime = 0;
//   bool _timerStarted = false;
//   String _orderStatusRequest() {
//     setState(() {
//       _timerStarted = true;
//     });
//     _timer = Timer.periodic(Duration(seconds: 2), (timer) async {
//       status = await apiServices.getOrderStatus();
//       _elapsedTime += 2; // Increment elapsed time by 2 seconds

//       if (status == 'PAID') {
//         _timer.cancel();
//         _cancelTimer.cancel();
//         TopSnackbar.show(context, 'Thanh toán thành công');
//       } else {
//         _cancelTimer = Timer(Duration(minutes: 2), () {
//           _timer.cancel(); // Cancel the periodic timer after 2 minutes
//         });
//       }
//     });

//     return status;
//   }

//   void _removeItem(Modal modal) {
//     setState(() {
//       widget.selectedItems.remove(modal);
//       _calculateTotalPrice();
//     });
//   }

//   List<Modal> addSelectedModals(List<Modal> modals) {
//     return modals.where((modal) => modal.selected).toList();
//   }

//   List<String> modalItems = [];
//   int amount = 0;
//   List<String> getList() {
//     for (var modal in widget.selectedItems) {
//       modalItems.add(modal.id);
//       print('lenght: $modalItems');
//     }
//     return modalItems;
//   }

//   int getAmount() {
//     for (var modal in widget.selectedItems) {
//       modalItems.add(modal.totalFinalPrice.toString());
//       print('amount: $amount');
//     }
//     return amount;
//   }

//   Future<void> _orderRequest() async {
//     await apiServices.createOrder(
//         modalId: modalItems,
//         promotionId: '',
//         giftEmail: 'mail',
//         useBalance: 0,
//         useVpoint: 0);
//     String? getOrderID() {
//       return getOrderIDString = apiServices.getOrderID();
//     }

//     getAmount();
//     getList();
//     getOrderID();
//   }

//   String _currencyFormat(double amount) {
//     String format = NumberFormat.currency(
//       locale: 'vi_VN',
//       symbol: '₫',
//       decimalDigits: 0, // No decimal digits
//     ).format(amount);
//     return format;
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
//                     'https://qr.sepay.vn/img?acc=0000321753575&bank=MBBank&amount=$totalPrice&des=ORD$getOrderIDString&template=TEMPLATE&download=DOWNLOAD',
//                   ),
//                 ),
//                 SizedBox(
//                   height: 8,
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     final path = '${Directory.systemTemp.path}/QR-code.jpg';
//                     await Dio().download(
//                       'https://qr.sepay.vn/img?acc=0000321753575&bank=MBBank&amount=$totalPrice&des=ORD$getOrderIDString&template=TEMPLATE&download=DOWNLOAD',
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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Checkout'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Chi tiết đơn hàng',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             SizedBox(height: 16),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: widget.selectedItems.length,
//                 itemBuilder: (context, index) {
//                   final modal = widget.selectedItems[index];
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(bottom: 16),
//                         child: Column(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(16.0),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(12.0),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black12,
//                                     blurRadius: 4,
//                                     offset: Offset(0, 2),
//                                   ),
//                                 ],
//                               ),
//                               child: Column(
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [
//                                       TextButton(
//                                           onPressed: () {
//                                             _removeItem(modal);
//                                           },
//                                           style: TextButton.styleFrom(
//                                             padding: EdgeInsets
//                                                 .zero, // Removes all padding
//                                             minimumSize: Size
//                                                 .zero, // Removes minimum size constraints
//                                             tapTargetSize: MaterialTapTargetSize
//                                                 .shrinkWrap, // Shrinks the touch target
//                                           ),
//                                           child: Text(
//                                             'xóa đơn hàng',
//                                             style: TextStyle(
//                                                 color: AppColor.lightGrey,
//                                                 fontSize: 11,
//                                                 fontWeight: FontWeight.w300),
//                                           )),
//                                     ],
//                                   ),
//                                   // ...modal.sellers.map((sellers) => Column(
//                                   //   children: [
//                                   //     ...sellers.modals.map((modals)=> Column(
//                                   //       children: [
//                                   //         Text(modals.quantity.toString()),,
//                                   //       ],
//                                   //     ))
//                                   //   ],
//                                   // ),)
//                                   _buildTextRow('Tên voucher', modal.title),
//                                   _buildTextRow('Thương hiệu', modal.brandName),
//                                   _buildTextRow('Hạn sử dụng', modal.endDate),
//                                   _buildPriceRow('Giá', modal.sellPrice),
//                                   _buildNumberRow('Giá',
//                                       '${modal.shopDiscountPercent.toInt()}%'),
//                                   _buildPriceRow(
//                                       'Giảm giá', modal.discountPrice),
//                                   _buildNumberRow(
//                                       'Số lượng', modal.quantity.toString()),
//                                   // _buildPromotionRow(
//                                   //     'Mã giảm giá', widget.modal.),
//                                   Divider(),
//                                   _buildPriceRow(
//                                     'Tổng số tiền 1 voucher',
//                                     modal.totalFinalPrice,
//                                     isBold: true,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//             Text(
//               'Phương thức thanh toán',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             SizedBox(height: 12),
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12.0),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 4,
//                     offset: Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
//                 child: Column(
//                   children: [
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         IconButton(
//                             padding: EdgeInsets.zero,
//                             constraints: BoxConstraints(),
//                             onPressed: () {},
//                             icon: Icon(
//                               Icons.radio_button_off,
//                               color: AppColor.lightGrey,
//                               size: 16,
//                             )),
//                         Text('Sử dụng số dư ví')
//                       ],
//                     ),
//                     InkWell(
//                       onTap: () {
//                         _orderRequest();
//                         // _orderStatusRequest();
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: AppColor.lightBlue,
//                           borderRadius: BorderRadius.circular(7.0),
//                         ),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             IconButton(
//                                 padding: EdgeInsets.zero,
//                                 constraints: BoxConstraints(),
//                                 onPressed: () {},
//                                 icon: Icon(
//                                   Icons.radio_button_checked,
//                                   color: AppColor.primary,
//                                   size: 16,
//                                 )),
//                             Text('Chuyển khoản bằng QR code')
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Divider(),
//             Row(
//               children: [
//                 Text(
//                   'Tổng thanh toán:',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(
//                   width: 4,
//                 ),
//                 Text(
//                   _currencyFormat(totalPrice),
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: totalPrice > 0
//                   ? () {
//                       _showCheckoutModal(context);
//                     }
//                   : null, // Disable button if no items are selected
//               style: ElevatedButton.styleFrom(
//                 minimumSize: Size(double.infinity, 50),
//                 backgroundColor: Colors.blueAccent,
//               ),
//               child: Text(
//                 'Đặt voucher',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
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

//   Widget _buildNumberRow(String label, String content) {
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
//             content.toString(),
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
// }
