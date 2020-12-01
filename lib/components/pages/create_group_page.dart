import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_chat/components/common/alert_container_widget.dart';
import 'package:live_chat/components/common/appbar_widget.dart';
import 'package:live_chat/components/common/container_column.dart';
import 'package:live_chat/components/common/container_row.dart';
import 'package:live_chat/components/common/image_widget.dart';
import 'package:live_chat/components/common/loading_dialog_widget.dart';
import 'package:live_chat/components/common/title_area.dart';
import 'package:live_chat/models/group_model.dart';
import 'package:live_chat/models/user_model.dart';
import 'package:live_chat/views/chat_view.dart';
import 'package:live_chat/views/user_view.dart';
import 'package:provider/provider.dart';

class CreateGroupPage extends StatefulWidget {
  final List<UserModel> selectedUserList;
  const CreateGroupPage({Key key, this.selectedUserList}) : super(key: key);

  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  UserView _userView;
  ChatView _chatView;

  GlobalKey<AppbarWidgetState> _appbarWidgetState = GlobalKey();
  GlobalKey<AlertContainerWidgetState> _alertContainerWidgetState = GlobalKey();

  ImagePicker picker = ImagePicker();
  TextEditingController _controllerName;
  TextEditingController _controllerStatement;
  FocusNode _focusNode;

  File groupPhoto;
  String groupName;
  String groupStatement;

  @override
  void initState() {
    super.initState();

    _controllerName = TextEditingController();
    _controllerStatement = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controllerName.dispose();
    _controllerStatement.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _userView = Provider.of<UserView>(context);
    _chatView = Provider.of<ChatView>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: createGroup,

        child: Icon(Icons.send),
      ),

      appBar: AppbarWidget(
        backgroundColor: Theme.of(context).primaryColor,
        key: _appbarWidgetState,
        appBarType: 'Chat',
        titleImage: ImageWidget(
          imageFit: BoxFit.contain,
          imageWidth: 50,
          imageHeight: 50,
          backgroundShape: BoxShape.circle,
          image: groupPhoto != null
              ? FileImage(groupPhoto)
              : NetworkImage('https://img.webme.com/pic/c/creative-blog/users_black.png'),
        ),
        titleText: 'New group',
        onLeftSideClick: () {
          Navigator.of(context).pop(false);
        },
      ),

      body: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop(false);
          return false;
        },
        child: Container(
          child: ListView(
            shrinkWrap: true,
            children: [

              ContainerColumn(
                padding: EdgeInsets.all(10),

                children: [
                  TitleArea(titleText: 'Grup Bilgisi', icon: Icons.insert_drive_file, iconColor: Theme.of(context).primaryColor),

                  ContainerRow(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) => showModal()
                            );
                          },
                          child: ImageWidget(
                            image: groupPhoto != null
                                ? FileImage(groupPhoto)
                                : NetworkImage('https://img.webme.com/pic/c/creative-blog/users_black.png'),
                            backgroundShape: BoxShape.circle,
                            backgroundColor: Colors.grey.withOpacity(0.3),
                            // backgroundPadding: 5,
                          ),
                        ),
                      ),

                      Expanded(
                          flex: 2,
                          child: ContainerColumn(
                            children: [
                              AlertContainerWidget(
                                  key: _alertContainerWidgetState,
                                  textSize: 10,
                                  areaText: 'Grup ismi boş bırakılamaz.',
                                  areaColor: Colors.red.withOpacity(0.3)
                              ),

                              ContainerRow(
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: TextField(
                                        inputFormatters: [LengthLimitingTextInputFormatter(20)],

                                        onChanged: (value) {
                                          setState(() {
                                            if(value.length <= 20) {
                                              _appbarWidgetState.currentState.updateTitle(value);
                                              groupName = value;
                                            }
                                          });
                                        },
                                        controller: _controllerName,
                                        focusNode: _focusNode,

                                        // maxLength: 20,
                                        // maxLengthEnforced: true,
                                        // buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused}) {
                                        //   return null;
                                        // },
                                        decoration: InputDecoration(
                                          hintText: 'Grup ismini giriniz.',
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),

                                  Container(
                                    width: 50,
                                    child: Text('${groupName != null ? groupName.length : 0} / 20'),
                                  ),
                                ],
                              ),

                              Container(
                                margin: EdgeInsets.only(top: 10),
                                constraints: BoxConstraints(
                                    maxHeight: 200
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(10),
                                ),

                                child: TextField(
                                  controller: _controllerStatement,
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                  onChanged: (value) {
                                    setState(() {
                                      groupStatement = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Grup açıklaması giriniz.',
                                    border: InputBorder.none,
                                  ),
                                ),

                              ),
                            ],
                          )
                      )
                    ],
                  ),

                  TitleArea(titleText: 'Katılımcılar', icon: Icons.people, iconColor: Theme.of(context).primaryColor),
                  Container(
                    child: GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 4 : 8,
                        childAspectRatio: 0.9,

                        children: widget.selectedUserList.map((item) => ContainerColumn(
                              children: [
                                ImageWidget(
                                  image: NetworkImage(item.userProfilePhotoUrl),
                                  imageWidth: 65,
                                  imageHeight: 65,
                                  backgroundShape: BoxShape.circle,
                                  backgroundColor: Colors.grey.withOpacity(0.3),
                                ),
                                Text(item.userName),
                              ],
                            )
                        ).toList(),

                        // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //   crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 4 : 8,
                        // ),

                        // itemBuilder: (BuildContext context, int index) {
                        //
                        //   return ContainerColumn(
                        //     height: 100,
                        //     children: [
                        //       ImageWidget(
                        //         image: NetworkImage(widget.selectedUserList[index].userProfilePhotoUrl),
                        //         imageWidth: 65,
                        //         imageHeight: 65,
                        //         backgroundShape: BoxShape.circle,
                        //         backgroundColor: Colors.grey.withOpacity(0.3),
                        //       ),
                        //       Text(widget.selectedUserList[index].userName),
                        //     ],
                        //   );
                        //
                        // }
                    ),
                  )
                ],
              )

            ],
          ),
        ),
      ),
    );
  }


  void photoFromCamera() async {
    PickedFile pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        groupPhoto = File(pickedFile.path);
      });
    }
  }

  void photoFromGallery() async {
    PickedFile pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        groupPhoto = File(pickedFile.path);
      });
    }
  }

  void createGroup() async {
    if(groupName != null) {
      if(groupName.trim().length > 1) {
        _alertContainerWidgetState.currentState.hideAlert();
        LoadingDialogWidget(operationDetail: 'Grup oluşturuluyor.').show(context);
        List<String> groupMembers = widget.selectedUserList.map((e) => e.userId).toList();
        groupMembers.insert(0, _userView.user.userId);

        String groupId = await _chatView.createGroupId();
        String imageUrl;

        if(groupPhoto != null)
          imageUrl = await _chatView.uploadGroupPhoto(groupId, 'Profile_Photo', groupPhoto);

        GroupModel createdGroup = GroupModel.plural(
            groupId: groupId,
            groupName: groupName,
            groupStatement: groupStatement,
            groupType: 'Plural',
            groupImageUrl: imageUrl != null ? imageUrl : 'https://img.webme.com/pic/c/creative-blog/users_black.png',
            createdBy: _userView.user.userId,
            members: groupMembers,
        );

        GroupModel group = await _chatView.createGroup(_userView.user, createdGroup);
        // _chatView.selectChat(group.groupId);
        Navigator.of(context).pop();
        Navigator.of(context).pop(true);
      } else{
        _alertContainerWidgetState.currentState.showAlert();
      }
    } else {
      setState(() {
        _alertContainerWidgetState.currentState.showAlert();
      });
    }
  }

  showModal() {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('Kamera Kullan'),
            onTap: () => photoFromCamera(),
          ),

          ListTile(
            leading: Icon(Icons.image),
            title: Text('Geleriden Seç'),
            onTap: () => photoFromGallery(),
          )
        ],
      ),
    );
  }
}