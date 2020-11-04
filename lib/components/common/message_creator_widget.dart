import 'package:flutter/material.dart';
import 'package:live_chat/components/common/container_row.dart';

class MessageCreatorWidget extends StatefulWidget {

  final double height;
  final EdgeInsets margin;
  final EdgeInsets padding;

  final String hintText;
  final Color textAreaColor;
  final double textAreaRadius;
  final Color textColor;

  final double iconSize;
  final Color iconColor;

  final Color buttonColor;
  final VoidCallback onPressed;

  const MessageCreatorWidget({
    Key key,
    this.height : 50,
    this.margin : EdgeInsets.zero,
    this.padding : EdgeInsets.zero,
    this.hintText : '',
    this.textAreaColor : Colors.transparent,
    this.textAreaRadius : 10,
    this.textColor : Colors.black,
    this.iconSize : 32,
    this.iconColor : Colors.black,
    this.buttonColor : Colors.amber,
    this.onPressed
  }) : super(key: key);

  @override
  MessageCreatorWidgetState createState() => MessageCreatorWidgetState();
}

class MessageCreatorWidgetState extends State<MessageCreatorWidget> {

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ContainerRow(
      height: widget.height,

      margin: widget.margin,
      padding: widget.padding,

      children: [

        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              color: widget.textAreaColor,
              borderRadius: BorderRadius.circular(widget.textAreaRadius),
            ),
            child: ContainerRow(
              padding: EdgeInsets.symmetric(horizontal: 5),
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(width: widget.iconSize, height: widget.iconSize, child: Icon(Icons.emoji_emotions, color: widget.iconColor)),

                Expanded(
                  child: Container(
                    child: TextField(
                      controller: controller,
                      style: TextStyle(color: widget.textColor),
                      decoration: InputDecoration(
                          hintText: widget.hintText,
                          border: InputBorder.none,
                      ),

                    ),
                  ),
                ),

                Container(width: widget.iconSize, height: widget.iconSize,  child: Icon(Icons.attach_file, color: widget.iconColor)),
                Container(width: widget.iconSize, height: widget.iconSize,  child: Icon(Icons.camera_alt, color: widget.iconColor)),
              ],
            ),
          ),
        ),

        SizedBox(width: 10),

        Container(
          width: widget.height,
          height: widget.height,
          child: RaisedButton(
            elevation: 0,
            onPressed: widget.onPressed,

            color: widget.buttonColor,
            shape: CircleBorder(),

            child: Container(width: widget.iconSize, height: widget.iconSize, child: Icon(Icons.send, color: widget.iconColor)),
          ),
        )

      ],
    );
  }
}
