import 'dart:io';

import 'package:flutter/material.dart';
import 'package:live_chat/components/common/container_column.dart';
import 'package:live_chat/components/common/container_row.dart';
import 'package:live_chat/components/common/image_widget.dart';

class AppbarWidget extends StatefulWidget implements PreferredSizeWidget {
  final String appBarType;
  final VoidCallback onLeftSideClick;
  final VoidCallback onTitleClick;
  final VoidCallback onOperationCancel;

  final String titleText;
  final String subTitleText;
  final ImageWidget titleImage;

  final Color textColor;
  final Color backgroundColor;
  final Color operationColor;
  final Brightness brightness;

  final List<Widget> actions;
  final List<Widget> operationActions;

  const AppbarWidget({
    Key key,
    this.appBarType : 'Default',
    this.onLeftSideClick,
    this.onTitleClick,
    this.onOperationCancel,
    this.titleText,
    this.subTitleText,
    this.titleImage,
    this.textColor : Colors.black,
    this.backgroundColor : Colors.amber,
    this.operationColor : Colors.orange,
    this.brightness : Brightness.light,
    this.actions,
    this.operationActions,
  }) : super(key: key);

  @override
  AppbarWidgetState createState() => AppbarWidgetState();

  @override
  Size get preferredSize => Size.fromHeight(56);
}

class AppbarWidgetState extends State<AppbarWidget> {

  bool operation = false;
  String subTitle;
  String title;

  void updateTitle(String text) {
    setState(() {
      title = text;
    });
  }

  void updateSubtitle(String text) {
    setState(() {
      subTitle = text;
    });
  }

  void operationCancel() {
    setState(() {
      operation = false;
    });
  }

  void operationOpen() {
    setState(() {
      operation = true;
    });
  }

  @override
  void initState() {
    super.initState();
    if(widget.subTitleText != null)
      subTitle = widget.subTitleText;

    if(widget.titleText != null)
      title = widget.titleText;
  }

  @override
  Widget build(BuildContext context) {

    if(!operation) {
      switch(widget.appBarType) {
        case('Chat'):
          return chatAppBar();
          break;

        case('Default'):
          return widget.onLeftSideClick != null ? backDefaultAppBar() : defaultAppBar();
          break;

        default:
          return AppBar();
          break;
      }
    } else {
      return operationAppBar();
    }

  }

  Widget chatAppBar() {
    return AppBar(
      brightness: widget.brightness,
      centerTitle: false,
      elevation: 0,
      leadingWidth: 86,
      backgroundColor: widget.backgroundColor,

      leading: FlatButton(
        padding: EdgeInsets.zero,
        onPressed: widget.onLeftSideClick,
        child: ContainerRow(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
              color: widget.textColor,
            ),
            widget.titleImage
          ],
        ),
      ),

      titleSpacing: 0,
      title: InkWell(
          splashColor: Colors.transparent,
          onTap: widget.onTitleClick,
          child: ContainerColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            constraints: BoxConstraints(
              minWidth: 150
            ),
            children: [
              Text(title, style: TextStyle(color: widget.textColor, fontSize: Theme.of(context).textTheme.headline6.fontSize)),
              subTitle != null ? Text(subTitle, style: TextStyle(fontSize: 12, color: widget.textColor.withOpacity(0.7))) : Container(),
            ],
          ),
      ),

      actions: widget.actions,
    );
  }

  Widget backDefaultAppBar() {
    return AppBar(
      brightness: widget.brightness,
      centerTitle: false,
      elevation: 0,
      leading: FlatButton(
        minWidth: 50,
        onPressed: widget.onLeftSideClick,
        child: Icon(Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios, color: widget.textColor),
      ),
      backgroundColor: widget.backgroundColor,
      title: Text(title, style: TextStyle(color: widget.textColor)),
      actions: widget.actions,
    );
  }

  Widget defaultAppBar() {
    return AppBar(
      brightness: widget.brightness,
      centerTitle: false,
      elevation: 0,
      backgroundColor: widget.backgroundColor,
      title: Text(title, style: TextStyle(color: widget.textColor)),
      actions: widget.actions,
    );
  }

  Widget operationAppBar() {
    return AppBar(
      brightness: widget.brightness,
      elevation: 0,
      backgroundColor: widget.operationColor,
      leading: FlatButton(
        minWidth: 50,
        onPressed: () {
          widget.onOperationCancel();
          operationCancel();
        },
        child: Icon(Icons.cancel, color: widget.textColor),
      ),
      actions: widget.operationActions,
    );
  }
}