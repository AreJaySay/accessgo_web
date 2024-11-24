import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmAction{
  void action(context, Function onpress, String question) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext ctx) {
          return CupertinoAlertDialog(
            title: Text('Please confirm'),
            content: Text(question),
            actions: [
              CupertinoDialogAction(
                onPressed: (){
                  onpress();
                  Navigator.of(context).pop(null);
                },
                child: Text('Confirm'),
                isDefaultAction: true,
                isDestructiveAction: true,
              ),
              // The "No" button
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
                isDefaultAction: false,
                isDestructiveAction: false,
              )
            ],
          );
        });
  }
}

final ConfirmAction confirmAction = new ConfirmAction();