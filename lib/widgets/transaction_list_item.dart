import 'package:expenses_tracker/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionListItem extends StatelessWidget {
  final Transaction _transaction;
  final Function deleteTransaction;

  TransactionListItem(this._transaction, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: EdgeInsets.all(6),
            child: FittedBox(
              child: Text('\$${_transaction.amount.toStringAsFixed(2)}'),
            ),
          ),
        ),
        title: Text(
          _transaction.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          DateFormat.yMMMMd().format(_transaction.date),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          color: Colors.red,
          onPressed: () => deleteTransaction(_transaction.id),
        ),
      ),
    );
  }
}
