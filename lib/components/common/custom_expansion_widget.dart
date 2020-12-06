import 'package:flutter/material.dart';
import 'package:live_chat/components/common/container_column.dart';
import 'package:live_chat/components/common/container_row.dart';

class CustomExpansionWidget extends StatefulWidget {
  final String title;
  final List<Widget> children;
  final EdgeInsets childrenPadding;

  const CustomExpansionWidget({
    Key key,
    this.title,
    this.children,
    this.childrenPadding : EdgeInsets.zero,
  }) : super(key: key);

  @override
  _CustomExpansionWidgetState createState() => _CustomExpansionWidgetState();
}

class _CustomExpansionWidgetState extends State<CustomExpansionWidget> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return ContainerColumn(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        InkWell(
          onTap: () {
            setState(() {
              expanded = !expanded;
            });
          },
          child: ContainerRow(
            constraints: BoxConstraints(
                minHeight: 50
            ),
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,

            padding: EdgeInsets.symmetric(horizontal: 10),
            children: [
              Text(widget.title, style: TextStyle(fontSize: 16)),
              Icon(
                  expanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                  color: expanded ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyText2.color
              )
            ],
          ),
        ),
        expanded
            ? ContainerColumn(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,

              padding: widget.childrenPadding,
              children: widget.children,
            )

            : Container(),
      ],
    );
  }
}
