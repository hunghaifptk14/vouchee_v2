import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:vouchee/core/configs/theme/app_color.dart';
import 'package:vouchee/presentation/pages/purchased/refund.dart';
import 'package:vouchee/presentation/widgets/snack_bar.dart';

class ShowCodePage extends StatefulWidget {
  final String title;
  final String date;
  final String newCode;
  final String voucherCodeId;

  const ShowCodePage({
    super.key,
    required this.title,
    required this.date,
    required this.newCode,
    required this.voucherCodeId,
  });

  @override
  State<ShowCodePage> createState() => _ShowCodePageState();
}

class _ShowCodePageState extends State<ShowCodePage> {
  // Simulate loading process for QR generation
  late Future<void> _qrGenerationFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the "QR code generation" process (simulated)
    _qrGenerationFuture = _generateQrCode();
  }

  // Simulate QR code generation (you can replace this with actual async logic)
  Future<void> _generateQrCode() async {
    // Simulating a delay for QR code generation
    await Future.delayed(Duration(seconds: 2)); // Simulate loading time
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sử dụng voucher'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<void>(
          future: _qrGenerationFuture, // Pass the future here
          builder: (context, snapshot) {
            // Check the connection state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child:
                      CircularProgressIndicator()); // Show loading spinner while QR code is being generated
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Something went wrong: ${snapshot.error}'));
            } else {
              // When future is completed, show the actual content
              return Column(
                children: [
                  Card(
                    color: AppColor.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          Text('HSD: ${widget.date}'),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                color: AppColor.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Center(
                                child: QrImageView(
                                  data: widget.newCode,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: 300,
                            height: 80,
                            child: BarcodeWidget(
                              barcode: Barcode.code128(),
                              data: widget.newCode,
                              width: 300,
                              height: 80,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: Column(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Clipboard.setData(
                                        ClipboardData(text: widget.newCode));
                                    widget.newCode != ''
                                        ? TopSnackbar.show(
                                            context, 'Đã copy mã code',
                                            backgroundColor: AppColor.success)
                                        : TopSnackbar.show(context,
                                            'Đã xảy ra lỗi khi copy mã code',
                                            backgroundColor: AppColor.warning);
                                  },
                                  child: const Text("Copy mã code",
                                      style:
                                          TextStyle(color: AppColor.middleBue)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColor.warning,
                        side: BorderSide(color: AppColor.warning, width: 2),
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                RefundPage(voucherCodeId: widget.voucherCodeId),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outlined, color: AppColor.warning),
                          SizedBox(width: 8),
                          Text(
                            'Báo lỗi voucher',
                            style: TextStyle(
                                color: AppColor.warning, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
