import 'package:flutter/material.dart';

class ContainerRow extends StatelessWidget {
  final Alignment alignment;
  final Color color;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double height;
  final double width;
  final BoxDecoration decoration;
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;

  const ContainerRow({
    Key key,
    this.alignment,
    this.color : Colors.transparent,
    this.padding : EdgeInsets.zero,
    this.margin : EdgeInsets.zero,
    this.height,
    this.width,
    this.decoration,
    this.children,
    this.mainAxisAlignment : MainAxisAlignment.start,
    this.mainAxisSize  : MainAxisSize.max,
    this.crossAxisAlignment : CrossAxisAlignment.center
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      decoration: decoration != null
          ? decoration : color != null
          ? BoxDecoration(color: color) : null,
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
