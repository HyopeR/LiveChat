import 'dart:async';

import 'package:flutter/material.dart';
import 'package:live_chat/components/common/combine_gesture_widget.dart';
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

  final bool permissionsAllowed;

  final VoidCallback onPressed;
  final VoidCallback onLongPressStart;
  final VoidCallback onLongPressEnd;

  const MessageCreatorWidget(
      {Key key,
      this.height: 50,
      this.margin: EdgeInsets.zero,
      this.padding: EdgeInsets.zero,
      this.hintText: '',
      this.textAreaColor: Colors.transparent,
      this.textAreaRadius: 10,
      this.textColor: Colors.black,
      this.iconSize: 32,
      this.iconColor: Colors.black,
      this.buttonColor: Colors.amber,
      this.permissionsAllowed: false,
      this.onPressed,
      this.onLongPressStart,
      this.onLongPressEnd,
      })
      : super(key: key);

  @override
  MessageCreatorWidgetState createState() => MessageCreatorWidgetState();
}

class MessageCreatorWidgetState extends State<MessageCreatorWidget> {
  bool permissionsAllowed;
  TextEditingController controller;

  bool voiceRecordCancelled = false;
  bool timerRun = false;

  int time = 0;
  int oldTime = 0;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    permissionsAllowed = widget.permissionsAllowed;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  permissionAllow() {
    setState(() {
      permissionsAllowed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ContainerRow(
      // height: widget.height,
      margin: widget.margin,
      padding: widget.padding,

      crossAxisAlignment: CrossAxisAlignment.end,

      children: [
        Expanded(
          flex: 1,
          child: Container(
            constraints: BoxConstraints(minHeight: widget.height),
            decoration: BoxDecoration(
              color: widget.textAreaColor,
              borderRadius: BorderRadius.circular(widget.textAreaRadius),
            ),

            child: !timerRun

              ? ContainerRow(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: defaultArea(),
              )

              : ContainerRow(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: voiceRecordArea(),
              ),

          ),
        ),
        SizedBox(width: 10),
        Container(
          child: controller.text.trim().length > 0
              ? defaultButton()
              : voiceRecordButton(),
        )
      ],
    );
  }

  String calculateTimer(int time) {
    if (time < 60) {
      String secondStr = (time % 60).toString().padLeft(2, '0');
      return '00 : $secondStr';
    } else {
      int remainingSecond = time % 60;
      String secondStr = (remainingSecond % 60).toString().padLeft(2, '0');

      int minutes = (time / 60).truncate();
      String minutesStr = (minutes % 60).toString().padLeft(2, '0');

      return '$minutesStr : $secondStr';
    }
  }

  List<Widget> defaultArea() {
    return [
      Container(
          width: widget.iconSize,
          height: widget.iconSize,
          child: Icon(Icons.emoji_emotions, color: widget.iconColor)),
      Expanded(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: 150,
          ),
          child: TextField(
            maxLines: null,
            keyboardType: TextInputType.multiline,
            onChanged: (value) => setState(() {}),
            controller: controller,
            style: TextStyle(color: widget.textColor),
            decoration: InputDecoration(
              hintText: widget.hintText,
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.only(top: 10, bottom: 6),
            ),
          ),
        ),
      ),
      Container(
          width: widget.iconSize,
          height: widget.iconSize,
          child: Icon(Icons.attach_file, color: widget.iconColor)),
      AnimatedOpacity(
        duration: Duration(milliseconds: 750),
        opacity: controller.text.length <= 0 ? 1 : 0,
        child: controller.text.length <= 0
            ? InkWell(
                onTap: () {},
                child: Container(
                    width: widget.iconSize,
                    height: widget.iconSize,
                    child: Icon(Icons.camera_alt, color: widget.iconColor)),
              )
            : Container(),
      )
    ];
  }

  List<Widget> voiceRecordArea() {
    return [
      Icon(Icons.mic),
      Text(
        calculateTimer(time),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      Expanded(
          child: Container(
              alignment: Alignment.centerRight,
              child: Text('İptal etmek için belirli alana bırak.')))
    ];
  }

  Widget defaultButton() {
    return GestureDetector(
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
    );
  }

  Widget voiceRecordButton() {
    return Column(
      children: [
        timerRun
            ? DragTarget(
                builder: (context, List<int> candidateData, rejectedData) {
                  return Center(
                      child: Container(
                          color: widget.textAreaColor,
                          width: 50,
                          height: 50,
                          child: Icon(Icons.delete)));
                },
                onAccept: (data) {
                  setState(() {
                    voiceRecordCancelled = true;
                  });
                },
              )
            : Container(),
        SizedBox(height: 10),
        Container(
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
                });
              }

              widget.onLongPressEnd();
            },
            child: LongPressDraggable(
              data: 1,
              axis: Axis.vertical,
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
      ],
    );
  }
}
