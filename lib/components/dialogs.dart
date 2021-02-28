

import 'package:flutter/cupertino.dart';

showDialogWithOkayButton(BuildContext context, String message){
  showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(message),
          actions: [
            CupertinoButton(
                child: Text("Okay"),
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        );
      });
}