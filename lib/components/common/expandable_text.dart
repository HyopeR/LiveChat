import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ExpandableText extends StatefulWidget {
  final List<InlineSpan> children;
  final int maxCharCount;

  final String text;
  final double textSize;
  final String enlargeText;
  final String shrinkText;

  ExpandableText({
    @required this.children,
    this.maxCharCount : 500,
    @required this.text,
    this.textSize,
    this.enlargeText : 'Devamını oku',
    this.shrinkText : 'Küçült'
  });

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> with TickerProviderStateMixin<ExpandableText> {
  bool isExpanded = false;
  bool isLongText = false;

  @override
  void initState() {
    super.initState();
    isLongText = widget.text.length > widget.maxCharCount;
  }

  @override
  Widget build(BuildContext context) {
    return

      isLongText
          ? Column(
              children: [
                AnimatedSize(
                    vsync: this,
                    duration: Duration(milliseconds: 500),
                    child: RichText(
                      maxLines: !isExpanded ? 5 : null,
                      text: TextSpan(
                          style: TextStyle(color: Theme.of(context).textTheme.bodyText2.color, fontSize: widget.textSize),
                          children: widget.children
                      ),
                    )
                ),

                isLongText
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        child: Container(
                            alignment: Alignment.bottomRight,
                            child: Text(
                                !isExpanded ? widget.enlargeText : widget.shrinkText,
                                style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w500, fontSize: widget.textSize)
                            )
                        )
                    )

                    : Container(width: 0)
              ]
          )

          : RichText(
            maxLines: null,
            text: TextSpan(
                style: TextStyle(color: Theme.of(context).textTheme.bodyText2.color, fontSize: widget.textSize),
                children: widget.children
            ),
          );
  }
}


// Column(
// children: [
// AnimatedSize(
// vsync: this,
// duration: Duration(milliseconds: 500),
// child: ConstrainedBox(
// constraints: isExpanded ? BoxConstraints() : BoxConstraints(maxHeight: 150),
// child: RichText(
// maxLines: 5,
// text: TextSpan(
// style: TextStyle(color: Colors.black),
// children: widget.children
// ),
// ),
// )
// ),
//
// isLongText
// ? GestureDetector(
// onTap: () {
// setState(() {
// isExpanded = !isExpanded;
// });
// },
// child: Container(
// alignment: Alignment.bottomRight,
// child: Text(
// !isExpanded ? widget.enlargeText : widget.shrinkText,
// style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w500, fontSize: 11)
// )
// )
// )
//
// : Container(width: 0)
// ]
// )
