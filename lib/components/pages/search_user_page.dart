import 'package:flutter/material.dart';
import 'package:live_chat/components/common/container_column.dart';
import 'package:live_chat/components/common/container_row.dart';

class SearchUserPage extends StatefulWidget {
  @override
  _SearchUserPageState createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search User'),
      ),

      body: ContainerColumn(
        padding: EdgeInsets.all(10),
        children: [

          ContainerRow(
            children: [
              Text('Arama inputu'),
              RaisedButton(
                  child: Text('Arama butonu'),
                  onPressed: () {}
              )
            ],
          ),

          Text('Dinamik gelecek user listesi'),
        ],
      ),
    );
  }
}
