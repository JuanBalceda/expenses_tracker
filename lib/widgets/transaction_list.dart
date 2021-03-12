import 'package:expenses_tracker/models/transaction.dart';
import 'package:expenses_tracker/widgets/transaction_list_item.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  TransactionList(this.transactions);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView.builder(
        itemBuilder: (ctx, i) {
          return TransactionListItem(transactions[i]);
        },
        itemCount: transactions.length,
        // children: transactions.map((tx) => TransactionListItem(tx)).toList(),
      ),
    );
  }
}
