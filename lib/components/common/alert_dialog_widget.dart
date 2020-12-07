import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:live_chat/components/common/container_column.dart';

import 'package:live_chat/components/common/platform_responsive.dart';

class AlertDialogWidget extends PlatformResponsiveWidget {

  final String alertTitle;
  final List<Widget> alertChildren;
  final VoidCallback completeAction;
  final String completeActionText;
  final String cancelActionText;

  AlertDialogWidget({
    @required this.alertTitle,
    @required this.alertChildren,
    this.completeAction,
    @required this.completeActionText,
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
      scrollable: true,
      elevation: 0,
      title: Text(alertTitle),
      content: ContainerColumn(
        mainAxisSize: MainAxisSize.min,
        children: alertChildren,
      ),
      actions: _dialogButtons(context),
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(alertTitle),
      content: ContainerColumn(
        mainAxisSize: MainAxisSize.min,
        children: alertChildren,
      ),
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
        child: Text(completeActionText),
        onPressed: completeAction != null
            ? completeAction
            : () {Navigator.of(context).pop(true);},
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
        child: Text(completeActionText),
        onPressed: completeAction != null
            ? completeAction
            : () {Navigator.of(context).pop(true);},
      ));
    }

    return buttons;
  }

}
