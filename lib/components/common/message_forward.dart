import 'package:flutter/material.dart';
import 'package:live_chat/components/common/container_column.dart';
import 'package:live_chat/components/common/container_row.dart';
import 'package:live_chat/components/common/image_widget.dart';
import 'package:live_chat/models/message_model.dart';
import 'package:live_chat/services/operation_service.dart';

class MessageForward extends StatelessWidget {
  final MessageModel message;
  final VoidCallback forwardCancel;

  MessageForward({Key key, this.message, this.forwardCancel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContainerRow(
        mainAxisAlignment: MainAxisAlignment.start,
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
            Expanded(
              flex: 1,
              child: ContainerColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(message.ownerUsername, style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text(message.message),
                ],
              ),
            ),
            IconButton(
                splashRadius: 24,
                icon: Icon(Icons.cancel),
                onPressed: forwardCancel)
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
            Expanded(
              flex: 1,
              child: ContainerColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(message.ownerUsername, style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text(message.message),
                ],
              ),
            ),
            IconButton(
                splashRadius: 24,
                icon: Icon(Icons.cancel),
                onPressed: forwardCancel)
          ];
        break;

      case ('Voice'):
        return [
          Expanded(
            flex: 1,
            child: ContainerColumn(
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
          ),
          IconButton(
              splashRadius: 24,
              icon: Icon(Icons.cancel),
              onPressed: forwardCancel)
        ];
        break;

      default:
        return [];
        break;
    }
  }

}
