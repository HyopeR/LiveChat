import 'dart:io';

import 'package:flutter/material.dart';
import 'package:live_chat/components/common/container_row.dart';
import 'package:live_chat/components/common/image_widget.dart';

class AppbarWidget extends StatefulWidget implements PreferredSizeWidget {
  final String appBarType;
  final VoidCallback onLeftSideClick;
  final VoidCallback onTitleClick;
  final VoidCallback onOperationCancel;

  final String titleText;
  final String subTitleText;
  final String titleImageUrl;

  final Color textColor;
  final Color backgroundColor;
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
    this.titleImageUrl,
    this.textColor : Colors.black,
    this.backgroundColor : Colors.amber,
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
  Color operationColor = Color(0xFFe7ad01);
  String subTitle;

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

      leading: InkWell(
        onTap: widget.onLeftSideClick,
        child: ContainerRow(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
              color: widget.textColor,
            ),
            ImageWidget(
              imageUrl: widget.titleImageUrl,
              imageWidth: 50,
              imageHeight: 50,
              backgroundShape: BoxShape.circle,
            ),
          ],
        ),
      ),

      titleSpacing: 0,
      title: InkWell(
          onTap: widget.onTitleClick,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(widget.titleText, style: TextStyle(color: widget.textColor)),
              subTitle != null ? Text(subTitle, style: TextStyle(fontSize: 11, color: Colors.black54)) : Container(),
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
      leading: InkWell(
        onTap: widget.onLeftSideClick,
        child: Icon(Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios),
      ),
      backgroundColor: widget.backgroundColor,
      title: Text(widget.titleText, style: TextStyle(color: widget.textColor)),
      actions: widget.actions,
    );
  }

  Widget defaultAppBar() {
    return AppBar(
      brightness: widget.brightness,
      centerTitle: false,
      elevation: 0,
      backgroundColor: widget.backgroundColor,
      title: Text(widget.titleText, style: TextStyle(color: widget.textColor)),
      actions: widget.actions,
    );
  }

  Widget operationAppBar() {
    return AppBar(
      brightness: widget.brightness,
      elevation: 0,
      backgroundColor: operationColor,
      leading: InkWell(
        onTap: () {
          widget.onOperationCancel();
          operationCancel();
        },
        child: Icon(Icons.cancel),
      ),
      actions: widget.operationActions,
    );
  }
}