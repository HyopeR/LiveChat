import 'package:flutter/material.dart';

class ContainerRow extends StatelessWidget {
  final Alignment alignment;
  final Color color;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double height;
  final double width;

  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;

  const ContainerRow({
    Key key,
    this.alignment : Alignment.topLeft,
    this.color : Colors.transparent,
    this.padding : EdgeInsets.zero,
    this.margin : EdgeInsets.zero,
    this.height,
    this.width,
    this.children,
    this.mainAxisAlignment : MainAxisAlignment.start,
    this.mainAxisSize  : MainAxisSize.max,
    this.crossAxisAlignment : CrossAxisAlignment.center
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      color: color,
      padding: padding,
      margin: margin,
      height: height,
      width: width,

      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,

        children: children != null ? children : [],
      ),
    );
  }
}
