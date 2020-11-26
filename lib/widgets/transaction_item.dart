import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatefulWidget {
  final transaction;
  final Function deleteTx;

  const TransactionItem({
             Key key,
            this.transaction,
            this.deleteTx
      }):super(key: key);

  @override
  _TransactionItemState createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  Color _bgColor;

  @override
  void initState() {
    const availableColors = [
      Colors.red,
      Colors.black,
      Colors.blue,
      Colors.purple,
    ];

    _bgColor = availableColors[Random().nextInt(4)];
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 8
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: FittedBox(
                child: Text("₹${widget.transaction.amount}")
            ),
          ),
        ),
        title: Text(widget.transaction.title,
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: Text(DateFormat.yMMMd().format(widget.transaction.date)
        ),
        trailing: MediaQuery.of(context).size.width > 460 ?
        FlatButton.icon(
          icon: Icon(Icons.delete_sweep),
          label: Text("Remove"),
          onPressed: () => widget.deleteTx(widget.transaction.id),
          textColor: Theme.of(context).errorColor,
        )
            :
        IconButton(
          icon: Icon(Icons.delete_sweep),
          onPressed: () => widget.deleteTx(widget.transaction.id),
          color: Theme.of(context).errorColor,
        ),
      ),
    );
  }
}
