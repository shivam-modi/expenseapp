import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myexpense/models/transactions.dart';
import 'package:myexpense/widgets/chart.dart';
import 'package:myexpense/widgets/new_transaction.dart';
import 'package:myexpense/widgets/list_transactions.dart';

void main() {
//  SystemChrome.setPreferredOrientations([
//    DeviceOrientation.portraitUp,
//    DeviceOrientation.portraitDown,
//  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Personal Expenses",
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.orangeAccent,
        errorColor: Colors.redAccent,
        fontFamily: 'Quicksand',
        appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
                button: TextStyle(color: Colors.white),
            )
        )
      ),
           home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    Transaction(
      id: 't1',
      title: 'New Laptop',
      amount: 300000,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'Phone',
      amount: 6000,
      date: DateTime.now(),
    )
  ];
  bool _showChart= false;

  void _addNewTransaction(String txTitle, double txAmount, DateTime chosenDate){
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransactions(String id){
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }
  //String titleInput;
  //String amountInput;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }


  void _startAddNewTrans(BuildContext ctx){
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
              onTap: () {},
              child: NewTransactions(_addNewTransaction),
              behavior: HitTestBehavior.opaque,
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final mediaQuery = MediaQuery.of(context);
    final PreferredSizeWidget appBarMain = Platform.isIOS
        ? CupertinoNavigationBar(
             middle: Text("Personal Expenses"),
             trailing: Row(
               mainAxisSize: MainAxisSize.min,
               children: <Widget>[
                 GestureDetector(
                     child: Icon(CupertinoIcons.create_solid),
                     onTap: () => _startAddNewTrans(context)
                 ),
               ],
             ),
        )
        : AppBar(
           title: Text("Personal Expenses"),
            actions: <Widget>[
              IconButton(icon: Icon(Icons.edit),
              onPressed: () => _startAddNewTrans(context),
        ),
      ],
    );

    final txListWidget = Container(
        height: (mediaQuery.size.height -
            appBarMain.preferredSize.height) *
            0.7,
        child: TransactionList(_userTransactions, _deleteTransactions)
    );
    final pageBody = SafeArea(
      child: SingleChildScrollView(
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.stretch,
         children: <Widget>[
           isLandscape ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Show Chart!'),
              Switch.adaptive(
                  activeColor: Theme.of(context).accentColor,
                  value: _showChart,
                  onChanged: (val) {
                    setState(() {
                      _showChart= val;
                    });
                  }
              )
            ],
          ):
          SizedBox(height: 0.0, width: 0.0),
          isLandscape? (_showChart? Container(
              height: (mediaQuery.size.height -
                  appBarMain.preferredSize.height -
                  mediaQuery.padding.top) *
                  0.7,
              child: Chart(_recentTransactions)) :
              txListWidget
             )
              : Container(
              height: (mediaQuery.size.height -
                  appBarMain.preferredSize.height -
                  mediaQuery.padding.top) *
                  0.3,
              child: Chart(_recentTransactions),
             ),
              txListWidget
         ],
       ),
      ),
    );

    return Platform.isIOS ? CupertinoPageScaffold(
                  child: pageBody,
                  navigationBar: appBarMain,
    ) :
      Scaffold(
        appBar: appBarMain,
        body: pageBody,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Platform.isIOS ? Container():
          FloatingActionButton(
              child: Icon(Icons.edit),
              hoverColor: Colors.purpleAccent,
              onPressed: () =>_startAddNewTrans(context)
          )
    );
  }
}
