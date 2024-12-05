// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vouchee/model/cart.dart';
import 'package:vouchee/model/category.dart';
import 'package:vouchee/model/checkout.dart';
import 'package:vouchee/model/item_brief.dart';
import 'package:vouchee/model/modal.dart';
import 'package:vouchee/model/my_voucher.dart';
import 'package:vouchee/model/near_voucher.dart';
import 'package:vouchee/model/order.dart';
import 'package:vouchee/model/promotion.dart';
import 'package:vouchee/model/user.dart';
import 'package:vouchee/model/voucher.dart';
import 'package:vouchee/model/wallet.dart';

// 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjZXJ0c2VyaWFsbnVtYmVyIjoiMTY5NjY3ZTItZTA4ZC00ODBlLWFiODAtZGMzYWYxNTdhYzk4IiwiZW1haWwiOiJuZ3V5ZW5odW5naGFpazE0QGdtYWlsLmNvbSIsImFjdG9ydCI6ImhhaSBuZ3V5ZW4iLCJyb2xlIjoiVVNFUiIsIm5iZiI6MTczMTg1NjA0NiwiZXhwIjoxNzQ5ODU2MDQ2LCJpYXQiOjE3MzE4NTYwNDZ9.w09IHK-EYF7Q-AL8RiyD6R2JlgbkyfNu-d9l4anz0P0';
String? auth;
String? orderID;
String? userName;

class ApiServices {
  Future<String?> postToken(String accessToken) async {
    final String apiUrl =
        'https://api.vouchee.shop/api/v1/auth/login_with_google_token?token=';
    final url = Uri.parse('$apiUrl$accessToken');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'accessToken': accessToken,
        }),
      );

      if (response.statusCode == 200) {
        auth = json.decode(response.body)['accessToken'];
        userName = json.decode(response.body)['name'];

        return auth;
      } else {
        print('Login fail: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  String? getUserName() {
    return userName;
  }

  Future<Voucher> fetchVoucherById(String voucherId) async {
    final String apiUrl =
        'https://api.vouchee.shop/api/v1/voucher/get_voucher/';

    try {
      final response = await http.get(Uri.parse('$apiUrl$voucherId'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body)['results'];
        return Voucher.fromJson(jsonData);
      } else {
        throw Exception('Failed to load voucher');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load voucher: $e');
    }
  }

  Future<Modal> fetchModalById(String modalId) async {
    final String apiUrl = 'https://api.vouchee.shop/api/v1/modal/get_modal/';
    try {
      final response = await http.get(Uri.parse('$apiUrl$modalId'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Modal.fromJson(jsonData);
      } else {
        throw Exception('Không tải được sản phẩm');
      }
    } catch (e) {
      print(e);
      throw Exception('Không tải được sản phẩm: $e');
    }
  }

  Future<List<Voucher>> fetchVouchers() async {
    final String apiUrl =
        'https://api.vouchee.shop/api/v1/voucher/get_all_voucher';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<dynamic> results = jsonData['results'];

        return results.map((voucher) => Voucher.fromJson(voucher)).toList();
      } else {
        throw Exception('Không tải được sản phẩm');
      }
    } catch (e) {
      print(e);
      throw Exception('Không tải được sản phẩm: $e');
    }
  }

  Future<List<Voucher>> getNewestVoucher() async {
    final String apiUrl =
        'https://api.vouchee.shop/api/v1/voucher/get_newest_vouchers';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<dynamic> results = jsonData;

        return results.map((voucher) => Voucher.fromJson(voucher)).toList();
      } else {
        throw Exception('Không tải được sản phẩm');
      }
    } catch (e) {
      print(e);
      throw Exception('Không tải được sản phẩm: $e');
    }
  }

  Future<List<Modal>> fetchModal() async {
    final String apiUrl = 'https://api.vouchee.shop/api/v1/modal/get_all_modal';
    final url = Uri.parse(apiUrl);
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $auth',
        },
      );
      // final jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        // log(response.body);
        List<dynamic> results = jsonData['results'];

        return results.map((modal) => Modal.fromJson(modal)).toList();
      } else {
        print('Unexpected JSON structure');
        return [];
      }
    } catch (e) {
      print('Error fetching cart items: $e');
      return [];
    }
  }

  Future<Category> fetchCategoryById(String categoryId) async {
    final String apiUrl =
        'https://api.vouchee.shop/api/v1/category/get_category/';

    try {
      final response = await http.get(Uri.parse('$apiUrl$categoryId'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(jsonData);
        return Category.fromJson(jsonData);
      } else {
        throw Exception('Failed to load category');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load category: $e');
    }
  }

  Future<List<Category>> fetchCategory() async {
    final String apiUrl =
        'https://api.vouchee.shop/api/v1/category/get_all_category';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<dynamic> results = jsonData['results'];
      // return jsonData.map((json) => Category.fromJson(json)).toList();
      return results.map((category) => Category.fromJson(category)).toList();
    } else {
      throw Exception('Không tải category');
    }
  }

  Future<List<NearVoucher>> fetchNearVouchers(
      {required double lat, required double lon}) async {
    final String apiUrl =
        'https://api.vouchee.shop/api/v1/voucher/get_nearest_vouchers';
    try {
      final response = await http.get(Uri.parse('$apiUrl?lon=$lon&lat=$lat'));
      print('Fetching vouchers from: $apiUrl?lon=$lon&lat=$lat');

      if (response.statusCode == 200) {
        // List<dynamic> results = jsonData['results'];
        // return results.map((voucher) => Voucher.fromJson(voucher)).toList();
        final List<dynamic> jsonData = json.decode(response.body)['results'];
        print(jsonData);
        return jsonData.map((json) => NearVoucher.fromJson(json)).toList();
      } else {
        throw Exception('Không tải được sản phẩm');
      }
    } catch (e) {
      throw Exception('Không tải được sản phẩm');
    }
  }

  Future<Wallet?> fetchWallet() async {
    final String apiUrl =
        'https://api.vouchee.shop/api/v1/wallet/get_buyer_wallet';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $auth'
        },
      );
      print('auth: $auth');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Wallet.fromJson(jsonData);
      } else {
        throw Exception('Chưa có ví');
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<bool> createWallet() async {
    final String apiUrl =
        'https://api.vouchee.shop/api/v1/wallet/create_wallet';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $auth'
        },
      );
      print('auth: $auth');

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Chưa có ví');
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<User> fetchUsers(String userID) async {
    final String apiUrl =
        'https://api.vouchee.shop/api/v1/auth/login_with_google_token?token=';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return User.fromJson(jsonData);
    } else {
      throw Exception('Không tải được thông tin');
    }
  }

  Future<bool> addToCart(String modalId) async {
    final String apiUrl = 'https://api.vouchee.shop/api/v1/cart/add_item/';

    final url = Uri.parse('$apiUrl$modalId');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $auth'
        },
        body: jsonEncode({
          'id': modalId,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to add to cart: ${response.body}');
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['message'] ?? 'Unknown error occurred';
        print('Error: $errorMessage');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<bool> decreaseItem(String modalId) async {
    final String apiUrl =
        'https://api.vouchee.shop/api/v1/cart/decrease_quantity/';
    final url = Uri.parse('$apiUrl$modalId');
    print(url);
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $auth'
        },
        body: jsonEncode({
          'id': modalId,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<bool> increaseItem(String modalId) async {
    final String apiUrl =
        'https://api.vouchee.shop/api/v1/cart/increase_quantity/';
    final url = Uri.parse('$apiUrl$modalId');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $auth'
        },
        body: jsonEncode({
          'id': modalId,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to increase item: ${response.body}');

        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<bool> RemoveItem(String modalId) async {
    final String apiUrl = 'https://api.vouchee.shop/api/v1/cart/remove_item/';
    final url = Uri.parse('$apiUrl$modalId');
    print(url);
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $auth'
        },
        body: jsonEncode({
          'id': modalId,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to remove item: ${response.body}');

        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<bool> updateCartQuantity(String modalId, int quantity) async {
    final String apiUrl =
        'https://api.vouchee.shop/api/v1/cart/update_quantity/';
    final url = Uri.parse('$apiUrl$modalId?quantity=$quantity');
    print(url);
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $auth'
        },
        body: jsonEncode({
          'id': modalId,
          'quanity': quantity,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to update item: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<Cart> fetchCartData() async {
    final url = Uri.parse('https://api.vouchee.shop/api/v1/cart/get_all_item');

    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $auth',
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        // Decode the response body
        final jsonData = json.decode(response.body);
        return Cart.fromJson(jsonData);
      } else {
        throw Exception("Failed to fetch cart data: ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception("Error fetching cart data: $e");
    }
  }

  Future<Checkout?> checkoutCart({
    required List<ItemBrief> items,
    required int useVpoint,
    required int useBalance,
    required String giftEmail,
  }) async {
    final String apiUrl = 'https://api.vouchee.shop/api/v1/cart/checkout';

    try {
      // Serialize ItemBrief list to JSON
      final List<Map<String, dynamic>> itemBriefList =
          items.map((item) => item.toJson()).toList();

      // Create the request body
      final body = jsonEncode({
        "item_brief": itemBriefList,
        "use_VPoint": useVpoint,
        "use_balance": useBalance,
        "gift_email": giftEmail,
      });

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type":
              "application/json-patch+json", // Ensure correct content type
          "Authorization": 'Bearer $auth', // Add your authorization token here
        },
        body: body,
      );

      // Debugging: Print the request body and response body

      if (response.statusCode == 200) {
        // Successful response
        final jsonData = json.decode(response.body);
        print('Response : $jsonData');

        return Checkout.fromJson(jsonData);
      } else {
        // Handle failure
        print("Failed to checkout: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error during checkout: $e");
      return null;
    }
  }

  Future<List<Order>> fetchAllOrder() async {
    final url =
        Uri.parse('https://api.vouchee.shop/api/v1/order/get_all_order');

    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $auth',
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<dynamic> results = jsonData['results'];
        print(jsonData);
        return results.map((order) => Order.fromJson(order)).toList();
      } else {
        throw Exception("Failed to fetch order data: ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception("Error fetching order data: $e");
    }
  }

  Future<Order> fetchOrderID(String orderID) async {
    final url =
        Uri.parse('https://api.vouchee.shop/api/v1/order/get_order/$orderID');

    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $auth',
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        // Decode the response body
        final jsonData = json.decode(response.body);

        return Order.fromJson(jsonData);
      } else {
        throw Exception("Failed to fetch order data: ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception("Error fetching order data: $e");
    }
  }

  Future<String?> createOrder({
    required List<ItemBrief> items,
    required int useVpoint,
    required int useBalance,
    required String giftEmail,
  }) async {
    final String apiUrl = 'https://api.vouchee.shop/api/v1/order/create_order';
    final List<Map<String, dynamic>> itemBriefList =
        items.map((item) => item.toJson()).toList();
    try {
      final body = jsonEncode({
        "item_brief": itemBriefList,
        "use_VPoint": useVpoint,
        "use_balance": useBalance,
        "gift_email": giftEmail
      });

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json-patch+json",
          "Authorization": 'Bearer $auth'
        },
        body: body,
      );
      print(response.body);
      if (response.statusCode == 200) {
        orderID = jsonDecode(response.body)['value'];
        print('Order created: $orderID');
        return orderID;
      } else {
        // Handle error
        print("Failed to create order: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error during order: $e");
      return null;
    }
  }

  String? getOrderID() {
    print('get order ID: $orderID');
    return orderID;
  }

  Future<String> getOrderStatus() async {
    final url =
        Uri.parse('https://api.vouchee.shop/api/v1/order/get_order/$orderID');

    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $auth',
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body)['status'];
        print('request');
        return jsonData;
      } else {
        throw Exception("Failed to fetch cart data: ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception("Error fetching cart data: $e");
    }
  }

  Future<String?> topUpRequest({required num aoumt}) async {
    final String apiUrl =
        'https://api.vouchee.shop/api/v1/topUpRequest/create_top_up_request';

    try {
      // Create the request body
      final body = jsonEncode({"aoumt": aoumt});

      // Make the POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json-patch+json",
          "Authorization": 'Bearer $auth'
        },
        body: body,
      );

      if (response.statusCode == 200) {
        print('request top up ok');
        return orderID;
      } else {
        // Handle error
        print("Failed to create order: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error during order: $e");
      return null;
    }
  }

  Future<List<Promotion>> fetchPromotionByShopID(String shopID) async {
    final url = Uri.parse(
        'https://api.vouchee.shop/api/v1/shopPromotion/get_promotions_by_shop_id?shopId=$shopID');

    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $auth',
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        // Decode the response body
        final List<dynamic> jsonData = json.decode(response.body);

        return jsonData.map((promo) => Promotion.fromJson(promo)).toList();
      } else {
        throw Exception(
            "Failed to fetch promotion data: ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception("Error fetching promotion data: $e");
    }
  }

  Future<List<MyVoucher>?> fetchMyVoucher() async {
    final String apiUrl =
        'https://api.vouchee.shop/api/v1/myVoucher/get_my_vouchers';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $auth'
        },
      );
      print('auth: $auth');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body)['results'];
        print(jsonData);
        return jsonData
            .map((myVoucher) => MyVoucher.fromJson(myVoucher))
            .toList();
      } else {
        throw Exception('Chưa có voucher');
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
