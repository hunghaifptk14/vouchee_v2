import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vouchee/core/configs/assets/app_vector.dart';
import 'package:vouchee/core/configs/theme/app_color.dart';
import 'package:vouchee/model/voucher.dart';
import 'package:vouchee/networking/api_request.dart';
import 'package:vouchee/presentation/pages/voucher/modal_detail.dart';

class ModalList extends StatefulWidget {
  // Constructor to pass the selected voucher to this screen
  final String voucherId;
  const ModalList({super.key, required this.voucherId});

  @override
  State<ModalList> createState() => _ModalListState();
}

class _ModalListState extends State<ModalList> {
  late Future<Voucher> futureVoucher;
  final ApiServices apiService = ApiServices();

  @override
  void initState() {
    super.initState();
    futureVoucher = apiService.fetchVoucherById(widget.voucherId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Voucher>(
        future: futureVoucher,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.modals.isEmpty) {
            return Center(child: Text('No vouchers found'));
          }
          Voucher voucher = snapshot.data!;
          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            // padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.86,
            ),
            itemCount: voucher.modals.length,
            itemBuilder: (context, index) {
              final modal = voucher.modals[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ModalsDetailPage(
                        modal: modal,
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: AppColor.white,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              image: DecorationImage(
                                image: NetworkImage(modal.image),
                                fit: BoxFit
                                    .cover, // Scale the image to fit the container
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              modal.title,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${modal.sellPrice.toInt()} đ',
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.green),
                                ),
                                Row(
                                  children: [
                                    SvgPicture.asset(AppVector.promotionIcon,
                                        height: 16,
                                        fit: BoxFit.cover,
                                        colorFilter: const ColorFilter.mode(
                                            AppColor.black, BlendMode.srcIn)),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      modal.stock.toInt().toString(),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColor.black,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }
}
