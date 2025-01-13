// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:vouchee/core/configs/theme/app_color.dart';

import 'package:vouchee/model/rating.dart';
import 'package:vouchee/networking/api_request.dart';
import 'package:vouchee/presentation/pages/purchased/Purchased_voucher.dart';
import 'package:vouchee/presentation/widgets/snack_bar.dart';

class RatingVoucherPage extends StatefulWidget {
  final String orderId;
  final String modalId;

  const RatingVoucherPage({
    super.key,
    required this.orderId,
    required this.modalId,
  });
  @override
  _RatingVoucherPageState createState() => _RatingVoucherPageState();
}

class _RatingVoucherPageState extends State<RatingVoucherPage> {
  ApiServices apiServices = ApiServices();
  int qualityStar = 0;
  int serviceStar = 0;
  int sellerStar = 0;
  String comment = '';
  final TextEditingController commentController = TextEditingController();

  Future<void> _submitRating() async {
    // Collect data for submission
    Rating rating = Rating(
      orderId: widget.orderId,
      modalId: widget.modalId,
      // medias: [Media(url: "string")],
      qualityStar: qualityStar,
      serviceStar: serviceStar,
      sellerStar: sellerStar,
      comment: commentController.text,
    );

    // Call API
    bool success = await apiServices.updateRating(rating);

    if (success) {
      print('object');
      TopSnackbar.show(context, 'Tạo rating thành công',
          backgroundColor: AppColor.success);
    } else {
      TopSnackbar.show(context, 'Lỗi khi đánh giá',
          backgroundColor: AppColor.warning);
    }
  }

  Widget _buildStarRating(
      String label, int currentRating, Function(int) onRatingChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 18)),
        Row(
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(
                Icons.star,
                color: index < currentRating ? Colors.orange : Colors.grey,
              ),
              onPressed: () => onRatingChanged(index + 1),
            );
          }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Đánh giá voucher"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStarRating("Chất lượng voucher", qualityStar, (rating) {
                setState(() => qualityStar = rating);
              }),
              _buildStarRating("Dịch vụ", serviceStar, (rating) {
                setState(() => serviceStar = rating);
              }),
              _buildStarRating("Đánh giá người bán", sellerStar, (rating) {
                setState(() => sellerStar = rating);
              }),
              TextField(
                controller: commentController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Nhận xét của bạn",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    comment = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  _submitRating;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const PurchedVoucher()));
                },
                child: Text("Hoàn tất"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
