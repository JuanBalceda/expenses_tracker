import 'package:expenses_tracker/models/transaction.dart';
import 'package:expenses_tracker/widgets/chart.dart';
import 'package:expenses_tracker/widgets/new_transaction.dart';
import 'package:expenses_tracker/widgets/transaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(ExpensesTrackerApp());

class ExpensesTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var title = 'Expenses Tracker';
    var platForm = Theme.of(context).platform;
    var isIOS = platForm == TargetPlatform.iOS;

    return isIOS
        ? CupertinoApp(
            debugShowCheckedModeBanner: false,
            title: title,
            theme: CupertinoThemeData(
              primaryColor: Colors.purple,
              primaryContrastingColor: Colors.amber,
            ),
            home: HomePage(),
          )
        : MaterialApp(
            debugShowCheckedModeBanner: false,
            title: title,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              accentColor: Colors.pink,
              fontFamily: 'QuickSand',
              textTheme: ThemeData.light().textTheme.copyWith(
                    headline6: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 20,
                    ),
                  ),
              appBarTheme: AppBarTheme(
                textTheme: ThemeData.light().textTheme.copyWith(
                      headline6: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 20,
                      ),
                    ),
              ),
            ),
            home: HomePage(),
          );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Transaction> _userTransactions = [];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(String txTitle, double txAmount, DateTime txDate) {
    final newTx = Transaction(
      id: _userTransactions.length.toString(),
      title: txTitle,
      amount: txAmount,
      date: txDate,
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startNewTransaction(BuildContext ctx) {
    var platForm = Theme.of(context).platform;
    var isIOS = platForm == TargetPlatform.iOS;

    var builder = (_) => NewTransaction(_addNewTransaction);

    if (isIOS) {
      showCupertinoDialog(
        context: ctx,
        builder: builder,
      );
    } else {
      showModalBottomSheet(
        context: ctx,
        builder: builder,
      );
    }
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    var platForm = Theme.of(context).platform;
    var isIOS = platForm == TargetPlatform.iOS;

    return isIOS
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text('Expenses Tracker'),
              trailing: CupertinoButton(
                onPressed: () => _startNewTransaction(context),
                child: Icon(CupertinoIcons.add),
                padding: EdgeInsets.all(0),
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Chart(_recentTransactions),
                    TransactionList(_userTransactions, _deleteTransaction),
                  ],
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('Expenses Tracker'),
              actions: [
                Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => _startNewTransaction(context),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Chart(_recentTransactions),
                  TransactionList(_userTransactions, _deleteTransaction),
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Builder(
              builder: (context) => FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () => _startNewTransaction(context),
              ),
            ),
          );
  }
}
