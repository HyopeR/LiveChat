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

  MessageMarked({Key key, this.message, this.forwardCancel, this.mainAxisSize = MainAxisSize.max}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContainerRow(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: mainAxisSize,

        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(10),
        ),

        constraints: BoxConstraints(
          maxHeight: 100,
          minHeight: 50,
        ),

        children: createMarkedMessage(message)

    );
  }

  List<Widget> createMarkedMessage(MessageModel message) {
    switch (message.messageType) {
      case ('Text'):
        return [
            Flexible(
              child: ContainerColumn(
                constraints: BoxConstraints(
                  minWidth: 100,
                ),

                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(message.ownerUsername, style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text(
                    message.message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          forwardCancel != null
              ? IconButton(
                icon: Icon(Icons.cancel),
                splashRadius: 24,
                onPressed: forwardCancel
              )
              : Container(height: 0),
          ];
        break;

      case ('Image'):
        return [
            ImageWidget(
              image: NetworkImage(message.attach),
              imageHeight: 45,
              imageWidth: 45,
              imageFit: BoxFit.cover,
              backgroundPadding: 0,
              backgroundRadius: BorderRadius.circular(5),
            ),

            Flexible(
              child: ContainerColumn(
                padding: EdgeInsets.all(5),
                constraints: BoxConstraints(
                  minWidth: 100,
                ),
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,

                children: [
                  Text(
                      message.ownerUsername,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold)
                  ),
                  SizedBox(height: 5),
                  message.message != null
                      ? Text(
                        message.message,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      )
                      : Container()
                ],
              ),
            ),
            forwardCancel != null
                ? IconButton(
                    splashRadius: 24,
                    icon: Icon(Icons.cancel),
                    onPressed: forwardCancel
                  )
                : Container(height: 0),
          ];
        break;

      case ('Voice'):
        return [
          Flexible(
            child: ContainerColumn(
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
                    Text(
                      'Sesli mesaj (${calculateTimer(message.duration)})',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )
              ],
            ),
          ),
          forwardCancel != null
              ? IconButton(
                splashRadius: 24,
                icon: Icon(Icons.cancel),
                onPressed: forwardCancel
              )
              : Container(height: 0),
        ];
        break;

      default:
        return [];
        break;
    }
  }

}
