import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:vouchee/core/configs/theme/app_color.dart';
import 'package:vouchee/model/banks.dart';
import 'package:vouchee/model/user.dart';
import 'package:vouchee/networking/api_request.dart';
import 'package:vouchee/presentation/pages/profile/profile_page.dart';
import 'package:vouchee/presentation/widgets/snack_bar.dart';

class EditBank extends StatefulWidget {
  const EditBank({super.key});

  @override
  State<EditBank> createState() => _EditBankState();
}

class _EditBankState extends State<EditBank> {
  late TextEditingController accountController;
  late TextEditingController bankNameController;
  late TextEditingController numberController;
  late TextEditingController searchController;

  late Future<AppUser> currentUser;
  final ApiServices apiServices = ApiServices();
  List<Map<String, dynamic>> filteredBankList = bankList;
  String? selectedBankName;
  String? selectedBankShortName;

  @override
  void initState() {
    super.initState();
    currentUser = apiServices.getCurrentUser();
    accountController = TextEditingController();
    numberController = TextEditingController();
    searchController = TextEditingController();

    // Listen to search input changes
    searchController.addListener(() {
      setState(() {
        filteredBankList = bankList
            .where((bank) => (bank['name'] as String)
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
            .toList();
      });
    });
  }

  @override
  void dispose() {
    // Dispose of controllers to free resources
    accountController.dispose();
    numberController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cập nhật thông tin ngân hàng'),
      ),
      body: FutureBuilder<AppUser>(
        future: currentUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final user = snapshot.data!;
            accountController.text = user.bankAccount ?? "";
            numberController.text = user.bankNumber ?? "";
            // selectedBankName = user.bankName;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      labelText: 'Tìm kiếm',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Bank List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredBankList.length,
                    itemBuilder: (context, index) {
                      final bank = filteredBankList[index];
                      final bankName = bank['name'] as String;
                      final bankShortName = bank['shortName'] as String;
                      final bankLogo = bank['logo'] as String;

                      return ListTile(
                        leading: Container(
                          // width: double.infinity,
                          height: 35,
                          width: 80,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(bankLogo),
                              fit: BoxFit
                                  .fill, // Scale the image to fit the container
                            ),
                          ),
                        ),
                        title: Text(bankName),
                        trailing: selectedBankName == bankName
                            ? const Icon(Icons.check, color: Colors.green)
                            : null,
                        onTap: () {
                          setState(() {
                            selectedBankName = bankName;
                            selectedBankShortName = bankShortName;
                            searchController.text = bankName;
                          });
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: accountController,
                    decoration:
                        const InputDecoration(labelText: 'Tên tài khoản'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: numberController,
                    decoration:
                        const InputDecoration(labelText: 'Số tài khoản'),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Center(
                    child: Text(
                      'Vui lòng kiểm tra thông tin bằng cách tải mã QR và quét mã.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColor.warning,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Center(
                    child: SizedBox(
                      height: 240,
                      width: 240,
                      child: numberController.text == null &&
                              selectedBankShortName == null
                          ? Image.network(
                              'https://qr.sepay.vn/img?acc=${numberController.text}&bank=$selectedBankShortName&template=TEMPLATE',
                            )
                          : Image.network(
                              'https://qr.sepay.vn/img?acc=0000321753575&bank=MBBank&template=TEMPLATE',
                            ),
                    ),
                  ),

                  Center(
                    child: TextButton(
                      onPressed: () async {
                        final path = '${Directory.systemTemp.path}/QR-code.jpg';
                        await Dio().download(
                          'https://qr.sepay.vn/img?acc=${numberController.text}&bank=$selectedBankShortName&template=TEMPLATE',
                          path,
                        );
                        await Gal.putImage(path);
                        TopSnackbar.show(context, 'Đã tải ảnh',
                            backgroundColor: AppColor.success);
                      },
                      child: SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.download_outlined,
                              color: AppColor.lightGrey,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Tải ảnh',
                              style: TextStyle(
                                color: AppColor.lightGrey,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final bankName = selectedBankName;
                        final bankAccount = accountController.text;
                        final bankNumber = numberController.text;
                        print('Bank selected: $selectedBankName');
                        print('Bank selected: $bankName');
                        if (bankName != null &&
                            bankAccount.isNotEmpty &&
                            bankNumber.isNotEmpty) {
                          try {
                            await apiServices.updateBuyerBank(
                                bankAccount, bankName, bankNumber);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ProfilePage()));
                            // Close the page on success
                          } catch (error) {
                            TopSnackbar.show(
                                context, 'Xảy ra lỗi khi cập nhật thông tin',
                                backgroundColor: AppColor.warning);
                          }
                        } else {
                          TopSnackbar.show(
                              context, 'Vui lòng điền đủ thông tin',
                              backgroundColor: AppColor.warning);
                        }
                      },
                      child: const Text(
                        'Cập nhật thông tin',
                        style: TextStyle(color: AppColor.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Không tìm thấy thông tin'));
          }
        },
      ),
    );
  }
}
