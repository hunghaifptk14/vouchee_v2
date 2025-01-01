import 'package:flutter/material.dart';
import 'package:vouchee/model/voucher.dart';
import 'package:vouchee/networking/api_request.dart';
import 'package:vouchee/presentation/pages/voucher/voucher_detail.dart';

class UserSearchPage extends StatefulWidget {
  const UserSearchPage({super.key});

  @override
  _UserSearchPageState createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> {
  late Future<List<Voucher>> futureUsers;
  ApiServices apiServices = ApiServices();
  List<Voucher> _users = [];
  List<Voucher> _filteredUsers = [];
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    futureUsers = apiServices.fetchVouchers();
  }

  // Method to filter the user list based on search query
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
    return SizedBox(
      height: 90,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            // Search TextField
            GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                setState(() {
                  _isSearching =
                      true; // Show results when the TextField is tapped
                });
              },
              child: TextField(
                onChanged: _filterUsers, // Trigger filtering when text changes
                decoration: InputDecoration(
                  hintText: "Enter title to search",
                  prefixIcon: Icon(Icons.search),
                  // border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 16),

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
                          _isSearching = false; // Hide results after selection
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
                  child: Text("No results found."),
                ),
              ),
            ],

            // FutureBuilder to fetch and display user list
            Positioned(
              top: 100,
              left: 0,
              child: SizedBox(
                height: 250,
                child: FutureBuilder<List<Voucher>>(
                  future: futureUsers,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('Không có voucher nào.'));
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
            ),
          ],
        ),
      ),
    );
  }
}
