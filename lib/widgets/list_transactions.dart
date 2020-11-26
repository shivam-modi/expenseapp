import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:myexpense/models/transactions.dart';
import 'package:myexpense/widgets/transaction_item.dart';


class TransactionList extends StatelessWidget {
   final List<Transaction> userTransactions;
   final Function deleteTx;

   TransactionList(this.userTransactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: userTransactions.isEmpty ?
       LayoutBuilder(
               builder: (ctx, constraints) {
                 return Column(
                     children: <Widget>[
                       FittedBox(
                           fit: BoxFit.contain,
                         child: Text("No Transactions added yet!",
                           style: Theme.of(context).textTheme.title,
                         ),
                       ),
                       SizedBox(height: 20,),
                       Container(
                           height: constraints.maxHeight * 0.6,
                           child: Image.asset('assets/images/waiting.png',
                             fit: BoxFit.cover,)
                       ),
                     ],
                   );
               },
      )
            :
            Expanded(
              child: ListView(
                 children: userTransactions
                      .map((tx) => TransactionItem(
                             key: ValueKey(tx.id),
                             transaction: tx,
                             deleteTx: deleteTx
                 )).toList(),
           ),
            ),
        );
  }
}

//Card(
//child: Row(
//children: <Widget>[
//Container(
//margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//child: Text("₹${userTransactions[index].amount.toStringAsFixed(2)}",
//style: TextStyle(fontWeight: FontWeight.bold,
//fontSize: 13,
//color: Theme.of(context).primaryColor,
//),
//),
//decoration: BoxDecoration(
//border: Border.all(
//color: Theme.of(context).primaryColor,
//width: 2
//)
//),
//padding: EdgeInsets.all(10),
//),
//Column(
//crossAxisAlignment: CrossAxisAlignment.start,
//children: <Widget>[
//Text(
//userTransactions[index].title,
//style: TextStyle(
//fontSize: 16,
//fontWeight:FontWeight.bold
//)
//),
//Text(
//DateFormat.yMMMd().format(userTransactions[index].date),
//style: TextStyle(
//color: Colors.blueGrey
//)
//)
//],
//)
//],
//)
//);