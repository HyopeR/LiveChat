import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_chat/components/common/appbar_widget.dart';
import 'package:live_chat/components/common/container_column.dart';
import 'package:live_chat/components/common/container_row.dart';
import 'package:live_chat/components/common/title_area.dart';
import 'package:live_chat/models/group_model.dart';
import 'package:live_chat/models/user_model.dart';
import 'package:live_chat/services/operation_service.dart';
import 'package:live_chat/views/chat_view.dart';
import 'package:provider/provider.dart';

class UserPreviewPage extends StatefulWidget {
  final Color color;
  const UserPreviewPage({Key key, this.color}) : super(key: key);

  @override
  _UserPreviewPageState createState() => _UserPreviewPageState();
}

class _UserPreviewPageState extends State<UserPreviewPage> {
  ChatView _chatView;
  StreamSubscription<UserModel> _subscriptionUser;
  StreamSubscription<GroupModel> _subscriptionGroup;

  ImagePicker picker = ImagePicker();


  @override
  void initState() {
    super.initState();
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
    if(_subscriptionUser != null)
      _subscriptionUser.cancel();

    if(_subscriptionGroup != null)
      _subscriptionGroup.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _chatView = Provider.of<ChatView>(context);

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

  Widget userDataWidget(String key, dynamic value) {
    return ContainerRow(
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

  List<Widget> _userDataWrite() {
    return [
      TitleArea(titleText: 'Hakkında', icon: Icons.person, iconColor: widget.color),
      userDataWidget('Name', _chatView.interlocutorUser.userName),
      userDataWidget('Email', _chatView.interlocutorUser.userEmail),
      userDataWidget('Last Seen', _chatView.interlocutorUser.updatedAt != null
          ? showDateComposedString(_chatView.interlocutorUser.lastSeen)
          : 'Yükleniyor...'),

      userDataWidget('Status', _chatView.interlocutorUser.online
          ? 'Online'
          : 'Offline'),
      userDataWidget('Registered', _chatView.interlocutorUser.createdAt != null ? showDate(_chatView.interlocutorUser.createdAt)['date'] : 'Yükleniyor...'),
      userDataWidget('Updated', _chatView.interlocutorUser.updatedAt != null ? showDateComposedString(_chatView.interlocutorUser.updatedAt) : 'Yükleniyor...'),
    ];
  }

  List<Widget> _groupDataWrite() {
    return [
      ContainerColumn(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        padding: EdgeInsets.all(10),
        children: [
          Text('Açıklama', style: TextStyle(fontSize: Theme.of(context).textTheme.headline6.fontSize)),
          RichText(
              text: TextSpan()
          )
        ],
      ),

      ContainerColumn(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Medyalar'),
        ],
      )
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
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => showModal()
                          );
                        }
                    )
                  ],
              backgroundColor: widget.color != null ? widget.color : Colors.amber,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(left: 56, bottom: 10),
                background: Image.network(
                  _chatView.groupType == 'Private' ? _chatView.interlocutorUser.userProfilePhotoUrl : _chatView.selectedChat.groupImageUrl,
                  fit: BoxFit.cover,
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
            child: SafeArea(
              child: SingleChildScrollView(
                child: ContainerColumn(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _chatView.groupType == 'Private' ? _userDataWrite() : _groupDataWrite(),
                ),
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
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) => showModal()
                                    );
                                  }
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

  void photoFromCamera() async {
    PickedFile pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      String imgUrl = await _chatView.uploadGroupPhoto(_chatView.selectedChat.groupId, 'Profile_Photo', file);
      bool result = await _chatView.updateGroupPhoto(_chatView.selectedChat.groupId, imgUrl);

      if(result)
        setState(() {});
    }
  }

  void photoFromGallery() async {
    PickedFile pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      String imgUrl = await _chatView.uploadGroupPhoto(_chatView.selectedChat.groupId, 'Profile_Photo', file);
      bool result = await _chatView.updateGroupPhoto(_chatView.selectedChat.groupId, imgUrl);

      if(result)
        setState(() {});
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

