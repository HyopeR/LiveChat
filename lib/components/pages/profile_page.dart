import 'dart:io';
import 'package:live_chat/components/common/appbar_widget.dart';
import 'package:live_chat/components/common/custom_expansion_widget.dart';
import 'package:live_chat/components/common/expandable_text.dart';
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
import 'package:live_chat/views/user_view.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserView _userView;

  GlobalKey<AlertContainerWidgetState> _alertContainerWidgetState = GlobalKey();
  GlobalKey<ImageWidgetState> _imageWidgetState = GlobalKey();
  ImagePicker picker = ImagePicker();

  File _profilePhoto;

  TextEditingController _controllerUserName;
  String updateControllerUserName;

  bool showUserData = true;
  bool showUserProfilePhoto = true;

  @override
  void initState() {
    super.initState();
    _controllerUserName = TextEditingController();
  }

  @override
  void dispose() {
    _controllerUserName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _userView = Provider.of<UserView>(context);

    return Scaffold(
      appBar: AppbarWidget(
          backgroundColor: Theme.of(context).primaryColor,
          operationColor: Theme.of(context).primaryColor.withAlpha(180),
          titleText: 'Live Chat',
          actions: [
            FlatButton(
                minWidth: 50,
                child: Icon(Icons.settings),
                onPressed: () => Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => SettingsPage()))
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
                                          labelText: 'Username',
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
                                      onPressed: () async {
                                        bool updateName = await _updateUserName();
                                        bool updatePhoto = await _updateProfilePhoto();

                                        if (updateName || updatePhoto)
                                          _alertContainerWidgetState.currentState.showAlertAddText('Kullanıcı adınız güncellendi.');
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
                                      controller: _controllerUserName,
                                      decoration: InputDecoration(
                                          errorText: updateControllerUserName != null ? updateControllerUserName : null,
                                          labelText: 'Statement',
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
                                      onPressed: () async {
                                        _alertContainerWidgetState.currentState.showAlertAddText('Durumunuz güncellendi.');
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
      userDataWidget('Email', _userView.user.userEmail),
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
              child: ExpandableText(children: [TextSpan(text: value.toString())], text: value.toString(), textSize: Theme.of(context).textTheme.bodyText2.fontSize),
            )),
      ],
    );
  }

  void photoFromCamera() async {
    PickedFile pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _profilePhoto = File(pickedFile.path);
      _alertContainerWidgetState.currentState
          .showAlertAddText('Resim eklendi. Değişiklikleri kaydedin.');
    }
  }

  void photoFromGallery() async {
    PickedFile pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _profilePhoto = File(pickedFile.path);
      _alertContainerWidgetState.currentState
          .showAlertAddText('Resim eklendi. Değişiklikleri kaydedin.');
    }
  }

  Future<bool> _updateUserName() async {
    if (_userView.user.userName != _controllerUserName.text) {
      // setState(() => showUserData = false);
      bool updatedUserName = await _userView.updateUserName(
          _userView.user.userId, _controllerUserName.text);

      if (updatedUserName) {
        setState(() {
          // showUserData = true;
          updateControllerUserName = null;
        });
        return true;
      } else {
        setState(() {
          // showUserData = true;
          updateControllerUserName = 'Bu username zaten kullanılıyor.';
        });
        return false;
      }
    } else
      return false;
  }

  Future<bool> _updateProfilePhoto() async {
    if (_profilePhoto != null) {
      setState(() => showUserProfilePhoto = false);
      _imageWidgetState.currentState.loadingStart();

      var uploadFile = await _userView.updateProfilePhoto(
          _userView.user.userId, 'Profile_Photo', _profilePhoto);

      if (uploadFile != null) {
        setState(() {
          _profilePhoto = null;
          showUserProfilePhoto = true;
        });
        _imageWidgetState.currentState.loadingFinish();

        return true;
      } else
        return false;
    } else
      return false;
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
            onTap: () => photoFromCamera(),
          ),

          ListTile(
            leading:
            Icon(Icons.image),
            title: Text('Geleriden Seç'),
            onTap: () => photoFromGallery(),
          )
        ],
      ),
    );
  }

}
