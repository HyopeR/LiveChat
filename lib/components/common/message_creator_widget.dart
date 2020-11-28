import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:live_chat/components/common/combine_gesture_widget.dart';
import 'package:live_chat/components/common/container_column.dart';
import 'package:live_chat/components/common/container_row.dart';
import 'package:live_chat/services/operation_service.dart';

class MessageCreatorWidget extends StatefulWidget {
  final double height;
  final EdgeInsets margin;
  final EdgeInsets padding;

  final String hintText;

  final Color textAreaColor;
  final double textAreaMaxHeight;
  final CrossAxisAlignment textAreaCrossAxisAlignment;
  final double textAreaRadius;
  final Color textColor;

  final Alignment iconAlignment;
  final double iconSize;
  final Color iconColor;

  final Color buttonColor;

  final bool permissionsAllowed;

  final VoidCallback onWriting;
  final VoidCallback onWritingStop;

  final VoidCallback onPressed;
  final VoidCallback onLongPressStart;
  final VoidCallback onLongPressEnd;

  final VoidCallback useCamera;
  final VoidCallback useAttach;

  const MessageCreatorWidget(
      {Key key,
      this.height: 50,
      this.margin: EdgeInsets.zero,
      this.padding: EdgeInsets.zero,
      this.hintText: '',
      this.textAreaColor: Colors.transparent,
      this.textAreaMaxHeight,
      this.textAreaCrossAxisAlignment: CrossAxisAlignment.end,
      this.textAreaRadius: 10,
      this.textColor: Colors.black,
      this.iconAlignment: Alignment.topCenter,
      this.iconSize: 32,
      this.iconColor: Colors.black,
      this.buttonColor: Colors.amber,
      this.permissionsAllowed: false,
      this.onWriting,
      this.onWritingStop,
      this.onPressed,
      this.onLongPressStart,
      this.onLongPressEnd,
      this.useCamera,
      this.useAttach
      })
      : super(key: key);

  @override
  MessageCreatorWidgetState createState() => MessageCreatorWidgetState();
}

class MessageCreatorWidgetState extends State<MessageCreatorWidget> {

  bool permissionsAllowed;
  Widget markedMessageWidget;
  TextEditingController controller;
  FocusNode focusNode;

  bool voiceRecordCancelled = false;
  bool onCancel = false;
  bool timerRun = false;

  int time = 0;
  int oldTime = 0;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    focusNode = FocusNode();
    permissionsAllowed = widget.permissionsAllowed;

    controller.addListener(() {
      if(controller.text.isNotEmpty) {
        if(controller.text.trim().length == 1)
          widget.onWriting();
      } else {
        widget.onWritingStop();
      }

    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  permissionAllow() {
    setState(() {
      permissionsAllowed = true;
    });
  }

  setMarkedMessage(Widget markedMessage) {
    setState(() {
      markedMessageWidget = markedMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ContainerRow(
      // color: Colors.red,
      height: widget.height,
      margin: widget.margin,
      padding: widget.padding,

      crossAxisAlignment: CrossAxisAlignment.end,

      children: [
        Expanded(
          flex: 1,
          child: ContainerColumn(
            constraints: BoxConstraints(minHeight: widget.height),
            decoration: BoxDecoration(
              color: widget.textAreaColor,
              borderRadius: BorderRadius.circular(widget.textAreaRadius),
            ),

            children: [
              markedMessageWidget != null ? markedMessageWidget : Container(),

              !timerRun
                  ? ContainerRow(
                constraints: BoxConstraints(minHeight: widget.height),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: widget.textAreaCrossAxisAlignment,
                children: defaultArea(),
              )

                  : ContainerRow(
                constraints: BoxConstraints(minHeight: widget.height),
                padding: EdgeInsets.symmetric(horizontal: 5),
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: voiceRecordArea(),
              ),

            ],

          ),
        ),
        SizedBox(width: 10),
        Container(
          child: controller.text.trim().length > 0
              ? defaultButton()
              : voiceRecordButton(),
        ),
      ],
    );
  }

  List<Widget> defaultArea() {
    return [
      Container(
          alignment: widget.iconAlignment,
          width: widget.iconSize,
          height: widget.iconSize,
          child: InkWell(
            onTap: () => focusNode.hasPrimaryFocus ? focusNode.unfocus() : focusNode.requestFocus(),

            child: Icon(
                Icons.keyboard,
                color: widget.iconColor
            ),
          )
      ),
      Expanded(
        child: Container(
          constraints:
          BoxConstraints(
            maxHeight: widget.textAreaMaxHeight,
          ),
          child: TextField(
            maxLines: null,
            keyboardType: TextInputType.multiline,
            onChanged: (value) => setState(() {}),
            controller: controller,
            focusNode: focusNode,
            style: TextStyle(color: widget.textColor),
            decoration: InputDecoration(
              hintText: widget.hintText,
              border: InputBorder.none,
              isDense: true,
              // contentPadding: EdgeInsets.all(8),
            ),
          ),
        ),
      ),

      widget.useAttach != null
          ? InkWell(
              onTap: widget.useAttach,
              child: Container(
                  alignment: widget.iconAlignment,
                  width: widget.iconSize,
                  height: widget.iconSize,
                  child: Icon(Icons.attach_file, color: widget.iconColor)),
            )
          : Container(),

      widget.useCamera != null
          ? AnimatedOpacity(
            duration: Duration(milliseconds: 500),
            opacity: controller.text.length <= 0 ? 1 : 0,
            child: InkWell(
                    onTap: widget.useCamera,
                    child: AnimatedContainer(
                        alignment: widget.iconAlignment,
                        duration: Duration(milliseconds: 250),
                        width: controller.text.length <= 0 ? widget.iconSize : 0,
                        height: controller.text.length <= 0 ? widget.iconSize : 0,
                        child: Icon(Icons.camera_alt, color: widget.iconColor)),
                  )
          )

          : Container(),
    ];
  }

  List<Widget> voiceRecordArea() {
    return [
      Icon(
          onCancel ? Icons.delete : Icons.mic,
          color: onCancel ? Colors.red : Colors.black,
      ),
      Text(
        calculateTimer(time),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      Expanded(
        child: Container(
          height: 40,
          child: DragTarget(builder: (context, List<int> candidateData, rejectedData) {
            return Container(
                alignment: Alignment.centerRight,
                child: Text('İptal etmek için buraya sürükle.'),
            );
          },
            onLeave: (data) {
              setState(() {
                onCancel = false;
              });
              return false;
            },

            onWillAccept: (data) {
              setState(() {
                onCancel = true;
              });
              return true;
            },

            onAccept: (data) {
              setState(() {
                voiceRecordCancelled = true;
              });
            },
          ),
        ),
      )
    ];
  }

  Widget defaultButton() {
    return widget.onPressed != null
        ? GestureDetector(
          onTap: widget.onPressed,
          child: Container(
            constraints: BoxConstraints(
              minHeight: widget.height,
              minWidth: widget.height,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.buttonColor,
            ),
            child: Container(
                width: widget.iconSize,
                height: widget.iconSize,
                child: Icon(Icons.send, color: widget.iconColor)),
          ),
        )

        : Container();
  }

  Widget voiceRecordButton() {

    return (widget.onLongPressStart != null && widget.onLongPressEnd != null)
        ? Container(
          child: CombineGestureWidget(
            onLongPressStart: () {

              if(permissionsAllowed) {
                setState(() {
                  voiceRecordCancelled = false;
                  timerRun = true;
                });
              }

              widget.onLongPressStart();
            },

            onLongPress: () {

              if(permissionsAllowed) {
                Timer.periodic(Duration(seconds: 1), (Timer timer) {
                  if (timerRun)
                    setState(() => time = time + 1);
                  else
                    timer.cancel();
                });
              }

            },

            onLongPressEnd: () {

              if(permissionsAllowed) {
                setState(() {
                  if(time < 1)
                    voiceRecordCancelled = true;

                  oldTime = time;
                  time = 0;
                  timerRun = false;
                  onCancel = false;
                });
              }

              widget.onLongPressEnd();
            },
            child: LongPressDraggable(
              data: 1,
              // axis: Axis.horizontal,
              dragAnchor: DragAnchor.child,

              feedback: Container(
                constraints: BoxConstraints(
                  minHeight: widget.height,
                  minWidth: widget.height,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.buttonColor.withGreen(120),
                ),
                child: Container(
                    width: widget.iconSize,
                    height: widget.iconSize,
                    child: Icon(Icons.mic, color: widget.iconColor)),
              ),

              childWhenDragging: Container(
                  constraints: BoxConstraints(
                    minHeight: widget.height,
                    minWidth: widget.height,
                  )
              ),

              child: Container(
                      constraints: BoxConstraints(
                        minHeight: widget.height,
                        minWidth: widget.height,
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.buttonColor,
                      ),
                      child: Container(
                          width: widget.iconSize,
                          height: widget.iconSize,
                          child: Icon(Icons.mic, color: widget.iconColor)),
                    ),
            ),
          ),
        )

        : Container();
  }
}
