import 'dart:io';

import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_chat/components/common/appbar_widget.dart';
import 'package:live_chat/components/common/container_column.dart';
import 'package:live_chat/components/common/container_row.dart';
import 'package:live_chat/views/chat_view.dart';
import 'package:provider/provider.dart';

class CameraPreviewPage extends StatefulWidget {
  @override
  _CameraPreviewPageState createState() => _CameraPreviewPageState();
}

class _CameraPreviewPageState extends State<CameraPreviewPage> {
  ChatView _chatView;

  LocalFileSystem _localFileSystem = LocalFileSystem();
  ImagePicker picker = ImagePicker();
  TextEditingController controller;
  FocusNode _focusNodeDefault;
  FocusNode _focusNodeOther;

  bool visibilityDataTarget = false;
  bool innerDeleteArea = false;

  File selectedImage;
  int selectedImageIndex;

  List<File> attachFiles = [];
  List<String> attachTexts = [];

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    _focusNodeDefault = FocusNode();
    _focusNodeOther = FocusNode();

    controller.addListener(() {
      attachTexts[selectedImageIndex] = controller.text;
    });

    addAttach();
  }

  @override
  void dispose() {
    _focusNodeDefault.dispose();
    _focusNodeOther.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _chatView = Provider.of<ChatView>(context);

    return Theme(
      data: ThemeData(brightness: Brightness.dark),
      child: OrientationBuilder(
        builder: (context, orientation) {
          print(_focusNodeDefault.hasFocus.toString());
          bool status = !(orientation == Orientation.landscape && _focusNodeDefault.hasFocus);

          return status ? defaultPage() : textAreaPage();
        }
      ),
    );
  }

  Widget textAreaPage() {
    return WillPopScope(
      onWillPop: () async {
        _focusNodeOther.unfocus();
        _focusNodeDefault.unfocus();
        return false;
      },
      child: SafeArea(
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: ContainerRow(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  child: IconButton(
                      splashRadius: 25,
                      icon: Icon(Icons.keyboard),
                      onPressed: () {}
                      ),
                ),
                Flexible(
                  child: TextField(
                    // textInputAction: TextInputAction.done,
                    // onSubmitted: (value) {
                    //   _focusNodeOther.unfocus();
                    //   _focusNodeDefault.unfocus();
                    // },
                    maxLines: null,
                    showCursor: true,
                    autofocus: true,
                    focusNode: _focusNodeOther,
                    keyboardType: TextInputType.multiline,
                    controller: controller,
                    onChanged: (value) => attachTexts[selectedImageIndex] = value,
                    decoration: InputDecoration(
                      hintText: 'Başlık ekleyin...',
                      border: InputBorder.none,
                      // isDense: true,
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {
                    _focusNodeOther.unfocus();
                    _focusNodeDefault.unfocus();
                  },
                  child: Container(
                    width: 50,
                    color: Theme.of(context).primaryColor,
                    child: Icon(Icons.done),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget defaultPage() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,

      child: Material(
        child: Stack(
          children: [
            InteractiveViewer(
              panEnabled: false, // Set it to false to prevent panning.
              minScale: 1,
              maxScale: 4,
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
              ),
            ),

            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 80,
                child: AppbarWidget(
                  textColor: Colors.white,
                  backgroundColor: Colors.black.withOpacity(0.5),
                  onLeftSideClick: () {
                    popControl();
                  },
                  appBarType: 'Chat',
                  titleImageUrl: _chatView.groupType == 'Private'
                      ? _chatView.interlocutorUser.userProfilePhotoUrl
                      : _chatView.selectedChat.groupImageUrl,
                  titleText: _chatView.groupType == 'Private'
                      ? _chatView.interlocutorUser.userName
                      : _chatView.selectedChat.groupName,
                ),
              ),
            ),

            visibilityDataTarget
                ? Align(
              alignment: Alignment.center,
              child: Container(
                  child: DragTarget(
                    builder: (context, List<int> candidateData, rejectedData) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: 100,
                        height: 100,
                        color: visibilityDataTarget
                            ? Colors.black.withOpacity(0.5)
                            : Colors.transparent,
                        child: visibilityDataTarget
                            ? Icon(Icons.delete,
                            size: 32,
                            color: innerDeleteArea
                                ? Colors.amber
                                : Colors.white)
                            : Container(),
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

                      bool sameItem =
                          selectedImage.path == attachFiles[data].path;

                      setState(() {
                        attachFiles.removeAt(data);
                        attachTexts.removeAt(data);

                        if (sameItem && attachFiles.length > 1) {
                          selectedImage = attachFiles[0];
                          selectedImageIndex = 0;
                          controller.text = attachTexts[0];
                        } else {
                          selectedImage = null;
                          controller.text = '';
                        }
                        innerDeleteArea = false;
                      });

                      if (attachFiles.length < 1) popControl();
                    },
                  )),
            )
                : Container(),

            Positioned(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              child: WillPopScope(
                onWillPop: () async {
                  popControl();
                  return false;
                },
                child: ContainerColumn(
                  // color: Colors.red,
                  // height: MediaQuery.of(context).size.height * 0.4,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
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
                                constraints: BoxConstraints(minHeight: 100, maxHeight: 200),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
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
                                            _focusNodeDefault.hasPrimaryFocus
                                                ? _focusNodeDefault.unfocus()
                                                : _focusNodeDefault.requestFocus();
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
                                            onChanged: (value) => attachTexts[selectedImageIndex] = value,
                                            focusNode: _focusNodeDefault,
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
                                      Text(_chatView.groupType == 'Private'
                                          ? _chatView.interlocutorUser.userName
                                          : _chatView.selectedChat.groupName
                                      )
                                    ],
                                  ),

                                  ContainerRow(
                                      padding: EdgeInsets.symmetric(horizontal: 5),
                                      margin: EdgeInsets.only(top: 10),
                                      height: 50,
                                      children: [
                                        InkWell(
                                          onTap: () => addAttach(),
                                          child: Container(
                                            margin: EdgeInsets.symmetric(horizontal: 5),
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              // color: Colors.black.withOpacity(0.5),
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
                                      ]
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget defaultButton() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        List<Map<String, dynamic>> listData = [];
        for (int i = 0; i < attachFiles.length; i++) {
          listData.add({
            'file': attachFiles[i],
            'text': attachTexts[i],
          });
        }

        Navigator.of(context).pop(listData);
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
                color: attachFiles[photoIndex].path == selectedImage.path
                    ? Colors.amber
                    : Colors.black.withOpacity(0.5)),
            image: DecorationImage(
                fit: BoxFit.cover, image: FileImage(attachFiles[photoIndex]))),
      ),
      childWhenDragging: Container(width: 60, height: 50),
      child: InkWell(
        onTap: () {
          if (selectedImage.path != attachFiles[photoIndex].path) {
            setState(() {
              selectedImageIndex = photoIndex;
              selectedImage = attachFiles[photoIndex];
              controller.text = attachTexts[photoIndex];
            });
          }
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(
                  width: 1,
                  color: attachFiles[photoIndex].path == selectedImage.path
                      ? Colors.amber
                      : Colors.black.withOpacity(0.5)),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: FileImage(attachFiles[photoIndex]))),
        ),
      ),
    );
  }

  void addAttach() async {
    PickedFile pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
        selectedImageIndex = attachFiles.length < 1 ? 0 : attachFiles.length;
        attachFiles.add(File(pickedFile.path));
        attachTexts.add(' ');
        controller.text = '';
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