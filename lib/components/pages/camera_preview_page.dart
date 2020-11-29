import 'dart:io';

import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_chat/components/common/appbar_widget.dart';
import 'package:live_chat/components/common/container_column.dart';
import 'package:live_chat/components/common/container_row.dart';
import 'package:live_chat/components/common/file_preview.dart';
import 'package:live_chat/views/chat_view.dart';
import 'package:provider/provider.dart';

class CameraPreviewPage extends StatefulWidget {
  @override
  _CameraPreviewPageState createState() => _CameraPreviewPageState();
}

class _CameraPreviewPageState extends State<CameraPreviewPage> {
  ChatView _chatView;

  GlobalKey<FilePreviewState> _filePreviewState = GlobalKey();
  LocalFileSystem _localFileSystem = LocalFileSystem();
  ImagePicker picker = ImagePicker();
  TextEditingController controller;
  FocusNode _focusNode;

  bool visibilityDataTarget = false;
  bool innerDeleteArea = false;

  int selectedImageIndex;

  List<File> attachFiles = [];
  List<String> attachTexts = [];

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    _focusNode = FocusNode();

    controller.addListener(() {
      attachTexts[selectedImageIndex] = controller.text;
    });

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

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.black.withOpacity(0.3),
        statusBarIconBrightness: Brightness.light,
      ),
      child: Theme(
        data: ThemeData.dark(),
        child: SafeArea(
          child: KeyboardVisibilityBuilder(
            builder: (context, isVisible) {
              return OrientationBuilder(
                  builder: (context, orientation) {
                    bool orientationLandscape = orientation == Orientation.landscape;

                    if(orientationLandscape) {
                      return !isVisible ? defaultPage() : textAreaPage();
                    } else
                      return defaultPage();
                  }
              );
            },
          ),
        ),
      ),
    );
  }

  Widget textAreaPage() {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ContainerRow(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KeyboardDismissOnTap(
              child: Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.topCenter,
                child: Icon(Icons.keyboard),
              ),
            ),
            Flexible(
              child: TextField(
                maxLines: null,
                showCursor: true,
                autofocus: true,
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

            KeyboardDismissOnTap(
              child: Container(
                width: 50,
                color: Theme.of(context).primaryColor,
                child: Icon(Icons.done),
              ),
            )
          ],
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
            FilePreview(
              key: _filePreviewState,
              itemList: attachFiles,
              currentPage: selectedImageIndex != null ? selectedImageIndex : 0,
              onPageChange: () {
                int currentItemIndex = _filePreviewState.currentState.currentPage;

                if (selectedImageIndex != currentItemIndex) {
                  setState(() {
                    selectedImageIndex = currentItemIndex;
                    if(attachTexts[currentItemIndex] != null)
                      controller.text = attachTexts[currentItemIndex];
                    else
                      controller.clear();
                  });
                }
              },
            ),

            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 56,
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

            Positioned(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              child: WillPopScope(
                onWillPop: () async {
                  popControl();
                  return false;
                },
                child: ContainerColumn(
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
                                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                                constraints: BoxConstraints(minHeight: 100, maxHeight: 200),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  // color: Colors.blue,
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
                                            onChanged: (value) => attachTexts[selectedImageIndex] = value,
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
                                            margin: EdgeInsets.symmetric(horizontal: 3),
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              // color: Colors.black.withOpacity(0.5),
                                              color: Theme.of(context).primaryColor,
                                            ),
                                            child: Icon(Icons.add, color: Colors.black),
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
                    onAccept: (data) async {
                      int filesLength = attachFiles.length;

                      if(filesLength == 1) {
                        await _localFileSystem.file(attachFiles[data].path).delete();
                        attachFiles.removeAt(data);
                        attachTexts.removeAt(data);
                        popControl();

                      } else if(filesLength > 1) {
                        bool isSelected = data == selectedImageIndex;
                        bool isLittle = data <= selectedImageIndex;

                        int newIndex = isLittle ? ((filesLength - 1) - 1) : selectedImageIndex;

                        await _localFileSystem.file(attachFiles[data].path).delete();
                        attachFiles.removeAt(data);
                        attachTexts.removeAt(data);

                        if(newIndex != selectedImageIndex || isSelected) {
                          _filePreviewState.currentState.pageController.jumpToPage(newIndex);

                          setState(() {
                            selectedImageIndex = newIndex;
                            controller.text = attachTexts[newIndex];
                            innerDeleteArea = false;
                          });
                        } else {
                          setState(() {
                            innerDeleteArea = false;
                          });
                        }

                      }

                    },
                  )),
            )
                : Container(),
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
    return LongPressDraggable(
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
        margin: EdgeInsets.symmetric(horizontal: 3),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            border: Border.all(
                width: 1,
                color: photoIndex == selectedImageIndex
                    ? Colors.amber
                    : Colors.black.withOpacity(0.5)),
            image: DecorationImage(
                fit: BoxFit.cover, image: FileImage(attachFiles[photoIndex]))),
      ),
      childWhenDragging: Container(width: 60, height: 50),
      child: InkWell(
        onTap: () {
          if (selectedImageIndex != photoIndex) {
            _filePreviewState.currentState.pageController.jumpToPage(photoIndex);
            setState(() {
              selectedImageIndex = photoIndex;
              if(attachTexts[photoIndex] != null)
                controller.text = attachTexts[photoIndex];
              else
                controller.clear();
            });
          }
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 3),
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(
                  width: 1,
                  color: photoIndex == selectedImageIndex
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
        selectedImageIndex = attachFiles.length < 1 ? 0 : attachFiles.length;
        attachFiles.add(File(pickedFile.path));
        attachTexts.add(null);
        controller.clear();
      });

      _filePreviewState.currentState.pageController.jumpToPage(attachFiles.length < 1 ? 0 : attachFiles.length);
    } else {
      Navigator.of(context).pop([]);
    }
  }

  void popControl() async {
    if (attachFiles.length > 0) {
      attachFiles.forEach((filePath) async {
        await _localFileSystem.file(filePath).delete();
      });
    }

    Navigator.of(context).pop([]);
  }
}
