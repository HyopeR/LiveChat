import 'dart:io';
import 'package:live_chat/components/common/appbar_widget.dart';
import 'package:live_chat/components/common/custom_expansion_widget.dart';
import 'package:live_chat/components/common/expandable_text.dart';
import 'package:live_chat/components/pages/photo_preview_page.dart';
import 'package:live_chat/components/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_chat/components/common/alert_container_widget.dart';
import 'package:live_chat/components/common/container_column.dart';
import 'package:live_chat/components/common/container_row.dart';
import 'package:live_chat/components/common/image_widget.dart';
import 'package:live_chat/components/common/login_button.dart';
import 'package:live_chat/components/common/title_area.dart';
import 'package:live_chat/models/user_model.dart';
import 'package:live_chat/views/chat_view.dart';
import 'package:live_chat/views/user_view.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserView _userView;
  ChatView _chatView;

  GlobalKey<AlertContainerWidgetState> _alertContainerWidgetState = GlobalKey();
  GlobalKey<ImageWidgetState> _imageWidgetState = GlobalKey();
  ImagePicker picker = ImagePicker();

  File _profilePhoto;

  TextEditingController _controllerUserName;
  String updateControllerUserName;

  TextEditingController _controllerStatement;

  bool showUserData = true;
  bool showUserProfilePhoto = true;

  @override
  void initState() {
    super.initState();
    _controllerUserName = TextEditingController();
    _controllerStatement = TextEditingController();
  }

  @override
  void dispose() {
    _controllerUserName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _userView = Provider.of<UserView>(context);
    _chatView = Provider.of<ChatView>(context);

    return Scaffold(
      appBar: AppbarWidget(
          backgroundColor: Theme.of(context).primaryColor,
          operationColor: Theme.of(context).primaryColor.withAlpha(180),
          titleText: 'Live Chat',
          actions: [
            FlatButton(
                minWidth: 50,
                child: Icon(Icons.settings),
                onPressed: () => Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => SettingsPage())).then((value) {
                  if(value) {
                    _signOut();
                  }
                })
            ),
          ]
      ),


      body: SafeArea(
        child: SingleChildScrollView(
          child: ContainerColumn(
            padding: EdgeInsets.all(10),
            children: [
              TitleArea(
                titleText: 'Bilgilerim',
                icon: Icons.person,
                iconColor: Theme.of(context).primaryColor
              ),
              StreamBuilder<UserModel>(
                  stream: _userView.streamCurrentUser(_userView.user.userId),
                  builder: (context, streamData) {

                    if (_userView.user.userName != null) {
                      _controllerUserName.text = _userView.user.userName;
                      if(_userView.user.userStatement != null)
                        _controllerStatement.text = _userView.user.userStatement;

                      return ContainerColumn(
                        children: [
                          ContainerRow(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                                context: context,
                                                builder: (context) => showModal());
                                          },
                                          child: ImageWidget(
                                            key: _imageWidgetState,
                                            image: NetworkImage(_userView.user.userProfilePhotoUrl),
                                            backgroundShape: BoxShape.circle,
                                            backgroundColor:
                                                Colors.grey.withOpacity(0.3),
                                          )),
                                    ],
                                  )),
                              Expanded(
                                flex: 4,
                                child: ContainerColumn(
                                  padding: EdgeInsets.all(10),
                                  children: _userDataWrite(),
                                ),
                              ),
                            ],
                          ),
                          AlertContainerWidget(
                            areaColor: Theme.of(context).primaryColor,
                            key: _alertContainerWidgetState,
                          ),

                          ContainerColumn(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TitleArea(
                                  titleText: 'Bilgileri Güncelle',
                                  icon: Icons.insert_drive_file,
                                  iconColor: Theme.of(context).primaryColor
                              ),

                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(width: 2, color: Colors.grey.withOpacity(0.3))
                                ),
                                margin: EdgeInsets.only(top: 5),
                                child: CustomExpansionWidget(
                                  title: 'Kullanıcı Adı',
                                  childrenPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  children: [
                                    TextFormField(
                                      controller: _controllerUserName,
                                      decoration: InputDecoration(
                                          errorText: updateControllerUserName != null ? updateControllerUserName : null,
                                          hintText: 'Kullanıcı adı giriniz.',
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10)
                                          )
                                      ),
                                    ),

                                    LoginButton(
                                      margin: EdgeInsets.symmetric(vertical: 10),
                                      buttonText: 'Kullanıcı Adını Güncelle',
                                      buttonRadius: 10,
                                      buttonHeight: 40,
                                      textColor: Colors.black,
                                      buttonColor:
                                      Theme.of(context).primaryColor,
                                      onPressed: () {
                                        _updateUserName();
                                      },
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(width: 2, color: Colors.grey.withOpacity(0.3))
                                ),
                                margin: EdgeInsets.only(top: 5),
                                child: CustomExpansionWidget(
                                  title: 'Durum',
                                  childrenPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  children: [
                                    TextFormField(
                                      maxLines: null,
                                      controller: _controllerStatement,
                                      decoration: InputDecoration(
                                          hintText: 'Durum giriniz.',
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10)
                                          )
                                      ),
                                    ),

                                    LoginButton(
                                      margin: EdgeInsets.symmetric(vertical: 10),
                                      buttonText: 'Durumu Güncelle',
                                      buttonRadius: 10,
                                      buttonHeight: 40,
                                      textColor: Colors.black,
                                      buttonColor:
                                      Theme.of(context).primaryColor,
                                      onPressed: () {
                                        _updateUserStatement();
                                      },
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _userDataWrite() {
    return [
      userDataWidget('İsim', _userView.user.userName),
      // userDataWidget('Email', _userView.user.userEmail),
      userDataWidget('Durum', _userView.user.userStatement ?? 'Durum güncellemesi yok.')
      // userDataWidget('Last Seen', _userView.user.updatedAt != null ? showDateComposedString(_userView.user.lastSeen) : 'Yükleniyor...'),
      // userDataWidget('Status', _userView.user.online ? 'Online' : 'Offline'),
      // userDataWidget('Registered', _userView.user.createdAt != null ? showDate(_userView.user.createdAt)['date'] : 'Yükleniyor...'),
      // userDataWidget('Updated', _userView.user.updatedAt != null ? showDateComposedString(_userView.user.updatedAt) : 'Yükleniyor...'),
    ];
  }

  Widget userDataWidget(String key, dynamic value) {
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
              child: ExpandableText(
                  maxCharCount: 200,
                  children: [TextSpan(text: value.toString())],
                  text: value.toString(), textSize: Theme.of(context).textTheme.bodyText2.fontSize),
            )),
      ],
    );
  }

  void chosePhoto(String methodName) async {
    PickedFile pickedFile;

    switch (methodName) {
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
      _profilePhoto = File(pickedFile.path);
      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => PhotoPreviewPage(file: _profilePhoto))).then((file) async {
        Navigator.of(context).pop();
        if(file != null) {
          _profilePhoto = file;
          _updateProfilePhoto();
        }
      });
    }
  }

  Future<void> _updateUserName() async {
    if (_userView.user.userName != _controllerUserName.text) {
      bool updatedUserName = await _userView.updateUserName(_userView.user.userId, _controllerUserName.text);

      if (updatedUserName) {
        _alertContainerWidgetState.currentState.showAlertAddText('Kullanıcı adınız güncellendi.');
        setState(() {
          updateControllerUserName = null;
        });
      } else {
        setState(() {
          updateControllerUserName = 'Bu username zaten kullanılıyor.';
        });
      }
    }
  }

  Future<void> _updateUserStatement() async {
    if (_userView.user.userStatement != _controllerStatement.text) {
      bool updatedUserStatement = await _userView.updateStatement(_userView.user.userId, _controllerStatement.text);

      if (updatedUserStatement) {
        _alertContainerWidgetState.currentState.showAlertAddText('Durumunuz güncellendi.');
      } else {
        _alertContainerWidgetState.currentState.showAlertAddText('Durum güncelleme sırasında hata.');
      }
    }
  }

  Future<void> _updateProfilePhoto() async {
    if (_profilePhoto != null) {
      setState(() => showUserProfilePhoto = false);
      _imageWidgetState.currentState.loadingStart();

      var uploadFile = await _userView.updateProfilePhoto(_userView.user.userId, 'Profile_Photo', _profilePhoto);

      if (uploadFile != null) {
        _alertContainerWidgetState.currentState.showAlertAddText('Profil resminiz güncellendi.');

        setState(() {
          _profilePhoto = null;
          showUserProfilePhoto = true;
        });
        _imageWidgetState.currentState.loadingFinish();
      }
    }
  }

  showModal() {
    return SafeArea(
      child: Column(
        mainAxisSize:
        MainAxisSize.min,
        children: [

          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('Kamera Kullan'),
            onTap: () => chosePhoto('Camera'),
          ),

          ListTile(
            leading:
            Icon(Icons.image),
            title: Text('Geleriden Seç'),
            onTap: () => chosePhoto('Gallery'),
          )
        ],
      ),
    );
  }

  _signOut() async {
    _userView.logoutUpdate(_userView.user.userId);
    _userView.signOut();
    Navigator.of(context, rootNavigator: true).pushReplacementNamed('/signInPage');
    _chatView.clearState();
  }

}
