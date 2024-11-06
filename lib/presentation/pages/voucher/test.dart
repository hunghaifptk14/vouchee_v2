// import 'package:flutter/material.dart';
// import 'package:vouchee/core/configs/theme/app_color.dart';
// import 'package:vouchee/model/voucher.dart';
// import 'package:vouchee/presentation/widgets/appBar/top_app_bar.dart';
// import 'package:vouchee/presentation/widgets/buttons/basic_button.dart';

// class VoucherDetail extends StatefulWidget {
//   final Voucher voucher;

//   const VoucherDetail({
//     super.key,
//     required this.voucher,
//   });

//   @override
//   State<VoucherDetail> createState() => _VoucherDetailState();
// }

// class _VoucherDetailState extends State<VoucherDetail> {
//   int quantity = 1; // Initial Voucher count
//   // List<CartItem> cart = [];
//   void incrementCount() {
//     setState(() {
//       quantity++; // Increment Voucher count
//     });
//   }

//   void decrementCount() {
//     if (quantity > 1) {
//       setState(() {
//         quantity--; // Decrement Voucher count
//       });
//     }
//   }

//   void addToCart(Voucher voucher, int quantity) {
//     setState(() {
//       // CartItem? existingCartItem = cart.firstWhere(
//       //   (item) => item.voucher.brandName == voucher.brandName,
//       //   orElse: () => CartItem(voucher: voucher, quantity: 0),
//       // );

//       // if (existingCartItem.quantity > 0) {
//       //   existingCartItem.quantity += quantity;
//       // } else {
//       //   cart.add(CartItem(voucher: voucher, quantity: quantity));
//       // }

//       // ScaffoldMessenger.of(context).showSnackBar(
//       //   SnackBar(content: Text('${voucher.brandName} added to cart!')),
//       // );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const TopAppBar(
//         topTitle: Text('Chi tiết voucher'),
//       ),
//       // bottomNavigationBar: const BottomAppBarcustom(),
//       body: SingleChildScrollView(
//           child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(8),
//               child: Image.network(
//                 widget.voucher.brandImage,
//                 height: 250,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             const SizedBox(
//               height: 8,
//             ),
//             Text(
//               widget.voucher.brandName,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(
//               height: 8,
//             ),
//             Text(
//               '${widget.voucher.sellPrice} đ',
//               style: const TextStyle(
//                   fontSize: 16,
//                   color: Colors.green,
//                   fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(
//               height: 8,
//             ),
//             Row(
//               children: [
//                 const Text(
//                   'Ngày hết hạn: ',
//                   style: TextStyle(fontSize: 16, color: AppColor.black),
//                 ),
//                 // Text(
//                 //   widget.voucher.endDate.toString(),
//                 //   style: const TextStyle(fontSize: 14, color: AppColor.grey),
//                 // ),
//               ],
//             ),
//             const SizedBox(
//               height: 8,
//             ),
//             const Text(
//               'Mô tả: ',
//               style: TextStyle(fontSize: 16, color: AppColor.black),
//             ),
//             const SizedBox(
//               height: 8,
//             ),
//             // Text(
//             //   widget.voucher.addresses.toString(),
//             //   style: const TextStyle(
//             //       fontSize: 14,
//             //       color: AppColor.black,
//             //       fontWeight: FontWeight.w300),
//             // ),
//             const SizedBox(
//               height: 16,
//             ),
//             const Text(
//               'Vị trí cửa hàng:',
//               style: TextStyle(fontSize: 16, color: AppColor.black),
//             ),
//             const SizedBox(
//               height: 8,
//             ),
//             // Text(
//             //   widget.voucher.,
//             //   style: const TextStyle(
//             //       fontSize: 14,
//             //       color: AppColor.grey,
//             //       fontWeight: FontWeight.w300),
//             // ),
//             // const SizedBox(
//             //   height: 16,
//             // ),
//             const Text(
//               'Chú ý:',
//               style: TextStyle(fontSize: 16, color: AppColor.black),
//             ),
//             const SizedBox(
//               height: 8,
//             ),

//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   OutlinedButton(
//                       onPressed: () {
//                         // for (int i = 0; i < quantity; i++) {
//                         //   Provider.of<CartProvider>(context, listen: false)
//                         //       .addToCart(widget.voucher);
//                         // }

//                         // // Show a snackbar to confirm that the Voucher was added to the cart
//                         // ScaffoldMessenger.of(context).showSnackBar(
//                         //   SnackBar(
//                         //     content: Text(
//                         //         'Added $quantity ${widget.voucher.brandName} to cart!'),
//                         //   ),
//                         // );
//                       },
//                       style: OutlinedButton.styleFrom(
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15)),
//                           side: const BorderSide(
//                             width: 2.0,
//                             color: AppColor.primary,
//                           )),
//                       child: const Padding(
//                         padding:
//                             EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//                         child: Text(
//                           'Thêm vào giỏ',
//                           style: TextStyle(
//                               color: AppColor.secondary, fontSize: 14),
//                         ),
//                       )),
//                   Row(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(50),
//                           border:
//                               Border.all(color: AppColor.secondary, width: 2),
//                         ),
//                         child: IconButton(
//                           icon: const Icon(Icons.remove),
//                           iconSize: 20,
//                           onPressed: decrementCount,
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 16,
//                       ),
//                       Container(
//                         width: 30,
//                         alignment: Alignment.center,
//                         child: Text(
//                           '$quantity',
//                           style: const TextStyle(fontSize: 22),
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 16,
//                       ),
//                       Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(50),
//                           border:
//                               Border.all(color: AppColor.secondary, width: 2),
//                         ),
//                         child: IconButton(
//                           icon: const Icon(Icons.add),
//                           iconSize: 20,
//                           onPressed: incrementCount,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(
//               height: 30,
//             ),
//             BasicButton(
//               onPressed: () {
//                 // Provider.of<CartProvider>(context, listen: false)
//                 //     .addToCart(widget.voucher);
//               },
//               textColor: AppColor.white,
//               title: "Mua ngay",
//               font: 22,
//             )
//           ],
//         ),
//       )),
//     );
//   }
// }
