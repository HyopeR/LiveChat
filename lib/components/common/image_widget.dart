import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final double imageWidth;
  final double imageHeight;
  final BoxFit imageFit;
  final String imageUrl;
  final bool imageLoading;

  final double backgroundPadding;
  final BoxShape backgroundShape;
  final Color backgroundColor;

  const ImageWidget({
    Key key,
    this.imageWidth : 100,
    this.imageHeight : 100,
    this.imageFit : BoxFit.contain,
    this.imageUrl,
    this.imageLoading : false,
    this.backgroundPadding : 5,
    this.backgroundShape : BoxShape.rectangle,
    this.backgroundColor: Colors.transparent
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      width: imageWidth,
      height: imageHeight,
      padding: EdgeInsets.all(backgroundPadding),
      decoration: BoxDecoration(
        shape: backgroundShape,
        color: backgroundColor,
      ),
      child: !imageLoading
          ? Container(
            decoration: BoxDecoration(
              shape: backgroundShape,
              image: DecorationImage(
                fit: imageFit,
                image: NetworkImage(imageUrl)
              )
            ),
          )
          : Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
      ,
    );
  }
}
