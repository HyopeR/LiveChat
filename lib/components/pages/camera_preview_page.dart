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

  bool visibilityDataTarget = false;
  bool innerDeleteArea = false;
  File selectedImage;
  List<File> attachFiles = [];

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
                  image: FileImage(selectedImage),
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
              child: ContainerColumn(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: ContainerColumn(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [
                        DragTarget(
                          builder: (context, List<int> candidateData, rejectedData) {
                            return AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              width: 100,
                              height: 100,
                              color: visibilityDataTarget ? Colors.black.withOpacity(0.5) : Colors.transparent,
                              child: visibilityDataTarget ? Icon(Icons.delete, size: 32, color: innerDeleteArea ? Colors.amber : Colors.white) : Container(),
                            );
                          },

                          onWillAccept: (data) {
                            setState(() {
                              innerDeleteArea = true;
                            });
                            return true;
                          },

                          onLeave: (data) {
                            setState(() {
                              innerDeleteArea = false;
                            });
                          },

                          onAccept: (data) {
                            _localFileSystem.file(attachFiles[data].path).delete();

                              setState(() {
                                if(selectedImage.path == attachFiles[data].path)
                                  selectedImage = attachFiles[0];

                                attachFiles.removeAt(data);
                                innerDeleteArea = false;
                              });

                              if(attachFiles.length < 1)
                                popControl();
                          },
                        )
                      ],
                    ),
                  ),

                  ContainerRow(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      margin: EdgeInsets.only(bottom: 10),
                      height: 50,
                      children: [
                        InkWell(
                          onTap: () => addAttach(),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                            ),
                            child: Icon(Icons.add),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: attachFiles.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) => childPhoto(index),
                          ),
                        ),
                      ]),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Stack(
                      children: [
                        ContainerColumn(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          // color: Colors.red,

                          children: [
                            Container(
                              height: 35,
                              color: Colors.transparent,
                            ),
                            ContainerColumn(
                              mainAxisSize: MainAxisSize.min,
                              padding: EdgeInsets.all(10),
                              constraints: BoxConstraints(
                                  minHeight: 100, maxHeight: 150),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                // color: Colors.blue
                              ),
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
                                        constraints:
                                            BoxConstraints(maxHeight: 90),
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
                                Divider(thickness: 1, height: 5),
                                ContainerRow(
                                  height: 25,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.arrow_right),
                                    Text(_chatView.selectedChat.groupType ==
                                            'Private'
                                        ? _chatView.interlocutorUser.userName
                                        : _chatView.selectedChat.groupName)
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Positioned(
                          right: 10,
                          top: 0,
                          child: Container(
                            // color: Colors.red,
                            child: defaultButton(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Widget defaultButton() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.of(context).pop(attachFiles);
      },
      child: Container(
        height: 65,
        width: 65,
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

  void changeSelectedPhoto(File attach) {
    if(selectedImage.path != attach.path)
      setState(() => selectedImage = attach);
  }

  Widget childPhoto(int photoIndex) {
    return Draggable(
      data: photoIndex,
      onDragStarted: () {
        setState(() {
          visibilityDataTarget = true;
        });
      },

      onDragEnd: (value) {
        setState(() {
          visibilityDataTarget = false;
        });
      },

      feedback: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            border: Border.all(
                width: 1,
                color: attachFiles[photoIndex].path == selectedImage.path ? Colors.amber : Colors.black.withOpacity(0.5)
            ),
            image: DecorationImage(
                fit: BoxFit.cover, image: FileImage(attachFiles[photoIndex]))),
      ),
      childWhenDragging: Container(width: 60, height: 50),
      child: InkWell(
        onTap: () => changeSelectedPhoto(attachFiles[photoIndex]),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(
                  width: 1,
                  color: attachFiles[photoIndex].path == selectedImage.path ? Colors.amber : Colors.black.withOpacity(0.5)
              ),
              image: DecorationImage(
                  fit: BoxFit.cover, image: FileImage(attachFiles[photoIndex]))),
        ),
      ),
    );
  }

  void addAttach() async {
    PickedFile pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
        attachFiles.add(File(pickedFile.path));
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
