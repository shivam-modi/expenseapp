import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myexpense/widgets/adaptive_button.dart';

class NewTransactions extends StatefulWidget {
  final Function newTrans;

  NewTransactions(this.newTrans);

  @override
  _NewTransactionsState createState() => _NewTransactionsState();
}

class _NewTransactionsState extends State<NewTransactions> {

  final titleController = new TextEditingController();
  final amountController = new TextEditingController();
  DateTime _selectedDate;

  @override
  void initState() {
    print('initState()');
    super.initState();
  }

  @override
  void didUpdateWidget(NewTransactions oldWidget) {
    print('didUpdateWidget()');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    print('dispose()');
    super.dispose();
  }

  void submitData(){
    if(amountController.text.isEmpty){
      return;
    }
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);

    if(enteredTitle.isEmpty || enteredAmount<=0 || _selectedDate== null){
      return;
    }

    widget.newTrans(
        enteredTitle,
        enteredAmount,
        _selectedDate
    );
    Navigator.of(context).pop();
//    setState(() {
//      Navigator.of(context).pop();
//    });
  }

  void _presentDatePicker(){
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime.now(),
    ).then((pickedDate) {
        if(pickedDate== null){
          return;
        }
        setState(() {
          _selectedDate= pickedDate;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
          elevation: 5,
          child: Container(
            margin: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10, 
                bottom: MediaQuery.of(context).viewInsets.bottom + 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Platform.isIOS ? CupertinoTextField(
                  placeholder: 'Title',
                  controller: titleController,
                  onSubmitted: (_) => submitData(),
                )
                :TextField(
                  decoration: InputDecoration(
                    labelText: 'Title',
                  ),
                  //onChanged: (val) {titleInput = val;},
                  controller: titleController,
                  onSubmitted: (_) => submitData(),
                ),
                Platform.isIOS ? CupertinoTextField(
                  placeholder: 'Title',
                  controller: titleController,
                  onSubmitted: (_) => submitData(),
                )
                    :TextField(
                  decoration: InputDecoration(
                    labelText: 'Amount',
                  ),
                  //onChanged: (val)=> amountInput = val,
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) => submitData(),
                ),
                Container(
                  height: 75,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(_selectedDate== null ?'No Date Choosen!':
                               'Picked Date: ${DateFormat.yMd().format(_selectedDate)}'
                        ),
                      ),
                      AdaptiveFlatButton("Choose Date", _presentDatePicker)
                    ],
                  ),
                ),
                RaisedButton(
                    onPressed: submitData,
                    child: Text('Add Transaction'),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).textTheme.button.color,
                ),
              ],
            ),
          )
      ),
    );
  }
}

