import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live_chat/components/common/appbar_widget.dart';
import 'package:live_chat/components/common/container_column.dart';
import 'package:live_chat/components/common/container_row.dart';
import 'package:live_chat/components/common/title_area.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_chatView.groupType == 'Private') {
        _subscriptionUser = _chatView.streamOneUser(_chatView.interlocutorUser.userId).listen((user) {
          _chatView.interlocutorUser = user;
          setState(() {});
        });
      }

    });
  }

  @override
  void dispose() {
    _subscriptionUser.cancel();
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

    return OrientationBuilder(builder: (context, orientation) {
      return orientation == Orientation.portrait
          ? portraitDesign(context, status)
          : landscapeDesign(context, status);
    });
  }



  List<Widget> _userDataWrite() {
    return [
      TitleArea(titleText: 'Hakkında', icon: Icons.person, iconColor: widget.color),
      userDataWidget('Name', _chatView.interlocutorUser.userName),
      userDataWidget('Email', _chatView.interlocutorUser.userEmail),
      userDataWidget('Last Seen', _chatView.interlocutorUser.updatedAt != null ? showDateComposedString(_chatView.interlocutorUser.lastSeen) : 'Yükleniyor...'),
      userDataWidget('Status', _chatView.interlocutorUser.online ? 'Online' : 'Offline'),
      userDataWidget('Registered', _chatView.interlocutorUser.createdAt != null ? showDate(_chatView.interlocutorUser.createdAt)['date'] : 'Yükleniyor...'),
      userDataWidget('Updated', _chatView.interlocutorUser.updatedAt != null ? showDateComposedString(_chatView.interlocutorUser.updatedAt) : 'Yükleniyor...'),
    ];
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

  portraitDesign(BuildContext context, String status) {
    return Scaffold(
      body: CustomScrollView(
        primary: true,
        slivers: [
          Theme(
            data: ThemeData.dark(),
            child: SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height * 0.5,
              pinned: true,
              primary: true,
              backgroundColor: widget.color != null ? widget.color : Colors.amber,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(left: 56, bottom: 10),
                background: Image.network(
                  _chatView.interlocutorUser.userProfilePhotoUrl,
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
                              text: _chatView.interlocutorUser.userName + '\n',
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
                  height: MediaQuery.of(context).size.height - 86,
                  // margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.all(10),

                  children: _userDataWrite(),
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
      child: SafeArea(
        child: ContainerRow(
          children: [

            Container(
              alignment: Alignment.bottomLeft,
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(_chatView.interlocutorUser.userProfilePhotoUrl)
                ),
              ),

              child: Stack(
                children: [

                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 56,
                      child: Theme(
                        data: ThemeData.dark(),
                        child: AppbarWidget(
                          titleText: ' ',
                          backgroundColor: Colors.transparent,
                          textColor: Colors.white,
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
                                  text: _chatView.interlocutorUser.userName + '\n',
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

            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: ContainerColumn(
                  padding: EdgeInsets.all(10),
                  children: _userDataWrite(),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

