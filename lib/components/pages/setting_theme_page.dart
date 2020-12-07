import 'dart:io';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_chat/components/common/appbar_widget.dart';
import 'package:live_chat/components/common/container_column.dart';
import 'package:live_chat/components/common/container_row.dart';
import 'package:live_chat/components/common/login_button.dart';
import 'package:live_chat/components/common/title_area.dart';
import 'package:live_chat/views/user_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
List<Map<String, dynamic>> colorList = [
  {'name': 'orange', 'color': Colors.orange},
  {'name': 'blue', 'color': Colors.blue},
  {'name': 'amber', 'color': Colors.amber},
  {'name': 'green', 'color': Colors.green},
  {'name': 'purple', 'color': Colors.purple},
  {'name': 'teal', 'color': Colors.teal},
];

class SettingThemePage extends StatefulWidget {
  @override
  _SettingThemePageState createState() => _SettingThemePageState();
}

class _SettingThemePageState extends State<SettingThemePage> {
  UserView _userView;
  SharedPreferences _sharedPreferences;

  ImagePicker picker = ImagePicker();

  bool wallpaperLoading = false;
  File chatWallpaper;


  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((sharedPreferences) => _sharedPreferences = sharedPreferences);
  }

  @override
  Widget build(BuildContext context) {
    _userView = Provider.of<UserView>(context);

    return Scaffold(
      appBar: AppbarWidget(
        backgroundColor: Theme.of(context).primaryColor,
        onLeftSideClick: () {
          Navigator.of(context).pop();
        },

        titleText: 'Tema',
      ),

      body: ListView(
        children: [

          ContainerColumn(
            padding: EdgeInsets.all(10),
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              TitleArea(titleText: 'Tema Renkleri', icon: Icons.palette, iconColor: Theme.of(context).primaryColor),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 3 : 6,
                childAspectRatio: 2,

                children: colorList.map((colorMap) => Container(
                  margin: EdgeInsets.all(3),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                        splashRadius: 25,
                        icon: Icon(Icons.format_color_fill, color: colorMap['color']),
                        onPressed: () => changeThemeColor(colorMap['name'], colorMap['color'])
                      ),
                  ),
                  )
                ).toList(),
              ),

              TitleArea(titleText: 'Konuşma Arkaplanı', icon: Icons.wallpaper, iconColor: Theme.of(context).primaryColor),
              ContainerRow(
                crossAxisAlignment: CrossAxisAlignment.center,

                margin: EdgeInsets.all(3),
                children: [
                  Expanded(
                    flex: 1,
                    child: ContainerColumn(
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [
                        Container(
                          constraints: BoxConstraints(
                            maxHeight: 200
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(_userView.user.userWallpaper)
                              )
                            ),
                            child: wallpaperLoading
                              ? Center(child: CircularProgressIndicator())
                              : Container(),
                          ),
                        )
                      ],
                    ),
                  ),

                  Expanded(
                    flex: 2,
                    child: ContainerColumn(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      margin: EdgeInsets.only(left: 10),

                      children: [
                        LoginButton(
                          buttonText: 'Galeriden Seç',
                          buttonColor: Colors.grey[200],
                          buttonRadius: 10,
                          icon: Icon(Icons.image),
                          textColor: Colors.black,
                          onPressed: () => chosePhoto('Gallery'),
                        ),

                        LoginButton(
                          buttonText: 'Kameradan Seç',
                          buttonColor: Colors.grey[200],
                          buttonRadius: 10,
                          icon: Icon(Icons.camera_alt),
                          textColor: Colors.black,
                          onPressed: () => chosePhoto('Camera'),
                        ),

                        LoginButton(
                          buttonText: 'Varsayılan',
                          buttonColor: Colors.grey[200],
                          buttonRadius: 10,
                          icon: Icon(Icons.history),
                          textColor: Colors.black,
                          onPressed: () => returnDefaultChatWallpaper(),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),

        ],
      ),
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
      setState(() {
        wallpaperLoading = true;
      });

      chatWallpaper = File(pickedFile.path);
      await _userView.updateChatWallpaper(_userView.user.userId, 'Chat_Wallpaper', chatWallpaper);
      setState(() {
        wallpaperLoading = false;
      });
    }
  }

  void returnDefaultChatWallpaper() async {
    setState(() {
      wallpaperLoading = true;
    });

    await _userView.returnDefaultChatWallpaper(_userView.user.userId);

    setState(() {
      wallpaperLoading = false;
    });
  }

  void changeThemeColor(String colorName, Color color) async {
    // DynamicTheme.of(context).setBrightness(Theme.of(context).brightness == Brightness.dark? Brightness.light: Brightness.dark);
    String currentColor = _sharedPreferences.getString('themeColor') != null ? _sharedPreferences.getString('themeColor') : 'orange';

    if(currentColor != colorName) {
      DynamicTheme.of(context).setThemeData(ThemeData(primaryColor: color));
      await _sharedPreferences.setString('themeColor', colorName);
    }
  }
}
