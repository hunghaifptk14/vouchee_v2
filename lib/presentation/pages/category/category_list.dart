import 'package:flutter/material.dart';
import 'package:vouchee/core/configs/theme/app_color.dart';
import 'package:vouchee/model/category.dart';
import 'package:vouchee/networking/api_request.dart';
import 'package:vouchee/presentation/pages/category/category_detail.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override
  void initState() {
    super.initState();
    futureCategory = apiService.fetchCategory(); // Fetch data on init
  }

  late Future<List<Category>> futureCategory;
  final ApiServices apiService = ApiServices();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: futureCategory,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No categories found'));
        }

        List<Category> categories = snapshot.data!;

        return SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            // itemCount: categories.length > 6 ? 6 : categories.length,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];

              return Wrap(spacing: 4, children: [
                InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryDetail(
                            category: category,
                          ),
                        ),
                      );
                    },
                    child:
                        // Padding(
                        //   padding: const EdgeInsets.only(right: 8),
                        //   child: Container(
                        //     width: 80,
                        //     height: 80,
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(14),
                        //       color: AppColor.white,
                        //     ),
                        //     child: Padding(
                        //       padding: EdgeInsets.all(8),
                        //       child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.center,
                        //         mainAxisAlignment: MainAxisAlignment.start,
                        //         children: [
                        //           Padding(
                        //             padding: const EdgeInsets.all(0.0),
                        //             child: ClipRRect(
                        //               borderRadius: BorderRadius.circular(12),
                        //               child: SvgPicture.network(
                        //                 category.image,
                        //                 fit: BoxFit.cover,
                        //                 height: 32,
                        //                 width: 32,
                        //               ),
                        //             ),
                        //           ),
                        //           Padding(
                        //             padding: const EdgeInsets.only(top: 4.0),
                        //             child: Text(
                        //               category.title,
                        //               overflow: TextOverflow.clip,
                        //               textAlign: TextAlign.center,
                        //               style: const TextStyle(
                        //                 fontSize: 8,
                        //                 fontWeight: FontWeight.w500,
                        //               ),
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColor.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                width: 0.2, color: AppColor.lightGrey)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: Text(
                            category.title,
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    )),
              ]);
            },
          ),
        );
      },
    );
  }
}
