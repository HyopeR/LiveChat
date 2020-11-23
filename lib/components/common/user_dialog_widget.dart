import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:live_chat/components/common/container_column.dart';
import 'package:live_chat/components/common/container_row.dart';

class UserDialogWidget extends StatelessWidget {

  final String userName;
  final VoidCallback onProfileClick;
  final VoidCallback onChatClick;
  final VoidCallback onCancel;

  UserDialogWidget({
    @required this.userName,
    this.onProfileClick,
    this.onChatClick,
    this.onCancel
  });

  Future<bool> show(BuildContext context) async {
    return await showDialog(context: context, builder: (context) => this);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,

      title: InteractiveViewer(
        minScale: 1,
        maxScale: 4,
        child: Container(
          alignment: Alignment.bottomCenter,
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://i.pinimg.com/originals/81/28/d7/8128d7f04da219c0fb2509edd719a215.png'),
                fit: BoxFit.contain,
              )
          ),

          child: ContainerRow(
            mainAxisSize: MainAxisSize.max,
            padding: EdgeInsets.all(10),
            color: Colors.black.withOpacity(0.5),

            children: [
              Text(userName, style: TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
        ),
      ),

      content: ContainerColumn(
        mainAxisSize: MainAxisSize.min,
        children: [
          ContainerRow(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            color: Colors.white,

            children: [
              Text('Profil'),
              Text('Konuşma')
            ],
          )
        ],
      ),
    );
  }

}