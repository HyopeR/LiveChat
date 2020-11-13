import 'dart:io';

import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_chat/components/common/appbar_widget.dart';
import 'package:live_chat/components/common/container_column.dart';
import 'package:live_chat/components/common/container_row.dart';
import 'package:live_chat/views/chat_view.dart';
import 'package:provider/provider.dart';

class AttachShowPage extends StatefulWidget {
  @override
  _AttachShowPageState createState() => _AttachShowPageState();
}

class _AttachShowPageState extends State<AttachShowPage> {
  ChatView _chatView;

  LocalFileSystem _localFileSystem = LocalFileSystem();
  ImagePicker picker = ImagePicker();
  TextEditingController controller;
  FocusNode _focusNode;

  List<String> attachFiles = [];

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    _focusNode = FocusNode();

    addAttach();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _chatView = Provider.of<ChatView>(context);

    return Theme(
      data: ThemeData(brightness: Brightness.dark),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: attachFiles.length > 0
            ? BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  image: FileImage(File(attachFiles[0])),
                  // image: NetworkImage(attachFiles[0]),
                  fit: BoxFit.contain,
                ))
            : BoxDecoration(
                color: Colors.black,
              ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppbarWidget(
              textColor: Colors.white,
              backgroundColor: Colors.black.withOpacity(0.5),
              onLeftSideClick: () {
                popControl();
              },
              titleImageUrl: _chatView.selectedChat.groupType == 'Private'
                  ? _chatView.interlocutorUser.userProfilePhotoUrl
                  : _chatView.selectedChat.groupImageUrl,
              titleText: _chatView.selectedChat.groupType == 'Private'
                  ? _chatView.interlocutorUser.userName
                  : _chatView.selectedChat.groupName,
            ),
            body: WillPopScope(
              onWillPop: () async {
                popControl();
                return false;
              },
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,

                  children: [
                    ContainerColumn(
                      mainAxisSize: MainAxisSize.min,
                      padding: EdgeInsets.all(10),
                      constraints: BoxConstraints(minHeight: 100, maxHeight: 150),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),

                      ),
                      children: [
                        Stack(
                          overflow: Overflow.visible,
                          children: [

                            ContainerRow(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IconButton(
                                    splashRadius: 25,
                                    icon: Icon(Icons.keyboard),
                                    onPressed: () {
                                      _focusNode.hasPrimaryFocus
                                          ? _focusNode.unfocus()
                                          : _focusNode.requestFocus();
                                    }),
                                Flexible(
                                  child: Container(
                                    constraints: BoxConstraints(maxHeight: 90),
                                    child: TextField(
                                      maxLines: null,
                                      showCursor: true,
                                      keyboardType: TextInputType.multiline,
                                      controller: controller,
                                      focusNode: _focusNode,
                                      decoration: InputDecoration(
                                        hintText: 'Başlık ekleyin...',
                                        border: InputBorder.none,
                                        // isDense: true,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            Positioned(
                                right: 0,
                                bottom: 0,
                                child: defaultButton()
                            ),

                          ],
                        ),
                        Divider(thickness: 1, height: 5),
                        ContainerRow(
                          height: 25,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_right),
                            Text(_chatView.selectedChat.groupType == 'Private'
                                ? _chatView.interlocutorUser.userName
                                : _chatView.selectedChat.groupName)
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Widget defaultButton() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,

      onTap: () {
        print('asdasdasd');
        Navigator.of(context).pop(attachFiles);
      },
      child: Container(
        constraints: BoxConstraints(
          minHeight: 65,
          minWidth: 65,
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).primaryColor,
        ),
        child: Container(
            width: 32,
            height: 32,
            child: Icon(Icons.send, color: Colors.black)),
      ),
    );
  }

  void addAttach() async {
    PickedFile pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        attachFiles.add(pickedFile.path);
      });
    } else {
      Navigator.of(context).pop([]);
    }
  }

  void popControl() async {
    if (attachFiles.length > 0) {
      attachFiles.forEach((filePath) {
        _localFileSystem.file(filePath).delete();
      });
    }

    Navigator.of(context).pop([]);
  }
}
