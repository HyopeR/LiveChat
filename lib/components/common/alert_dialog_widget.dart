import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:live_chat/components/common/platform_responsive.dart';

class AlertDialogWidget extends PlatformResponsiveWidget {

  final String alertTitle;
  final String alertContent;
  final String complateActionText;
  final String cancelActionText;

  AlertDialogWidget({
    @required this.alertTitle,
    @required this.alertContent,
    @required this.complateActionText,
    this.cancelActionText
  });

  Future<bool> show(BuildContext context) async {
    return Platform.isAndroid
        ? await showDialog(context: context, builder: (context) => this)
        : await showCupertinoDialog(context: context, builder: (context) => this);
  }


  @override
  Widget buildAndroidWidget(BuildContext context) {
    return AlertDialog(
      title: Text(alertTitle),
      content: Text(alertContent),
      actions: _dialogButtons(context),
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(alertTitle),
      content: Text(alertContent),
      actions: _dialogButtons(context),
    );
  }


  List<Widget> _dialogButtons(BuildContext context) {
    List<Widget> buttons = [];

    if(Platform.isAndroid) {
      if(cancelActionText != null)
        buttons.add(FlatButton(
          child: Text(cancelActionText),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ));

      buttons.add(FlatButton(
        child: Text(complateActionText),
        onPressed: () {
          Navigator.of(context).pop(true);
        },
      ));
    }

    else {
      if(cancelActionText != null)
        buttons.add(CupertinoDialogAction(
          child: Text(cancelActionText),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ));

      buttons.add(CupertinoDialogAction(
        child: Text(complateActionText),
        onPressed: () {
          Navigator.of(context).pop(true);
        },
      ));
    }

    return buttons;
  }

}
