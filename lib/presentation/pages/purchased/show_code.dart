// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sử dụng voucher'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Display QR Code and barcode at the top
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Center(
                          child: QrImageView(
                            data: widget.newCode,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Display Barcode using barcode_flutter
                    SizedBox(
                      width: 300,
                      height: 80,
                      child: BarcodeWidget(
                        barcode: Barcode.code128(), // Barcode type and settings
                        data: widget.newCode, // Content
                        width: 300,
                        height: 80,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Display voucher code (optional)
                    Center(
                      child: Column(
                        children: [
                          Center(
                            child: TextButton(
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
                              child: const Text(
                                "Copy mã code",
                                style: TextStyle(color: AppColor.middleBue),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(), // This will push the following buttons to the bottom
            // Buttons are aligned to the bottom
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColor.warning,
                    side: BorderSide(
                        color: AppColor.warning,
                        width: 2), // Text color (same as border color)
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          8), // Rounded corners (optional)
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outlined, color: AppColor.warning),
                      SizedBox(width: 8),
                      Text(
                        'Báo lỗi voucher',
                        style: TextStyle(color: AppColor.warning, fontSize: 11),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
