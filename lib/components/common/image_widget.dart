import 'package:flutter/material.dart';

class ImageWidget extends StatefulWidget {
  final double imageWidth;
  final double imageHeight;
  final BoxFit imageFit;
  final String imageUrl;

  final double backgroundPadding;
  final BoxShape backgroundShape;
  final Color backgroundColor;

  const ImageWidget({
    Key key,
    this.imageWidth : 100,
    this.imageHeight : 100,
    this.imageFit : BoxFit.contain,
    this.imageUrl,
    this.backgroundPadding : 5,
    this.backgroundShape : BoxShape.rectangle,
    this.backgroundColor: Colors.transparent
  }) : super(key: key);

  @override
  ImageWidgetState createState() => ImageWidgetState();
}

class ImageWidgetState extends State<ImageWidget> {

  bool imageLoading = false;

  loadingStart() {
    setState(() {
      imageLoading = true;
    });
  }

  loadingFinish() {
    setState(() {
      imageLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.imageWidth,
      height: widget.imageHeight,
      padding: EdgeInsets.all(widget.backgroundPadding),
      decoration: BoxDecoration(
        shape: widget.backgroundShape,
        color: widget.backgroundColor,
      ),
      child: !imageLoading
          ? Container(
            decoration: BoxDecoration(
              shape: widget.backgroundShape,
              image: DecorationImage(
                fit: widget.imageFit,
                image: NetworkImage(widget.imageUrl)
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
