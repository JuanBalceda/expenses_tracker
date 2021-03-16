import 'package:expenses_tracker/models/transaction.dart';
import 'package:expenses_tracker/widgets/chart.dart';
import 'package:expenses_tracker/widgets/new_transaction.dart';
import 'package:expenses_tracker/widgets/transaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(ExpensesTrackerApp());
}

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
  bool _showChart = false;

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
    var mediaQuery = MediaQuery.of(context);
    var isLandscape = mediaQuery.orientation == Orientation.landscape;

    var appBar = AppBar(
      title: Text('Expenses Tracker'),
      actions: [
        Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _startNewTransaction(context),
          ),
        ),
      ],
    );

    var availableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    var transactions = Container(
      height: availableHeight * 0.7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );

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
            appBar: appBar,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (isLandscape)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Show Chart'),
                        Switch(
                          value: _showChart,
                          onChanged: (val) {
                            setState(() {
                              _showChart = val;
                            });
                          },
                        ),
                      ],
                    ),
                  if (!isLandscape)
                    Container(
                      height: availableHeight * 0.3,
                      child: Chart(_recentTransactions),
                    ),
                  if (!isLandscape) transactions,
                  if (isLandscape)
                    _showChart
                        ? Container(
                            height: availableHeight * 0.7,
                            child: Chart(_recentTransactions),
                          )
                        : transactions,
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
