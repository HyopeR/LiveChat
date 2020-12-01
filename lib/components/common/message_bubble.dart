import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:live_chat/components/common/container_column.dart';
import 'package:live_chat/components/common/container_row.dart';
import 'package:live_chat/components/common/image_widget.dart';
import 'package:live_chat/components/common/message_marked.dart';
import 'package:live_chat/components/common/sound_player.dart';
import 'package:live_chat/components/pages/media_show_page.dart';
import 'package:live_chat/models/message_model.dart';
import 'package:live_chat/services/operation_service.dart';

class MessageBubble extends StatelessWidget {
  final String groupType;
  final MessageModel message;
  final Color color;

  const MessageBubble({Key key, this.groupType, this.message, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double bubbleMarginRate = 0.1;
    switch(message.messageType){

      case('Video'):
      case('Image'):
        bubbleMarginRate = 0.4;
        break;

      case('Sound'):
      case('Voice'):
        bubbleMarginRate = 0.2;
        break;

      default:
        break;

    }
    return ContainerColumn(
      margin: message.fromMe
          ? EdgeInsets.only(top: 3, bottom: 3, right: 10, left: MediaQuery.of(context).size.width * bubbleMarginRate)
          : EdgeInsets.only(top: 3, bottom: 3, left: 10, right: MediaQuery.of(context).size.width * bubbleMarginRate),

      crossAxisAlignment: message.fromMe
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,

      children: [
        Stack(
          children: [
            IntrinsicWidth(
              child: ContainerColumn(
                constraints: BoxConstraints(minWidth: 60),
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (!message.fromMe && groupType == 'Plural')
                    ? Container(
                      padding: EdgeInsets.only(top: 3, bottom: 3),
                      child: Text(message.ownerUsername, style: TextStyle(fontWeight: FontWeight.bold))
                    )
                    : Container(width: 0),

                  message.markedMessage != null
                      ? Container(
                        margin: EdgeInsets.only(bottom: 6),
                        child: MessageMarked(message: message.markedMessage),
                      )
                      : Container(),
                  Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: writeMessage(context, message)),
                ],
              ),
            ),
            message.date != null
                ? Positioned(
                    right: 5,
                    bottom: 2,
                    child: Text(showClock(message.date),
                        style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 10)))
                : Text('')
          ],
        ),
      ],
    );
  }

  Widget writeMessage(BuildContext context, MessageModel message) {
    List<String> spliceTextList;

    if(message.message != null) {
      if(regexKeepEmoji.hasMatch(message.message)) {
        spliceTextList = message.message.split(regexKeepEmoji);
      }
    }

    switch (message.messageType) {
      case ('Text'):
        return Container(
            constraints: BoxConstraints(maxWidth: (MediaQuery.of(context).size.width * 0.9) - 20),
            child: RichText(
              text: TextSpan(
                  style: TextStyle(color: Theme.of(context).textTheme.bodyText2.color),
                  children: spliceTextList == null
                      ? [TextSpan(text: message.message, style: TextStyle(fontSize: Theme.of(context).textTheme.bodyText2.fontSize))]
                      : spliceTextList.map((pieceText) => regexKeepEmoji.hasMatch(pieceText)
                        ? TextSpan(text: pieceText, style: TextStyle(fontSize: 22))
                        : TextSpan(text: pieceText, style: TextStyle(fontSize: Theme.of(context).textTheme.bodyText2.fontSize))
                      ).toList(),
              ),
            ),
        );
        break;

      case ('Image'):
        double imageSize = MediaQuery.of(context).orientation == Orientation.portrait
          ? (MediaQuery.of(context).size.width * 0.6) - 20
          : (MediaQuery.of(context).size.width * 0.4) - 20;

        return InkWell(
          onTap: () {
            Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => MediaShowPage(currentMessageId: message.messageId)));
          },
          child: ContainerColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageWidget(
                  backgroundRadius: BorderRadius.circular(5),
                  backgroundPadding: 0,
                  imageWidth: imageSize,
                  imageHeight: imageSize,
                  image: NetworkImage(message.attach),
                  imageFit: BoxFit.cover
              ),
              message.message != null
                  ? Container(
                    margin: EdgeInsets.only(top: 5),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: Theme.of(context).textTheme.bodyText2.color),
                        children: spliceTextList == null
                            ? [TextSpan(text: message.message, style: TextStyle(fontSize: Theme.of(context).textTheme.bodyText2.fontSize))]
                            : spliceTextList.map((pieceText) => regexKeepEmoji.hasMatch(pieceText)
                              ? TextSpan(text: pieceText, style: TextStyle(fontSize: 22))
                              : TextSpan(text: pieceText, style: TextStyle(fontSize: Theme.of(context).textTheme.bodyText2.fontSize))
                        ).toList(),
                      ),
                    ),
                  )
                  : Container(width: 0),
            ],
          ),
        );
        break;

      case ('Voice'):
        return Container(
          constraints: BoxConstraints(maxWidth: 300),
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
