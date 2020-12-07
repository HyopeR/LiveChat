import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:image_cropper/image_cropper.dart';

enum AppState {
  picked,
  cropped,
}

class PhotoPreviewPage extends StatefulWidget {
  final File file;

  PhotoPreviewPage({this.file});

  @override
  _PhotoPreviewPageState createState() => _PhotoPreviewPageState();
}

class _PhotoPreviewPageState extends State<PhotoPreviewPage> {
  AppState state = AppState.picked;
  File imageFile;

  @override
  void initState() {
    super.initState();
    imageFile = widget.file;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _cropImage();
    });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
    );
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(

        sourcePath: imageFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          // CropAspectRatioPreset.ratio3x2,
          // CropAspectRatioPreset.ratio4x3,
          // CropAspectRatioPreset.ratio16x9
        ]
            : [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          // CropAspectRatioPreset.ratio3x2,
          // CropAspectRatioPreset.ratio4x3,
          // CropAspectRatioPreset.ratio5x3,
          // CropAspectRatioPreset.ratio5x4,
          // CropAspectRatioPreset.ratio7x5,
          // CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            backgroundColor: Colors.black,
            activeControlsWidgetColor: Theme.of(context).primaryColor,
            toolbarTitle: 'Resim Düzenle',
            toolbarColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Colors.black,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
        ),
        iosUiSettings: IOSUiSettings(
          title: 'Resim Düzenle',
        ));
    if (croppedFile != null) {
      imageFile = croppedFile;
      setState(() {
        state = AppState.cropped;
      });
      Navigator.of(context).pop(croppedFile);
    } else {
      Navigator.of(context).pop(null);
    }
  }
}