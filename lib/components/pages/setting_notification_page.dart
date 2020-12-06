import 'package:flutter/material.dart';
import 'package:live_chat/components/common/appbar_widget.dart';
import 'package:live_chat/components/common/container_column.dart';

class SettingNotificationPage extends StatefulWidget {
  @override
  _SettingNotificationPageState createState() => _SettingNotificationPageState();
}

class _SettingNotificationPageState extends State<SettingNotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        backgroundColor: Theme.of(context).primaryColor,
        onLeftSideClick: () {
          Navigator.of(context).pop();
        },

        titleText: 'Bildirim',
      ),

      body: ContainerColumn(
        children: [
          Text('Not ready yet.'),
        ],
      ),
    );
  }
}