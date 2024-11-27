// import 'package:flutter/material.dart';
// import 'package:vouchee/model/cart.dart';
// import 'package:vouchee/model/modal.dart';
// import 'package:vouchee/api/api_service.dart';

// class CartScreen extends StatefulWidget {
//   final String buyerId;

//   CartScreen({required this.buyerId});

//   @override
//   _CartScreenState createState() => _CartScreenState();
// }

// class _CartScreenState extends State<CartScreen> {
//   late Future<Cart> _cartFuture;
//   late Cart _cart; // Store the cart data in a local variable

//   @override
//   void initState() {
//     super.initState();
//     _cartFuture = ApiService().fetchCart(widget.buyerId);
//   }

//   // Function to calculate the total price of selected items
//   double _calculateTotalPrice() {
//     double total = 0;
//     for (var seller in _cart.sellers) {
//       for (var modal in seller.modals) {
//         if (modal.selected) {
//           total +=
//               modal.salePrice * modal.quantity; // Add price of selected items
//         }
//       }
//     }
//     return total;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('My Cart')),
//       body: FutureBuilder<Cart>(
//         future: _cartFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData) {
//             return Center(child: Text('No items in cart'));
//           }

//           _cart = snapshot.data!;

//           return Stack(
//             children: [
//               Column(
//                 children: [
//                   // Display total quantity and balance at the top
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Total Quantity: ${_cart.totalQuantity}',
//                             style: TextStyle(fontSize: 16)),
//                         Text('Balance: \$${_cart.balance.toStringAsFixed(2)}',
//                             style: TextStyle(fontSize: 16)),
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: _cart.sellers.length,
//                       itemBuilder: (context, index) {
//                         Seller seller = _cart.sellers[index];
//                         return ExpansionTile(
//                           title: Text(seller.sellerName),
//                           leading: Image.network(seller.sellerImage,
//                               width: 40, height: 40),
//                           children: seller.modals.map((modal) {
//                             return Card(
//                               margin: EdgeInsets.symmetric(
//                                   vertical: 8, horizontal: 16),
//                               child: ListTile(
//                                 contentPadding: EdgeInsets.all(10),
//                                 title: Text(modal.title),
//                                 subtitle: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                         'Original Price: \$${modal.originalPrice.toStringAsFixed(2)}'),
//                                     Text(
//                                         'Discounted Price: \$${modal.salePrice.toStringAsFixed(2)}'),
//                                     Text('Quantity: ${modal.quantity}'),
//                                   ],
//                                 ),
//                                 leading: Checkbox(
//                                   value: modal
//                                       .selected, // The state of the checkbox
//                                   onChanged: (bool? selected) {
//                                     setState(() {
//                                       modal.selected = selected ??
//                                           false; // Toggle the selection state
//                                     });
//                                   },
//                                 ),
//                                 trailing: IconButton(
//                                   icon: Icon(Icons.remove_shopping_cart),
//                                   onPressed: () {
//                                     _removeItemFromCart(
//                                         _cart.buyerId, modal.id);
//                                   },
//                                 ),
//                                 onTap: () {
//                                   _updateQuantityDialog(
//                                       context, _cart.buyerId, modal);
//                                 },
//                               ),
//                             );
//                           }).toList(),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               // Floating Row at the bottom
//               Positioned(
//                 bottom: 0,
//                 left: 0,
//                 right: 0,
//                 child: Container(
//                   color: Colors.blueAccent,
//                   padding: EdgeInsets.all(16),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Total: \$${_calculateTotalPrice().toStringAsFixed(2)}',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       ElevatedButton(
//                         onPressed: _calculateTotalPrice() > 0
//                             ? () {
//                                 // Handle Checkout or Confirm action
//                               }
//                             : null, // Disable if no items are selected
//                         child: Text('Checkout'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   // Method to remove item from the cart
//   Future<void> _removeItemFromCart(String buyerId, String modalId) async {
//     try {
//       await ApiService().removeFromCart(buyerId, modalId);
//       setState(() {
//         _cartFuture = ApiService().fetchCart(buyerId); // Refresh cart data
//       });
//     } catch (e) {
//       print('Error removing item: $e');
//     }
//   }

//   // Method to update item quantity (show a dialog to modify)
//   Future<void> _updateQuantityDialog(
//       BuildContext context, String buyerId, Modal modal) async {
//     int newQuantity = modal.quantity;
//     TextEditingController quantityController =
//         TextEditingController(text: newQuantity.toString());

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Update Quantity'),
//           content: TextField(
//             controller: quantityController,
//             keyboardType: TextInputType.number,
//             decoration: InputDecoration(labelText: 'Quantity'),
//             onChanged: (value) {
//               newQuantity = int.tryParse(value) ?? newQuantity;
//             },
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 if (newQuantity > 0) {
//                   modal.quantity = newQuantity;
//                   await ApiService()
//                       .updateItemQuantity(buyerId, modal.id, newQuantity);
//                   setState(() {
//                     _cartFuture =
//                         ApiService().fetchCart(buyerId); // Refresh cart data
//                   });
//                   Navigator.of(context).pop();
//                 }
//               },
//               child: Text('Update'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
