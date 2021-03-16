import 'package:expenses_tracker/models/transaction.dart';
import 'package:expenses_tracker/widgets/transaction_list_item.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction;
  TransactionList(this.transactions, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: transactions.isEmpty
          ? Column(
              children: [
                Text(
                  'No transactions added yet',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 200,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            )
          : ListView.builder(
              itemBuilder: (ctx, i) {
                return TransactionListItem(transactions[i], deleteTransaction);
              },
              itemCount: transactions.length,
              // children: transactions.map((tx) => TransactionListItem(tx)).toList(),
            ),
    );
  }
}
