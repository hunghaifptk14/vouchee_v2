// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:vouchee/model/address.dart';
import 'package:vouchee/model/cart.dart';
import 'package:vouchee/model/category.dart';
import 'package:vouchee/model/checkout.dart';
import 'package:vouchee/model/item_brief.dart';
import 'package:vouchee/model/modal.dart';
import 'package:vouchee/model/my_voucher.dart';
import 'package:vouchee/model/near_voucher.dart';
import 'package:vouchee/model/notification.dart';
import 'package:vouchee/model/order.dart';
import 'package:vouchee/model/promotion.dart';
import 'package:vouchee/model/rating.dart';
import 'package:vouchee/model/refund.dart';
import 'package:vouchee/model/transactions.dart';
import 'package:vouchee/model/user.dart';
import 'package:vouchee/model/voucher.dart';
import 'package:vouchee/model/wallet.dart';

String? auth;
String? orderID;
String? userName;
String? topUpID;
String? drawID;

class ApiServices {
  Future<String?> getDeviceToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    try {
      String? token = await messaging.getToken();
      if (token != null) {
        print("Device Token: $token");

        return token;
      }
    } catch (e) {
      print("Error getting device token: $e");
    }
    return null;
  }

  Future<String?> postToken(String accessToken) async {
    final deviceToken = await getDeviceToken();

    if (deviceToken == null) {
      print("Device token is null.");
      return null;
    }
    final String apiUrl =
        'https://api.vouchee.shop/api/v1/auth/login_with_google_token?token=$accessToken&deviceToken=$deviceToken';
    final url = Uri.parse(apiUrl);
    log(apiUrl);

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
      throw Exception("Error fetching data: $e");
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

  Future<List<Address>> fetchVoucherAddress(String voucherId) async {
    final String apiUrl =
        'https://api.vouchee.shop/api/v1/voucher/get_voucher/';

    try {
      final response = await http.get(Uri.parse('$apiUrl$voucherId'));

      if (response.statusCode == 200) {
        List<dynamic> jsonData =
            json.decode(response.body)['results']['addresses'];
        return jsonData.map((address) => Address.fromJson(address)).toList();
      } else {
        throw Exception('Failed to load address');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load voucher: $e');
    }
  }

  Future<Modal> fetchModalById(String modalId) async {
    final String apiUrl = 'https://api.vouchee.shop/api/v1/modal/get_modal/';
    try {
      final response = await http.get(
        Uri.parse('$apiUrl$modalId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $auth',
        },
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body)['results'];
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
        List<dynamic> results = jsonData['results'];

        return results.map((modal) => Modal.fromJson(modal)).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception("Error fetching data: $e");
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
        final List<dynamic> jsonData = json.decode(response.body)['results'];
        return jsonData.map((json) => NearVoucher.fromJson(json)).toList();
      } else {
        throw Exception('Không tải được sản phẩm');
      }
    } catch (e) {
      throw Exception('Không tải được sản phẩm');
    }
  }

  Future<Wallet> fetchWallet() async {
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

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        return Wallet.fromJson(jsonData);
      } else {
        throw Exception('Chưa có ví');
      }
    } catch (e) {
      throw Exception('Không tải được wallet $e');
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

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Chưa có ví');
      }
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }
  }

  Future<AppUser> getUserInfo() async {
    final String apiUrl =
        'https://api.vouchee.shop/api/v1/auth/login_with_google_token?token=';
    final response = await http.get(Uri.parse('$apiUrl$auth'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return AppUser.fromJson(jsonData);
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
      throw Exception("Error fetching data: $e");
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
      throw Exception("Error fetching data: $e");
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
      throw Exception("Error fetching data: $e");
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
      throw Exception("Error fetching data: $e");
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
      throw Exception("Error fetching data: $e");
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
  }) async {
    final String apiUrl = 'https://api.vouchee.shop/api/v1/cart/checkout';

    try {
      // Serialize ItemBrief list to JSON
      final List<Map<String, dynamic>> itemBriefList =
          items.map((item) => item.toJson()).toList();

      // Create the request body
      final body = jsonEncode({
        "item_brief": itemBriefList,
        "use_VPoint": 0,
        "use_balance": 0,
        "gift_email": '',
      });

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json-patch+json",
          "Authorization": 'Bearer $auth',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        // Successful response
        final jsonData = json.decode(response.body);

        return Checkout.fromJson(jsonData);
      } else {
        print("Failed to checkout: ${response.body}");
        return null;
      }
    } catch (e) {
      throw Exception("Error fetching data: $e");
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
    required int? useVpoint,
    required int? useBalance,
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
      print('order use balance==> $useBalance');

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json-patch+json",
          "Authorization": 'Bearer $auth'
        },
        body: body,
      );
      print('order==> ${response.body}');
      if (response.statusCode == 200) {
        orderID = jsonDecode(response.body)['value'];
        // print('Order created: $orderID');
        return orderID;
      } else {
        // Handle error

        print("Lỗi khi tạo đơn hàng");
        return null;
      }
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }
  }

  String? getOrderID() {
    print('get order ID: $orderID');
    return orderID;
  }

  String? getTopUpID() {
    print('get topup ID: $topUpID');
    return topUpID;
  }

  String? getDrawID() {
    print('get draw ID: $drawID');
    return drawID;
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

  Future<String?> topUpRequest({required String amount}) async {
    final String apiUrl =
        'https://api.vouchee.shop/api/v1/topUpRequest/create_top_up_request';

    try {
      // Create the request body
      final body = jsonEncode({"amount": amount});

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
        topUpID = jsonDecode(response.body)['value'];
        print('request top up ok');
        return topUpID;
      } else {
        // Handle error
        print("Failed to topup: ${response.body}");
        return null;
      }
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }
  }

  Future<String?> withdrawRequest({required String amount}) async {
    final String apiUrl =
        'https://api.vouchee.shop/api/v1/withdraw/create_withdraw_request';

    try {
      // Create the request body
      final body = jsonEncode({"amount": amount});

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
        drawID = jsonDecode(response.body)['value'];
        print('request withdraw ok');
        return drawID;
      } else {
        // Handle error
        print("Failed to withdraw: ${response.body}");
        return null;
      }
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }
  }

  Future<List<Promotion>> fetchPromotionByShopID(String shopID) async {
    print(shopID);
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
        print('promotion api:$jsonData');
        return jsonData.map((promo) => Promotion.fromJson(promo)).toList();
      } else {
        throw Exception(
            "Failed to fetch promotion data: ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception("Error fetching promotion data: $e");
    }
  }

  Future<List<MyVoucher>?> fetchMyUnuseVoucher() async {
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

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body)['results'];

        return jsonData
            .map((myVoucher) => MyVoucher.fromJson(myVoucher))
            .toList();
      } else {
        throw Exception('Chưa có voucher');
      }
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }
  }

  Future<List<MyVoucher>?> fetchMyUsedVoucher() async {
    final String apiUrl =
        'https://api.vouchee.shop/api/v1/myVoucher/get_my_vouchers?status=2';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $auth'
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body)['results'];

        return jsonData
            .map((myVoucher) => MyVoucher.fromJson(myVoucher))
            .toList();
      } else {
        throw Exception('Chưa có voucher');
      }
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }
  }

  Future<List<MyVoucher>?> fetchMyPendingVoucher() async {
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

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body)['results'];

        return jsonData
            .map((myVoucher) => MyVoucher.fromJson(myVoucher))
            .toList();
      } else {
        throw Exception('Chưa có voucher');
      }
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }
  }

  Future<AppUser> getCurrentUser() async {
    final String apiUrl =
        'https://api.vouchee.shop/api/v1/user/get_current_user';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $auth'
        },
      );

      if (response.statusCode == 200) {
        return AppUser.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error fetching user');
      }
    } catch (e) {
      throw Exception("Error fetching user: $e");
    }
  }

  Future<void> updateBuyerBank(
      String? bankAccount, String? bankName, String? bankNumber) async {
    String apiUrl =
        'https://api.vouchee.shop/api/v1/user/update_user_bank?walletTypeEnum=0';
    final url = Uri.parse(apiUrl);

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json-pacth+json',
          'Authorization': 'Bearer $auth'
        },
        body: jsonEncode({
          'bankAccount': bankAccount,
          'bankName': bankName,
          'bankNumber': bankNumber,
        }),
      );

      if (response.statusCode == 200) {
        print('ok: ${response.body}');
      } else {
        print('false');
      }
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }
  }

  Future<void> updateBuyerInfo(
      String? name, String? phoneNumber, String? image) async {
    String apiUrl = 'https://api.vouchee.shop/api/v1/user/update_user';
    final url = Uri.parse(apiUrl);
    if (image == null) {
      String base64Images = "";
      try {
        final response = await http.put(
          url,
          headers: {
            'Content-Type': 'application/json-pacth+json',
            'Authorization': 'Bearer $auth'
          },
          body: jsonEncode({
            'name': name,
            'phoneNumber': phoneNumber,
            'image': base64Images,
          }),
        );

        if (response.statusCode == 200) {
          print('ok');
        } else {
          print('false');
        }
      } catch (e) {
        throw Exception("Error fetching data: $e");
      }
    } else {
      String? base64Images = await _encodeImageToBase64(image);
      try {
        final response = await http.put(
          url,
          headers: {
            'Content-Type': 'application/json-pacth+json',
            'Authorization': 'Bearer $auth'
          },
          body: jsonEncode({
            'name': name,
            'phoneNumber': phoneNumber,
            'image': base64Images,
          }),
        );

        if (response.statusCode == 200) {
          print('ok');
        } else {
          print('false');
        }
      } catch (e) {
        throw Exception("Error fetching data: $e");
      }
    }
  }

  Future<void> updateVoucherCodeStatus(
    String? id,
  ) async {
    String apiUrl =
        'https://api.vouchee.shop/api/v1/voucherCode/update_status_voucher_code/$id?status=2';
    final url = Uri.parse(apiUrl);

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json-pacth+json',
          'Authorization': 'Bearer $auth'
        },
        body: jsonEncode({
          'id': id,
        }),
      );

      if (response.statusCode == 200) {
        print('status ok');
      } else {
        print('false');
      }
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }
  }

  Future<bool> updateRating(Rating rating) async {
    final String apiUrl =
        'https://api.vouchee.shop/api/v1/rating/create_rating';
    final url = Uri.parse(apiUrl);

    // Prepare the request body
    final body = {
      "orderId": rating.orderId,
      "modalId": rating.modalId,
      // "medias": rating.medias.map((media) => {"url": media.url}).toList(),
      "qualityStar": rating.qualityStar,
      "serviceStar": rating.serviceStar,
      "sellerStar": rating.sellerStar,
      "comment": rating.comment,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $auth',
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print("Rating updated successfully: ${response.body}");
        return true;
      } else {
        print("Failed to update rating: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error during API call: $e");
      return false;
    }
  }

  Future<String> getVoucherCodeById(String codeId) async {
    final String apiUrl =
        'https://api.vouchee.shop/api/v1/myVoucher/get_voucher_code/$codeId';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $auth'
        },
      );

      if (response.statusCode == 200) {
        final String data = json.decode(response.body)['newCode'];
        print(data);
        return data;
      } else {
        throw Exception('Error code id ');
      }
    } catch (e) {
      throw Exception("Error code id : $e");
    }
  }

  Future<List<NotificationReceiver>> getNotification() async {
    final url = Uri.parse(
        'https://api.vouchee.shop/api/v1/notification/get_receiver_notifications?pageSize=99');

    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $auth',
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        // Decode the response body
        final List<dynamic> jsonData = json.decode(response.body)['results'];
        return jsonData
            .map((noti) => NotificationReceiver.fromJson(noti))
            .toList();
      } else {
        throw Exception("Failed to fetch order data: ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception("Error fetching order data: $e");
    }
  }

  Future<bool> markSeenNotification(String notificationId) async {
    final url = Uri.parse(
        'https://api.vouchee.shop/api/v1/notification/mark_seen_notification/$notificationId');

    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $auth',
      };
      final body = jsonEncode({
        'id': notificationId,
      });

      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        // Decode the response body
        return true;
      } else {
        throw Exception("Failed to mark notificaiton");
      }
    } catch (e) {
      throw Exception("Failed to mark notificaiton");
    }
  }

  Future<List<Refund>> getRefundRequest() async {
    final url = Uri.parse(
        'https://api.vouchee.shop/api/v1/refundRequest/get_buyer_refund_request?pageSize=99');

    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $auth',
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        // Decode the response body as a map
        var jsonData = json.decode(response.body);

        // Check if the 'results' key exists and contains a list
        if (jsonData is Map<String, dynamic> &&
            jsonData.containsKey('results')) {
          List<dynamic> refundList =
              jsonData['results']; // Extract the 'results' list
          print('refund: $jsonData');
          // Map the list to Refund objects
          return refundList.map((refund) => Refund.fromJson(refund)).toList();
        } else {
          // Handle the case where 'results' key is missing or not a list
          throw Exception(
              "API response doesn't contain 'results' key or it's not a list.");
        }
      } else {
        throw Exception(
            "Failed to fetch refund data: ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception("Error fetching refunds data: $e");
    }
  }

  Future<List<BuyerWalletTransaction>> fetchBuyerTransaction() async {
    final url = Uri.parse(
        'https://api.vouchee.shop/api/v1/wallet/get_buyer_transactions');

    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $auth',
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        // Decode the response body
        final List<dynamic> jsonData = json.decode(response.body)['results'];
        print(jsonData);
        return jsonData
            .map((trans) => BuyerWalletTransaction.fromJson(trans))
            .toList();
      } else {
        throw Exception("Failed to fetch order data: ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception("Error fetching order data: $e");
    }
  }

  Future<bool> refundVoucherCode(
    String voucherCodeId,
    String content,
    num? latitude,
    num? longitude,
  ) async {
    if (latitude == null || longitude == null || content.isEmpty) {
      print('Missing required data');
      return false;
    }

    final apiUrl =
        'https://api.vouchee.shop/api/v1/refundRequest/create_refund_request';

    try {
      // Prepare multipart request
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl))
        ..headers['Authorization'] =
            'Bearer $auth' // Add authorization if required
        ..headers['Content-Type'] = 'multipart/form-data';

      // Attach the images to the request

      // Attach other fields to the request
      request.fields['voucherCodeId'] = voucherCodeId;
      request.fields['content'] = content;
      request.fields['lat'] = latitude.toString();
      request.fields['lon'] = longitude.toString();

      // Make the request
      final response = await request.send();

      // Check the response status
      if (response.statusCode == 200) {
        print('Data successfully sent');
        return true;
      } else {
        print('Failed to send data: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error sending data: $e');
      return false;
    }
  }

  // Helper method to encode images to Base64
  Future<List<String>> _encodeImagesToBase64(List<String> imagePaths) async {
    List<String> base64Images = [];
    for (String path in imagePaths) {
      final bytes = await File(path).readAsBytes();
      base64Images.add(base64Encode(bytes));
    }
    return base64Images;
  }

  Future<String> _encodeImageToBase64(String imagePath) async {
    try {
      final bytes = await File(imagePath).readAsBytes();
      String base64Image = base64Encode(bytes);
      return base64Image;
    } catch (e) {
      throw Exception("Error encoding image: $e");
    }
  }
}
