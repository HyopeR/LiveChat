import 'dart:io';

import 'package:flutter/material.dart';
import 'package:live_chat/components/common/container_row.dart';
import 'package:live_chat/components/common/image_widget.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onLeftSideClick;

  final String titleText;
  final String titleImageUrl;

  const AppbarWidget({Key key, this.onLeftSideClick, this.titleText, this.titleImageUrl}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        leadingWidth: 85,
        leading: InkWell(
          onTap: onLeftSideClick,
          child: ContainerRow(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Platform.isAndroid
                    ? Icons.arrow_back
                    : Icons.arrow_back_ios,
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
        title: Text(titleText)
    );
  }
  
}