import 'package:flutter/material.dart';
import 'package:vouchee/model/voucher.dart';

class VoucherSearchDelegate extends SearchDelegate<Voucher> {
  final List<Voucher> allVouchers;
  final Function(Voucher) onVoucherSelected;

  VoucherSearchDelegate(
      {required this.allVouchers, required this.onVoucherSelected});

  @override
  List<Widget> buildActions(BuildContext context) {
    // Actions for the AppBar (clear search text)
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Leading icon (Back button)
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        // close(context, null); // Close search
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Build the search results
    List<Voucher> searchResults = allVouchers.where((voucher) {
      return voucher.title.toLowerCase().contains(query.toLowerCase()) ||
          voucher.brandName.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        Voucher voucher = searchResults[index];
        return ListTile(
          leading: Image.network(voucher.brandImage),
          title: Text(voucher.title),
          subtitle: Text(voucher.brandName),
          trailing: Text('Rating: ${voucher.rating}'),
          onTap: () {
            onVoucherSelected(voucher);
            close(context,
                voucher); // Close the search and return the selected voucher
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show suggestions as the user types
    List<Voucher> suggestions = allVouchers.where((voucher) {
      return voucher.title.toLowerCase().contains(query.toLowerCase()) ||
          voucher.brandName.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        Voucher voucher = suggestions[index];
        return ListTile(
          leading: Image.network(voucher.brandImage),
          title: Text(voucher.title),
          subtitle: Text(voucher.brandName),
          trailing: Text('Rating: ${voucher.rating}'),
          onTap: () {
            onVoucherSelected(voucher);
            close(context,
                voucher); // Close the search and return the selected voucher
          },
        );
      },
    );
  }
}
