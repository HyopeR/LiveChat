import 'package:flutter/material.dart';
import 'package:live_chat/components/common/appbar_widget.dart';
import 'package:live_chat/components/common/container_column.dart';

class SettingAccountPage extends StatefulWidget {
  @override
  _SettingAccountPageState createState() => _SettingAccountPageState();
}

class _SettingAccountPageState extends State<SettingAccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        backgroundColor: Theme.of(context).primaryColor,
        onLeftSideClick: () {
          Navigator.of(context).pop();
        },

        titleText: 'Hesap',
      ),

      body: ContainerColumn(
        children: [
          Text('Not ready yet.'),
        ],
      ),
    );
  }
}
