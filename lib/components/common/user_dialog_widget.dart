import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:live_chat/components/common/container_column.dart';
import 'package:live_chat/components/common/container_row.dart';

class UserDialogWidget extends StatelessWidget {

  final String name;
  final String photoUrl;
  final VoidCallback onPhotoClick;
  final VoidCallback onDetailClick;
  final VoidCallback onChatClick;
  final VoidCallback onCancel;

  UserDialogWidget({
    @required this.name,
    this.photoUrl,
    this.onPhotoClick,
    this.onDetailClick,
    this.onChatClick,
    this.onCancel
  });

  Future<bool> show(BuildContext context) async {
    return await showDialog(context: context, builder: (context) => this);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,

      title: InteractiveViewer(

        minScale: 1,
        maxScale: 4,
        child: InkWell(
          onTap: onPhotoClick,
          child: Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.width * 0.7 : MediaQuery.of(context).size.height * 0.7,
            height: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.width * 0.7 : MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
              ),

                image: DecorationImage(
                  image: NetworkImage(photoUrl != null ? photoUrl : 'https://i.pinimg.com/originals/81/28/d7/8128d7f04da219c0fb2509edd719a215.png'),
                  fit: BoxFit.cover,
                )
            ),

            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ContainerRow(
                    mainAxisSize: MainAxisSize.max,
                    padding: EdgeInsets.all(10),
                    color: Colors.black.withOpacity(0.5),

                    children: [
                      Text(name, style: TextStyle(color: Colors.white, fontSize: 16)),
                    ],
                  ),
                ),

                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    splashRadius: 25,
                    onPressed: () {
                      if(onCancel != null)
                        onCancel();

                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.cancel),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      content: ContainerColumn(
        mainAxisSize: MainAxisSize.min,
        children: [
          ContainerRow(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            children: [
              Expanded(child: InkWell(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                ),
                splashColor: Colors.amber,
                onTap: onDetailClick,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  alignment: Alignment.center,
                  child: Icon(Icons.portrait),
                ),
              )),
              Expanded(child: InkWell(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                ),
                splashColor: Colors.amber,
                onTap: onChatClick,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  alignment: Alignment.center,
                  child: Icon(Icons.chat_outlined),
                ),
              )),
            ],
          )
        ],
      ),
    );
  }

}