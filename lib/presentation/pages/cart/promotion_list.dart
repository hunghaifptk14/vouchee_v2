// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:vouchee/core/configs/theme/app_color.dart';
import 'package:vouchee/model/promotion.dart';
import 'package:vouchee/networking/api_request.dart';

class PromotionList extends StatefulWidget {
  final String shopID;
  final Function(String, String, int) onPromotionSelected;
  const PromotionList({
    super.key,
    required this.shopID,
    required this.onPromotionSelected,
  });

  @override
  State<PromotionList> createState() => _PromotionListState();
}

class _PromotionListState extends State<PromotionList> {
  late Future<List<Promotion>> futurePromotion;
  ApiServices apiServices = ApiServices();

  @override
  void initState() {
    super.initState();
    futurePromotion = apiServices.fetchPromotionByShopID(widget.shopID);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: FutureBuilder<List<Promotion>>(
          future: futurePromotion,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('No items'));
            } else {
              List<Promotion> promotion = snapshot.data!;
              return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(4.0),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final promo = promotion[index];
                    return InkWell(
                      onTap: () {
                        widget.onPromotionSelected(
                            promo.name, promo.id, promo.percentDiscount);
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            border:
                                Border.all(width: 1, color: AppColor.primary)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                promo.name,
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Số lượng',
                                        style: TextStyle(
                                            color: AppColor.lightGrey),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(promo.stock.toString()),
                                    ],
                                  ),
                                  Text(
                                    '-${promo.percentDiscount.toString()}%',
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }
          }),
    );
  }
}
