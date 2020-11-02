import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_chat/components/common/alert_container_widget.dart';
import 'package:live_chat/components/common/alert_dialog_widget.dart';
import 'package:live_chat/components/common/container_column.dart';
import 'package:live_chat/components/common/container_row.dart';
import 'package:live_chat/components/common/image_widget.dart';
import 'package:live_chat/components/common/login_button.dart';
import 'package:live_chat/components/common/title_area.dart';
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

  File _profilePhoto;

  TextEditingController _controllerUserName;
  String updateControllerUserName;

  bool showUserData = true;
  bool showUserProfilePhoto = true;
  bool showForm = true;

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

    if (showUserData) _controllerUserName.text = _userView.user.userName;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          FlatButton(
              onPressed: () => _signOutControl(), child: Icon(Icons.logout))
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ContainerColumn(
            padding: EdgeInsets.all(10),
            children: [
              TitleArea(
                titleText: 'Bilgiler',
                icon: Icons.person,
              ),
              ContainerRow(
                children: [
                  Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
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
                                    });
                              },
                              child: ImageWidget(
                                key: _imageWidgetState,
                                imageUrl: _userView.user.userProfilePhotoUrl,
                                backgroundShape: BoxShape.circle,
                                backgroundColor: Colors.grey.withOpacity(0.3),
                              )
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: IconButton(
                                icon: Icon(!showForm ? Icons.edit : Icons.close),
                                splashRadius: 25,
                                onPressed: () {
                                  setState(() {
                                    showForm = !showForm;
                                  });
                                }
                            ),
                          )
                        ],
                      )),
                  Expanded(
                    flex: 4,
                    child: ContainerColumn(
                      padding: EdgeInsets.all(10),
                      children: showUserData
                          ? _userDataWrite()
                          : [Center(child: CircularProgressIndicator())],
                    ),
                  ),
                ],
              ),
              AlertContainerWidget(
                  key: _alertContainerWidgetState,
                  areaText: 'Profil güncelleme başarılı.',
              ),
              showForm
                  ? ContainerColumn(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TitleArea(
                          titleText: 'Bilgileri Güncelle',
                          icon: Icons.insert_drive_file
                        ),
                        TextFormField(
                          controller: _controllerUserName,
                          decoration: InputDecoration(
                              errorText: updateControllerUserName != null ? updateControllerUserName : null,
                              labelText: 'Username',
                              hintText: 'Enter username',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        LoginButton(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          buttonText: 'Değişiklikleri Kaydet',
                          buttonRadius: 10,
                          buttonHeight: 40,
                          textColor: Colors.black,
                          buttonColor: Theme.of(context).primaryColor,
                          onPressed: () async {
                            bool updateName = await _updateUserName();
                            bool updatePhoto = await _updateProfilePhoto();

                            if(updateName || updatePhoto)
                              _alertContainerWidgetState.currentState.showAlert();
                          },
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _userDataWrite() {
    List<Widget> usersData = [];

    _userView.user.toMap().forEach((key, value) {
      if (key != 'userProfilePhotoUrl' && key != 'userId')
        usersData.add(
          ContainerRow(
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
          ),
        );
    });

    return usersData;
  }

  void photoFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile.path != null)
      _profilePhoto = File(pickedFile.path);
  }

  void photoFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile.path != null)
      _profilePhoto = File(pickedFile.path);
  }

  Future<bool> _updateUserName() async {
    if (_userView.user.userName != _controllerUserName.text) {
      setState(() => showUserData = false);
      bool updatedUserName = await _userView.updateUserName(_userView.user.userId, _controllerUserName.text);

      if (updatedUserName) {
        setState(() {
          showUserData = true;
          updateControllerUserName = null;
        });
        return true;
      } else {
        setState(() {
          showUserData = true;
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

      var uploadFile = await _userView.uploadFile(
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

  Future _signOutControl() async {
    AlertDialogWidget(
      alertTitle: 'Çıkış',
      alertContent: 'Çıkmak istediğinizden emin misiniz?',
      completeActionText: 'Evet',
      cancelActionText: 'Vazgeç',
    ).show(context).then((value) {
      if (value) _signOut();
    });
  }

  _signOut() async {
    _userView.signOut();
    Navigator.of(context, rootNavigator: true)
        .pushReplacementNamed('/signInPage');
  }
}
