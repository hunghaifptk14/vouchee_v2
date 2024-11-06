import 'package:flutter/material.dart';
import 'package:vouchee/model/voucher.dart';
import 'package:vouchee/networking/api_request.dart';
import 'package:vouchee/presentation/pages/voucher/voucher_detail.dart';

class SearchBarCustom extends StatefulWidget {
  const SearchBarCustom({super.key});

  @override
  _SearchBarCustomState createState() => _SearchBarCustomState();
}

class _SearchBarCustomState extends State<SearchBarCustom> {
  late Future<List<Voucher>> futureVouchers;
  List<Voucher> allVouchers = []; // All vouchers from the API
  List<Voucher> filteredVouchers = []; // Vouchers to be displayed (filtered)
  final GetAllVouchers apiService =
      GetAllVouchers(); // Initialize the API service
  String searchQuery = ''; // Store the current search query

  @override
  void initState() {
    super.initState();
    futureVouchers = apiService.fetchVouchers(); // Fetch data on init
    futureVouchers.then((vouchers) {
      setState(() {
        allVouchers = vouchers;
        filteredVouchers = vouchers; // Initially, show all vouchers
      });
    });
  }

  // Function to filter vouchers based on search query
  void filterVouchers(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        // If search is empty, show all vouchers
        filteredVouchers = allVouchers;
      } else {
        // Filter vouchers based on title or brandName
        filteredVouchers = allVouchers.where((voucher) {
          return voucher.title.toLowerCase().contains(query.toLowerCase()) ||
              voucher.brandName.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar to filter vouchers
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (value) {
              filterVouchers(value); // Call filter function on input change
            },
            decoration: InputDecoration(
              labelText: 'Search Vouchers',
              hintText: 'Enter voucher title or brand name',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Voucher>>(
            future: futureVouchers,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No vouchers found'));
              }

              // If data is successfully fetched
              return ListView.builder(
                itemCount: filteredVouchers.length,
                itemBuilder: (context, index) {
                  Voucher voucher = filteredVouchers[index];
                  return ListTile(
                    leading: Image.network(voucher.brandImage),
                    title: Text(voucher.title),
                    subtitle: Text(voucher.brandName),
                    trailing: Text('Rating: ${voucher.rating}'),
                    onTap: () {
                      // Navigate to VoucherDetailPage on tap
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
              );
            },
          ),
        ),
      ],
    );
  }
}
