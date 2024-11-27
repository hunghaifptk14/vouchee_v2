import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:vouchee/core/configs/assets/app_vector.dart';
import 'package:vouchee/core/configs/theme/app_color.dart';
import 'package:vouchee/model/cart.dart';
import 'package:vouchee/model/modal.dart';
import 'package:vouchee/networking/api_request.dart';
import 'package:vouchee/presentation/pages/cart/promotion_list.dart';
import 'package:vouchee/presentation/pages/cart/testCheckout.dart';
import 'package:vouchee/presentation/pages/homePage/home_page.dart';
import 'package:vouchee/presentation/widgets/snack_bar.dart';

class CartPage extends StatefulWidget {
  const CartPage({
    super.key,
  });

  @override
  cartScreenState createState() => cartScreenState();
}

class cartScreenState extends State<CartPage> {
  late Future<Cart> futureCart;
  Cart? cart;
  List<Modal> selectedItems = [];
  ApiServices apiServices = ApiServices();
  bool selectAll = false;
  Map<String, String> selectedPromotionMap = {};
  Map<String, int> selectedPromotionDiscount = {};
  String selectedPromo = '';
  String? _appliedPromotions;
  @override
  void initState() {
    super.initState();

    futureCart = apiServices.fetchCartData();
  }

  void reloadUI() {
    selectAll = false;
    setState(() {});
    selectedItems = [];
    selectedPromotionMap = {};
    selectedPromotionDiscount = {};
    _appliedPromotions = '';
    modalIDList = [];
  }

  Future<void> _loadCartData() async {
    futureCart = apiServices.fetchCartData();
    reloadUI();
  }

  void onpromoSelected(String option) {
    setState(() {
      selectedPromo = option;
      _appliedPromotions = selectedPromo; // Update the selected option
    });
  }

  void updateButtonText(
      String sellerId, String promotionName, int promoPecentDiscount) {
    setState(() {
      selectedPromotionMap[sellerId] = promotionName;
      selectedPromotionDiscount[sellerId] = promoPecentDiscount;

      print(_appliedPromotions);
    });
  }

  List<String> modalIDList = [];

  Future<void> _checkout() async {
    await apiServices.checkoutCart(
        modalId: modalIDList,
        giftEmail: 'mail',
        promotionId: _appliedPromotions,
        useBalance: 0,
        useVpoint: 0);
  }

  double _calculateTotalPrice() {
    if (selectedItems.isEmpty) return 0.0;
    return selectedItems.fold(0.0, (total, modal) {
      // double origin = modal.sellPrice * (1 - (promotionDiscount! / 100));
      // print(origin);
      return total + (modal.sellPrice * modal.quantity);
    });
  }

  void _toggleSelectAll(bool? selected) {
    setState(() {
      selectAll = selected ?? false;
      if (cart != null) {
        for (var seller in cart!.sellers) {
          for (var modal in seller.modals) {
            modal.selected = selectAll;
            if (selectAll) {
              selectedItems.add(modal); // Add all modals to the list
            } else {
              selectedItems.remove(modal);
            }
          }
        }
      }
    });
  }

  void _updateSelectedItems(Modal modal, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedItems.add(modal); // Add item to the list
        modalIDList.add(modal.id);
      } else {
        selectedItems.remove(modal); // Remove item from the list
        modalIDList.remove(modal.id);
      }
      print(modalIDList);
    });
  }

  Future<void> _removeItem(String modalId) async {
    bool success = await apiServices.RemoveItem(modalId);
    reloadUI();
    if (success) {
      TopSnackbar.show(context, 'Đã xóa sản phẩm');
    } else {
      TopSnackbar.show(context, 'Xóa thất bại',
          backgroundColor: AppColor.warning);
    }
  }

  Future<void> _showConfirmDeleteDialog(String modalId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text(''),
          content: Text('Bạn có muốn xóa voucher này?'),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Xóa'),
              onPressed: () {
                // Perform the delete action
                _removeItem(modalId);
                Navigator.of(context).pop();
                _loadCartData(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _decreaseItem(String modalId) {
    apiServices.decreaseItem(modalId);
    _loadCartData();
  }

  Future<void> _increaseItem(String modalId) async {
    bool success = false;
    success = await apiServices.increaseItem(modalId);
    if (success) {
      _loadCartData();
    } else {
      TopSnackbar.show(
        context,
        'Số lượng voucher tối đa',
      );
    }
  }

  String _currencyFormat(double amount) {
    String format = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0, // No decimal digits
    ).format(amount);
    return format;
  }

  bool visible = false;

  @override
  Widget build(BuildContext context) {
    // double widthfit = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Giỏ hàng'),
        // backgroundColor: Colors.transparent,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => HomePage()));
            },
            icon: SvgPicture.asset(
              AppVector.homeIcon,
              height: 22,
              fit: BoxFit.cover,
              colorFilter:
                  const ColorFilter.mode(AppColor.black, BlendMode.srcIn),
            ),
            iconSize: 22,
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadCartData,
        child: FutureBuilder<Cart>(
          future: futureCart,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('No items in cart'));
            }

            Cart cart = snapshot.data!;

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(16.0),
                    itemCount: cart.sellers.length,
                    itemBuilder: (BuildContext context, int index) {
                      final seller = cart.sellers[index];
                      final selectedPromotionBtn =
                          selectedPromotionMap[seller.sellerId] ??
                              'Sử dụng mã khuyến mãi';
                      final selectedPromotionDiscountBtn =
                          selectedPromotionDiscount[seller.sellerId] ?? '';

                      return Column(
                        children: [
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(seller.sellerName,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                          Container(
                              child: Column(
                            children: [
                              ...seller.modals.map(
                                (modal) => Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: AppColor.white,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: 24,
                                                  height: 24,
                                                  child: Checkbox(
                                                    side: BorderSide(
                                                        color: Colors.black26),
                                                    activeColor:
                                                        AppColor.primary,
                                                    value: selectedItems
                                                        .contains(modal),
                                                    onChanged:
                                                        (bool? selected) {
                                                      _updateSelectedItems(
                                                        modal,
                                                        selected ?? false,
                                                      );
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                  height: 24,
                                                  child: IconButton(
                                                    padding: EdgeInsets.zero,
                                                    constraints:
                                                        BoxConstraints(),
                                                    color: Colors.black26,
                                                    onPressed: () {
                                                      _showConfirmDeleteDialog(
                                                          modal.id);
                                                    },
                                                    icon: SvgPicture.asset(
                                                      AppVector.trashBin,
                                                      colorFilter:
                                                          const ColorFilter
                                                              .mode(
                                                              AppColor
                                                                  .lightGrey,
                                                              BlendMode.srcIn),
                                                    ),
                                                    iconSize: 20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: 60,
                                                  width: 80,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          modal.image),
                                                      fit: BoxFit
                                                          .cover, // Scale the image to fit the container
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 4),
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 30,
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                SizedBox(
                                                                  // width: 220,
                                                                  child: Text(
                                                                    modal.title,
                                                                    style: TextStyle(
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 12,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    _currencyFormat(
                                                                        modal
                                                                            .sellPrice),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .green,
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  modal.discountPrice !=
                                                                          0
                                                                      ? Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(7),
                                                                            color:
                                                                                Colors.green,
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                                                                            child:
                                                                                Text(
                                                                              '- ${modal.discountPrice.toInt()}%',
                                                                              style: TextStyle(color: AppColor.white, fontSize: 8, fontWeight: FontWeight.w600),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : Container(
                                                                          height:
                                                                              0,
                                                                        ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  modal.quantity >
                                                                          1
                                                                      ? Container(
                                                                          width:
                                                                              28,
                                                                          height:
                                                                              28,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(20),
                                                                            border:
                                                                                Border.all(color: AppColor.secondary, width: 1),
                                                                          ),
                                                                          child:
                                                                              IconButton(
                                                                            icon:
                                                                                const Icon(Icons.remove),
                                                                            iconSize:
                                                                                10,
                                                                            onPressed:
                                                                                () {
                                                                              _decreaseItem(
                                                                                modal.id,
                                                                              );
                                                                            },
                                                                          ))
                                                                      : Container(
                                                                          width:
                                                                              28,
                                                                          height:
                                                                              28,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(20),
                                                                            border:
                                                                                Border.all(color: Colors.black26, width: 1),
                                                                          ),
                                                                          child:
                                                                              IconButton(
                                                                            color:
                                                                                Colors.black26,
                                                                            icon:
                                                                                const Icon(Icons.remove),
                                                                            iconSize:
                                                                                10,
                                                                            onPressed:
                                                                                () {},
                                                                          )),
                                                                  const SizedBox(
                                                                    width: 4,
                                                                  ),
                                                                  Container(
                                                                    width: 25,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Text(
                                                                      modal
                                                                          .quantity
                                                                          .toInt()
                                                                          .toString(),
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              12),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 4,
                                                                  ),
                                                                  Container(
                                                                    width: 28,
                                                                    height: 28,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20),
                                                                      border: Border.all(
                                                                          color: AppColor
                                                                              .secondary,
                                                                          width:
                                                                              1),
                                                                    ),
                                                                    child:
                                                                        IconButton(
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .add),
                                                                      iconSize:
                                                                          10,
                                                                      onPressed:
                                                                          () async {
                                                                        _increaseItem(
                                                                          modal
                                                                              .id,
                                                                        );
                                                                      },
                                                                    ),
                                                                  )
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    )
                                  ],
                                ),
                              ),
                              Divider(
                                color: AppColor.lightBlue,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          AppVector.promotionIcon,
                                          height: 18,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            minimumSize: Size.zero,
                                            padding: EdgeInsets.zero,
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                          ),
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Dialog(
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(16),
                                                      height: 300,
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                              'Mã có thể áp dụng'),
                                                          SizedBox(
                                                            height: 8,
                                                          ),
                                                          PromotionList(
                                                            shopID:
                                                                seller.sellerId,
                                                            onPromotionSelected:
                                                                (promotionName,
                                                                    promotionId,
                                                                    promoPecentDiscount) {
                                                              onpromoSelected(
                                                                  promotionId);

                                                              updateButtonText(
                                                                  seller
                                                                      .sellerId,
                                                                  promotionName,
                                                                  promoPecentDiscount); // Update the product's button text

                                                              Navigator.pop(
                                                                  context); // Close the dialog after selection
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // Text('data'),
                                                  );
                                                });
                                          },
                                          child: Text(
                                            selectedPromotionBtn,
                                            style: TextStyle(fontSize: 11),
                                          ),
                                        ),
                                      ],
                                    ),
                                    selectedPromotionDiscountBtn.toString() !=
                                            ''
                                        ? Text(
                                            '-${selectedPromotionDiscountBtn.toString()}%',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: AppColor.black,
                                                fontWeight: FontWeight.w600),
                                          )
                                        : Text(''),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              )
                            ],
                          )),
                          SizedBox(
                            height: 16,
                          )
                        ],
                      );
                    },
                  ),
                ),
                Container(
                  color: AppColor.lightBlue,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: Checkbox(
                              side: BorderSide(color: Colors.black26),
                              activeColor: AppColor.primary,
                              value: selectAll,
                              onChanged: _toggleSelectAll,
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            'Chọn tất cả',
                            style: TextStyle(
                                fontSize: 11, color: AppColor.lightGrey),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tổng: ${_currencyFormat(_calculateTotalPrice())}',
                            style: TextStyle(
                              color: AppColor.primary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: selectedItems.isNotEmpty
                                ? () {
                                    _checkout();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CheckoutPageTest(
                                            selectedItems: selectedItems),
                                      ),
                                    );
                                  }
                                : null, // Disable if no items are selected
                            child: Text(
                              'Thanh toán (${selectedItems.length})',
                              style: TextStyle(color: AppColor.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
