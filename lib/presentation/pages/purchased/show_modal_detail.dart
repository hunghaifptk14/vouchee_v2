import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vouchee/core/configs/theme/app_color.dart';
import 'package:vouchee/model/modal.dart';
import 'package:vouchee/networking/api_request.dart';

class ShowModalDetail extends StatefulWidget {
  final String modalId;
  const ShowModalDetail({
    Key? key,
    required this.modalId,
  }) : super(key: key);

  @override
  State<ShowModalDetail> createState() => _ShowModalDetailState();
}

class _ShowModalDetailState extends State<ShowModalDetail> {
  final ApiServices apiServices = ApiServices();
  late Future<Modal>
      futureModal; // Change to Modal, as you're expecting a single modal.

  @override
  void initState() {
    super.initState();
    futureModal =
        apiServices.fetchModalById(widget.modalId); // Fetch data on init
  }

  String _currencyFormat(double amount) {
    String format = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0, // No decimal digits
    ).format(amount);
    return format;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Thông tin voucher'),
      ),
      body: FutureBuilder<Modal>(
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
                        : Placeholder(fallbackHeight: 250, fallbackWidth: 100),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        modal.title.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        _currencyFormat(modal.sellPrice.toDouble()),
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
                            modal.endDate.toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Số lượng còn lại:',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColor.grey,
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            modal.stock.toString(),
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
