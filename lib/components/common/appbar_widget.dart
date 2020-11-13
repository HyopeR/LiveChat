import 'dart:io';

import 'package:flutter/material.dart';
import 'package:live_chat/components/common/container_row.dart';
import 'package:live_chat/components/common/image_widget.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onLeftSideClick;
  final VoidCallback onTitleClick;

  final String titleText;
  final String titleImageUrl;

  final Color textColor;
  final Color backgroundColor;

  const AppbarWidget({
    Key key,
    this.onLeftSideClick,
    this.onTitleClick,
    this.titleText,
    this.titleImageUrl,
    this.textColor : Colors.black,
    this.backgroundColor : Colors.amber
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        elevation: 0,
        leadingWidth: 85,

        backgroundColor: backgroundColor,

        leading: InkWell(
          onTap: onLeftSideClick,
          child: ContainerRow(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
                color: textColor,
              ),
              ImageWidget(
                imageUrl: titleImageUrl,
                imageWidth: 50,
                imageHeight: 50,
                backgroundShape: BoxShape.circle,
              ),
            ],
          ),
        ),
        title: InkWell(
            onTap: onTitleClick,
            child: Text(titleText, style: TextStyle(color: textColor))
        )
    );
  }
  
}