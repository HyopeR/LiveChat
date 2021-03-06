import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_chat/components/common/alert_dialog_widget.dart';
import 'package:live_chat/components/common/appbar_widget.dart';
import 'package:live_chat/components/common/container_column.dart';
import 'package:live_chat/components/common/container_row.dart';
import 'package:live_chat/components/common/expandable_text.dart';
import 'package:live_chat/components/common/image_widget.dart';
import 'package:live_chat/components/common/user_dialog_widget.dart';
import 'package:live_chat/components/pages/chat_page.dart';
import 'package:live_chat/components/pages/photo_preview_page.dart';
import 'package:live_chat/components/pages/profile_photo_show_page.dart';
import 'package:live_chat/models/group_model.dart';
import 'package:live_chat/models/user_model.dart';
import 'package:live_chat/services/operation_service.dart';
import 'package:live_chat/views/chat_view.dart';
import 'package:live_chat/views/user_view.dart';
import 'package:provider/provider.dart';

class UserPreviewPage extends StatefulWidget {
  final Color color;
  const UserPreviewPage({Key key, this.color}) : super(key: key);

  @override
  _UserPreviewPageState createState() => _UserPreviewPageState();
}

class _UserPreviewPageState extends State<UserPreviewPage> {
  ChatView _chatView;
  UserView _userView;
  Color pageColor;

  StreamSubscription<UserModel> _subscriptionUser;
  StreamSubscription<GroupModel> _subscriptionGroup;

  ImagePicker picker = ImagePicker();

  TextEditingController groupNameController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    groupNameController = TextEditingController();
    pageColor = widget.color;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_chatView.groupType == 'Private') {
        _subscriptionUser = _chatView.streamOneUser(_chatView.interlocutorUser.userId).listen((user) {
          _chatView.interlocutorUser = user;
          setState(() {});
        });
      } else {
        _subscriptionGroup = _chatView.streamOneGroup(_chatView.selectedChat.groupId).listen((group) {
          _chatView.selectedChat = group;
        });
      }

    });
  }

  @override
  void dispose() {
    groupNameController.dispose();

    if(_subscriptionUser != null)
      _subscriptionUser.cancel();

    if(_subscriptionGroup != null)
      _subscriptionGroup.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _chatView = Provider.of<ChatView>(context);
    _userView = Provider.of<UserView>(context);
    if(_chatView.groupType == 'Plural')
      groupNameController.text = _chatView.selectedChat.groupName;

    String status = _chatView.groupType == 'Private'
        ? _chatView.interlocutorUser.online
          ? 'Online'
          : showDateComposedString(_chatView.interlocutorUser.lastSeen)
        : 'Grup';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.black.withOpacity(0.3),
        statusBarIconBrightness: Brightness.light,
      ),
      child: OrientationBuilder(builder: (context, orientation) {
        return orientation == Orientation.portrait
            ? portraitDesign(context, status)
            : landscapeDesign(context, status);
      }),
    );
  }

  Widget mainDataArea(List<Widget> children) {
    return ContainerColumn(
      crossAxisAlignment: CrossAxisAlignment.stretch,

      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 20),

      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 1), //(x,y)
            blurRadius: 6,
          ),
        ],
      ),
      children: children,
    );
  }

  Widget userDataWrite(String key, dynamic value) {
    return ContainerRow(
      crossAxisAlignment: CrossAxisAlignment.start,
      margin: EdgeInsets.symmetric(vertical: 3),
      children: [
        Expanded(
          flex: 2,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.withOpacity(0.3),
            ),
            child: Text('$key:'),
          ),
        ),
        Expanded(
            flex: 4,
            child: Container(
              margin: EdgeInsets.only(left: 3),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.withOpacity(0.3),
              ),
              child: Text(value.toString()),
            )),
      ],
    );
  }
  Widget groupUserWrite(UserModel user) {
    return Container(
      margin: EdgeInsets.only(top: 5),

      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {},

        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
          leading: InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              if(user.userId != _userView.user.userId) {
                UserDialogWidget(
                  name: user.userName,
                  photoUrl: user.userProfilePhotoUrl,

                  onPhotoClick: () {

                    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                        builder: (context) => ProfilePhotoShowPage(name: user.userName, photoUrl: user.userProfilePhotoUrl, id: user.userId))
                    );
                  },

                  onChatClick: () {
                    _chatView.findChatByUserIdList([
                      _userView.user.userId,
                      user.userId
                    ]);

                    _chatView.interlocutorUser = user;
                    _chatView.groupType = 'Private';

                    Navigator.popUntil(context, ModalRoute.withName('/homePage'));
                    _chatView.listeningChat = true;
                    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => ChatPage()));
                  },

                  onDetailClick: () async {
                    _chatView.findChatByUserIdList([
                      _userView.user.userId,
                      user.userId
                    ]);

                    _chatView.interlocutorUser = user;
                    _chatView.groupType = 'Private';

                    Navigator.popUntil(context, ModalRoute.withName('/homePage'));
                    Color userColor = await getDynamicColor(_chatView.interlocutorUser.userProfilePhotoUrl);
                    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => UserPreviewPage(color: userColor)));
                  },
                ).show(context);
              }
            },
            child: Hero(
              tag: user.userId,
              child: ImageWidget(
                image: NetworkImage(user.userProfilePhotoUrl),
                imageWidth: 75,
                imageHeight: 75,
                backgroundShape: BoxShape.circle,
                backgroundColor: Colors.grey.withOpacity(0.3),
              ),
            ),
          ),
          title: Text(user.userName),
          subtitle: Text(user.userEmail),
        ),
      ),
    );
  }

  List<Widget> _userDataWrite() {
    return [
      mainDataArea([
        Container(
          margin: EdgeInsets.only(bottom: 5),
          child: Text('Durum', style: TextStyle(
              fontSize: Theme.of(context).textTheme.headline6.fontSize,
              color: pageColor,
              shadows: [Shadow(color: Colors.black, offset: Offset(0, 1), blurRadius: 5)]
            )
          ),
        ),
        Container(
          child: ExpandableText(
              children: [TextSpan(text: _chatView.interlocutorUser.userStatement ?? 'Durum güncellmesi yok.', style: TextStyle(color: Colors.black))],
              text: _chatView.interlocutorUser.userStatement ?? 'Durum güncellmesi yok.'
          ),
        )
      ]),

      mainDataArea([
        Container(
          margin: EdgeInsets.only(bottom: 5),
          child: Text('Hakkında', style: TextStyle(
              fontSize: Theme.of(context).textTheme.headline6.fontSize,
              color: pageColor,
              shadows: [Shadow(color: Colors.black, offset: Offset(0, 1), blurRadius: 5)]
            )
          ),
        ),
        userDataWrite('İsim', _chatView.interlocutorUser.userName),
        userDataWrite('Email', _chatView.interlocutorUser.userEmail),
        userDataWrite('Son Görülme', _chatView.interlocutorUser.online
            ? 'Online'
            : _chatView.interlocutorUser.lastSeen != null
            ? showDateComposedString(_chatView.interlocutorUser.lastSeen)
            : 'Yükleniyor...'
        ),
        userDataWrite('Durum', _chatView.interlocutorUser.userStatement ?? 'Durum güncellemesi yok.'),
      ]),
    ];
  }
  List<Widget> _groupDataWrite() {
    return [
      mainDataArea(
          [
            Container(
              margin: EdgeInsets.only(bottom: 5),
              child: Text('Açıklama', style: TextStyle(
                      fontSize: Theme.of(context).textTheme.headline6.fontSize,
                      color: pageColor,
                      shadows: [Shadow(color: Colors.black, offset: Offset(0, 1), blurRadius: 5)]
                  )
              ),
            ),
            ExpandableText(
                children: [TextSpan(text: _chatView.selectedChat.groupStatement, style: TextStyle(color: Colors.black))],
                text: _chatView.selectedChat.groupStatement
            )
          ]
      ),

      mainDataArea(
          [
            ContainerRow(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              margin: EdgeInsets.only(bottom: 5),
              children: [
                Text('Katılımcılar', style: TextStyle(
                    fontSize: Theme.of(context).textTheme.headline6.fontSize,
                    color: pageColor,
                    shadows: [Shadow(color: Colors.black, offset: Offset(0, 1), blurRadius: 5)]
                  )
                ),

                Text('(${_chatView.groupUsers.length})', style: TextStyle(
                    fontSize: Theme.of(context).textTheme.headline6.fontSize,
                    color: pageColor,
                    shadows: [Shadow(color: Colors.black, offset: Offset(0, 1), blurRadius: 5)]
                  )
                ),
              ],
            ),
            ContainerColumn(
              children: _chatView.groupUsers.map((user) {
                return groupUserWrite(user);
              }).toList(),
            )
          ]
      ),
    ];
  }

  Widget portraitDesign(BuildContext context, String status) {
    return Scaffold(
      body: CustomScrollView(
        primary: true,
        slivers: [
          Theme(
            data: Theme.of(context).copyWith(
              primaryColorBrightness: Brightness.dark,
              primaryIconTheme: IconThemeData(
                  color: Colors.white
              )
            ),
            child: SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height * 0.5,
              pinned: true,
              primary: true,
              actions: _chatView.groupType == 'Private'
                  ? []
                  : [
                    IconButton(
                        icon: Icon(Icons.photo),
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => showModal()
                          );
                        }
                    ),

                    IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => updateGroupName(),
                    )
                  ],
              backgroundColor: pageColor != null ? pageColor : Colors.amber,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(left: 56, bottom: 10),
                background: InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                        builder: (context) => ProfilePhotoShowPage(
                            name: _chatView.groupType == 'Private' ? _chatView.interlocutorUser.userName : _chatView.selectedChat.groupName,
                            photoUrl: _chatView.groupType == 'Private' ? _chatView.interlocutorUser.userProfilePhotoUrl : _chatView.selectedChat.groupImageUrl,
                            id:  _chatView.groupType == 'Private' ? _chatView.interlocutorUser.userId : _chatView.selectedChat.groupId,
                        )
                        )
                    );
                  },
                  child: Image.network(
                    _chatView.groupType == 'Private' ? _chatView.interlocutorUser.userProfilePhotoUrl : _chatView.selectedChat.groupImageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Align(
                  alignment: Alignment.bottomLeft,
                  child: RichText(
                    softWrap: false,
                    text: TextSpan(
                        style: TextStyle(shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: Offset(1, 1),
                            blurRadius: 10,
                          ),
                        ]),
                        children: [
                          TextSpan(
                              text: _chatView.groupType == 'Private' ? _chatView.interlocutorUser.userName + '\n' : _chatView.selectedChat.groupName +'\n',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: Theme.of(context).textTheme.headline6.fontSize)),

                          TextSpan(
                              text: status,
                              style: TextStyle(fontSize: Theme.of(context).textTheme.bodyText2.fontSize)),
                        ]
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              child: ContainerColumn(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 80,
                ),
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _chatView.groupType == 'Private' ? _userDataWrite() : _groupDataWrite(),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget landscapeDesign(BuildContext context, String status) {
    return Material(
      elevation: 0,
      child: ContainerRow(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            alignment: Alignment.bottomLeft,
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(_chatView.groupType == 'Private' ? _chatView.interlocutorUser.userProfilePhotoUrl : _chatView.selectedChat.groupImageUrl)
              ),
            ),

            child: Stack(
              children: [

                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 86,
                    child: Theme(
                      data: Theme.of(context).copyWith(
                          primaryColorBrightness: Brightness.dark,
                          primaryIconTheme: IconThemeData(
                              color: Colors.white
                          ),
                      ),
                      child: AppbarWidget(
                        titleText: ' ',
                        backgroundColor: Colors.transparent,
                        textColor: Colors.white,
                        actions: _chatView.groupType == 'Private'
                            ? []
                            : [
                              IconButton(
                                  icon: Icon(Icons.photo),
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) => showModal()
                                    );
                                  }
                              ),

                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => updateGroupName(),
                              )
                            ]
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: RichText(
                      text: TextSpan(
                          style: TextStyle(shadows: [
                            Shadow(
                              color: Colors.black,
                              offset: Offset(1, 1),
                              blurRadius: 10,
                            ),
                          ]),
                          children: [
                            TextSpan(
                                text: _chatView.groupType == 'Private' ? _chatView.interlocutorUser.userName + '\n' : _chatView.selectedChat.groupName +'\n',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),

                            TextSpan(
                                text: status,
                                style: TextStyle(fontSize: 16)),
                          ]
                      ),
                    ),
                  ),
                ),

              ],
            )
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: ContainerColumn(
                width: MediaQuery.of(context).size.width * 0.6,

                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _chatView.groupType == 'Private' ? _userDataWrite() : _groupDataWrite(),
              ),
            ),
          ),

        ],
      ),
    );
  }

  void chosePhoto(String methodName) async {
    PickedFile pickedFile;

    switch(methodName) {
      case('Camera'):
        pickedFile = await picker.getImage(source: ImageSource.camera);
        break;
      case('Gallery'):
        pickedFile = await picker.getImage(source: ImageSource.gallery);
        break;
      default:
        break;
    }

    if (pickedFile != null) {
      File file = File(pickedFile.path);
      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => PhotoPreviewPage(file: file))).then((croppedFile) async {
        Navigator.of(context).pop();
        if(croppedFile != null) {
          String imgUrl = await _chatView.uploadGroupPhoto(_chatView.selectedChat.groupId, 'Profile_Photo', croppedFile);
          bool result = await _chatView.updateGroupPhoto(_chatView.selectedChat.groupId, imgUrl);
          Color newPageColor = await getDynamicColor(imgUrl);

          if(result)
            setState(() {
              pageColor = newPageColor;
            });
        }
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
            onTap: () => chosePhoto('Camera'),
          ),

          ListTile(
            leading: Icon(Icons.image),
            title: Text('Geleriden Seç'),
            onTap: () => chosePhoto('Gallery'),
          )
        ],
      ),
    );
  }

  Future updateGroupName() async {
    AlertDialogWidget(
      alertTitle: 'Grup İsmi',
      alertChildren: [
        Container(
          child: Form(
            key: formKey,
            child: TextFormField(
              maxLength: 30,
              maxLengthEnforced: true,
              controller: groupNameController,
              validator: (value) {
                if(value.trim().isEmpty) {
                  return 'Grup ismi boş olamaz.';
                } else if(value.trim() == _chatView.selectedChat.groupName) {
                  return 'Varolan grup ismiyle aynı.';
                }

                return null;
              },
              decoration: InputDecoration(
                  hintText: 'Grup ismi giriniz.',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  )
              ),
            ),
          ),
        )
      ],
      completeActionText: 'Güncelle',
      cancelActionText: 'Vazgeç',
      completeAction: () async {
        if(formKey.currentState.validate()) {
          bool result = await _chatView.updateGroupName(_chatView.selectedChat.groupId, groupNameController.text);

          if(result) {
            Navigator.of(context).pop();
            setState(() {});
          }
        }
      },
    ).show(context);
  }
}

