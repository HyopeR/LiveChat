import 'package:flutter/material.dart';

class ZoomableWidget extends StatefulWidget {
  final Widget child;
  final double minScale;
  final double maxScale;
  final bool panEnabled;
  final VoidCallback onTap;

  const ZoomableWidget({
    Key key,
    this.child,
    this.minScale : 1,
    this.maxScale : 4,
    this.panEnabled : true,
    this.onTap
  }) : super(key: key);

  @override
  _ZoomableWidgetState createState() => _ZoomableWidgetState();
}

class _ZoomableWidgetState extends State<ZoomableWidget> {
  TransformationController transformationController = TransformationController();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,

      onDoubleTap: () {
        // Çift dokunmada resimin scale'inin sıfırlanması.
        transformationController.value = Matrix4.identity();
      },
      child: InteractiveViewer(
        transformationController: transformationController,
        // onInteractionUpdate: (ScaleUpdateDetails details) {
        //   currentScale = details.scale;
        //   print(details.scale.toString());
        // },
        panEnabled: widget.panEnabled,
        minScale: widget.minScale,
        maxScale: widget.maxScale,
        child: widget.child,
      ),
    );
  }
}
