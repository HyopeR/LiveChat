import 'dart:io';

import 'package:flutter/material.dart';

abstract class PlatformResponsiveWidget extends StatelessWidget {

  Widget buildAndroidWidget(BuildContext context);
  Widget buildIosWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    if(Platform.isAndroid)
      return buildAndroidWidget(context);
    else
      return buildIosWidget(context);
  }

}