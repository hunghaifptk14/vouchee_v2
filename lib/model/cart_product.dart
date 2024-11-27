// import 'package:vouchee/model/modal.dart';
// import 'package:vouchee/model/seller.dart';

// class CartProduct extends Modal {
//   final int cartQuantity;
//   Seller seller; // Seller associated with the product

//   CartProduct({
//     required this.seller,
//     required this.cartQuantity,
//     required super.voucherId,
//     required super.brandId,
//     required super.brandName,
//     required super.brandImage,
//     required super.title,
//     required super.stock,
//     required super.originalPrice,
//     required super.sellPrice,
//     required super.shopDiscountMoney,
//     required super.shopDiscountPercent,
//     required super.discountPrice,
//     required super.salePrice,
//     required super.totalUnitPrice,
//     required super.totalDiscountPrice,
//     required super.totalFinalPrice,
//     required super.status,
//     required super.image,
//     required super.startDate,
//     required super.endDate,
//     required super.shopPromotionId,
//     required super.id,
//     required super.quantity,
//   });

//   double get discountedPrice {
//     double priceBeforeDiscount = sellPrice * quantity;

//     // If the seller has a promotion, apply it to the total price
//     if (seller.promotion != null) {
//       double discount = seller.promotion!.percentDiscount;
//       priceBeforeDiscount = priceBeforeDiscount * (1 - (discount / 100));
//     }

//     return priceBeforeDiscount;
//   }
// }
