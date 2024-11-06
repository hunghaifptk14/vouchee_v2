import 'package:flutter/material.dart';
import 'package:vouchee/model/voucher.dart';
import 'package:vouchee/networking/api_request.dart';
import 'package:vouchee/presentation/pages/voucher/modal_list.dart';
import 'package:vouchee/presentation/widgets/buttons/cart_button.dart';

class VoucherDetailPage extends StatefulWidget {
  final Voucher voucher;

  // Constructor to pass the selected voucher to this screen
  const VoucherDetailPage({super.key, required this.voucher});

  @override
  State<VoucherDetailPage> createState() => _VoucherDetailPageState();
}

class _VoucherDetailPageState extends State<VoucherDetailPage> {
  late Future<List<Voucher>> futureVoucher;
  final GetAllVouchers apiService = GetAllVouchers();

  @override
  void initState() {
    super.initState();
    futureVoucher = apiService.fetchVouchers(); // Fetch data on init
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.voucher.title,
            style: TextStyle(fontSize: 14),
          ),
          actions: <Widget>[CartButton()],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.voucher.brandImage,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Voucher title and brand
                    Text(
                      widget.voucher.title,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                        Icon(Icons.star, color: Colors.yellow),
                        Text('${widget.voucher.rating}'),
                      ],
                    ),
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

                    // Display Addresses (if any)

                    Container(
                        child: ModalList(
                      voucherId: widget.voucher.id,
                    ))
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
