import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:vouchee/core/configs/theme/app_color.dart';
import 'package:vouchee/model/address.dart';
import 'package:vouchee/model/voucher.dart';
import 'package:vouchee/networking/api_request.dart';
import 'package:vouchee/presentation/pages/voucher/modal_list.dart';
import 'package:vouchee/presentation/widgets/snack_bar.dart';

class VoucherDetailPage extends StatefulWidget {
  final Voucher voucher;

  // Constructor to pass the selected voucher to this screen
  const VoucherDetailPage({super.key, required this.voucher});

  @override
  State<VoucherDetailPage> createState() => _VoucherDetailPageState();
}

class _VoucherDetailPageState extends State<VoucherDetailPage> {
  late Future<Voucher> futureVoucher;
  final ApiServices apiService = ApiServices();
  late Future<List<Address>> futureVouchersAddress;

  @override
  void initState() {
    super.initState();
    futureVoucher = apiService.fetchVoucherById(widget.voucher.id);
    futureVouchersAddress = apiService.fetchVoucherAddress(widget.voucher.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.voucher.title,
            style: TextStyle(fontSize: 14),
          ),
          backgroundColor: Colors.transparent,
        ),
        body: FutureBuilder<Voucher>(
            future: futureVoucher,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.modals.isEmpty) {
                return Center(child: Text('No vouchers found'));
              } else {
                Voucher voucher = snapshot.data!;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 250,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                image: DecorationImage(
                                  image: NetworkImage(widget.voucher.image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            // Voucher title and brand
                            Text(
                              widget.voucher.title,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 8),
                            Text(
                              // overflow: TextOverflow.ellipsis,
                              widget.voucher.brandName,
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(height: 8),

                            // Rating
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 14,
                                ),
                                Text('${widget.voucher.rating}'),
                              ],
                            ),
                            // HtmlElementView.fromTagName(tagName: 'p'),
                            SizedBox(height: 8),

                            // Supplier information
                            Row(
                              children: [
                                Text(
                                  'Sản phẩm: ',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 14),
                                ),
                                // Text(widget.voucher.supplierName),
                              ],
                            ),

                            SizedBox(height: 16),

                            Container(
                                child: ModalList(voucherId: widget.voucher.id)),
                            SizedBox(height: 16),

                            Html(
                              data: voucher.description,
                            ),
                            SizedBox(height: 16),
                            Text('Địa chỉ áp dụng: ',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                            SizedBox(
                              height: 8,
                            ),
                            SizedBox(height: 300, child: _getVoucherAddress()),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            }));
  }

  Widget _getVoucherAddress() {
    return FutureBuilder<List<Address>>(
        future: futureVouchersAddress,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Address> address = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: ListView.builder(
                  itemCount: address.length,
                  itemBuilder: (context, index) {
                    final voucherAddress = address[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 1,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.circle,
                                size: 6,
                                color: AppColor.lightGrey,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    // Copy the text to clipboard
                                    Clipboard.setData(ClipboardData(
                                        text: voucherAddress.name));

                                    TopSnackbar.show(context, 'Đã copy địa chỉ',
                                        backgroundColor: AppColor.success);
                                  },
                                  child: Text(
                                    voucherAddress.name,
                                    overflow: TextOverflow
                                        .ellipsis, // Ensure text doesn't overflow
                                    maxLines: 1, // Limit to 1 line
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            );
          }
        });
  }
}
