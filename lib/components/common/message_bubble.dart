import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:live_chat/components/common/container_column.dart';
import 'package:live_chat/components/common/image_widget.dart';
import 'package:live_chat/components/common/message_marked.dart';
import 'package:live_chat/components/common/sound_player.dart';
import 'package:live_chat/models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final Color color;

  const MessageBubble({Key key, this.message, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContainerColumn(
      margin: message.fromMe
          ? EdgeInsets.only(top: 5, left: MediaQuery.of(context).size.width * 0.1)
          : EdgeInsets.only(top: 5, right: MediaQuery.of(context).size.width * 0.1),

      crossAxisAlignment: message.fromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,

      children: [
        Stack(
          children: [
            ContainerColumn(
              constraints: BoxConstraints(minWidth: 60),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                message.markedMessage != null
                    ? Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: MessageMarked(message: message.markedMessage))
                    : Container(width: 0),
                Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: writeMessage(message)),
              ],
            ),
            message.date != null
                ? Positioned(
                    right: 5,
                    bottom: 2,
                    child: Text(showClock(message.date),
                        style: TextStyle(color: Colors.black54, fontSize: 10)))
                : Text('')
          ],
        ),
      ],
    );
  }

  Widget writeMessage(MessageModel message) {
    switch (message.messageType) {
      case ('Text'):
        return Container(
            constraints: BoxConstraints(maxWidth: 350),
            child: Text(message.message));
        break;

      case ('Image'):
        return InkWell(
          onTap: () {},
          child: ContainerColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageWidget(imageWidth: 180, imageHeight: 180, imageUrl: message.attach, imageFit: BoxFit.cover),
              message.message != null ? Text(message.message) : Container(),
            ],
          ),
        );
        break;

      case ('Voice'):
        return Container(
          constraints: BoxConstraints(maxWidth: 350),
          child: SoundPlayer.voice(
            soundUrl: message.message,
            soundDuration: message.duration.toDouble(),
            soundType: 'Voice',
            imageUrl: message.ownerImageUrl,
          ),
        );
        break;

      default:
        return null;
        break;
    }
  }

  String showClock(Timestamp date) {
    var formatter = DateFormat.Hm();
    var clock = formatter.format(date.toDate());
    return clock;
  }
}
