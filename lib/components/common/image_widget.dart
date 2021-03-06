import 'package:flutter/material.dart';

class ImageWidget extends StatefulWidget {
  final double imageWidth;
  final double imageHeight;
  final BoxFit imageFit;
  final ImageProvider<Object> image;

  final double backgroundPadding;
  final BoxShape backgroundShape;
  final BorderRadiusGeometry backgroundRadius;
  final Color backgroundColor;

  const ImageWidget({
    Key key,
    this.imageWidth : 100,
    this.imageHeight : 100,
    this.imageFit : BoxFit.contain,
    this.image,
    this.backgroundPadding : 5,
    this.backgroundShape : BoxShape.rectangle,
    this.backgroundRadius,
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
    bool radiusState = (widget.backgroundRadius != null && widget.backgroundShape != BoxShape.circle);

    return Container(
      width: widget.imageWidth,
      height: widget.imageHeight,
      padding: EdgeInsets.all(widget.backgroundPadding),
      decoration: radiusState
          ? BoxDecoration(
              borderRadius: widget.backgroundRadius,
              color: widget.backgroundColor,
          )

          : BoxDecoration(
            shape: widget.backgroundShape,
            color: widget.backgroundColor,
          ),

      child: !imageLoading
          ? Container(
            decoration: radiusState
                ? BoxDecoration(
                  borderRadius: widget.backgroundRadius,
                  color: widget.backgroundColor,
                  image: DecorationImage(
                      fit: widget.imageFit,
                      image: widget.image
                  )
                )

                : BoxDecoration(
                  shape: widget.backgroundShape,
                  color: widget.backgroundColor,
                  image: DecorationImage(
                      fit: widget.imageFit,
                      image: widget.image
                  )
                ),
          )
          : Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
    );
  }
}
