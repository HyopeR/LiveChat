import 'package:flutter/material.dart';

class AlertContainerWidget extends StatefulWidget {

  final double areaHeight;
  final double areaRadius;
  final Color areaColor;
  final String areaText;

  final double iconSize;
  final double textSize;
  final Color textColor;

  final Color leftSideColor;
  final IconData leftSideIcon;

  final Color rightSideColor;
  final IconData rightSideIcon;

  const AlertContainerWidget({
    Key key,
    this.areaHeight : 40,
    this.areaRadius : 10,
    this.areaColor : Colors.amber,
    this.areaText : '',

    this.iconSize : 24,
    this.textSize : 16,
    this.textColor : Colors.black,

    this.leftSideColor : Colors.transparent,
    this.leftSideIcon : Icons.announcement,
    this.rightSideColor : Colors.transparent,
    this.rightSideIcon : Icons.close,
  }) : super(key: key);


  @override
  AlertContainerWidgetState createState() => AlertContainerWidgetState();
}

class AlertContainerWidgetState extends State<AlertContainerWidget> {
  bool showedAlert = false;
  String areaText;

  showAlertAddText(String text) {
    setState(() {
      areaText = text;
      showedAlert = true;
    });
  }

  showAlert() {
    setState(() {
      showedAlert = true;
    });
  }

  hideAlert() {
    setState(() {
      showedAlert = false;
    });
  }

  @override
  void initState() {
    super.initState();
    areaText = widget.areaText;
  }

  @override
  Widget build(BuildContext context) {
    return showedAlert
      ? Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          height: widget.areaHeight,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.areaRadius),
              color: widget.areaColor
          ),

          child: Row(
            children: [

              Container(
                width: 50,
                decoration: BoxDecoration(
                    color: widget.leftSideColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(widget.areaRadius),
                      topLeft: Radius.circular(widget.areaRadius),
                    ),
                ),

                alignment: Alignment.center,
                child: Icon(
                  widget.leftSideIcon,
                  color: widget.textColor,
                  size: widget.iconSize,
                ),
              ),

              Expanded(
                  flex: 5,
                  child: Container(
                    padding: EdgeInsets.only(left: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(areaText, style: TextStyle(color: widget.textColor, fontSize: widget.textSize)),
                  )
              ),

              Container(
                alignment: Alignment.centerRight,
                child: FlatButton(
                  minWidth: 50,
                  color: widget.rightSideColor,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(widget.areaRadius),
                      topRight: Radius.circular(widget.areaRadius),
                    ),
                  ),

                  onPressed: () => hideAlert(),
                  child: Icon(
                    widget.rightSideIcon,
                    color: widget.textColor,
                    size: widget.iconSize,
                  ),
                ),
              )
            ],
          ),
      )

      : Container();
  }
}
