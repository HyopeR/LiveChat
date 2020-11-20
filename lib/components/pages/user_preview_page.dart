import 'package:flutter/material.dart';

class UserPreviewPage extends StatefulWidget {
  @override
  _UserPreviewPageState createState() => _UserPreviewPageState();
}

class _UserPreviewPageState extends State<UserPreviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Username'),
      ),

      body: SafeArea(
        child: Container(
          child: Text('User Preview'),
        ),
      ),
    );
  }
}
