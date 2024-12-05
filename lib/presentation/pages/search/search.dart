import 'package:flutter/material.dart';
import 'package:vouchee/model/voucher.dart';
import 'package:vouchee/networking/api_request.dart'; // Assuming you have this file to fetch data

class SearchBarWithClear extends StatefulWidget {
  const SearchBarWithClear({super.key});

  @override
  _SearchBarWithClearState createState() => _SearchBarWithClearState();
}

class _SearchBarWithClearState extends State<SearchBarWithClear> {
  final TextEditingController _controller = TextEditingController();
  String searchQuery = '';
  List<Voucher> allVouchers = []; // Assuming your Voucher class is available
  List<Voucher> filteredVouchers = []; // The filtered list for display
  final ApiServices apiService =
      ApiServices(); // Assuming ApiServices handles fetching data

  @override
  void initState() {
    super.initState();
    _fetchVouchers();
  }

  // Fetch vouchers from the API
  Future<void> _fetchVouchers() async {
    try {
      final vouchers = await apiService.fetchVouchers(); // Fetch all vouchers
      setState(() {
        allVouchers = vouchers;
        filteredVouchers = vouchers; // Initially, show all vouchers
      });
    } catch (e) {
      print('Error fetching vouchers: $e');
    }
  }

  // Function to filter vouchers based on the search query
  void _search(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredVouchers =
            allVouchers; // Show all vouchers if the search query is empty
      } else {
        // Filter vouchers based on title or brand name
        filteredVouchers = allVouchers.where((voucher) {
          return voucher.title.toLowerCase().contains(query.toLowerCase()) ||
              voucher.brandName.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                flex: 1,
                child: TextField(
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none),
                      hintText: 'Search',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                      prefixIcon: Container(
                        padding: EdgeInsets.all(15),
                        width: 18,
                        child: Image.asset('assets/icons/search.png'),
                      )),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 10),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(15)),
                  width: 25,
                  child: Image.asset('assets/icons/filter.png')),
            ],
          )
        ],
      ),
    );
  }
}
