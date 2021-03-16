import 'package:expenses_tracker/models/transaction.dart';
import 'package:expenses_tracker/widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      var totalSum = 0.0;
      for (var i = 0; i < recentTransactions.length; i++) {
        var transaction = recentTransactions[i];
        var transactionDate = transaction.date;
        if (transactionDate.day == weekDay.day &&
            transactionDate.month == weekDay.month &&
            transactionDate.year == weekDay.year) {
          totalSum += transaction.amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay), //.substring(0, 1),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get maxSpending {
    return groupedTransactionValues.fold(
        0.0, (sum, item) => sum + (item['amount'] as double));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((data) {
            double amount = (data['amount'] as double);
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                data['day'] as String,
                amount,
                maxSpending == 0.0 ? 0 : amount / maxSpending,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
