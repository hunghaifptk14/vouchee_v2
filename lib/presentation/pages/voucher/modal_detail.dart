// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:vouchee/core/configs/assets/app_vector.dart';

import 'package:vouchee/core/configs/theme/app_color.dart';
import 'package:vouchee/model/modal.dart';
import 'package:vouchee/networking/api_request.dart';
import 'package:vouchee/presentation/pages/cart/cart_list.dart';
import 'package:vouchee/presentation/widgets/snack_bar.dart';

class ModalsDetailPage extends StatefulWidget {
  // final Voucher voucher;
  final Modal modal;
  const ModalsDetailPage({
    super.key,
    // required this.voucher,
    required this.modal,
  });

  @override
  State<ModalsDetailPage> createState() => _ModalsDetailPageState();
}

class _ModalsDetailPageState extends State<ModalsDetailPage> {
  final ApiServices cartService = ApiServices();
  late Future<List<Modal>> futureModal;
  final ApiServices apiService = ApiServices();

  @override
  void initState() {
    super.initState();
    futureModal = apiService.fetchModal(); // Fetch data on init
  }

  String _DateTimeformat(String dateString) {
    try {
      DateTime parsedDate = DateTime.parse(dateString);

      String formattedDate =
          DateFormat('HH:mm - dd/MM/yyyy').format(parsedDate);

      return formattedDate;
    } catch (e) {
      // Handle parsing errors
      return "Lỗi thông tin";
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

  Future<void> _addToCart(String modalId) async {
    bool success = await cartService.addToCart(modalId);
    if (success) {
      TopSnackbar.show(context, 'Đã thêm voucher vào giỏ hàng',
          backgroundColor: AppColor.success);
    } else {
      TopSnackbar.show(context, 'Không thêm được voucher',
          backgroundColor: AppColor.warning);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('Thông tin voucher'),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const CartPage()));
              },
              icon: SvgPicture.asset(
                AppVector.cartIcon,
                height: 22,
                fit: BoxFit.cover,
                colorFilter:
                    const ColorFilter.mode(AppColor.black, BlendMode.srcIn),
              ),
              iconSize: 22,
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: widget.modal.image.isNotEmpty
                      ? Image.network(
                          widget.modal.image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 250,
                        )
                      : Placeholder(fallbackHeight: 250, fallbackWidth: 100),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.modal.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      _currencyFormat(widget.modal.sellPrice),
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        const Text(
                          'Ngày hết hạn: ',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColor.grey,
                          ),
                        ),
                        Text(
                          widget.modal.endDate.toString(),
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),

                    // Text(widget.voucher.description.toString()),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Số lượng còn lại:',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColor.grey,
                            )),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          widget.modal.stock.toInt().toString(),
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          widget.modal.stock.toInt() == 0
                              ? ElevatedButton(
                                  onPressed: null,
                                  child: Text(
                                    'Thêm vào giỏ',
                                    style: TextStyle(
                                        color: AppColor.secondary,
                                        fontSize: 14),
                                  ),
                                )
                              : OutlinedButton(
                                  onPressed: () {
                                    _addToCart(widget.modal.id);
                                    print(widget.modal.stock.toInt());
                                  },
                                  style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14)),
                                      side: const BorderSide(
                                        width: 2.0,
                                        color: AppColor.primary,
                                      )),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 8),
                                    child: Text(
                                      'Thêm vào giỏ',
                                      style: TextStyle(
                                          color: AppColor.secondary,
                                          fontSize: 14),
                                    ),
                                  )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                  ],
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 16),
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: [
              //       ...widget.modal.ratings.map((rating) => Column(
              //             children: [
              //               SizedBox(
              //                 width: double.infinity,
              //                 child: Card(
              //                   margin: EdgeInsets.all(8),
              //                   child: Padding(
              //                     padding: const EdgeInsets.all(16.0),
              //                     child: Column(
              //                       crossAxisAlignment:
              //                           CrossAxisAlignment.start,
              //                       children: [
              //                         // Rating Stars
              //                         Row(
              //                           children: [
              //                             Icon(
              //                               Icons.star,
              //                               color: Colors.amber,
              //                               size: 20,
              //                             ),
              //                             SizedBox(width: 10),
              //                             Text("${rating.totalStar}",
              //                                 style: TextStyle(fontSize: 16)),
              //                           ],
              //                         ),
              //                         const SizedBox(height: 10),

              //                         // Sub-ratings (Quality, Service, Seller)

              //                         const SizedBox(height: 10),

              //                         // Comment Text
              //                         Text("Bình luận: ${rating.comment}",
              //                             style: TextStyle(fontSize: 14)),
              //                         const SizedBox(height: 10),

              //                         // Media (if any)
              //                         // if (rating.medias != null &&
              //                         //     rating.medias!.isNotEmpty)
              //                         //   Column(
              //                         //     children: rating.medias!.map((media) {
              //                         //       return Padding(
              //                         //         padding: const EdgeInsets.only(
              //                         //             bottom: 8.0),
              //                         //         child: Image.network(media.url),
              //                         //       );
              //                         //     }).toList(),
              //                         //   ),
              //                         // const SizedBox(height: 10),

              //                         // Created Date
              //                         Text(
              //                           _DateTimeformat(
              //                               rating.createDate.toString()),
              //                           style: TextStyle(color: Colors.grey),
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //                 ),
              //               )
              //             ],
              //           )),
              //     ],
              //   ),
              // )
            ],
          ),
        ));
  }
}
