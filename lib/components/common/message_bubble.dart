import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:live_chat/components/common/container_column.dart';
import 'package:live_chat/models/message_model.dart';

class MessageBubble extends StatelessWidget {

  final MessageModel message;
  final Color color;
  final bool fromMe;

  const MessageBubble({Key key, this.message, this.color, this.fromMe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContainerColumn(
      margin:
      fromMe
          ? EdgeInsets.only(top: 5, left: MediaQuery.of(context).size.width * 0.1)
          : EdgeInsets.only(top: 5, right: MediaQuery.of(context).size.width * 0.1),

      crossAxisAlignment: fromMe
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,

      children: [
        ContainerColumn(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: EdgeInsets.only(bottom: 5),
                child: Text(message.message)
            ),

            message.date != null
                ? Text(showClock(message.date), style: TextStyle(color: Colors.black54))
                : Text('')
          ],
        ),
      ],
    );
  }

  String showClock(Timestamp date) {
    var formatter = DateFormat.Hm();
    var clock = formatter.format(date.toDate());
    return clock;
  }
}
