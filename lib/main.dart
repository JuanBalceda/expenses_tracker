import 'dart:io';

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

    /*Platform.isIOS
        ? CupertinoApp(
            debugShowCheckedModeBanner: false,
            title: title,
            theme: CupertinoThemeData(
              primaryColor: Colors.purple,
              primaryContrastingColor: Colors.amber,
            ),
            home: HomePage(),
          )
        : */
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(
        primarySwatch: Platform.isIOS ? Colors.purple : Colors.blue,
        accentColor: Platform.isIOS ? Colors.amber : Colors.pink,
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

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
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
    var builder = (_) => NewTransaction(_addNewTransaction);

    showModalBottomSheet(
      context: ctx,
      builder: builder,
    );
    // }
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  List<Widget> _buildLandscapeContent(
    Widget transactions,
    double availableHeight,
  ) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Show Chart',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          Switch.adaptive(
            activeColor: Theme.of(context).accentColor,
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          ),
        ],
      ),
      _showChart
          ? Container(
              height: availableHeight * 0.7,
              child: Chart(_recentTransactions),
            )
          : transactions,
    ];
  }

  List<Widget> _buildPortraitContent(
    Widget transactions,
    double availableHeight,
  ) {
    return [
      Container(
        height: availableHeight * 0.3,
        child: Chart(_recentTransactions),
      ),
      transactions,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Expenses Tracker'),
            trailing: CupertinoButton(
              onPressed: () => _startNewTransaction(context),
              child: Icon(CupertinoIcons.add),
              padding: EdgeInsets.all(0),
            ),
          ) as PreferredSizeWidget
        : AppBar(
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

    var mediaQuery = MediaQuery.of(context);

    var availableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    var transactions = Container(
      height: availableHeight * 0.7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );

    var isLandscape = mediaQuery.orientation == Orientation.landscape;

    var pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLandscape)
              ..._buildLandscapeContent(transactions, availableHeight)
            else
              ..._buildPortraitContent(transactions, availableHeight)
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar as CupertinoNavigationBar,
            child: pageBody,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
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

  @override
  void initState() {
    super.initState();
    print('initState::');
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    print('dispose::');
    WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }
}
