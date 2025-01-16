import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:vouchee/core/configs/theme/app_color.dart';
import 'package:vouchee/model/modal.dart';
import 'package:vouchee/model/voucher.dart';
import 'package:vouchee/networking/api_request.dart';

class ShowModalDetail extends StatefulWidget {
  final String modalId;
  const ShowModalDetail({
    super.key,
    required this.modalId,
  });

  @override
  State<ShowModalDetail> createState() => _ShowModalDetailState();
}

class _ShowModalDetailState extends State<ShowModalDetail> {
  final ApiServices apiServices = ApiServices();
  late Future<Modal> futureModal;
  late Future<Voucher>? futureVoucher; // Make this nullable
  String? voucherId; // State variable to hold the voucherId

  @override
  void initState() {
    super.initState();
    futureModal =
        apiServices.fetchModalById(widget.modalId); // Fetch modal data
    futureVoucher = null; // Initially, set to null
  }

  // Method to format currency
  String _currencyFormat(double amount) {
    String format = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0, // No decimal digits
    ).format(amount);
    return format;
  }

  // Method to trigger the voucher fetch once the modal data is fetched
  void _fetchVoucher(String voucherId) {
    setState(() {
      futureVoucher =
          apiServices.fetchVoucherById(voucherId); // Fetch voucher data
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Thông tin voucher'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<Modal>(
              future: futureModal,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return Center(child: Text('No items'));
                } else {
                  Modal modal = snapshot.data!; // Access the modal directly

                  // Use PostFrameCallback to update state after the build phase
                  if (voucherId == null && modal.voucherId.isNotEmpty) {
                    // Ensure this is only called once after the widget has been built
                    Future.delayed(Duration.zero, () {
                      setState(() {
                        voucherId = modal.voucherId; // Store voucherId
                        futureVoucher = apiServices
                            .fetchVoucherById(voucherId!); // Fetch voucher data
                      });
                    });
                  }

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: modal.image.isNotEmpty
                              ? Image.network(
                                  modal.image,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 250,
                                )
                              : Placeholder(
                                  fallbackHeight: 250, fallbackWidth: 100),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              modal.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              _currencyFormat(modal.sellPrice),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
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
                                  modal.endDate,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            // Display voucher info after fetching
                            if (futureVoucher !=
                                null) // Check if futureVoucher is not null
                              FutureBuilder<Voucher>(
                                future: futureVoucher,
                                builder: (context, voucherSnapshot) {
                                  if (voucherSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else if (voucherSnapshot.hasError) {
                                    return Center(
                                        child: Text(
                                            'Error: ${voucherSnapshot.error}'));
                                  } else if (!voucherSnapshot.hasData) {
                                    return Center(
                                        child:
                                            Text('No voucher data available'));
                                  } else {
                                    Voucher voucher = voucherSnapshot.data!;
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Html(
                                          data: voucher.description,
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
