import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

Future showAlertDialog(BuildContext context,
    {@required String? title,
    @required String? content,
    @required String? defaultActionText,
    String? cancelActionText}) {
  if (Platform.isAndroid) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title!),
              content: Text(content!),
              actions: [
                if(cancelActionText!=null)
                  TextButton(
                    child: Text(cancelActionText),
                    onPressed: () => Navigator.pop(context),
                  ),
                TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(defaultActionText!))
              ],
            ));
  } else {
    return showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text(title!),
              content: Text(content!),
              actions: [
                if(cancelActionText!=null)
                  CupertinoDialogAction(
                    child: Text(cancelActionText),
                    onPressed: () => Navigator.pop(context),
                  ),
                CupertinoDialogAction(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(defaultActionText!))
              ],
            ));
  }
}
