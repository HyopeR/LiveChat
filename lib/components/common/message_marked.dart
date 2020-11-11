import 'package:flutter/material.dart';
import 'package:live_chat/components/common/container_column.dart';
import 'package:live_chat/components/common/container_row.dart';
import 'package:live_chat/components/common/image_widget.dart';
import 'package:live_chat/models/message_model.dart';
import 'package:live_chat/services/operation_service.dart';

class MessageMarked extends StatelessWidget {
  final MessageModel message;
  final VoidCallback forwardCancel;

  final MainAxisSize mainAxisSize;

  MessageMarked({Key key, this.message, this.forwardCancel, this.mainAxisSize = MainAxisSize.min}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContainerRow(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: mainAxisSize,

        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),

        decoration: BoxDecoration(
          color: Colors.black38.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),

        constraints: BoxConstraints(
          maxHeight: 100,
          minHeight: 60,
        ),

        children: writeForwardMessage(message)

    );
  }

  List<Widget> writeForwardMessage(MessageModel message) {
    switch (message.messageType) {
      case ('Text'):
        return [
            ContainerColumn(
              constraints: BoxConstraints(
                minWidth: 100,
              ),

              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(message.ownerUsername, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text(message.message),
              ],
            ),
          forwardCancel != null
              ? IconButton(
                splashRadius: 24,
                icon: Icon(Icons.cancel),
                onPressed: forwardCancel)
              : Container(height: 0),
          ];
        break;

      case ('Image'):
        return [
            ImageWidget(
              imageUrl: message.message,
              imageHeight: 50,
              imageWidth: 50,
              backgroundPadding: 0,
            ),
            ContainerColumn(
              constraints: BoxConstraints(
                minWidth: 100,
              ),
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(message.ownerUsername, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text(message.message),
              ],
            ),
            forwardCancel != null
                ? IconButton(
                  splashRadius: 24,
                  icon: Icon(Icons.cancel),
                  onPressed: forwardCancel)
                : Container(height: 0),
          ];
        break;

      case ('Voice'):
        return [
          ContainerColumn(
            constraints: BoxConstraints(
              minWidth: 100,
            ),
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message.ownerUsername, style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.mic, size: 18),
                  Text('Sesli mesaj (${calculateTimer(message.duration)})'),
                ],
              )
            ],
          ),
          forwardCancel != null
              ? IconButton(
                splashRadius: 24,
                icon: Icon(Icons.cancel),
                onPressed: forwardCancel)
              : Container(height: 0),
        ];
        break;

      default:
        return [];
        break;
    }
  }

}
