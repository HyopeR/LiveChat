import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:live_chat/components/common/container_column.dart';
import 'package:live_chat/models/user_model.dart';

class SystemBubble extends StatelessWidget {
  final String message;
  final String operationType;
  final UserModel user;

  const SystemBubble({
    Key key,
    this.message,
    this.operationType,
    this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Bubble(
        elevation: 0,
        padding: BubbleEdges.all(5),
        margin: BubbleEdges.symmetric(vertical: 3),
        color: Theme.of(context).primaryColor.withGreen(100),
        radius: Radius.circular(10),

        child: ContainerColumn(
            children: writeMessage(context)
        ),
      ),
    );
  }

  List<Widget> writeMessage(BuildContext context) {

    switch(operationType){

      case('Log'):
        return [
          Text(
              user.userName + ': '  + message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).accentIconTheme.color)
          ),
        ];
        break;

      case('Date'):
        return [
          Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).accentIconTheme.color)
          ),
        ];
        break;

      default:
        return [];
        break;

    }

  }
}
