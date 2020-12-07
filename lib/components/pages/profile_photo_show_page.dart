import 'package:flutter/material.dart';
import 'package:live_chat/components/common/appbar_widget.dart';
import 'package:live_chat/components/common/zoomable_widget.dart';

class ProfilePhotoShowPage extends StatefulWidget {
  final String name;
  final String photoUrl;
  final String id;

  const ProfilePhotoShowPage({Key key, this.name, this.photoUrl, this.id}) : super(key: key);

  @override
  _ProfilePhotoShowPageState createState() => _ProfilePhotoShowPageState();
}

class _ProfilePhotoShowPageState extends State<ProfilePhotoShowPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppbarWidget(
        backgroundColor: Colors.transparent,
        brightness: Brightness.dark,
        textColor: Colors.white,
        onLeftSideClick: () {
          Navigator.of(context).pop();
        },
        titleText: widget.name,
      ),

      body: Container(
        child: ZoomableWidget(
          panEnabled: true,
          minScale: 1,
          maxScale: 4,
          child: Hero(
            tag: widget.id,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                    image: NetworkImage(widget.photoUrl),
                    // image: NetworkImage(attachFiles[0]),
                    fit: BoxFit.contain,
                  )
              ),
            ),
          ),
        ),
      ),
    );
  }
}
