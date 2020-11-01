import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_chat/components/common/alert_dialog_widget.dart';
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

  File _profilePhoto;

  TextEditingController _controllerUserName;
  String detailUpdate;

  bool showUserData = true;
  bool showForm = false;

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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              TitleArea(
                titleText: 'Bilgiler',
                icon: Icon(
                  Icons.person,
                  size: 24,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
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
                                imageUrl: _userView.user.userProfilePhotoUrl,
                                backgroundShape: BoxShape.circle,
                                backgroundColor: Colors.grey.withOpacity(0.3),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: IconButton(
                                  splashRadius: 25,
                                  icon: Icon(
                                      !showForm ? Icons.edit : Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      showForm = !showForm;
                                    });
                                  }),
                            )
                          ],
                        )),
                    Expanded(
                        flex: 4,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: showUserData
                                ? _userDataWrite()
                                : [Center(child: CircularProgressIndicator())],
                          ),
                        )),
                  ],
                ),
              ),
              showForm
                  ? Container(
                      child: Column(
                        children: [
                          TitleArea(
                            titleText: 'Bilgileri Güncelle',
                            icon: Icon(
                              Icons.insert_drive_file,
                              size: 24,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          detailUpdate != null
                              ? Container(
                                  margin: EdgeInsets.only(bottom: 20),
                                  alignment: Alignment.centerLeft,
                                  child: Text(detailUpdate))
                              : Container(),
                          TextFormField(
                            controller: _controllerUserName,
                            decoration: InputDecoration(
                                labelText: 'Username',
                                hintText: 'Enter username',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                          LoginButton(
                            buttonText: 'Değişiklikleri Kaydet',
                            buttonRadius: 10,
                            buttonHeight: 40,
                            textColor: Colors.black,
                            buttonColor: Theme.of(context).primaryColor,
                            onPressed: () => _updateUserName(),
                          ),
                        ],
                      ),
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
        usersData.add(Container(
          margin: EdgeInsets.symmetric(vertical: 3),
          child: Row(
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
        ));
    });

    return usersData;
  }

  void photoFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile.path != null)
      setState(() {
        _profilePhoto = File(pickedFile.path);
      });
  }

  void photoFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile.path != null)
      setState(() {
        _profilePhoto = File(pickedFile.path);
      });
  }

  void _updateUserName() async {
    if (_userView.user.userName != _controllerUserName.text) {
      setState(() => showUserData = false);
      bool updatedUserName = await _userView.updateUserName(
          _userView.user.userId, _controllerUserName.text);

      if (updatedUserName) {
        setState(() {
          showUserData = true;
          detailUpdate = 'Username güncellendi.';
        });
      } else {
        setState(() {
          showUserData = true;
          detailUpdate = 'Bu username zaten kullanılıyor.';
        });
      }
    } else {
      AlertDialogWidget(
        alertTitle: 'Hata',
        alertContent: 'Değişiklik yapmadınız.',
        complateActionText: 'Tamam',
      ).show(context);
    }
  }

  Future _signOutControl() async {
    AlertDialogWidget(
      alertTitle: 'Çıkış',
      alertContent: 'Çıkmak istediğinizden emin misiniz?',
      complateActionText: 'Evet',
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
