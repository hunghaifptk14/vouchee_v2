// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vouchee/core/configs/assets/app_image.dart';
import 'package:vouchee/core/configs/assets/app_vector.dart';
import 'package:vouchee/core/configs/theme/app_color.dart';
import 'package:vouchee/model/voucher.dart';
import 'package:vouchee/networking/api_request.dart';
import 'package:vouchee/presentation/pages/category/category_list.dart';
import 'package:vouchee/presentation/pages/homePage/user_name.dart';
import 'package:vouchee/presentation/pages/voucher/voucher_detail.dart';
import 'package:vouchee/presentation/pages/voucher/voucher_list.dart';
import 'package:vouchee/presentation/pages/wallet/wallet_bar.dart';
import 'package:vouchee/presentation/widgets/bottomNav/bottom_app_bar.dart';

class HomePage extends StatefulWidget {
  // final User? user;
  const HomePage({
    super.key,
    // this.user,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSearching = false;
  late Future<List<Voucher>> futureUsers;
  ApiServices apiServices = ApiServices();
  List<Voucher> _users = [];
  List<Voucher> _filteredUsers = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    futureUsers = apiServices.fetchVouchers();
  }

  void _filterUsers(String query) {
    setState(() {
      _searchQuery = query;
      _filteredUsers = _users
          .where(
              (user) => user.title.toLowerCase().contains(query.toLowerCase()))
          .toList();

      _isSearching = query.isNotEmpty; // Show popup when query is not empty
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomAppBarcustom(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  stops: [0, 1],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color.fromARGB(0, 255, 255, 255),
                    const Color.fromARGB(125, 206, 237, 252)
                  ],
                ),
              ),
              height: 180,
              width: double.infinity,
              child: Column(
                children: [
                  Expanded(
                    // width: double.infinity,
                    child: Opacity(
                        opacity: 0.1,
                        child: Image.asset(
                          AppImage.foodBanner,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )),
                  ),
                  Container(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [Text('Xin chào!'), UserInfo()],
                              ),
                              Stack(
                                children: [
                                  SizedBox(
                                    child: IconButton(
                                        onPressed: () {},
                                        icon: SvgPicture.asset(
                                            AppVector.notificationIcon)),
                                  ),
                                  Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Container(
                                        height: 15,
                                        width: 15,
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Center(
                                            child: Text(
                                              '4',
                                              style: TextStyle(
                                                  fontSize: 8,
                                                  color: AppColor.white,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ),
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ),
                        WalletBar(),
                      ],
                    ),
                  ),
                ],
              ),
              // fit: BoxFit.cover,
            ),
            Container(
              height: 30,
              color: const Color.fromARGB(125, 206, 237, 252),
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                    color: AppColor.theme,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GestureDetector(
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          setState(() {
                            _isSearching =
                                true; // Show results when the TextField is tapped
                          });
                        },
                        child: TextField(
                          onChanged:
                              _filterUsers, // Trigger filtering when text changes
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                                color: AppColor.lightGrey,
                                fontSize: 14,
                                fontWeight: FontWeight.normal),
                            hintText: "Tìm voucher",
                            prefixIcon: Icon(
                              Icons.search,
                              size: 24,
                            ),
                            // border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),

                    // Show search results below the TextField if any
                    if (_isSearching && _filteredUsers.isNotEmpty) ...[
                      Container(
                        color: Colors.white,
                        width: double.infinity,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _filteredUsers.length,
                          itemBuilder: (context, index) {
                            final voucher = _filteredUsers[index];
                            return ListTile(
                              title: Text(voucher.title),
                              onTap: () {
                                // When a user selects a result, set the TextField's text to that voucher's title
                                setState(() {
                                  _searchQuery = voucher.title;
                                  _isSearching =
                                      false; // Hide results after selection
                                });
                                // Optionally navigate to voucher details page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        VoucherDetailPage(voucher: voucher),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ] else if (_isSearching && _filteredUsers.isEmpty) ...[
                      // Show 'No Results' if there are no matches
                      Container(
                        color: Colors.white,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Không tìm thấy voucher."),
                        ),
                      ),
                    ],
                    _searchData()
                  ],
                ),
                const SizedBox(height: 16),

                // "Khám phá" Section Title
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Khám phá',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, left: 16),
                  child: CategoryList(),
                ),

                // const SizedBox(height: 16),
                // Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 16),
                //     child: SlideShow()),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Giành cho bạn',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                SizedBox(child: VoucherList()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchData() {
    return
        // FutureBuilder to fetch and display user list
        Positioned(
      top: 80,
      bottom: 0,
      left: 0,
      child: SizedBox(
        height: 250,
        child: FutureBuilder<List<Voucher>>(
          future: futureUsers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Lỗi: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Không tìm thấy voucher.'));
            } else {
              // Set the full list of vouchers if it's the first load
              if (_users.isEmpty) {
                _users = snapshot.data!;
                // To avoid calling setState during build, use addPostFrameCallback to update the state
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _filterUsers(
                        _searchQuery); // Apply current query for filtering
                  });
                });
              }

              return Container(); // You can add the main content here
            }
          },
        ),
      ),
    );
  }
}
